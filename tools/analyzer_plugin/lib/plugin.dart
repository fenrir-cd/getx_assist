import 'package:analyzer/dart/analysis/context_builder.dart';
import 'package:analyzer/dart/analysis/context_locator.dart';
import 'package:analyzer/file_system/file_system.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/driver.dart';
// ignore: implementation_imports
import 'package:analyzer/src/dart/analysis/driver_based_analysis_context.dart';
import 'package:analyzer_plugin/plugin/assist_mixin.dart';
import 'package:analyzer_plugin/plugin/plugin.dart';
import 'package:analyzer_plugin/protocol/protocol_generated.dart' as plugin;
import 'package:analyzer_plugin/utilities/assist/assist.dart';
import 'package:getx_assist_analyzer_plugin/assist_contributor.dart';

class GetxAssistPlugin extends ServerPlugin
    with AssistsMixin, DartAssistsMixin {
  GetxAssistPlugin(ResourceProvider provider) : super(provider);

  @override
  List<String> get fileGlobsToAnalyze => <String>['**/*.dart'];

  @override
  String get name => 'GetX assist plugin';

  @override
  String get version => '1.0.0';

  @override
  void contentChanged(String path) {
    driverForPath(path)?.addFile(path);
  }

  @override
  AnalysisDriverGeneric createAnalysisDriver(plugin.ContextRoot contextRoot) {
    final locator =
        ContextLocator(resourceProvider: resourceProvider).locateRoots(
      includedPaths: [contextRoot.root],
      excludedPaths: [
        ...contextRoot.exclude,
      ],
      optionsFile: contextRoot.optionsFile,
    );
    final builder = ContextBuilder(resourceProvider: resourceProvider);
    final analysisContext = builder.createContext(contextRoot: locator.first);
    final context = analysisContext as DriverBasedAnalysisContext;
    return context.driver;
  }

  @override
  List<AssistContributor> getAssistContributors(String path) {
    return [GetxAssistContributor()];
  }
}
