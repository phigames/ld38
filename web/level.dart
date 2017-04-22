part of ld38;

class Level {

  int width, height;
  List<List<Tile>> tiles;

  Level() {
    width = 10;
    height = 10;
    onResize();
    tiles = new List<List<Tile>>();
    for (int i = 0; i < width; i++) {
      tiles.add(new List<Tile>());
      for (int j = 0; j < height; j++) {
        tiles[i].add(new TileVessel(i, j, random.nextBool(), random.nextBool(), random.nextBool(), random.nextBool()));
      }
    }
  }

  void update() {

  }

  void draw() {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        tiles[i][j].draw();
      }
    }
  }

  void onResize() {
    Tile.width = Tile.height = 64;
  }

  void onClick() {
    // rotate tile
  }

}