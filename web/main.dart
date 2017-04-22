library ld38;

import 'dart:html';
import 'dart:math';

part 'gamestate.dart';
part 'level.dart';
part 'leveldata.dart';
part 'tile.dart';
part 'particle.dart';
part 'input.dart';
part 'resources.dart';

CanvasElement canvas, buffer;
CanvasRenderingContext2D canvasContext, bufferContext;
Random random;
Gamestate gamestate;
num lastFrame;

void main() {
  canvas = querySelector('#canvas');
  buffer = new CanvasElement();
  canvasContext = canvas.context2D;
  bufferContext = buffer.context2D;
  Input.init();
  Resources.load();
  random = new Random();
  gamestate = new GamestateLevel();
  window.onResize.listen((e) => onResize());
  onResize();
  requestFrame();
}

void onResize() {
  canvas.width = buffer.width = document.body.client.width;
  canvas.height = buffer.height = document.body.client.height;
  bufferContext.imageSmoothingEnabled = false;
  gamestate.onResize();
}

void frame(num time) {
  if (lastFrame == null) {
    if (Resources.doneLoading) {
      lastFrame = time;
    }
  } else {
    num updateTime = time - lastFrame;
    gamestate.update(updateTime);
    bufferContext.clearRect(0, 0, canvas.width, canvas.height);
    gamestate.draw();
    canvasContext.clearRect(0, 0, canvas.width, canvas.height);
    canvasContext.drawImage(buffer, 0, 0);
    lastFrame = time;
  }
  requestFrame();
}

void requestFrame() {
  window.animationFrame.then(frame);
}