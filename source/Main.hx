package;

import backend.macro.GitMacro;
import backend.macro.DefineMacro;
import backend.plugins.Skin;
import backend.utils.MethodUtil;
import haxe.CallStack;
import openfl.display3D.textures.TextureBase;
import openfl.events.UncaughtErrorEvent;

class Main extends Sprite {
	/**
	 * The starting state, controls where you go when starting up the app
	 * @since 0.8.7
	 */
	public static var startingState(get, never):Class<HState>;

	static function get_startingState() {
		#if SVG_SCREEN
		return engine.rendering.svg.SVGScreen;
		#end

		#if NAUTICINK_SCREEN
		return engine.rendering.nauticink.NauticScreen;
		#end

		return SplashScreen;
	}

	/**
	 * Entry point of Hydro-Frame for launching, this is what does stuff before any state loads.
	 * @since 0.0.0
	 */
	public function new() {
		fixColorFlipping();

		super();

		#if PRETTY_LOGGING
		haxe.Log.trace = Logger.log;
		#end

		Log.throwErrors = false;

		instance = this;
		HTween.globalParent = this; // so that new Tween() will auto-destroy and not cause memory leaks.

		initStage();

		WindowUtil.window.onClose.add(onClosing);
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrashing);

		WindowUtil.setTitle('${WindowUtil.window_title} [ ${Application.current.meta.get("version")}${#if GIT_INFO ' (${GitMacro.gitBranch()}/${GitMacro.gitHash()})' #else '' #end} ]');

		windowManager = new HWindowManager();

		addChild(StateSystem = new StateSystemInit(null));
		StateSystem.switchState(startingState);

		createDebugDisplay();

		Mouse.hide();

