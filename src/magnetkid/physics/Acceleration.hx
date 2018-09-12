package magnetkid.physics;

class Acceleration {
  public var x(default, null): Float;
  public var y(default, null): Float;

  public static var Null(default, null): Acceleration = Acceleration.fromX(0);

  public function new(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function integrate(dt: Float): Velocity {
    return new Velocity(x * dt, y * dt);
  }

  public static function fromX(x: Float) {
    return new Acceleration(x, 0);
  }

  public static function fromY(y: Float) {
    return new Acceleration(0, y);
  }

  public function toForce(): Force {
    return Force.fromAcceleration(this);
  }
}
