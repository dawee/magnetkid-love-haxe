package magnetkid.physics;

class Velocity {
  public var x(default, null): Float;
  public var y(default, null): Float;

  public static var Null(default, null): Velocity = new Velocity(0, 0);

  public function new(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function integrate(dt: Float): Point {
    return new Point(x * dt, y * dt);
  }
}
