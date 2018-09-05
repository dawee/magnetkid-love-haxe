typedef Vec2 = {
  x: Float,
  y: Float
};

typedef Rect = {
  left: Float,
  top: Float,
  width: Float,
  height: Float
};

typedef PlatformState = Rect;

typedef KidState = {
  height: Float,
  feetWidth: Float,
  position: Vec2,
  velocity: Vec2
};

class World {
  private var gravity: Float;

  public var platforms(default, null): List<Rect>;
  public var kidState(default, null): KidState;

  public function new() {
    gravity = -20;
    kidState = {
      height: 1.5,
      feetWidth: 0.6,
      position: { x: 0, y: 0 },
      velocity: { x: 0, y: 0 },
    };

    platforms = new List<Rect>();
    platforms.add({left: -20, top: -3, width: 40, height: 0.5});
  }

  public function step(dt: Float) {
    var nextVelocity: Vec2 = {
      x: kidState.velocity.x,
      y: kidState.velocity.y + gravity * dt
    };

    var nextPosition: Vec2 = {
      x: kidState.position.x,
      y: kidState.position.y + nextVelocity.y * dt
    };

    var touchesPlatform = false;

    for (platform in platforms) {
      touchesPlatform = kidState.position.y - kidState.height / 2 >= platform.top
        && nextPosition.y - kidState.height / 2 <= platform.top
        && kidState.position.x + kidState.feetWidth / 2 > platform.left
        && kidState.position.x - kidState.feetWidth / 2 < platform.left + platform.width;

      if (touchesPlatform) {
        kidState.position.y = platform.top + kidState.height / 2;
        kidState.velocity.y = 0;
        break;
      }
    }

    if (!touchesPlatform) {
      kidState.velocity.y = nextVelocity.y;
      kidState.position.y = nextPosition.y;
    }
  }
}
