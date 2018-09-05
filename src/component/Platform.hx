package component;

import love.Love;
import World.PlatformState;

class Platform {
  public function new() {}

  public function draw(state:PlatformState) {
    var coef = 112 / 1.5; // kid's height
    var screenGeometry = {
      left: 400 + state.left * coef,
      top: 300 - state.top * coef,
      width: state.width * coef,
      height: state.height * coef
    };

    Love.graphics.setColor(0.53, 0.41, 0.27, 1.0);
    Love.graphics.rectangle(
      'fill',
      screenGeometry.left,
      screenGeometry.top,
      screenGeometry.width,
      screenGeometry.height
    );
  }
}
