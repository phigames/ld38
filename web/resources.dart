part of ld38;

class Resources {

  static Map<String, ImageElement> images;
  static int imagesLoaded;
  static bool doneLoading;

  static void load() {
    images = new Map<String, ImageElement>();
    imagesLoaded = 0;
    doneLoading = false;
    List<String> directions = [ 'left', 'top', 'right', 'bottom', 'center' ];
    List<String> types = [ 'empty', 'blood', 'oxygen', 'infected' ];
    for (String d in directions) {
      for (String t in types) {
        loadImage('vessel_${d}_${t}');
      }
    }
  }

  static void loadImage(String key) {
    images[key] = new ImageElement(src: 'res/${key}.png')..onLoad.first.then((e) => onImageLoaded());
  }

  static void onImageLoaded() {
    imagesLoaded++;
    checkLoaded();
  }

  static void checkLoaded() {
    if (imagesLoaded == images.values.length) {
      doneLoading = true;
    }
  }

}