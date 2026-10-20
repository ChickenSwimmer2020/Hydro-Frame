package backend.objects;

/**
 * Sound manager, everything here is static so we dont need to isntance this
 * @since 0.2.0
 */
class HSoundManager {
	/**
	 * for looping music
	 * @since 0.2.0
	 */
	public static var music:Null<HSound>;

	/**
	 * play looping music 
	 * @param asset full path to sound to play
	 * @param vol volume of the sound
	 * @return HSound the sound that wsa just started, aka `music`
	 * @since 0.2.0
	 */
	public static function playMusic(asset:String, ?vol:Float = 1.0):HSound {
		if (music == null)
			music = new HSound();
		music.load(asset, true);
		music.autoDestroy = false;
		music.looped = true;
		music.volume = vol;
		return music.play();
	}

	/**
	 * play a sound once, then destroy it.
	 * @param asset asset path
	 * @param vol sound volume
	 * @return HSound the sound that was just started
	 * @since 0.2.0
	 */
	public static function playSound(asset:String, ?vol:Float = 1.0):HSound {
		var sound:HSound = new HSound().load(asset, true);
		sound.onComplete = () -> sound.destroy();
		sound.volume = vol;
		return sound.play();
	}
}

//--------------------------------------------------------------------------------------------------------------------//
//                   MADE BY FLIXEL, COPIED AND CONVERTED TO PURE OPENFL BY CHICKENSWIMMER2020                        //
//--------------------------------------------------------------------------------------------------------------------//

/**
 * you want api information? refer to the flixel api.
 * @since 0.2.0
 */
class HSound implements IDestroyable {
	// other
	public var autoDestroy:Bool;
	public var onComplete:Null<() -> Void> = null;
	public var pan(get, set):Float; //-1 = left, 1 = right

	inline function get_pan():Float
		return _transform.pan;

	inline function set_pan(pan:Float):Float {
		_transform.pan = pan;
		updateTransform();
		return pan;
	}

	public var playing(get, never):Bool;

	inline function get_playing():Bool
		return _channel != null;

	public var volume(get, set):Float;

	inline function get_volume():Float
		return _volume;

	function set_volume(Volume:Float):Float {
		_volume = HMath.bound(Volume, 0, 1);
		updateTransform();
		return Volume;
	}

	public var pitch(get, set):Float; // cuz i want this.

	inline function get_pitch():Float
		return _pitch;

	function set_pitch(v:Float):Float {
		if (_channel != null) {
			@:privateAccess if(_channel.__audioSource != null)
				_channel.__audioSource.pitch = v;
		}

		return _pitch = v;
	}

	// time
	public var time(get, set):Float;

	inline function get_time():Float
		return _time;

	function set_time(time:Float):Float {
		if (playing) {
			cleanup(false, true);
			startSound(time);
		}
		return _time = time;
	}

	public var length(get, never):Float;

	inline function get_length():Float
		return _length;

	// looping stuff
	public var looped:Bool;
	public var loopCount(default, null):Int = 0;
	public var loopUntil:Int = -1;
	public var loopTime:Float = 0; // in MS
	public var endTime:Null<Float> = null;

	// actual openfl stuff that is important.
	var _sound:Null<Sound> = null;
	var _channel:SoundChannel;
	var _transform:SoundTransform;
	// internals
	var _paused:Bool;
	var _volume:Float;
	var _time:Float = 0;
	var _length:Float = 0;
	var _pitch:Float = 1.0;
	var _volumeAdjust:Float = 1.0;

	public function new() {
		reset();
	}

	public function reset() {
		destroy();

		_time = 0;
		_paused = false;
		_volume = 1.0;
		_volumeAdjust = 1.0;
		looped = false;
		loopTime = 0.0;
		loopCount = 0;
		loopUntil = -1;
		endTime = 0.0;
		autoDestroy = false;
		if (_transform == null)
			_transform = new SoundTransform();
		_transform.pan = 0;
	}

	public function destroy() {
		_transform = null;

		if (_channel != null) {
			_channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
			_channel.stop();
			_channel = null;
		}

		if (_sound != null)
			_sound = null;
		onComplete = null;
	}

