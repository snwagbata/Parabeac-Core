import 'package:parabeac_core/controllers/interpret.dart';
import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_inherited_intermediate.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/interfaces/pb_injected_intermediate.dart';
import 'package:parabeac_core/generation/generators/plugins/pb_plugin_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

class InjectedNavbar extends PBEgg implements PBInjectedIntermediate {
  PBContext currentContext;

  String semanticName = '.*navbar';

  String UUID;

  String widgetType = 'AppBar';

  InjectedNavbar(Point topLeftCorner, Point bottomRightCorner, this.UUID,
      {this.currentContext})
      : super(topLeftCorner, bottomRightCorner, currentContext) {
    generator = PBAppBarGenerator();

    addAttribute(PBAttribute([], 'leading'));
    addAttribute(PBAttribute([], 'title'));
    addAttribute(PBAttribute([], 'actions'));
  }

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBInheritedIntermediate) {
      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*leading')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then(
                (value) => getAttributeNamed('leading').attributeNode = value);
      }

      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*trailing')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then(
                (value) => getAttributeNamed('actions').attributeNode = value);
      }
      if ((node as PBInheritedIntermediate)
          .originalRef
          .name
          .contains('.*middle')) {
        Interpret()
            .generateNonRootItem((node as PBInheritedIntermediate).originalRef)
            .then((value) => getAttributeNamed('title').attributeNode = value);
      }
    }

    return;
  }

  @override
  void alignChild() {}

  @override
  PBEgg generatePluginNode(
      Point topLeftCorner, Point bottomRightCorner, originalRef) {
    return InjectedNavbar(topLeftCorner, bottomRightCorner, UUID,
        currentContext: currentContext);
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  void extractInformation(DesignNode incomingNode) {}
}

class PBAppBarGenerator extends PBGenerator {
  PBAppBarGenerator() : super('AppBar');

  @override
  String generate(PBIntermediateNode source) {
    if (source is InjectedNavbar) {
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
}
