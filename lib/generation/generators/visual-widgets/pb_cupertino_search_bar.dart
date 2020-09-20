import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';

import '../pb_flutter_generator.dart';

class PBCupertinoSearchBar extends PBGenerator {
  PBCupertinoSearchBar() : super('CUPERTINOSEARCHBAR');

  @override
  String generate(PBIntermediateNode source) {
    var buffer = StringBuffer();
    var leadingItem = source.getAttributeNamed('leading').attributeNode;
    var middleItem = source.getAttributeNamed('title').attributeNode;
    var trailingItem = source.getAttributeNamed('actions').attributeNode;

    buffer.write('AppBar(');
    if (leadingItem != null) {
      buffer.write(
          'leading: ${manager.generate(leadingItem, type: source.builder_type ?? BUILDER_TYPE.BODY)},');
    }
    if (middleItem != null) {
      buffer.write(
          'title: ${manager.generate(middleItem, type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY)},');
    }

    if (trailingItem != null) {
      var trailingItemStr = '';
      trailingItemStr =
          '${manager.generate(trailingItem, type: source.builder_type ?? BUILDER_TYPE.SCAFFOLD_BODY)}';
      buffer.write('actions: [$trailingItemStr],');
    }

    buffer.write(')');
    return buffer.toString();
  }
}
