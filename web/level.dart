part of ld38;

class Level {

  int width, height;
  num tileOffsetX, tileOffsetY;
  List<List<Tile>> tiles;
  List<Tile> organs;
  List<Tile> flowTiles;
  num flowTime;
  List<ParticleEmitter> particleEmitters;
  bool won, lost;
  String lostMessage;
  int tutorialMessage;
  bool next;
  bool sound;

  Level(this.width, this.height) {
    onResize();
    organs = new List<Tile>();
    flowTiles = new List<Tile>();
    particleEmitters = new List<ParticleEmitter>();
    won = lost = false;
    next = false;
    sound = true;
  }

  void resetTiles() {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        tiles[i][j].reset();
      }
    }
    flowTime = null;
    particleEmitters.clear();
    won = lost = false;
    Resources.sounds['flow'].pause();
  }

  void flow() {
    flowTiles.clear();
    organs[0].update(flowTiles); // UPDATE HEART
    flowTime = 0;
  }

  void addBreak(Tile brokenTile) {
    String color;
    if (brokenTile.infected) {
      color = '#00B227';
    } else if (brokenTile.oxygen) {
      color = '#E12B27';
    } else if (brokenTile.blood) {
      color = '#005DFF';
    }
    particleEmitters.add(new ParticleEmitter(brokenTile.x * Tile.width + Tile.width / 2, brokenTile.y * Tile.height + Tile.height / 2, 0, 0, color));
    onLost();
    lostMessage = 'lost_mess';
    if (Resources.sounds['flow'].paused) {
      Resources.sounds['flow'].currentTime = 0;
      Resources.sounds['flow'].loop = true;
      Resources.sounds['flow'].play();
    }
  }

  void addLeak(Tile leakingTile, num offsetX, num offsetY) {
    String color;
    if (leakingTile.infected) {
      color = '#00B227';
    } else if (leakingTile.oxygen) {
      color = '#E12B27';
    } else if (leakingTile.blood) {
      color = '#005DFF';
    }
    particleEmitters.add(new ParticleEmitter(leakingTile.x * Tile.width + (Tile.width + offsetX * Tile.width) / 2, leakingTile.y * Tile.height + (Tile.height + offsetY * Tile.height) / 2, offsetX, offsetY, color));
    onLost();
    lostMessage = 'lost_mess';
    if (Resources.sounds['flow'].paused) {
      Resources.sounds['flow'].currentTime = 0;
      Resources.sounds['flow'].loop = true;
      Resources.sounds['flow'].play();
    }
  }

  bool checkOxygen() {
    for (int i = 0; i < organs.length; i++) {
      if (!organs[i].oxygen) {
        return false;
      }
    }
    return true;
  }

  void onWon() {
    won = true;
  }

  void onLost() {
    lost = true;
  }

  void update(num time) {
    if (flowTime != null) {
      flowTime += time;
      if (flowTime >= 200) {
        List<Tile> _flowTiles = new List<Tile>();
        for (int i = 0; i < flowTiles.length; i++) {
          flowTiles[i].update(_flowTiles);
        }
        flowTiles = _flowTiles;
        flowTime = 0;
        if (flowTiles.length == 0 && !won && !lost) {
          if (checkOxygen()) {
            onWon();
          } else {
            onLost();
            lostMessage = 'lost_oxygen';
          }
        }
      }
    }
    for (int i = 0; i < particleEmitters.length; i++) {
      particleEmitters[i].update(time);
    }
  }

  void draw() {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        tiles[i][j].draw();
      }
    }
    for (int i = 0; i < particleEmitters.length; i++) {
      particleEmitters[i].draw(tileOffsetX, tileOffsetY);
    }
    num scaleFactor = Tile.width / 16;
    if (flowTime == null) {
      num buttonX = (canvas.width - 38 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 8 * scaleFactor;
      num buttonWidth = 38 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight && tutorialMessage == null) {
        bufferContext.drawImageScaledFromSource(Resources.images['start'], 38, 0, 38, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      } else {
        bufferContext.drawImageScaledFromSource(Resources.images['start'], 0, 0, 38, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      }
    } else if (won) {
      bufferContext.drawImageScaled(Resources.images['won'], (canvas.width - 100 * scaleFactor) / 2, height * Tile.height + tileOffsetY + scaleFactor, 100 * scaleFactor, 13 * scaleFactor);
      num buttonX = (canvas.width - 32 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
      num buttonWidth = 32 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
        bufferContext.drawImageScaledFromSource(Resources.images['next'], 32, 0, 32, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      } else {
        bufferContext.drawImageScaledFromSource(Resources.images['next'], 0, 0, 32, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      }
    } else if (lost) {
      bufferContext.drawImageScaled(Resources.images[lostMessage], (canvas.width - 111 * scaleFactor) / 2, height * Tile.height + tileOffsetY + scaleFactor, 111 * scaleFactor, 13 * scaleFactor);
      num buttonX = (canvas.width - 36 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
      num buttonWidth = 36 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
        bufferContext.drawImageScaledFromSource(Resources.images['retry'], 36, 0, 36, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      } else {
        bufferContext.drawImageScaledFromSource(Resources.images['retry'], 0, 0, 36, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      }
    }
    if (tutorialMessage != null) {
      bufferContext.drawImageScaledFromSource(Resources.images['tutorial'], 0, tutorialMessage * 43, 114, 43,
          (canvas.width - 114 * scaleFactor) / 2, tileOffsetY, 114 * scaleFactor, 43 * scaleFactor);
    }
    if (sound) {
      bufferContext.drawImageScaled(Resources.images['speaker'], scaleFactor, canvas.height - 11 * scaleFactor, 11 * scaleFactor, 10 * scaleFactor);
    } else {
      bufferContext.drawImageScaled(Resources.images['speaker_no'], scaleFactor, canvas.height - 11 * scaleFactor, 11 * scaleFactor, 10 * scaleFactor);
    }
  }

  void drawLevelNumber(int levelNumber) {
    num scaleFactor = Tile.width / 16;
    bufferContext.drawImageScaledFromSource(Resources.images['level'], 0, 0, 57, 10,
        tileOffsetX, 3 * scaleFactor, 57 * scaleFactor, 10 * scaleFactor);
    if (levelNumber > 9) {
      bufferContext.drawImageScaledFromSource(Resources.images['level'], 57 + levelNumber ~/ 10 * 6, 0, 6, 10,
          tileOffsetX + 60 * scaleFactor, 3 * scaleFactor, 6 * scaleFactor, 10 * scaleFactor);
      bufferContext.drawImageScaledFromSource(Resources.images['level'], 57 + levelNumber % 10 * 6, 0, 6, 10,
          tileOffsetX + 67 * scaleFactor, 3 * scaleFactor, 6 * scaleFactor, 10 * scaleFactor);
    } else {
      bufferContext.drawImageScaledFromSource(Resources.images['level'], 57 + levelNumber * 6, 0, 6, 10,
          tileOffsetX + 60 * scaleFactor, 3 * scaleFactor, 6 * scaleFactor, 10 * scaleFactor);
    }
  }

  void onResize() {
    num gameWidth = max(width, 7);
    num gameHeight = height + 3;
    if (canvas.width / canvas.height > gameWidth / gameHeight) {
      Tile.width = Tile.height = canvas.height / gameHeight;
    } else {
      Tile.width = Tile.height = canvas.width / gameWidth;
    }
    tileOffsetX = (canvas.width - width * Tile.width) / 2;
    tileOffsetY = Tile.height;
  }

  void onClick() {
    if (tutorialMessage != null) {
      tutorialMessage = null;
    } else {
      num scaleFactor = Tile.width / 16;
      if (flowTime == null) {
        int x = (Input.mouseX - tileOffsetX) ~/ Tile.width;
        int y = (Input.mouseY - tileOffsetY) ~/ Tile.height;
        if (x >= 0 && x < width && y >= 0 && y < height) {
          tiles[x][y].rotate();
          Resources.sounds['blip_low'].currentTime = 0;
          Resources.sounds['blip_low'].play();
        } else {
          num buttonX = (canvas.width - 38 * scaleFactor) / 2;
          num buttonY = height * Tile.height + tileOffsetY + 8 * scaleFactor;
          num buttonWidth = 38 * scaleFactor;
          num buttonHeight = 16 * scaleFactor;
          if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
              Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
            flow();
            Resources.sounds['blip_high'].currentTime = 0;
            Resources.sounds['blip_high'].play();
          }
        }
      } else if (won) {
        num buttonX = (canvas.width - 32 * scaleFactor) / 2;
        num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
        num buttonWidth = 32 * scaleFactor;
        num buttonHeight = 16 * scaleFactor;
        if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
            Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
          next = true;
          Resources.sounds['blip_high'].currentTime = 0;
          Resources.sounds['blip_high'].play();
        }
      } else if (lost) {
        num buttonX = (canvas.width - 36 * scaleFactor) / 2;
        num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
        num buttonWidth = 36 * scaleFactor;
        num buttonHeight = 16 * scaleFactor;
        if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
            Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
          resetTiles();
          Resources.sounds['blip_high'].currentTime = 0;
          Resources.sounds['blip_high'].play();
        }
      }
      if (Input.mouseX > scaleFactor && Input.mouseX < scaleFactor + 11 * scaleFactor &&
          Input.mouseY > canvas.height - 11 * scaleFactor && Input.mouseY < canvas.height - 11 * scaleFactor + 10 * scaleFactor) {
        if (sound) {
          sound = false;
          Resources.sounds['operationroom'].pause();
        } else {
          sound = true;
          Resources.sounds['operationroom'].currentTime = 0;
          Resources.sounds['operationroom'].loop = true;
          Resources.sounds['operationroom'].play();
        }
      }
    }
  }

}