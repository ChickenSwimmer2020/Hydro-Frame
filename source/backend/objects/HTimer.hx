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

	//shell.
	public function new() {};

	/**
	 * Is the timer paused?
	 * @since 0.10.1
	**/
	public var paused(default, set):Bool = false;

	/**
	 * How many loops are left?
	 * @since 0.10.1
	**/
	public var loopsLeft:Int = 0;

	/**
	 * Should timers auto-destroy when completed?
	 * Defaults to FALSE.
	 * @since 0.10.1
	**/
	public var autoDestroy:Bool = false;


	@:noCompletion public var _timer:Null<Timer> = null;
	@:noCompletion public var _handler:Null<TimerEvent->Void> = null;
	@:noCompletion private var _initalLoops:Int = 1;
	@:noCompletion private var _initialTime:Float = 0;
	/**
	 * Run a new repeatable timer, assignable to a variable
	 * @param time Float how long do you want to run the timer for
	 * @param onComplete HTimer->Void what do you want the timer to do on complete?
	 * @param loops Int how many loops do you want? 0 for infinite
	 * @since 0.10.1
	**/
	public function run(time:Float, onComplete:HTimer->Void, loops:Int=1) {
		if(_timer == null) {
			_initialTime = time*1000;
			_timer = new Timer(time*1000, loops);
			loopsLeft=_initalLoops=loops;
			_handler = (_:TimerEvent)->{
				if(loops!=0 || loopsLeft==0) {
					if(autoDestroy) {
						_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, _handler);
						_timer.stop();
						_timer = null;
					}
					onComplete(this);
				}else{
					loopsLeft--;
					onComplete(this);
				}
			}
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, _handler);
			_timer.start();
		}else reset(); //auto re-start without trying to re-initilize.
	}

	@:noCompletion private var _timeLeft:Float = 0.0;
	public function set_paused(a:Bool):Bool {
		paused = a;
		if(a){ //pausing
			_timeLeft = _timer.delay;
			_timer.stop();
		}else{
			_timer.delay = _timeLeft;
			_timer.start();
		}
		return a;
	}
	/**
	 * Pause/Unpause the timer
	 * @since 0.10.1
	**/
	public function pause() paused=!paused;

	public function reset() {
		_timer.stop();
		_timer.reset();
		_timer.delay = _initialTime;
		_timer.start();
	}

	public function stop() {
		_timer.stop();
		if(autoDestroy) _timer = null;
	}
}
