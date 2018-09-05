package component;

import love.Love;
import love.Love.Image;
import love.Love.Quad;
import World;

typedef QuadsMap = {
  standRight: Quad
};

class Kid {
  private static inline var WIDTH:Float = 72;
  private static inline var HEIGHT:Float = 112;

  private var image:Image;
  private var quadsMap:QuadsMap;

  private function createQuad(x:Float, y:Float) {
    var dimensions = image.getDimensions();

    return Love.graphics.newQuad(
      (x - 1) * WIDTH,
      (y - 1) * HEIGHT,
      WIDTH,
      HEIGHT,
      dimensions.width,
      dimensions.height
    );
  }

  public function new() {}

  public function load() {
    image = Love.graphics.newImage('assets/kid.png');
    quadsMap = {
      standRight: createQuad(1, 2)
    };
  }

  public function draw(state: World.KidState) {
    var coef = HEIGHT / 1.5;
    var screenPosition = {
      x: 400 + state.position.x * coef - WIDTH / 2,
      y: 300 - state.position.y * coef - HEIGHT / 2,
    };

    Love.graphics.setColor(1.0, 1.0, 1.0, 1.0);
    Love.graphics.draw(image, quadsMap.standRight, screenPosition.x, screenPosition.y);
  }
}
