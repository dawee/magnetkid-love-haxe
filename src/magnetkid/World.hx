package magnetkid;

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

typedef Platform = Rect;

typedef Kid = {
  height: Float,
  feetWidth: Float,
  position: Vec2,
  velocity: Vec2
};

class World {
  public static inline var KID_HEIGHT:Float = 1.5;

  private var gravity: Float;

  public var platforms(default, null): List<Platform>;
  public var kid(default, null): Kid;

  public function new() {
    gravity = -20;
    kid = {
      height: KID_HEIGHT,
      feetWidth: 0.6,
      position: { x: 0, y: 0 },
      velocity: { x: 0, y: 0 },
    };

    platforms = new List<Rect>();
    platforms.add({left: -20, top: -3, width: 40, height: 0.5});
  }

  public function step(dt: Float) {
    var nextVelocity: Vec2 = {
      x: kid.velocity.x,
      y: kid.velocity.y + gravity * dt
    };

    var nextPosition: Vec2 = {
      x: kid.position.x,
      y: kid.position.y + nextVelocity.y * dt
    };

    var touchesPlatform = false;

    for (platform in platforms) {
      touchesPlatform = kid.position.y - kid.height / 2 >= platform.top
        && nextPosition.y - kid.height / 2 <= platform.top
        && kid.position.x + kid.feetWidth / 2 > platform.left
        && kid.position.x - kid.feetWidth / 2 < platform.left + platform.width;

      if (touchesPlatform) {
        kid.position.y = platform.top + kid.height / 2;
        kid.velocity.y = 0;
        break;
      }
    }

    if (!touchesPlatform) {
      kid.velocity.y = nextVelocity.y;
      kid.position.y = nextPosition.y;
    }
  }
}
