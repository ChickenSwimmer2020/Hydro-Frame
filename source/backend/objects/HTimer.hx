package backend.objects;

/**
 * a timer, it waits then does something.
 * @since 0.0.0
 */
class HTimer {
	/**
	 * easily start a new timer, much like how Flixel does it. because timers in openfl are REALLY. STUPID.
	 * @param time how long to wait
	 * @param onComplete what to do when done.
	 * @since 0.0.0
	 */
	public static function start(time:Float, onComplete:Void->Void) {
		var timer:Timer = new Timer(time * 1000, 1);
		var handler:TimerEvent->Void = null;
		handler = (_) -> {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler);
			timer.stop();
			timer = null;
			onComplete();
		};
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, handler);
		timer.start();
	}
}
