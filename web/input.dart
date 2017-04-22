part of ld38;

class Input {

  static int mouseX, mouseY;

  static void init() {
    canvas.onMouseMove.listen(onMouseMove);
    canvas.onClick.listen(onClick);
    mouseX = mouseY = 0;
  }

  static void onMouseMove(MouseEvent event) {
    mouseX = event.client.x;
    mouseY = event.client.y;
  }

  static void onClick(MouseEvent event) {
    gamestate.onClick();
  }

}