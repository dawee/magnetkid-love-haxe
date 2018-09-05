package love;

import love.Love.API;
import love.LifecycleListener;

class Bridge {
  private var lifecycleListeners:List<LifecycleListener>;

  public function new() {
    lifecycleListeners = new List<LifecycleListener>();
  }

  public function addLifecycleListener(listener:LifecycleListener) {
    lifecycleListeners.add(listener);
  }

  public function load() {
    for (listener in lifecycleListeners) {
      listener.load();
    }
  }

  public function draw() {
    for (listener in lifecycleListeners) {
      listener.draw();
    }
  }

  public function update(dt: Float) {
    for (listener in lifecycleListeners) {
      listener.update(dt);
    }
  }
}
