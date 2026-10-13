package backend.plugins;

/**
 * Use this to actually call stuff on plugins
 * @since 0.8.6
 */
class PluginController {
	public function new() {}

	/**
	 * Call a function on plugins
	 * @param func String the function to run
	 * @param args Array<Dynamic> the arguments to pass to the function. optional
	 * @since 0.8.6
	 */
	public function callOnPlugins(func:String, ?args:Array<Dynamic>) {}
}

/**
 * Wrapper class, used for actually calling stuff from a plugin file.
 * @since 0.8.6
 */
class Plugin {
	public function new() {}
}
