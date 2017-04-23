part of ld38;

abstract class Gamestate {

  void update(num time);

  void draw();

  void onResize();

  void onClick();

}

class GamestateLevel extends Gamestate {

  List<Level> levels;
  int levelNumber;
  Level level;

  GamestateLevel() {
    levels = [ LevelData.loadLevel(LevelData.level1),
               LevelData.loadLevel(LevelData.level2),
               LevelData.loadLevel(LevelData.level3),
               LevelData.loadLevel(LevelData.level4),
               LevelData.loadLevel(LevelData.level5) ];
    levelNumber = 4;
    level = levels[levelNumber];
    level.tutorialMessage = levelNumber < 3 ? levelNumber : null;
    Resources.sounds['operationroom'].currentTime = 0;
    Resources.sounds['operationroom'].loop = true;
    Resources.sounds['operationroom'].play();
  }

  void update(num time) {
    level.update(time);
    if (level.next) {
      levelNumber++;
      if (levelNumber >= levels.length) {
        gamestate = new GamestateEnd();
        // TODO game over
      } else {
        level = levels[levelNumber];
        level.tutorialMessage = levelNumber < 3 ? levelNumber : null;
        level.onResize();
      }
    }
  }

  void draw() {
    level.draw();
    level.drawLevelNumber(levelNumber + 1);
  }

  void onResize() {
    level.onResize();
  }

  void onClick() {
    level.onClick();
  }

}

class GamestateEnd extends Gamestate {

  GamestateLevel() {
  }

  void update(num time) {
  }

  void draw() {
  }

  void onResize() {
  }

  void onClick() {
  }

}