part of ld38;

class Level {

  int width, height;
  List<List<Tile>> tiles;
  Tile heart;
  List<Tile> flowTiles;
  num flowTime;
  List<ParticleEmitter> particleEmitters;

  Level() {
    width = 10;
    height = 10;
    onResize();
    tiles = new List<List<Tile>>();
    for (int i = 0; i < width; i++) {
      tiles.add(new List<Tile>());
      for (int j = 0; j < height; j++) {
        tiles[i].add(new TileVessel(this, i, j, random.nextBool(), random.nextBool(), random.nextBool(), random.nextBool()));
      }
    }
    tiles[5][7] = heart = new TileHeart(this, 5, 7, true, false, true, false, 2);
    tiles[6][7] = new TileVessel(this, 6, 7, true, true, true, false);
    tiles[7][7] = new TileLungs(this, 7, 7, true, true, false, false);
    flowTiles = new List<Tile>();
    particleEmitters = new List<ParticleEmitter>();
  }

  void resetTiles() {
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        tiles[i][j].reset();
      }
    }
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
      particleEmitters[i].draw();
    }
  }

  void onResize() {
    Tile.width = Tile.height = 64;
  }

  void onClick() {
    int x = Input.mouseX ~/ Tile.width;
    int y = Input.mouseY ~/ Tile.height;
    if (x >= 0 && x < width && y >= 0 && y < height) {
      tiles[x][y].rotate();
    }
  }

}

class ParticleEmitter {

  num x, y;
  num biasX, biasY;
  String color;
  List<Particle> particles;

  ParticleEmitter(this.x, this.y, this.biasX, this.biasY, this.color) {
    particles = new List<Particle>();
  }

  void update(num time) {
    for (int j = 0; j < 3; j++) {
      particles.add(new Particle(x, y, biasX, biasY, color));
    }
    for (int i = 0; i < particles.length; i++) {
      particles[i].update(time);
      if (particles[i].lifeTime <= 0) {
        particles.removeAt(i);
        i--;
      }
    }
  }

  void draw() {
    for (int i = 0; i < particles.length; i++) {
      particles[i].draw();
    }
  }

}

class Particle {

  num x, y;
  num biasX, biasY;
  num velocityX, velocityY;
  String color;
  num lifeTime;

  Particle(this.x, this.y, this.biasX, this.biasY, this.color) {
    num angle = random.nextDouble() * 2 * PI;
    num speed = random.nextDouble();
    velocityX = (cos(angle) + biasX) * speed * Tile.width / 256;
    velocityY = (sin(angle) + biasY) * speed * Tile.height / 256;
    lifeTime = 500;
  }

  void update(num time) {
    x += velocityX * time;
    y += velocityY * time;
    velocityX *= 0.95;
    velocityY *= 0.95;
    lifeTime -= time;
  }

  void draw() {
    bufferContext.fillStyle = color;
    bufferContext.fillRect(x, y, Tile.width / 8, Tile.height / 8);
  }

}