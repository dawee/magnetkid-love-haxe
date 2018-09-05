package love;

typedef Ref = {
  __type__: String,
  __ref__: Int
};

typedef ImageDimensions = {
  width: Float,
  height: Float
};

typedef Image = {
  > Ref,
  getDimensions: () -> ImageDimensions
};

typedef Quad = Ref;

typedef GraphicsAPI = {
  draw: (Image, Quad, Float, Float) -> Void,
  newImage: String -> Image,
  newQuad: (Float, Float, Float, Float, Float, Float) -> Quad,
  rectangle: (String, Float, Float, Float, Float) -> Void,
}

typedef API = {
  graphics: GraphicsAPI
};

class Graphics {
  private var api:GraphicsAPI;

  public function new(api:GraphicsAPI) {
    this.api = api;
  }

  public function draw(image, quad, x, y) {
    api.draw(image, quad, x, y);
  }

  public function newImage(newImage):Image {
    return api.newImage(newImage);
  }

  public function newQuad(x, y, width, height, sw, sh):Quad {
    return api.newQuad(x, y, width, height, sw, sh);
  }

  public function rectangle(mode, x, y, width, height) {
    api.rectangle(mode, x, y, width, height);
  }
}

class Love {
  public static var graphics(default, null):Graphics;
  private static var bridge(default, null):Bridge;

  public static function initInstance(api:API) {
    graphics = new Graphics(api.graphics);
  }
}
