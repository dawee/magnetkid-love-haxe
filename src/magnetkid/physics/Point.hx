package magnetkid.physics;


class Point {
  public var x(default, null): Float;
  public var y(default, null): Float;

  public static var Null(default, null): Point = new Point(0, 0);

  public function new(x: Float, y: Float) {
    this.x = x;
    this.y = y;
  }

  public function translate(tx: Float, ty: Float): Point {
    return new Point(x + tx, y + ty);
  }

  public function translateX(tx: Float): Point {
    return translate(tx, 0);
  }

  public function translateY(ty: Float): Point {
    return translate(ty, 0);
  }

}
