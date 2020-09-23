import 'package:parabeac_core/design_logic/design_node.dart';
import 'package:parabeac_core/generation/generators/layouts/pb_scaffold_gen.dart';
import 'package:parabeac_core/generation/prototyping/pb_prototype_node.dart';
import 'package:parabeac_core/input/sketch/entities/layers/artboard.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/injected_align.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/plugins/injected_app_bar.dart';
import 'package:parabeac_core/plugins/injected_tab_bar.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/layouts/temp_group_layout_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/pb_shared_instance.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_visual_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'interfaces/pb_inherited_intermediate.dart';

import 'package:json_annotation/json_annotation.dart';

part 'inherited_scaffold.g.dart';

@JsonSerializable(nullable: true)
class InheritedScaffold extends PBVisualIntermediateNode
    implements
        /* with GeneratePBTree */ /* PropertySearchable,*/ PBInheritedIntermediate {
  @override
  var originalRef;
  @override
  @JsonKey(ignore: true)
  PrototypeNode prototypeNode;
  String name;
  @JsonSerializable(nullable: true)
  String backgroundColor;

  bool isHomeScreen = false;

  @override
  String UUID;

  @JsonKey(ignore: true)
  PBContext currentContext;

  /// Gets the [PBIntermediateNode] at attribute `body`
  PBIntermediateNode get child => getAttributeNamed('body')?.attributeNode;

  /// Sets the `body` attribute's `attributeNode` to `element`.
  /// If a `body` attribute does not yet exist, it creates it.
  set child(PBIntermediateNode element) {
    if (!hasAttribute('body')) {
      addAttribute(PBAttribute([], 'body', attributeNodes: [element]));
    } else {
      getAttributeNamed('body').attributeNode = element;
    }
  }

  InheritedScaffold(this.originalRef,
      {Point topLeftCorner,
      Point bottomRightCorner,
      this.name,
      this.currentContext,
      this.isHomeScreen})
      : super(
            Point(originalRef.boundaryRectangle.x,
                originalRef.boundaryRectangle.y),
            Point(
                originalRef.boundaryRectangle.x +
                    originalRef.boundaryRectangle.width,
                originalRef.boundaryRectangle.y +
                    originalRef.boundaryRectangle.height),
            currentContext) {
    if (originalRef is DesignNode && originalRef.prototypeNodeUUID != null) {
      prototypeNode = PrototypeNode(originalRef?.prototypeNodeUUID);
    }
    this.name = name
        ?.replaceAll(RegExp(r'[\W]'), '')
        ?.replaceFirst(RegExp(r'^([\d]|_)+'), '');

    generator = PBScaffoldGenerator();

    this.currentContext.screenBottomRightCorner = Point(
        originalRef.boundaryRectangle.x + originalRef.boundaryRectangle.width,
        originalRef.boundaryRectangle.y + originalRef.boundaryRectangle.height);

    this.currentContext.screenTopLeftCorner =
        Point(originalRef.boundaryRectangle.x, originalRef.boundaryRectangle.y);

    UUID = originalRef.UUID;

    backgroundColor = (originalRef as Artboard).backgroundColor?.toHex();

    // Add body attribute
    addAttribute(PBAttribute([], 'body'));
  }

  @override
  List<PBIntermediateNode> layoutInstruction(List<PBIntermediateNode> layer) {
    return layer;
  }

  @override
  String semanticName;

  @override
  void addChild(PBIntermediateNode node) {
    if (node is PBSharedInstanceIntermediateNode) {
      if (node.originalRef.name.contains('.*navbar')) {
        addAttribute(PBAttribute([], 'appBar', attributeNodes: [node]));
        return;
      }
      if (node.originalRef.name.contains('.*tabbar')) {
        addAttribute(
            PBAttribute([], 'bottomNavigationBar', attributeNodes: [node]));
        return;
      }
    }

    if (node is InjectedNavbar) {
      addAttribute(PBAttribute([], 'appBar', attributeNodes: [node]));
      return;
    }
    if (node is InjectedTabBar) {
      addAttribute(
          PBAttribute([], 'bottomNavigationBar', attributeNodes: [node]));
      return;
    }

    var bodyAttribute = getAttributeNamed('body');
    var bodyNode = bodyAttribute?.attributeNode;
    if (bodyNode is TempGroupLayoutNode) {
      bodyNode.addChild(node);
      return;
    }
    // If there's multiple children add a temp group so that layout service lays the children out.
    if (bodyNode != null) {
      var temp = TempGroupLayoutNode(null, currentContext);
      temp.addChild(bodyNode);
      temp.addChild(node);
      bodyAttribute.attributeNode = temp;
    } else {
      bodyAttribute.attributeNode = node;
    }
  }

  @override
  void alignChild() {
    var align = InjectedAlign(topLeftCorner, bottomRightCorner, currentContext);
    var bodyAttribute = getAttributeNamed('body');
    var bodyNode = bodyAttribute?.attributeNode;
    align.addChild(bodyNode);
    align.alignChild();
    bodyAttribute.attributeNode = align;
  }

  Map<String, Object> toJson() => _$InheritedScaffoldToJson(this);
  factory InheritedScaffold.fromJson(Map<String, Object> json) =>
      _$InheritedScaffoldFromJson(json);
}
