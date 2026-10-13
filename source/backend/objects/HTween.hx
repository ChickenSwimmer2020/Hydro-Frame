package backend.objects;

import openfl.display.DisplayObjectContainer;

/**
 * tween data.
 * @since 0.0.0
 */
typedef HTweenData = {
	target:Dynamic,
	prop:String,
	startVal:Float,
	endVal:Float,
	duration:Float,
	elapsed:Float,
	?onComplete:Void->Void,
	?ease:Float->Float
}

/**
 * a tween system, yeahhh.
 * @since 0.0.0
 */
class HTween extends Sprite {
	/**
	 * active tweens
	 * @since 0.0.0
	 */
	private var tweens:Array<HTweenData> = [];

	private var lastTime:Float = 0;

	/**
	 * should auto-started tweens destroy on finish
	 * @since 0.0.0
	 */
	public var autoDestroy:Bool = true; // set false if you want it to persist

	/**
	 * always set to Main on startup
	 * @since 0.0.0
	 */
	public static var globalParent:DisplayObjectContainer;

	/**
	 * make a new tween
	 * @since 0.0.0
	 */
	public function new() {
		super();
		lastTime = openfl.Lib.getTimer();
		if (globalParent != null)
			globalParent.addChild(this);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/**
	 * make a tween happen
	 * @param target target object
	 * @param props properties to change
	 * @param duration how long to take (in seconds)
	 * @param onComplete what to do on complete
	 * @param ease ease to use
	 * @return HTween the tween that was just started
	 * @since 0.0.0
	 */
	public function tween(target:Dynamic, props:Dynamic, duration:Float, ?onComplete:Void->Void, ?ease:Float->Float):HTween {
		if (target != null) {
			if (Std.isOfType(target, DisplayObjectContainer)) {
				var targetSprite = cast(target, DisplayObjectContainer);
				if (parent != null)
					targetSprite.addChild(this);
			} else
				stage.addChild(this);
		}

		var fields = Reflect.fields(props);
		var remaining = fields.length;
		var wrappedComplete:Void->Void = null;
		if (onComplete != null) {
			wrappedComplete = function() {
				remaining--;
				if (remaining <= 0)
					onComplete();
			};
		}

		for (field in fields) {
			tweens.push({
				target: target,
				prop: field,
				startVal: Reflect.getProperty(target, field),
				endVal: Reflect.field(props, field),
				duration: duration,
				elapsed: 0,
				onComplete: wrappedComplete,
				ease: ease
			});
		}
		return this;
	}

	/**
	 * cancel all the tweens of `target`
	 * @param target object to stop tweens of
	 * @since 0.0.0
	 */
	public inline function cancelTweensOf(target:Dynamic)
		tweens = tweens.filter(t -> t.target != target);

	/**
	 * cancel every tween
	 * @since 0.0.0
	 */
	public inline function cancelAll()
		tweens = [];

	/**
	 * destroy the tween.
	 * @since 0.0.0
	 */
	public function destroy():Void {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		cancelAll();
		if (parent != null)
			parent.removeChild(this);
	}

	private function onEnterFrame(e:Event):Void {
		var now = openfl.Lib.getTimer();
		// ! CAUGHT YOU YOU FUCKING MEMORY LEAK!! (window movement was causing MAJOR leaks.)
		var dt = Math.min((now - lastTime) / 1000.0, 0.1); // real delta time in seconds
		lastTime = now;

		var active = tweens;
		tweens = [];
		var callbacks:Array<Void->Void> = [];

		for (tw in active) {
			tw.elapsed += dt;
			var t = Math.min(tw.elapsed / tw.duration, 1.0);
			if (tw.ease != null)
				t = tw.ease(t);
			Reflect.setProperty(tw.target, tw.prop, tw.startVal + (tw.endVal - tw.startVal) * t);

			if (tw.elapsed >= tw.duration) {
				if (tw.onComplete != null)
					callbacks.push(tw.onComplete);
			} else
				tweens.push(tw);
		}
		for (cb in callbacks)
			cb();
		if (autoDestroy && tweens.length == 0)
			destroy();
	}
}

/**
 * Its FlxEase.
 * @since 0.0.0
 */
class AEase {
	static var PI2:Float = Math.PI / 2;
	static var EL:Float = 2 * Math.PI / .45;
	static var B1:Float = 1 / 2.75;
	static var B2:Float = 2 / 2.75;
	static var B3:Float = 1.5 / 2.75;
	static var B4:Float = 2.5 / 2.75;
	static var B5:Float = 2.25 / 2.75;
	static var B6:Float = 2.625 / 2.75;
	static var ELASTIC_AMPLITUDE:Float = 1;
	static var ELASTIC_PERIOD:Float = 0.4;

	public static inline function linear(t:Float):Float
		return t;

	public static inline function quadIn(t:Float):Float
		return t * t;

	public static inline function quadOut(t:Float):Float
		return -t * (t - 2);

	public static inline function quadInOut(t:Float):Float
		return t <= .5 ? t * t * 2 : 1 - (--t) * t * 2;

