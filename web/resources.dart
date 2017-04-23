part of ld38;

class Resources {

  static Map<String, ImageElement> images;
  static Map<String, AudioElement> sounds;
  static int imagesLoaded, soundsLoaded;
  static bool doneLoading;

  static void load() {
    images = new Map<String, ImageElement>();
    sounds = new Map<String, AudioElement>();
    imagesLoaded = soundsLoaded = 0;
    doneLoading = false;
    List<String> directions = [ 'left', 'top', 'right', 'bottom', 'center' ];
    List<String> types = [ 'empty', 'blood', 'oxygen', 'infected' ];
    for (String d in directions) {
      for (String t in types) {
        loadImage('vessel_${d}_${t}');
      }
    }
    loadImage('vessel_center_break');
    loadImage('heart');
    loadImage('heart_arrow_left');
    loadImage('heart_arrow_top');
    loadImage('heart_arrow_right');
    loadImage('heart_arrow_bottom');
    loadImage('lungs');
    loadImage('liver');
    loadImage('level');
    loadImage('won');
    loadImage('next');
    loadImage('lost_mess');
    loadImage('lost_oxygen');
    loadImage('retry');
    loadImage('start');
    loadImage('speaker');
    loadImage('speaker_no');
    loadSound('operationroom');
  }

  static void loadImage(String key) {
    images[key] = new ImageElement(src: 'res/${key}.png')..onLoad.first.then((e) => onImageLoaded());
  }

  static void loadSound(String key) {
    sounds[key] = new AudioElement('res/${key}.wav')..onLoadedData.first.then((e) => onSoundLoaded());
  }

  static void onImageLoaded() {
    imagesLoaded++;
    checkLoaded();
  }

  static void onSoundLoaded() {
    soundsLoaded++;
    checkLoaded();
  }

  static void checkLoaded() {
    if (imagesLoaded == images.values.length && soundsLoaded == sounds.values.length) {
      doneLoading = true;
    }
  }

}