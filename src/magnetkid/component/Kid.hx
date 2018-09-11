package magnetkid.component;

import love.Love;
import love.Love.Image;
import love.Love.Quad;

using magnetkid.physics.World.KidState;
using magnetkid.physics.World.IntentName;
using magnetkid.physics.IntentListener;

typedef QuadsMap = {
  standLeft: Quad,
  standRight: Quad
};

class Kid implements IntentListener {
  public static inline var WIDTH:Float = 72;
  public static inline var HEIGHT:Float = 112;

  private var image:Image;
  private var quadsMap:QuadsMap;
  private var quad:Quad;

  public function new() {}

  private function createQuad(row:Float, col:Float) {
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

  public function validatedIntent(intentName: IntentName) {
    quad = switch (intentName) {
      case WalkLeft: quadsMap.standLeft;
      case WalkRight: quadsMap.standRight;
      default: quad;
    }
  }

  public function load() {
    image = Love.graphics.newImage('assets/kid.png');
    quadsMap = {
      standLeft: createQuad(1, 3),
      standRight: createQuad(1, 0)
    };

    quad = quadsMap.standRight;
  }

  public function draw(camera: Camera, state: KidState) {
    var screenPosition = camera.getScreenPosition(state.position);

    // quad = switch (state.walking) {
    //   case Left: quadsMap.standLeft;
    //   case Right: quadsMap.standRight;
    //   case Not: quad;
    // };

    Love.graphics.setColor(1.0, 1.0, 1.0, 1.0);
    Love.graphics.draw(
      image,
      quad,
      screenPosition.x - WIDTH / 2,
      screenPosition.y - HEIGHT / 2
    );
  }
}
