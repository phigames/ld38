part of ld38;

abstract class Tile {

  static num width, height;

  int x, y;
  bool blood, oxygen, infected;
  bool connectionLeft, connectionTop, connectionRight, connectionBottom;

  Tile(this.x, this.y, this.connectionLeft, this.connectionTop, this.connectionRight, this.connectionBottom) {
    blood = oxygen = infected = false;
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
    bufferContext.drawImageScaled(Resources.images['vessel_center_${type}'], x * width, y * height, width, height);
    if (connectionLeft) {
      bufferContext.drawImageScaled(Resources.images['vessel_left_${type}'], x * width, y * height, width, height);
    }
    if (connectionTop) {
      bufferContext.drawImageScaled(Resources.images['vessel_top_${type}'], x * width, y * height, width, height);
    }
    if (connectionBottom) {
      bufferContext.drawImageScaled(Resources.images['vessel_bottom_${type}'], x * width, y * height, width, height);
    }
    if (connectionRight) {
      bufferContext.drawImageScaled(Resources.images['vessel_right_${type}'], x * width, y * height, width, height);
    }
  }

}

class TileVessel extends Tile {

  TileVessel(int x, int y, bool left, bool top, bool right, bool bottom) : super(x, y, left, top, right, bottom) {

  }

  void draw() {
    super.draw();
  }

}