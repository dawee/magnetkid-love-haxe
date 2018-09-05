package magnetkid.component;

import love.Love;
import love.Love.Image;
import love.Love.Quad;
import magnetkid.World;

typedef QuadsMap = {
  standRight: Quad
};

class Kid {
  public static inline var WIDTH:Float = 72;
  public static inline var HEIGHT:Float = 112;

  private static var image:Image;
  private static var quadsMap:QuadsMap;

  private static function createQuad(row:Float, col:Float) {
    var dimensions = image.getDimensions();

    return Love.graphics.newQuad(
      col * WIDTH,
      row * HEIGHT,
      WIDTH,
      HEIGHT,
      dimensions.width,
      dimensions.height
    );
  }

  public static function load() {
    image = Love.graphics.newImage('assets/kid.png');
    quadsMap = {
      standRight: createQuad(1, 0)
    };
  }

  public static function draw(camera: Camera, state: World.Kid) {
    var screenPosition = camera.getScreenPosition(state.position);

    Love.graphics.setColor(1.0, 1.0, 1.0, 1.0);
    Love.graphics.draw(
      image,
      quadsMap.standRight,
      screenPosition.x - WIDTH / 2,
      screenPosition.y - HEIGHT / 2
    );
  }
}
