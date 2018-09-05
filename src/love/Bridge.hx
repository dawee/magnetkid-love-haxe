package love;

import love.Love;
import love.Love.API;
import love.LifecycleListener;

@:expose
class Bridge {
  private static var lifecycleListeners:List<LifecycleListener> = new List<LifecycleListener>();

  public static function registerAPI(api: API) {
    Love.initInstance(api);
  }

  public static function addLifecycleListener(listener:LifecycleListener) {
    lifecycleListeners.add(listener);
  }

  public static function load() {
    for (listener in lifecycleListeners) {
      listener.load();
    }
  }

  public static function draw() {
    for (listener in lifecycleListeners) {
      listener.draw();
    }
  }

  public static function update(dt: Float) {
    for (listener in lifecycleListeners) {
      listener.update(dt);
    }
  }
}
