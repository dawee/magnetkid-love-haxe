package magnetkid;

import love.Love;

class Camera {
  private var target:World.Vec2;
  private var worldToScreenCoefficient:Float;
  private var screenTarget:World.Vec2;

  public function new(worldToScreenCoefficient) {
    this.worldToScreenCoefficient = worldToScreenCoefficient;
    this.target = { x: 0, y: 0 };
  }

  public function updateScreenTarget() {
    var screenDimensions = Love.graphics.getDimensions();

    this.screenTarget = {
      x: screenDimensions.width / 2,
      y: screenDimensions.height / 2,
    };
  }

  public function lookAt(target:World.Vec2) {
    this.target = {x: target.x, y: 0};
    this.updateScreenTarget();
  }

  public function getScreenPosition(position:World.Vec2):World.Vec2 {
    return {
      x: screenTarget.x + (position.x - this.target.x) * worldToScreenCoefficient,
      y: screenTarget.y - (position.y - this.target.y) * worldToScreenCoefficient
    }
  }

  public function getScreenGeometry(geometry:World.Rect):World.Rect {
    return {
      left: screenTarget.x + (geometry.left - this.target.x) * worldToScreenCoefficient,
      top: screenTarget.y - (geometry.top - this.target.y) * worldToScreenCoefficient,
      width: geometry.width * worldToScreenCoefficient,
      height: geometry.height * worldToScreenCoefficient
    }
  }
}
