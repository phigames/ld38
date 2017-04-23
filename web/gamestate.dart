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
               LevelData.loadLevel(LevelData.level5),
               LevelData.loadLevel(LevelData.level6),
               LevelData.loadLevel(LevelData.level7),
               LevelData.loadLevel(LevelData.level8) ];
    levelNumber = 0;
    level = levels[levelNumber];
    level.tutorialMessage = levelNumber < 3 ? levelNumber : null;
    Resources.sounds['background'].currentTime = 0;
    Resources.sounds['background'].loop = true;
    Resources.sounds['background'].play();
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
    bufferContext.drawImageScaled(Resources.images['game_over'], canvas.width / 2 - 89 * 2, canvas.height / 2 - 77 * 2, 89 * 4, 77 * 4);
  }

  void onResize() {
  }

  void onClick() {
  }

}