		UPrefs.currentSkin = new Skin("Default"); // init the skinning system.
	}

	/**
	 * Fix a color flipping bug
	 * 
	 * @since 0.9.1
	 */
	function fixColorFlipping() {
		// To fix the color flipping.
		@:privateAccess {
			TextureBase.__supportsBGRA = true;
			TextureBase.__textureFormat = 0x80E1; // GL_BGRA
		}
	}

	/**
	 * Init things related to `stage`
	 * 
	 * @since 0.9.1
	 */
	function initStage() {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		stage.addEventListener(Event.RESIZE, onStageResize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(MouseEvent.CLICK, onMouseClick);

		onStageResize(null); // apply once at startup
	}

	/**
	 * Creates and adds the debug display
	 * 
	 * @since 0.9.1
	 */
	function createDebugDisplay() {
		#if debug
		stats = new DebugDisplay();
		stage.addChild(stats); // add to stage directly so it's always on top
		stats.x = 10;
		stats.y = 10;
		stats.visible = UPrefs.debuggerVisible.value;
		#end
	}

	/**
	 * Instance access to Main
	 * @since 0.2.0
	 */
	public static var instance:Main;

	/**
	 * Program internal width
	 * @since 0.1.0
	 */
	public static var pWidth:Int = 1280;

	/**
	 * Program internal height
	 * @since 0.1.0
	 */
	public static var pHeight:Int = 720;

	/**
	 * the current mouse position, relative to the resized/scaled stage
	 * @since 0.2.0
	 */
	public static var vMouse:HPoint = new HPoint(0, 0);

	/**
	 * for managing the in-windows windows of Hydro-Frame
	 * @since 0.2.0
	 */
	public static var windowManager:HWindowManager;

	#if debug
	/**
	 * DEBUG EXCLUSIVE
	 * Debugger stats, inclueds fps, memory, and loaded objects.
	 * @since 0.0.0
	 */
	public var stats:DebugDisplay;
	#end

	/**
	 * State system, controls the actual states of Hydro-Frame, this is actually a very important thing.
	 * @since 0.0.0
	 */
	public static var StateSystem:StateSystemInit; // defaults to splashscreen since thats literally the only thing it does on init

	/**
	 * For checking when global keys are pressed.
	 * @since 0.4.0
	 */
	private static var onKeyPressed:Map<String, {k:String, ar:Bool, c:KeyboardEvent->Void}>;

	/**
	 * Add an listener to `onKeyPressed` globally, functions are set when this function is called.
	 * @param a the name of the listener
	 * @param k the key to listen to (set to "*" for any key)
	 * @param autoRemove should the listener remove automatically?
	 * @param c the function to run
	 * @since 0.4.0
	 */
	public static function addKeyPressed(a:String, k:Dynamic, autoRemove:Bool = true, c:KeyboardEvent->Void) {
		if (onKeyPressed == null)
			onKeyPressed = new Map<String, {k:String, ar:Bool, c:KeyboardEvent->Void}>();
		if (onKeyPressed.get(a) != null)
			return; // cuz it already exists, so why add it again?
		onKeyPressed.set(a, {k: Std.string(k), ar: autoRemove, c: c});
		trace('added "$a" to keyboard listener.');
	}

	/**
	 * Remove a listener from the event pool, only realled used when autoRemove is true
	 * @param a target listener
	 * @return Bool if the listener was removed correctly
	 * @since 0.4.0
	 */
	public static function removeKeyPressed(a:String):Bool {
		onKeyPressed.remove(a);
		trace('removed "$a" from keyboard listener.');
		return onKeyPressed.get(a) == null;
		return false;
	}

	/**
	 * Used with the listener system for checking when a key is pressed and doing an associated action
	 * @param e 
	 * @since 0.1.0
	 */
	private function onKeyDown(e:KeyboardEvent) {
		#if (debug) // whoops.
		if (e.keyCode == Keyboard.F1) {
			stats.visible = !stats.visible;
			UPrefs.debuggerVisible.value = stats.visible;
		}
		#end

		if (onKeyPressed != null)
			for (label => info in onKeyPressed) {
				if (label == null || info == null)
					continue;

				if (info.k == "*") {
					if (info.c != null) {
						info.c(e);
						info.ar ? removeKeyPressed(label) : null;

						continue;
					}

					trace('Null info found with $label!!');
					continue;
				}

				var tk:Null<Int> = Std.parseInt(info.k);
				if (tk == null) {
					trace('Couldnt parse ${info.k} on $label, so we\'re skipping it.');
					continue;
				}

				if (e.keyCode == tk) {
					if (info.c != null) {
						info.c(e);
						info.ar ? removeKeyPressed(label) : null;
						continue;
					}

					trace('Null info found with $label!!');
					continue;
				}
			}

		if (!HDropdown.dropdownOpen)
			return;

		// dropdownCommands(e);
	}

	/**
	 * TODO: fix this.
	 * For commands on a dropdown having keybinds
	 * 
	 * @since 0.9.1
	 */
	function dropdownCommands(e:KeyboardEvent) {
		for (keys => targetOption in HDropdown.dropdownKeys) {
			if (!keys.contains(e.keyCode) && (!e.shiftKey && (!e.altKey && !e.controlKey))) {
				if (HDropdown.canCloseInstace)
					HDropdown.closeDropdownMenu(); // force close any open instance.
				continue;
			}

			var targetKeys:Array<Bool> = [];
			var allKeys:Array<Int> = keys;

			for (key in allKeys) {
				if (key == Keyboard.CONTROL) {
					targetKeys.push(e.controlKey);
					allKeys.splice(allKeys.indexOf(17), 1);
					continue;
				}

				if (key == Keyboard.ALTERNATE) {
					targetKeys.push(e.altKey);
					allKeys.splice(allKeys.indexOf(18), 1);
					continue;
				}

				if (key == Keyboard.SHIFT) {
					targetKeys.push(e.shiftKey);
					allKeys.splice(allKeys.indexOf(16), 1); // remove the key from the array
					continue; // then skip over the index
				}

				allKeys.splice(allKeys.indexOf(e.keyCode), 1); // remove the key from the array

				trace(targetKeys);
			}
		}
	}

	/**
	 * Used mostly for closing dropdowns when needed, might be expanded in the future.
	 * @param e mouseEvent, this is called by underlying Lime layers 
	 * @since 0.1.0
	 */
	private function onMouseClick(e:MouseEvent) {
		if (HDropdown.dropdownOpen && HDropdown.canCloseInstace)
			checkClosingDropdown();

		if (HDropdown.subDropdownOpen && HDropdown.canCloseSubInstace)
			checkClosingSubDropdown();
	}

	function checkClosingDropdown() {
		if (!HDropdown.dropdownBG.containsMouse()) { // if off the backing, then exit.
			HDropdown.closeDropdownMenu(); // force close any open instance.
			return;
		}

		for (object in HDropdown.members) {
			if (object == HDropdown.dropdownBG)
				continue; // skip it and dont increase index

			var obj:HSprite = cast(object, HSprite);

			if (!obj.containsMouse())
				continue;

			final isDropdownObject = cast(obj.getAttribute("isDropdownObject"), Bool) == true;
			final closeOnClick = cast(obj.getAttribute("isDropdownObject"), Bool) == true;

			if (isDropdownObject && closeOnClick)
				HDropdown.closeDropdownMenu();
		}
	}

	function checkClosingSubDropdown() {
		if (!HDropdown.subDropdownBG.containsMouse()) { // if off the backing, then exit.
			HDropdown.closeSubDropdownMenu(); // force close any open instance.
			return;
		}

		for (object in HDropdown.members) {
			if (object == HDropdown.subDropdownBG)
				continue; // skip it and dont increase index

			var obj:HSprite = cast(object, HSprite);

			if (!obj.containsMouse())
				continue;

			final closeFullDropdown = cast(obj.getAttribute("closeFullDropdown"), Bool) == true;
			final isSubDropdownObject = cast(obj.getAttribute("isSubDropdownObject"), Bool) == true;
			final closeOnClick = cast(obj.getAttribute("isDropdownObject"), Bool) == true;

			if (closeFullDropdown) {
				HDropdown.closeSubDropdownMenu();
				HDropdown.closeDropdownMenu(); // cuz, close the whole thing.
				continue;
			}

			if (isSubDropdownObject && closeOnClick)
				HDropdown.closeSubDropdownMenu();
		}
	}

	/**
	 * OPENFL's actual scale mode for Stage is ASS AF. so we're gonna do it properly.
	 * 
	 * Resizes the window, but also the stage properly, its based on the way that flixel sizes FlxGame.
	 * @param _ Event, called by underlying Lime Layers
	 * @since 0.1.0
	 */
	private function onStageResize(_:Event):Void {
		var w = stage.stageWidth;
		var h = stage.stageHeight;
		var s = Math.min(w / pWidth, h / pHeight);

		scaleX = scaleY = s;
		x = (w - pWidth * s) / 2;
		y = (h - pHeight * s) / 2;
		updateVirtualMouse();
	}

	/**
	 * Called whenever the mouse moves, only used to update the `vMouse` variable.
	 * @param _ MouseEvent
	 * @since 0.1.0
	 */
	private inline function onStageMouseMove(_:MouseEvent):Void
		updateVirtualMouse();

	/**
	 * Actually updates the `vMouse` variable.
	 */
	private inline function updateVirtualMouse():Void
		vMouse.set(((stage.mouseX - x) / scaleX), ((stage.mouseY - y) / scaleY));

	/**
	 * Called when the window is closing, currently used for cleanup.
	 * @since 0.1.0
	 */
	public function onClosing() {
		#if debug
		stats.destroy();
		#end

		stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.removeEventListener(Event.RESIZE, onStageResize);
		WindowUtil.window.onClose.remove(onClosing);
	}

	@:unwrapSafe
	function onCrashing(e:UncaughtErrorEvent):Void {
		e.preventDefault();
		if (showCrash(e.error, CallStack.callStack(), true) == 1)
			StateSystem.resetState();
		else
			Sys.exit(1);
	}

	@:unwrapSafe
	public static function showCrash(message:String, stack:CallStack, isFatal:Bool = false):Int {
		var error:String = '$message\nPlease report this on the github: https://github.com/ChickenSwimmer2020/Hydro-Frame/issues\n\nCall Stack:\n';
		@:privateAccess stack.asArray().reverse();

		function pushStack(stackItem:StackItem) {
			switch (stackItem) {
				case Method(classname, method):
					error += 'Called from ${(classname == null ? '<??' + '?>' : classname)}::$method ';
				case FilePos(s, file, line, _):
					switch (s) {
						case null:
							error += '$file line $line\n';
						case Method(_, method):
							var finalClass = file.replace('/', '.').replace('.hx', '');
							error += '$finalClass line $line\n    ${MethodUtil.getSig(finalClass, method)}\n';
						default:
							pushStack(s);
					}
				default:
					trace(stackItem);
			}
		}

		for (stackItem in stack)
			pushStack(stackItem);

		trace('\n$error');

		var options = ['Exit', 'Retry', 'Continue'];

		if (!isFatal) {
			function runNonFatal():Int {
				switch (WindowUtil.window.alert(ERROR, error, 'Error', ['Exit', 'Retry', 'Continue'])) {
					case 0:
						return 0;
					case 1:
						return 1;
					case 2:
						return WindowUtil.window.alert(WARNING, 'Are you sure? This could cause undefined behavior.', 'Continue?',
							['Go Back', 'Continue']) == 1 ? 2 : runNonFatal();
				}
				return 0;
			}
			return runNonFatal();
		}

		switch (WindowUtil.window.alert(ERROR, error, 'FATAL ERROR', ['Exit', 'Retry'])) {
			case 0:
				return 0;
			case 1:
				return WindowUtil.window.alert(WARNING, 'Are you sure? This could cause undefined behavior.', 'RETRY', ['Exit', 'Retry']) == 1 ? 1 : 0;
		}

		return 0;
	}
}
