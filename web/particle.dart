part of ld38;

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

  void draw(num tileOffsetX, num tileOffsetY) {
    for (int i = 0; i < particles.length; i++) {
      particles[i].draw(tileOffsetX, tileOffsetY);
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

  void draw(num tileOffsetX, num tileOffsetY) {
    bufferContext.fillStyle = color;
    bufferContext.fillRect(x + tileOffsetX, y + tileOffsetY, Tile.width / 8, Tile.height / 8);
  }

}