package magnetkid.physics;

abstract Velocity(Array<Float>) {
  public var x(get, set): Float;
  public var y(get, set): Float;
  public var length(get, never): Float;

  public static var Null(default, null): Velocity = new Velocity(0, 0);

  inline public function new(x: Float, y: Float) {
    this = new Array<Float>();
    this.push(x);
    this.push(y);
  }

  public function get_x() {
    return this[0];
  }

  public function set_x(x: Float) {
    return this[0] = x;
  }

  public function get_y() {
    return this[1];
  }

  public function set_y(y: Float) {
    return this[1] = y;
  }

  public function get_length() {
    return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
  }

  public function integrate(dt: Float): Point {
    return new Point(x * dt, y * dt);
  }

  @:op(A < B)
  public static function isLowerThan(velA: Velocity, velB: Velocity) {
    return velA.length < velB.length;
  }

  @:op(A > B)
  public static function isGreaterThan(velA: Velocity, velB: Velocity) {
    return velA.length > velB.length;
  }

  @:op(A + B)
  public static function add(velA: Velocity, velB: Velocity) {
    return new Acceleration(velA.x + velB.x, velA.y + velB.y);
  }
}
