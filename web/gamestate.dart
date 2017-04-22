part of ld38;

abstract class Gamestate {

  void update(num time);

  void draw();

  void onResize();

  void onClick();

}

class GamestateLevel extends Gamestate {

  Level level;

  GamestateLevel() {
    level = new Level();
  }

  void update(num time) {
    level.update();
  }

  void draw() {
    level.draw();
  }

  void onResize() {
    level.onResize();
  }

  void onClick() {
    level.onClick();
  }

}