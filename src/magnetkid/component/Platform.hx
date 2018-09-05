package magnetkid.component;

import love.Love;
import magnetkid.World;

class Platform {
  public static function draw(camera:Camera, state:World.Platform) {
    var screenGeometry = camera.getScreenGeometry(state);

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
