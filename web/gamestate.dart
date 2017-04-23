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
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2),
    LevelData.loadLevel(LevelData.level2) ];
    levelNumber = 0;
    level = levels[levelNumber];
    Resources.sounds['operationroom'].currentTime = 0;
    Resources.sounds['operationroom'].loop = true;
    Resources.sounds['operationroom'].play();
  }

  void update(num time) {
    level.update(time);
    if (level.next) {
      levelNumber++;
      if (levelNumber >= levels.length) {
        // TODO game over
      }
      level = levels[levelNumber];
      level.onResize();
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