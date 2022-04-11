import 'package:flutter/material.dart';

class LoadingScreen {
  LoadingScreen({required this.context});
  bool? isItLoading;
  final BuildContext context;
  late OverlayEntry? overlay;
  void showOverlay() {
    final renederBox = context.findRenderObject() as RenderBox;
    final size = renederBox.size;
    overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.1,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(children: const [
              SizedBox(
                height: 20,
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              Text("Please wait a moment"),
            ]),
          ),
        ),
      );
    });

    final state = Overlay.of(context);
    state?.insert(overlay!);
    isItLoading = true;
  }

  void removeOverlay() {
    if (isItLoading == true) {
      overlay!.remove();
      isItLoading = false;
    }
  }
}
