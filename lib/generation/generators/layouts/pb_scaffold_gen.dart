import 'package:parabeac_core/generation/generators/attribute-helper/pb_color_gen_helper.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_scaffold.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';

class PBScaffoldGenerator extends PBGenerator {
  PBScaffoldGenerator() : super('Scaffold');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InheritedScaffold) {
      var appBar = source.getAttributeNamed('appBar')?.attributeNode;
      var body = source.getAttributeNamed('body')?.attributeNode;
      var bottomNavBar =
          source.getAttributeNamed('bottomNavigationBar')?.attributeNode;

      var buffer = StringBuffer();
      buffer.write('Scaffold(\n');
      if (source.backgroundColor != null) {
        var str = PBColorGenHelper().generate(source);
        buffer.write(str);
      }
      if (appBar != null) {
        buffer.write('appBar: ');
        var appbarStr =
            manager.generate(appBar, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$appbarStr,\n');
      }
      if (bottomNavBar != null) {
        buffer.write('bottomNavigationBar: ');
        var navigationBar =
            manager.generate(bottomNavBar, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$navigationBar, \n');
      }

      if (body != null) {
        // hack to pass screen width and height to the child
        buffer.write('body: ');
        var bodyStr = manager.generate(body, type: BUILDER_TYPE.SCAFFOLD_BODY);
        buffer.write('$bodyStr, \n');
      }
      buffer.write(')');
      return buffer.toString();
    }
  }
}
