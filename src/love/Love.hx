package love;

import love.Bridge;

typedef Ref = {
  __type__: String,
  __ref__: Int
};

typedef Dimensions = {
  width: Float,
  height: Float
};

typedef Image = {
  > Ref,
  getDimensions: () -> Dimensions
};

typedef Quad = Ref;

typedef GraphicsAPI = {
  draw: (Image, Quad, Float, Float) -> Void,
  getDimensions: () -> Dimensions,
  newImage: String -> Image,
  newQuad: (Float, Float, Float, Float, Float, Float) -> Quad,
  rectangle: (String, Float, Float, Float, Float) -> Void,
  setBackgroundColor: (Float, Float, Float, Float) -> Void,
  setColor: (Float, Float, Float, Float) -> Void,
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

  public function getDimensions():Dimensions {
    return api.getDimensions();
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

  public function setBackgroundColor(red, green, blue, alpha) {
    api.setBackgroundColor(red, green, blue, alpha);
  }

  public function setColor(red, green, blue, alpha) {
    api.setColor(red, green, blue, alpha);
  }
}

@:expose
class Love {
  public static var graphics(default, null):Graphics;
  public static var bridge(get, null):Bridge;

  public static function get_bridge():Bridge {
    if (bridge == null) {
      bridge = new Bridge();
    }

    return bridge;
  }

  public static function registerAPI(api: API) {
    graphics = new Graphics(api.graphics);
  }
}
