import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/source/source_range.dart';
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:analyzer_plugin/utilities/assist/assist_contributor_mixin.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';
import 'package:analyzer_plugin/utilities/change_builder/change_builder_dart.dart';

class GetxAssistContributor extends Object
    with AssistContributorMixin
    implements AssistContributor {
  static AssistKind wrapWithObx =
      AssistKind('wrapWithObx', 100, "Wrap with Obx");

  @override
  late AssistCollector collector;

  @override
  Future<void> computeAssists(
      DartAssistRequest request, AssistCollector collector) async {
    this.collector = collector;
    await _wrapWithObx(request);
  }

  Future<void> _wrapWithObx(DartAssistRequest request) async {
    var visitor = WidgetCreationVisitor(request.offset);
    request.result.unit.accept(visitor);
    var range = visitor.range;
    if (range == null) {
      return;
    }

    var builder = ChangeBuilder(session: request.result.session);
    var content = request.result.content;
    var linePrefix = getLinePrefix(content, range);
    var widget = content.substring(range.offset, range.end).split('\n');
    await builder.addDartFileEdit(request.result.path,
        (DartFileEditBuilder editBuilder) {
      editBuilder.addReplacement(range, (DartEditBuilder builder) {
        builder.writeln('Obx(() {');
        builder.write('$linePrefix  return ${widget.first}');
        for (var line in widget.sublist(1)) {
          builder.writeln();
          builder.write('  $line');
        }
        builder.writeln(';');
        builder.write('$linePrefix})');
      });
    });
    addAssist(wrapWithObx, builder);
  }

  String getLinePrefix(String content, SourceRange range) {
    var prefix = '';
    for (var i = range.end - 1; i >= 0; i--) {
      var c = content[i];
      if (c == '\n') {
        break;
      } else if (c == ' ') {
        prefix += ' ';
      } else {
        prefix = '';
      }
    }
    return prefix;
  }
}

class WidgetCreationVisitor extends RecursiveAstVisitor {
  final int offset;

  SourceRange? range;

  WidgetCreationVisitor(this.offset);

  void _visitWidgetExpression(Expression node) {
    if (offset < node.offset || offset >= node.end) {
      return;
    }

    if (offset >= node.beginToken.end) {
      node.visitChildren(this);
      return;
    }

    var isWidget = false;
    var element = node.staticType?.element;
    if (element is ClassElement) {
      isWidget = element.allSupertypes.any((element) =>
          element.getDisplayString(withNullability: false) == 'Widget');
    }

    if (isWidget) {
      range = SourceRange(node.offset, node.length);
    } else {
      node.visitChildren(this);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    _visitWidgetExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    _visitWidgetExpression(node);
  }
}
