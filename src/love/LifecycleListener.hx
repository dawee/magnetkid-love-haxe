package love;

interface LifecycleListener {
  public function load():Void;
  public function draw():Void;
  public function update(dt: Float):Void;
}
