import 'package:parabeac_core/generation/generators/pb_flutter_generator.dart';
import 'package:parabeac_core/generation/generators/pb_generator.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_attribute.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'package:json_annotation/json_annotation.dart';

/// PB’s  representation of the intermediate representation for a sketch node.
/// Usually, we work with its subclasses. We normalize several aspects of data that a sketch node presents in order to work better at the intermediate level.
/// Sometimes, PBNode’s do not have a direct representation of a sketch node. For example, most layout nodes are primarily made through and understanding of a need for a layout.
@JsonSerializable(nullable: true)
abstract class PBIntermediateNode {
  /// A subsemantic is contextual info to be analyzed in or in-between the visual generation & layout generation services.
  String subsemantic;

  @JsonKey(ignore: true)
  BUILDER_TYPE builder_type;

  String widgetType;

  @JsonKey(ignore: true)
  PBGenerator generator;

  final String UUID;

  /// List of attributes of the node that may contain other IntermediateNodes
  /// or IntermediateNode trees
  @JsonKey(ignore: true)
  List<PBAttribute> _attributes;

  List<PBAttribute> get attributes => _attributes;

  /// Gets the [PBIntermediateNode] at attribute `child`
  @JsonKey(ignore: true)
  PBIntermediateNode get child => getAttributeNamed('child')?.attributeNode;

  /// Sets the `child` attribute's `attributeNode` to `element`.
  /// If a `child` attribute does not yet exist, it creates it.
  @JsonKey(ignore: true)
  set child(PBIntermediateNode element) {
    if (!hasAttribute('child')) {
      addAttribute(PBAttribute([], 'child', attributeNodes: [element]));
    } else {
      getAttributeNamed('child').attributeNode = element;
    }
  }

  Point topLeftCorner;
  Point bottomRightCorner;

  @JsonKey(ignore: true)
  PBContext currentContext;

  String color;
  Map size;
  Map borderInfo;
  Map alignment;

  String name;

  PBIntermediateNode(
    this.topLeftCorner,
    this.bottomRightCorner,
    this.UUID, {
    this.currentContext,
    this.subsemantic,
  }) {
    if (topLeftCorner != null && bottomRightCorner != null) {
      assert(topLeftCorner.x <= bottomRightCorner.x &&
          topLeftCorner.y <= bottomRightCorner.y);
    }
    _attributes = [];
  }

  /// Returns the [PBAttribute] named `attributeName`. Returns
  /// null if the [PBAttribute] does not exist.
  PBAttribute getAttributeNamed(String attributeName) {
    for (var attribute in attributes) {
      if (attribute.attributeName == attributeName) {
        return attribute;
      }
    }
    return null;
  }

  /// Returns true if there is an attribute in the node's `attributes`
  /// that matches `attributeName`. Returns false otherwise.
  bool hasAttribute(String attributeName) {
    for (var attribute in attributes) {
      if (attribute.attributeName == attributeName) {
        return true;
      }
    }
    return false;
  }

  /// Adds the [PBAttribute] to this node's `attributes` list.
  /// When `overwrite` is set to true, if the provided `attribute` has the same
  /// name as another attribute in `attributes`, it will replace the old one.
  /// Returns true if the addition was successful, false otherwise.
  bool addAttribute(PBAttribute attribute, {bool overwrite = false}) {
    // Iterate through the list of attributes
    for (var i = 0; i < attributes.length; i++) {
      var childAttr = attributes[i];

      // If there is a duplicate, replace if `overwrite` is true
      if (childAttr.attributeName == attribute.attributeName) {
        if (overwrite) {
          attributes[i] = attribute;
          return true;
        }
        return false;
      }
    }

    // Add attribute, no duplicate found
    attributes.add(attribute);
    return true;
  }

  /// Adds child to node.
  void addChild(PBIntermediateNode node);

  Map<String, dynamic> toJson() {
    return {};
  }
}

abstract class ChildrenListener {
  ///the [convertedChildren] are updated. Used for subclasses that need their convertedChildren information
  ///in order to assign some of their attributes. Left
  void childrenUpdated();
}
