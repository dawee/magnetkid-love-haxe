typedef Quad = {
  __type__: String,
  __ref__: Int
};

typedef LoveGraphicsAPI = {
  rectangle: (String, Float, Float, Float, Float) -> Void,
  newQuad: (Float, Float, Float, Float, Float, Float) -> Quad
}

typedef LoveAPI = {
  graphics: LoveGraphicsAPI
};

class LoveGraphics {
  private var api:LoveGraphicsAPI;

  public function new(api:LoveGraphicsAPI) {
    this.api = api;
  }

  public function newQuad(x, y, width, height, sw, sh):Quad {
    return api.newQuad(x, y, width, height, sw, sh);
  }

  public function rectangle(mode, x, y, width, height) {
    api.rectangle(mode, x, y, width, height);
  }
}

class Love {
  public static var graphics(default, null):LoveGraphics;

  public static function initInstance(api:LoveAPI) {
    graphics = new LoveGraphics(api.graphics);
  }
}
