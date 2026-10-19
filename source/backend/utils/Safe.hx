package backend.utils;

@:dox(hide) @:noCompletion class Safe {
	@:dox(hide) @:noCompletion public static function run(fn:Void->Void, ?label:String) {
		while (true) {
			try {
				fn();
				return;
			} catch (e:Exception) {
				var res = Main.showCrash(e.message, e.stack);
				switch (res) {
					case 0:
						Sys.exit(1);
					case 1:
						continue;
					case 2:
						return;
				}
			}
		}
	}

	@:dox(hide) @:noCompletion public static function runR<T>(fn:Void->T, fallback:T, ?label:String):T {
		while (true) {
			try {
				return fn();
			} catch (e:Exception) {
				var res = Main.showCrash(e.message, e.stack);
				switch (res) {
					case 0:
						Sys.exit(1);
					case 1:
						continue;
					case 2:
						return fallback;
				}
			}
		}
	}

	/**
	 * Runs the given function on the next frame on the main thread.
	 * Use this when you want to run code on the main thread when executing
	 * on another thread.
	 * 
	 * @param fn The function to run on the next frame.
	 * @since 0.10.0
	 */
	public static function onNextFrame(fn:Void->Void) {
		var listener:Event->Void = null;
		var stage = Main.instance.stage;
		listener = (e) -> {
			stage.removeEventListener(Event.ENTER_FRAME, listener);
			fn();
		};
		stage.addEventListener(Event.ENTER_FRAME, listener);
	}
}
