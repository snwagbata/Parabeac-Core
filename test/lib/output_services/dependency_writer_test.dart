import 'dart:io';
import 'package:test/test.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_writer.dart';

void main() {
  group('Dependency writer test', () {
    var writer;
    var yamlAbsPath =
        '${Directory.current.path}/test/lib/output_services/tempTest/pubspec.yaml';
    setUp(() async {
      Process.runSync('flutter', ['create', 'tempTest'],
          workingDirectory:
              '${Directory.current.path}/test/lib/output_services/');
      writer = PBFlutterWriter();
      writer.addDependency('http_parser', '^3.1.4');
      writer.addDependency('shelf_proxy', '^0.1.0+7');
    });
    test('Dependency writer test', () async {
      await writer.submitDependencies(yamlAbsPath);
      var lineHttp = -1;
      var lineShelf = -1;
      var readYaml = await File(yamlAbsPath).readAsLinesSync();
      lineHttp = await readYaml.indexOf('  http_parser: ^3.1.4');
      lineShelf = await readYaml.indexOf('  shelf_proxy: ^0.1.0+7');
      expect(lineHttp >= 0, true);
      expect(lineShelf >= 0, true);
    });
    tearDownAll(() {
      Process.runSync('rm', ['-r', 'tempTest'],
          workingDirectory:
              '${Directory.current.path}/test/lib/output_services/');
    });
  });
}