	public static inline function cubeIn(t:Float):Float
		return t * t * t;

	public static inline function cubeOut(t:Float):Float
		return 1 + (--t) * t * t;

	public static inline function cubeInOut(t:Float):Float
		return t <= .5 ? t * t * t * 4 : 1 + (--t) * t * t * 4;

	public static inline function quartIn(t:Float):Float
		return t * t * t * t;

	public static inline function quartOut(t:Float):Float
		return 1 - (t -= 1) * t * t * t;

	public static inline function quartInOut(t:Float):Float
		return t <= .5 ? t * t * t * t * 8 : (1 - (t = t * 2 - 2) * t * t * t) / 2 + .5;

	public static inline function quintIn(t:Float):Float
		return t * t * t * t * t;

	public static inline function quintOut(t:Float):Float
		return(t = t - 1) * t * t * t * t + 1;

	public static inline function quintInOut(t:Float):Float
		return((t *= 2) < 1) ? (t * t * t * t * t) / 2 : ((t -= 2) * t * t * t * t + 2) / 2;

	public static inline function smoothStepIn(t:Float):Float
		return 2 * smoothStepInOut(t / 2);

	public static inline function smoothStepOut(t:Float):Float
		return 2 * smoothStepInOut(t / 2 + 0.5) - 1;

	public static inline function smoothStepInOut(t:Float):Float
		return t * t * (t * -2 + 3);

	public static inline function smootherStepIn(t:Float):Float
		return 2 * smootherStepInOut(t / 2);

	public static inline function smootherStepOut(t:Float):Float
		return 2 * smootherStepInOut(t / 2 + 0.5) - 1;

	public static inline function smootherStepInOut(t:Float):Float
		return t * t * t * (t * (t * 6 - 15) + 10);

	public static inline function sineIn(t:Float):Float
		return -Math.cos(PI2 * t) + 1;

	public static inline function sineOut(t:Float):Float
		return Math.sin(PI2 * t);

	public static inline function sineInOut(t:Float):Float
		return -Math.cos(Math.PI * t) / 2 + .5;

	public static function bounceIn(t:Float):Float
		return 1 - bounceOut(1 - t);

	public static function bounceOut(t:Float):Float {
		if (t < B1)
			return 7.5625 * t * t;
		if (t < B2)
			return 7.5625 * (t - B3) * (t - B3) + .75;
		if (t < B4)
			return 7.5625 * (t - B5) * (t - B5) + .9375;
		return 7.5625 * (t - B6) * (t - B6) + .984375;
	}

	public static function bounceInOut(t:Float):Float
		return t < 0.5 ? (1 - bounceOut(1 - 2 * t)) / 2 : (1 + bounceOut(2 * t - 1)) / 2;

	public static inline function circIn(t:Float):Float
		return -(Math.sqrt(1 - t * t) - 1);

	public static inline function circOut(t:Float):Float
		return Math.sqrt(1 - (t - 1) * (t - 1));

	public static function circInOut(t:Float):Float
		return t <= .5 ? (Math.sqrt(1 - t * t * 4) - 1) / -2 : (Math.sqrt(1 - (t * 2 - 2) * (t * 2 - 2)) + 1) / 2;

	public static inline function expoIn(t:Float):Float
		return Math.pow(2, 10 * (t - 1));

	public static inline function expoOut(t:Float):Float
		return -Math.pow(2, -10 * t) + 1;

	public static function expoInOut(t:Float):Float
		return t < .5 ? Math.pow(2, 10 * (t * 2 - 1)) / 2 : (-Math.pow(2, -10 * (t * 2 - 1)) + 2) / 2;

	public static inline function backIn(t:Float):Float
		return t * t * (2.70158 * t - 1.70158);

	public static inline function backOut(t:Float):Float
		return 1 - (--t) * (t) * (-2.70158 * t - 1.70158);

	public static function backInOut(t:Float):Float {
		t *= 2;
		if (t < 1)
			return t * t * (2.70158 * t - 1.70158) / 2;
		t--;
		return(1 - (--t) * (t) * (-2.70158 * t - 1.70158)) / 2 + .5;
	}

	public static inline function elasticIn(t:Float):Float
		return -(ELASTIC_AMPLITUDE * Math.pow(2,
			10 * (t -= 1)) * Math.sin((t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD));

	public static inline function elasticOut(t:Float):Float
		return(ELASTIC_AMPLITUDE * Math.pow(2,
			-10 * t) * Math.sin((t - (ELASTIC_PERIOD / (2 * Math.PI) * Math.asin(1 / ELASTIC_AMPLITUDE))) * (2 * Math.PI) / ELASTIC_PERIOD)
			+ 1);

	public static function elasticInOut(t:Float):Float {
		if (t < 0.5)
			return -0.5 * (Math.pow(2, 10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD));
		return Math.pow(2, -10 * (t -= 0.5)) * Math.sin((t - (ELASTIC_PERIOD / 4)) * (2 * Math.PI) / ELASTIC_PERIOD) * 0.5 + 1;
	}
}
