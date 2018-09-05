package love;

import love.Bridge;

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
