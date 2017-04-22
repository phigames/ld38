part of ld38;

class LevelData {

  static final List<String> level1 =
    [ '.....',
      '.++L.',
      '.+.+.',
      '.+>+.',
      '.....' ];
  static final List<String> level2 =
    [ '.....',
      '.++L.',
      '.+.+.',
      '.+>+.',
      '.....' ];

  static Level loadLevel(List<String> data) {
    int width = data[0].length;
    int height = data.length;
    Level level = new Level(width, height);
    List<List<Tile>> tiles = new List<List<Tile>>();
    for (int i = 0; i < width; i++) {
      tiles.add(new List<Tile>());
      for (int j = 0; j < height; j++) {
        String symbol = data[j][i];
        if (symbol == ' ') {
          tiles[i].add(new TileVessel(level, i, j, false, false, false, false));
        } else {
          bool connectLeft = false, connectTop = false, connectRight = false, connectBottom = false;
          if (i > 0 && data[j][i - 1] != ' ' && data[j][i - 1] != '.') {
            connectLeft = true;
          }
          if (j > 0 && data[j - 1][i] != ' ' && data[j - 1][i] != '.') {
            connectTop = true;
          }
          if (i < width - 1 && data[j][i + 1] != ' ' && data[j][i + 1] != '.') {
            connectRight = true;
          }
          if (j < height - 1 && data[j + 1][i] != ' ' && data[j + 1][i] != '.') {
            connectBottom = true;
          }
          if (symbol == '+') {
            tiles[i].add(new TileVessel(level, i, j, connectLeft, connectTop, connectRight, connectBottom));
            int rotation = random.nextInt(4);
            for (int k = 0; k < rotation; k++) {
              tiles[i][j].rotate();
            }
            tiles[i][j].rotate();
          } else if (symbol == '<') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 0));
            level.heart = tiles[i][j];
          } else if (symbol == '^') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 1));
            level.heart = tiles[i][j];
          } else if (symbol == '>') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 2));
            level.heart = tiles[i][j];
          } else if (symbol == 'v') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 3));
            level.heart = tiles[i][j];
          } else if (symbol == 'L') {
            tiles[i].add(new TileLungs(level, i, j, connectLeft, connectTop, connectRight, connectBottom));
          } else if (symbol == '.') {
            tiles[i].add(new TileVessel(level, i, j, random.nextBool(), random.nextBool(), random.nextBool(), random.nextBool()));
          }
        }
      }
    }
    level.tiles = tiles;
    return level;
  }

}