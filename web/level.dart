part of ld38;

class Level {

  int width, height;
  num tileOffsetX, tileOffsetY;
  List<List<Tile>> tiles;
  Tile heart;
  List<Tile> flowTiles;
  num flowTime;
  List<ParticleEmitter> particleEmitters;
  bool won, lost;
  bool next;

  Level(this.width, this.height) {
    onResize();
    flowTiles = new List<Tile>();
    particleEmitters = new List<ParticleEmitter>();
    won = lost = false;
    next = false;
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
  }

  void flow() {
    flowTiles.clear();
    heart.update(flowTiles);
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
  }

  void onWon() {
    won = true;
  }

  void onLost() {
    print('lost');
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
    if (flowTime == null) {
      num scaleFactor = Tile.width / 16;
      num buttonX = (canvas.width - 38 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 8 * scaleFactor;
      num buttonWidth = 38 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
        bufferContext.drawImageScaledFromSource(Resources.images['start'], 38, 0, 38, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      } else {
        bufferContext.drawImageScaledFromSource(Resources.images['start'], 0, 0, 38, 16, buttonX, buttonY, buttonWidth, buttonHeight);
      }
    } else if (won) {
      num scaleFactor = Tile.width / 16;
      bufferContext.drawImageScaled(Resources.images['won'], (canvas.width - 105 * scaleFactor) / 2, height * Tile.height + tileOffsetY + scaleFactor, 105 * scaleFactor, 13 * scaleFactor);
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
      num scaleFactor = Tile.width / 16;
      bufferContext.drawImageScaled(Resources.images['lost'], (canvas.width - 105 * scaleFactor) / 2, height * Tile.height + tileOffsetY + scaleFactor, 105 * scaleFactor, 13 * scaleFactor);
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
    if (flowTime == null) {
      int x = (Input.mouseX - tileOffsetX) ~/ Tile.width;
      int y = (Input.mouseY - tileOffsetY) ~/ Tile.height;
      if (x >= 0 && x < width && y >= 0 && y < height) {
        tiles[x][y].rotate();
      } else {
        num scaleFactor = Tile.width / 16;
        num buttonX = (canvas.width - 38 * scaleFactor) / 2;
        num buttonY = height * Tile.height + tileOffsetY + 8 * scaleFactor;
        num buttonWidth = 38 * scaleFactor;
        num buttonHeight = 16 * scaleFactor;
        if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
            Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
          flow();
        }
      }
    } else if (won) {
      num scaleFactor = Tile.width / 16;
      num buttonX = (canvas.width - 32 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
      num buttonWidth = 32 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
        next = true;
      }
    } else if (lost) {
      num scaleFactor = Tile.width / 16;
      num buttonX = (canvas.width - 36 * scaleFactor) / 2;
      num buttonY = height * Tile.height + tileOffsetY + 15 * scaleFactor;
      num buttonWidth = 36 * scaleFactor;
      num buttonHeight = 16 * scaleFactor;
      if (Input.mouseX > buttonX && Input.mouseX < buttonX + buttonWidth &&
          Input.mouseY > buttonY && Input.mouseY < buttonY + buttonHeight) {
        resetTiles();
      }
    }
  }

}