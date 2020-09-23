import 'package:parabeac_core/input/figma/entities/abstract_figma_node_factory.dart';
import 'package:parabeac_core/input/figma/entities/layers/vector.dart';
import 'package:parabeac_core/input/sketch/entities/objects/frame.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_container.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/inherited_text.dart';
import 'package:parabeac_core/interpret_and_optimize/entities/subclasses/pb_intermediate_node.dart';
import 'package:parabeac_core/interpret_and_optimize/helpers/pb_context.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:parabeac_core/interpret_and_optimize/value_objects/point.dart';

import 'figma_node.dart';

part 'text.g.dart';

@JsonSerializable(nullable: true)
class FigmaText extends FigmaVector implements AbstractFigmaNodeFactory {
  @override
  String type = 'TEXT';
  FigmaText({
    String name,
    bool visible,
    String type,
    pluginData,
    sharedPluginData,
    this.style,
    layoutAlign,
    constraints,
    Frame boundaryRectangle,
    size,
    fills,
    strokes,
    strokeWeight,
    strokeAlign,
    styles,
    this.characters,
    this.characterStyleOverrides,
    this.styleOverrideTable,
  }) : super(
          name: name,
          visible: visible,
          type: type,
          pluginData: pluginData,
          sharedPluginData: sharedPluginData,
          style: style,
          layoutAlign: layoutAlign,
          constraints: constraints,
          boundaryRectangle: boundaryRectangle,
          size: size,
          fills: fills,
          strokes: strokes,
          strokeWeight: strokeWeight,
          strokeAlign: strokeAlign,
          styles: styles,
        );

  String characters;

  @override
  var style;

  List<double> characterStyleOverrides;

  Map styleOverrideTable;

  @override
  FigmaNode createFigmaNode(Map<String, dynamic> json) =>
      FigmaText.fromJson(json);
  factory FigmaText.fromJson(Map<String, dynamic> json) =>
      _$FigmaTextFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$FigmaTextToJson(this);

  @override
  Future<PBIntermediateNode> interpretNode(PBContext currentContext) {
    return Future.value(InheritedContainer(
      this,
      Point(boundaryRectangle.x, boundaryRectangle.y),
      Point(boundaryRectangle.x + boundaryRectangle.width,
          boundaryRectangle.y + boundaryRectangle.height),
      currentContext: currentContext,
    )..addChild(
        InheritedText(this, currentContext: currentContext),
      ));
  }
}
