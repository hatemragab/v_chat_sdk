import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:v_chat_utils/v_chat_utils.dart';

class ImagePinterView extends StatefulWidget {
  final VPlatformFileSource platformFileSource;

  const ImagePinterView({super.key, required this.platformFileSource});

  @override
  State<ImagePinterView> createState() => _ImagePinterViewState();
}

class _ImagePinterViewState extends State<ImagePinterView> {
  bool isPressing = false;

  static const Color red = Colors.indigo;
  FocusNode textFocusNode = FocusNode();
  late PainterController painterController;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.indigo
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.butt;

  void redo() {
    painterController.redo();
  }

  @override
  void initState() {
    super.initState();
    painterController = PainterController(
      settings: PainterSettings(
        text: TextSettings(
          focusNode: textFocusNode,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: red,
            fontSize: 18,
          ),
        ),
        freeStyle: const FreeStyleSettings(
          color: red,
          strokeWidth: 5,
        ),
        shape: ShapeSettings(
          paint: shapePaint,
        ),
        scale: const ScaleSettings(
          enabled: true,
        ),
      ),
    );
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);
    // Initialize background
    initBackground();
  }

  void onFocus() {
    setState(() {});
  }

  void undo() {
    painterController.undo();
  }

  Future<void> initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]
    late final ui.Image image;
    if (widget.platformFileSource.bytes != null) {
      image = await MemoryImage(
        Uint8List.fromList(widget.platformFileSource.bytes!),
      ).image;
    } else {
      image = await FileImage(File(widget.platformFileSource.filePath!)).image;
    }

    setState(() {
      backgroundImage = image;
      painterController.background = image.backgroundDrawable;
    });
    toggleFreeStyleDraw();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        // Listen to the controller and update the UI when it updates.
        child: ValueListenableBuilder<PainterControllerValue>(
          valueListenable: painterController,
          builder: (context, _, child) {
            return AppBar(
              title: child,
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.flip,
                  ),
                  onPressed: painterController.selectedObjectDrawable != null &&
                          painterController.selectedObjectDrawable
                              is ImageDrawable
                      ? flipSelectedImageDrawable
                      : null,
                ),
                // Redo action
                IconButton(
                  icon: const Icon(
                    PhosphorIcons.arrowClockwise,
                  ),
                  onPressed: painterController.canRedo ? redo : null,
                ),
                // Undo action
                IconButton(
                  icon: const Icon(
                    PhosphorIcons.arrowCounterClockwise,
                  ),
                  onPressed: painterController.canUndo ? undo : null,
                ),
                if (isPressing)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoActivityIndicator(),
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.done,
                    ),
                    onPressed: () => renderAndDisplayImage(context),
                  ),
              ],
            );
          },
        ),
      ),
      body: Stack(
        children: [
          if (backgroundImage != null)
            // Enforces constraints
            Positioned.fill(
              child: Center(
                child: AspectRatio(
                  aspectRatio: backgroundImage!.width / backgroundImage!.height,
                  child: FlutterPainter(
                    controller: painterController,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: ValueListenableBuilder(
              valueListenable: painterController,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 400,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: const BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                        color: Colors.white54,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (painterController.freeStyleMode !=
                              FreeStyleMode.none) ...[
                            Row(),
                            if (painterController.freeStyleMode ==
                                FreeStyleMode.draw)
                              Row(
                                children: [
                                  const Expanded(child: Text("Color")),
                                  // Control free style color hue
                                  Expanded(
                                    flex: 3,
                                    child: Slider.adaptive(
                                      max: 359.99,
                                      value: HSVColor.fromColor(
                                        painterController.freeStyleColor,
                                      ).hue,
                                      activeColor:
                                          painterController.freeStyleColor,
                                      onChanged: setFreeStyleColor,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                          if (textFocusNode.hasFocus) ...[
                            const Divider(),
                            const Text("Text settings"),
                            // Control text font size
                            Row(
                              children: [
                                const Expanded(
                                  child: Text("Font Size"),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 8,
                                    max: 96,
                                    value:
                                        painterController.textStyle.fontSize ??
                                            14,
                                    onChanged: setTextFontSize,
                                  ),
                                ),
                              ],
                            ),

                            // Control text color hue
                            Row(
                              children: [
                                const Expanded(child: Text("Color")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    max: 359.99,
                                    value: HSVColor.fromColor(
                                      painterController.textStyle.color ?? red,
                                    ).hue,
                                    activeColor:
                                        painterController.textStyle.color,
                                    onChanged: setTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (painterController.shapeFactory != null) ...[
                            const Divider(),
                            const Text("Shape Settings"),

                            // Control text color hue
                            Row(
                              children: [
                                const Expanded(
                                  child: Text("Stroke Width"),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    min: 2,
                                    max: 25,
                                    value: painterController
                                            .shapePaint?.strokeWidth ??
                                        shapePaint.strokeWidth,
                                    onChanged: (value) => setShapeFactoryPaint(
                                      (painterController.shapePaint ??
                                              shapePaint)
                                          .copyWith(
                                        strokeWidth: value,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Control shape color hue
                            Row(
                              children: [
                                const Expanded(child: Text("Color")),
                                Expanded(
                                  flex: 3,
                                  child: Slider.adaptive(
                                    max: 359.99,
                                    value: HSVColor.fromColor(
                                      (painterController.shapePaint ??
                                              shapePaint)
                                          .color,
                                    ).hue,
                                    activeColor:
                                        (painterController.shapePaint ??
                                                shapePaint)
                                            .color,
                                    onChanged: (hue) => setShapeFactoryPaint(
                                      (painterController.shapePaint ??
                                              shapePaint)
                                          .copyWith(
                                        color: HSVColor.fromAHSV(1, hue, 1, 1)
                                            .toColor(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              children: [
                                const Expanded(
                                  child: Text("Fill shape"),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Switch(
                                      value: (painterController.shapePaint ??
                                                  shapePaint)
                                              .style ==
                                          PaintingStyle.fill,
                                      onChanged: (value) =>
                                          setShapeFactoryPaint(
                                        (painterController.shapePaint ??
                                                shapePaint)
                                            .copyWith(
                                          style: value
                                              ? PaintingStyle.fill
                                              : PaintingStyle.stroke,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: painterController,
        builder: (context, _, __) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Free-style eraser
            IconButton(
              icon: Icon(
                PhosphorIcons.eraser,
                color: painterController.freeStyleMode == FreeStyleMode.erase
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: toggleFreeStyleErase,
            ),
            // Free-style drawing
            IconButton(
              icon: Icon(
                PhosphorIcons.scribbleLoop,
                color: painterController.freeStyleMode == FreeStyleMode.draw
                    ? Theme.of(context).colorScheme.secondary
                    : null,
              ),
              onPressed: toggleFreeStyleDraw,
            ),
            // Add text

            if (painterController.shapeFactory == null)
              PopupMenuButton<ShapeFactory?>(
                tooltip: "Add shape",
                itemBuilder: (context) => <ShapeFactory, String>{
                  LineFactory(): "Line",
                  ArrowFactory(): "Arrow",
                  DoubleArrowFactory(): "Double Arrow",
                  RectangleFactory(): "Rectangle",
                  OvalFactory(): "Oval",
                }
                    .entries
                    .map(
                      (e) => PopupMenuItem(
                        value: e.key,
                        child: Row(
                          children: [
                            Icon(
                              getShapeIcon(e.key),
                              color: Colors.black,
                            ),
                            Text(" ${e.value}")
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onSelected: selectShape,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    getShapeIcon(painterController.shapeFactory),
                    color: painterController.shapeFactory != null
                        ? Theme.of(context).colorScheme.secondary
                        : null,
                  ),
                ),
              )
            else
              IconButton(
                icon: Icon(
                  getShapeIcon(painterController.shapeFactory),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                onPressed: () => selectShape(null),
              ),
          ],
        ),
      ),
    );
  }

  void toggleFreeStyleErase() {
    painterController.freeStyleMode =
        painterController.freeStyleMode != FreeStyleMode.erase
            ? FreeStyleMode.erase
            : FreeStyleMode.none;
  }

  Future<void> renderAndDisplayImage(BuildContext context) async {
    if (backgroundImage == null) return;

    setState(() {
      isPressing = true;
    });

    final backgroundImageSize = Size(
      backgroundImage!.width.toDouble(),
      backgroundImage!.height.toDouble(),
    );
    final ui.Image image =
        await painterController.renderImage(backgroundImageSize);
    final bytes = await image.pngBytes;
    if (widget.platformFileSource.bytes != null) {
      widget.platformFileSource.bytes = bytes;
      return context.pop(widget.platformFileSource);
    } else {
      final tempFile = File(
        join(
          (await getTemporaryDirectory()).path,
          "${DateTime.now().millisecondsSinceEpoch}.png",
        ),
      );
      final file = await tempFile.writeAsBytes(bytes!);
      widget.platformFileSource.filePath = file.path;
      return context.pop(widget.platformFileSource);
    }
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = painterController.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    painterController.replaceDrawable(
      imageDrawable,
      imageDrawable.copyWith(flipped: !imageDrawable.flipped),
    );
  }

  void selectShape(ShapeFactory? factory) {
    painterController.shapeFactory = factory;
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrowsHorizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }

  void removeSelectedDrawable() {
    final selectedDrawable = painterController.selectedObjectDrawable;
    if (selectedDrawable != null) {
      painterController.removeDrawable(selectedDrawable);
    }
  }

  void addText() {
    if (painterController.freeStyleMode != FreeStyleMode.none) {
      painterController.freeStyleMode = FreeStyleMode.none;
    }
    painterController.addText();
  }

  void setFreeStyleStrokeWidth(double value) {
    painterController.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    painterController.freeStyleColor =
        HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void toggleFreeStyleDraw() {
    painterController.freeStyleMode =
        painterController.freeStyleMode != FreeStyleMode.draw
            ? FreeStyleMode.draw
            : FreeStyleMode.none;
  }

  void setTextColor(double hue) {
    painterController.textStyle = painterController.textStyle
        .copyWith(color: HSVColor.fromAHSV(1, hue, 1, 1).toColor());
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      painterController.textSettings = painterController.textSettings.copyWith(
        textStyle:
            painterController.textSettings.textStyle.copyWith(fontSize: size),
      );
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      painterController.shapePaint = paint;
    });
  }
}
