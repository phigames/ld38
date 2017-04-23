part of ld38;

class LevelData {

  static final List<String> level1 =
  [ 'LpL',
    'I I',
    'L>L' ];
  static final List<String> level2 =
  [ 'LIJIL',
    'I   I',
    'I LIP',
    'I I I',
    'LI>IL' ];
  static final List<String> level3 =
  [ '.LIIL',
    '.I..I',
    '.PI<T',
    '.I..I',
    '.IJIL' ];
  static final List<String> level4 =
  [ 'LIIIL',
    'v...I',
    'ILIpT',
    'II..J',
    'LTpIL' ];
  static final List<String> level5 =
  [ 'L....L.',
    'LIIPITL',
    'ILI+ILI',
    'JLLTBLL',
    'LTLLT^.',
    '.LIJIL.' ];
  static final List<String> level6 =
  [ 'LILLIL.',
    'ILTLISL',
    'TBLpILI',
    'IILI.LT',
    'L>TL.PL',
    'L.LTIL.' ];

  static Level loadLevel(List<String> data) {
    int width = data[0].length;
    int height = data.length;
    Level level = new Level(width, height);
    List<List<Tile>> tiles = new List<List<Tile>>();
    level.organs.add(null);
    for (int i = 0; i < width; i++) {
      tiles.add(new List<Tile>());
      for (int j = 0; j < height; j++) {
        String symbol = data[j][i];
        if (symbol == ' ') {
          tiles[i].add(new TileVessel(level, i, j, false, false, false, false));
        } else if (symbol == '.') {
          tiles[i].add(new TileVessel(level, i, j, random.nextBool(), random.nextBool(), random.nextBool(), random.nextBool()));
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
            tiles[i].add(new TileVessel(level, i, j, true, true, true, true));
          } else if (symbol == 'T') {
            tiles[i].add(new TileVessel(level, i, j, true, true, true, false));
          } else if (symbol == 'I') {
            tiles[i].add(new TileVessel(level, i, j, true, false, true, false));
          } else if (symbol == 'L') {
            tiles[i].add(new TileVessel(level, i, j, true, true, false, false));
          } else if (symbol == 'i') {
            tiles[i].add(new TileVessel(level, i, j, true, false, false, false));
          } else if (symbol == '<') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 0));
            level.organs[0] = tiles[i][j];
          } else if (symbol == '^') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 1));
            level.organs[0] = tiles[i][j];
          } else if (symbol == '>') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 2));
            level.organs[0] = tiles[i][j];
          } else if (symbol == 'v') {
            tiles[i].add(new TileHeart(level, i, j, connectLeft, connectTop, connectRight, connectBottom, 3));
            level.organs[0] = tiles[i][j];
          } else if (symbol == 'P') {
            tiles[i].add(new TileLungs(level, i, j, true, true, true, false));
            level.organs.add(tiles[i][j]);
          } else if (symbol == 'p') {
            tiles[i].add(new TileLungs(level, i, j, true, false, true, false));
            level.organs.add(tiles[i][j]);
          } else if (symbol == 'J') {
            tiles[i].add(new TileLiver(level, i, j, true, false, true, false));
            level.organs.add(tiles[i][j]);
          } else if (symbol == 'B') {
            tiles[i].add(new TileBrain(level, i, j, true, true, false, false));
            level.organs.add(tiles[i][j]);
          } else if (symbol == 'S') {
            tiles[i].add(new TileStomach(level, i, j, true, true, true, false));
            level.organs.add(tiles[i][j]);
          }
          int rotation = random.nextInt(4);
          for (int k = 0; k < rotation; k++) {
            tiles[i][j].rotate();
          }
        }
      }
    }
    level.tiles = tiles;
    return level;
  }

}