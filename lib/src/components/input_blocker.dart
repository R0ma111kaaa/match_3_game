import 'package:flame/events.dart';
import 'package:flame/components.dart';

class InputBlocker extends PositionComponent with TapCallbacks, DragCallbacks {
  InputBlocker({required super.size}) {
    priority = 100;
  }

  @override
  void onTapDown(TapDownEvent event) {
    event.handled = true;
    super.onTapDown(event);
  }

  @override
  void onDragStart(DragStartEvent event) {
    event.handled = true;
    super.onDragStart(event);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    event.handled = true;
  }
}