	public function enterFrame(_:Event) {
		if (!playing)
			return;
		_time = _channel.position;
		if (endTime != null && _time >= endTime)
			stopped();
	}

	public inline function kill()
		cleanup(false);

	// important stuff.
	public function load(asset:String, allowCache:Bool = true):HSound {
		if (asset == null)
			trace("Couldnt find a valid sound to load!!");
		return loadHelper(asset, true, allowCache, true).init(false, false, null);
	}

	function loadHelper(asset:String, destroy:Bool = false, allowCache:Bool = true, addExt:Bool = false):HSound {
		cleanup(destroy);

		_sound = Assets.getSound(asset, allowCache);
		if (_sound != null)
			onSoundSet();

		return this;
	}

	public function loadFromURL(URL:String, ?onLoad:Void->Void):HSound
		return loadFromURLHelper(URL, onLoad).init(false, false, null);

	function loadFromURLHelper(URL:String, ?onLoad:Void->Void):HSound {
		cleanup(true);

		final sound = _sound = new Sound();
		onSoundSet();
		function loadCallback(e:Event) {
			sound.removeEventListener(e.type, loadCallback);
			if (sound == e.target) {
				_length = sound.length;
				if (onLoad != null)
					onLoad();
			}
		}
		sound.addEventListener(Event.COMPLETE, loadCallback, false, 0, true);
		sound.load(new URLRequest(URL));

		return this;
	}

	overload public inline extern function setup(volume = 1.0, looped = false, autoDestroy = false, ?onComplete:() -> Void):HSound {
		this.volume = volume;
		loopUntil = -1;
		return init(looped, autoDestroy, onComplete);
	}

	overload public inline extern function setup(volume = 1.0, loopUntil:Int, autoDestroy = false, ?onComplete:() -> Void):HSound {
		this.volume = volume;
		this.loopUntil = loopUntil;
		return init(true, autoDestroy, onComplete);
	}

	function init(looped:Bool, autoDestroy:Bool, onComplete:Null<() -> Void>):HSound {
		this.looped = looped;
		this.autoDestroy = autoDestroy;
		this.onComplete = onComplete;
		updateTransform();
		pitch = 1;
		return this;
	}

	public function play(forceRestart = false, startTime = 0.0, ?endTime:Float):HSound {
		if (forceRestart)
			cleanup(false, true);
		else if (playing) // Already playing sound
			return this;

		if (_paused)
			resume();
		else {
			loopCount = 0;
			startSound(startTime);
		}

		this.endTime = endTime;
		return this;
	}

	public function resume():HSound {
		if (_paused)
			startSound(_time);
		return this;
	}

	public function pause():HSound {
		if (!playing)
			return this;

		_time = _channel.position;
		_paused = true;
		cleanup(false, false);
		return this;
	}

	public inline function stop():HSound {
		cleanup(autoDestroy, true);
		return this;
	}

	function updateTransform() {
		_transform.volume = calcTransformVolume();

		if (_channel != null)
			_channel.soundTransform = _transform;
	}

	inline function calcTransformVolume():Float
		return(1.0 * _volume * _volumeAdjust);

	function startSound(StartTime:Float):Void {
		if (_sound == null)
			return;

		_time = StartTime;
		_paused = false;
		_channel = _sound.play(_time, 0, _transform);
		if (_channel != null) {
			pitch = _pitch;
			_channel.addEventListener(Event.SOUND_COMPLETE, stopped);
		}
	}

	function stopped(?_):Void {
		if (onComplete != null)
			onComplete();

		if (looped && (loopUntil == -1 || loopCount < loopUntil)) {
			loopCount++;

			cleanup(false, false);
			startSound(loopTime);
		} else {
			_time = 0; // Remove this line in 7.0.0
			cleanup(autoDestroy, false);
		}
	}

	function cleanup(destroySound:Bool, resetPosition:Bool = true):Void {
		if (destroySound) {
			reset();
			return;
		}

		if (_channel != null) {
			_channel.removeEventListener(Event.SOUND_COMPLETE, stopped);
			_channel.stop();
			_channel = null;
		}

		if (resetPosition) {
			_time = 0;
			_paused = false;
			loopCount = 0;
		}
	}

	function onSoundSet() {
		_length = _sound.length;
		endTime = _length;
	}
}
