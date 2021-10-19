import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:getx_assist_analyzer_plugin/plugin.dart';

void main(List<String> args, SendPort sendPort) {
  ServerPluginStarter(GetxAssistPlugin(PhysicalResourceProvider.INSTANCE))
      .start(sendPort);
}
