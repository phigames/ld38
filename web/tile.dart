part of ld38;

abstract class Tile {

  static num width, height;

  Level level;
  int x, y;
  bool blood, oxygen, infected;
  bool connectionLeft, connectionTop, connectionRight, connectionBottom;
  bool sourceLeft, sourceTop, sourceRight, sourceBottom;
  int breakAnimationFrame;

  Tile(this.level, this.x, this.y, this.connectionLeft, this.connectionTop, this.connectionRight, this.connectionBottom) {
    reset();
  }

  void reset() {
    blood = oxygen = infected = false;
    sourceLeft = sourceTop = sourceRight = sourceBottom = false;
  }

  void rotate() {
    bool _connectionLeft = connectionLeft;
    connectionLeft = connectionBottom;
    connectionBottom = connectionRight;
    connectionRight = connectionTop;
    connectionTop = _connectionLeft;
  }

  void update(List<Tile> flowTiles) {
    if (breakAnimationFrame == null) {
      bool drain = false;
      bool leakLeft = false, leakTop = false, leakRight = false, leakBottom = false;
      if (sourceLeft) { // SUCK LEFT
        Tile source = level.tiles[x - 1][y];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (connectionLeft) { // FLOW LEFT
        if (x > 0) {
          Tile flowTile = level.tiles[x - 1][y];
          if (flowTile.connectionRight) {
            flowTile.sourceRight = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            leakLeft = true;
          }
        } else {
          leakLeft = true;
        }
        drain = true;
      }
      if (sourceTop) { // SUCK TOP
        Tile source = level.tiles[x][y - 1];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (connectionTop) { // FLOW TOP
        if (y > 0) {
          Tile flowTile = level.tiles[x][y - 1];
          if (flowTile.connectionBottom) {
            flowTile.sourceBottom = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            leakTop = true;
          }
        } else {
          leakTop = true;
        }
        drain = true;
      }
      if (sourceRight) { // SUCK RIGHT
        Tile source = level.tiles[x + 1][y];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (connectionRight) { // FLOW RIGHT
        if (x < level.width - 1) {
          Tile flowTile = level.tiles[x + 1][y];
          if (flowTile.connectionLeft) {
            flowTile.sourceLeft = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            leakRight = true;
          }
        } else {
          leakRight = true;
        }
        drain = true;
      }
      if (sourceBottom) { // SUCK BOTTOM
        Tile source = level.tiles[x][y + 1];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (connectionBottom) { // FLOW BOTTOM
        if (y < level.height - 1) {
          Tile flowTile = level.tiles[x][y + 1];
          if (flowTile.connectionTop) {
            flowTile.sourceTop = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            leakBottom = true;
          }
        } else {
          leakBottom = true;
        }
        drain = true;
      }
      if (!drain) {
        breakAnimationFrame = -1;
        flowTiles.add(this);
      }
      if (leakLeft) {
        level.addLeak(this, -1, 0);
      }
      if (leakTop) {
        level.addLeak(this, 0, -1);
      }
      if (leakRight) {
        level.addLeak(this, 1, 0);
      }
      if (leakBottom) {
        level.addLeak(this, 0, 1);
      }
    } else {
      breakAnimationFrame++;
      if (breakAnimationFrame > 2) {
        breakAnimationFrame = 2;
        level.addBreak(this);
      } else {
        flowTiles.add(this);
      }
    }
  }

  void draw() {
    String type;
    if (infected) {
      type = 'infected';
    } else if (oxygen) {
      type = 'oxygen';
    } else if (blood) {
      type = 'blood';
    } else {
      type = 'empty';
    }
    if (connectionLeft || connectionTop || connectionRight || connectionBottom) {
      if (breakAnimationFrame == null || breakAnimationFrame < 0) {
        bufferContext.drawImageScaled(Resources.images['vessel_center_${type}'], x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      } else {
        bufferContext.drawImageScaledFromSource(Resources.images['vessel_center_break'], breakAnimationFrame * 16, 0, 16, 16, x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
      if (connectionLeft) {
        bufferContext.drawImageScaled(Resources.images['vessel_left_${type}'], x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
      if (connectionTop) {
        bufferContext.drawImageScaled(Resources.images['vessel_top_${type}'], x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
      if (connectionBottom) {
        bufferContext.drawImageScaled(Resources.images['vessel_bottom_${type}'], x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
      if (connectionRight) {
        bufferContext.drawImageScaled(Resources.images['vessel_right_${type}'], x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
      if (breakAnimationFrame != null && breakAnimationFrame >= 0) {
        int frameY;
        if (type == 'blood') {
          frameY = 1;
        } else if (type == 'oxygen') {
          frameY = 2;
        } else if (type == 'infected') {
          frameY = 3;
        }
        bufferContext.drawImageScaledFromSource(Resources.images['vessel_center_break'], breakAnimationFrame * 16, frameY * 16, 16, 16, x * width + level.tileOffsetX, y * height + level.tileOffsetY, width, height);
      }
    }
  }

}

class TileVessel extends Tile {

  TileVessel(Level level, int x, int y, bool left, bool top, bool right, bool bottom)
      : super(level, x, y, left, top, right, bottom);

}

class TileHeart extends Tile {

  int flowDirection;

  TileHeart(Level level, int x, int y, bool left, bool top, bool right, bool bottom, this.flowDirection)
      : super(level, x, y, left, top, right, bottom);

  void rotate() {
    super.rotate();
    flowDirection++;
    if (flowDirection > 3) {
      flowDirection = 0;
    }
  }

  void update(List<Tile> flowTiles) {
    if (!blood) { // START OF CYCLE
      blood = true;
      if (flowDirection == 0) { // FLOW LEFT
        if (x > 0) {
          Tile flowTile = level.tiles[x - 1][y];
          if (flowTile.connectionRight) {
            flowTile.sourceRight = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            level.addLeak(this, -1, 0);
          }
        } else {
          level.addLeak(this, -1, 0);
        }
      } else if (flowDirection == 1) { // FLOW TOP
        if (y > 0) {
          Tile flowTile = level.tiles[x][y - 1];
          if (flowTile.connectionBottom) {
            flowTile.sourceBottom = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            level.addLeak(this, 0, -1);
          }
        } else {
          level.addLeak(this, 0, -1);
        }
      } else if (flowDirection == 2) { // FLOW RIGHT
        if (x < level.width - 1) {
          Tile flowTile = level.tiles[x + 1][y];
          if (flowTile.connectionLeft) {
            flowTile.sourceLeft = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            level.addLeak(this, 1, 0);
          }
        } else {
          level.addLeak(this, 1, 0);
        }
      } else if (flowDirection == 3) { // FLOW BOTTOM
        if (y < level.height - 1) {
          Tile flowTile = level.tiles[x][y + 1];
          if (flowTile.connectionLeft) {
            flowTile.sourceTop = true;
            if (!flowTiles.contains(flowTile)) {
              flowTiles.add(flowTile);
            }
          } else {
            level.addLeak(this, 0, 1);
          }
        } else {
          level.addLeak(this, 0, 1);
        }
      }
    } else { // END OF CYCLE
      if (sourceLeft) { // SUCK LEFT
        Tile source = level.tiles[x - 1][y];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (sourceTop) { // SUCK TOP
        Tile source = level.tiles[x][y - 1];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (sourceRight) { // SUCK RIGHT
        Tile source = level.tiles[x + 1][y];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      } else if (sourceBottom) { // SUCK BOTTOM
        Tile source = level.tiles[x][y + 1];
        blood = blood || source.blood;
        oxygen = oxygen || source.oxygen;
        infected = infected || source.infected;
      }
      level.onWon();
    }
  }

  void draw() {
    super.draw();
    bufferContext.drawImageScaled(Resources.images['heart'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height);
    switch (flowDirection) {
      case 0: bufferContext.drawImageScaled(Resources.images['heart_arrow_left'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height); break;
      case 1: bufferContext.drawImageScaled(Resources.images['heart_arrow_top'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height); break;
      case 2: bufferContext.drawImageScaled(Resources.images['heart_arrow_right'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height); break;
      case 3: bufferContext.drawImageScaled(Resources.images['heart_arrow_bottom'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height); break;
    }
  }

}

class TileLungs extends Tile {

  TileLungs(Level level, int x, int y, bool left, bool top, bool right, bool bottom)
      : super(level, x, y, left, top, right, bottom);

  void update(List<Tile> flowTiles) {
    oxygen = true;
    super.update(flowTiles);
  }

  void draw() {
    super.draw();
    bufferContext.drawImageScaled(Resources.images['lungs'], x * Tile.width + level.tileOffsetX, y * Tile.height + level.tileOffsetY, Tile.width, Tile.height);
  }

}