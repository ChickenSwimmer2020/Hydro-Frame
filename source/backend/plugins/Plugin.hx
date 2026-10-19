package backend.plugins;

import backend.plugins.data.PluginMetadata;

/**
 * A `Plugin` for Hydro-Frame. Meant to be extended by scripts.
 * 
 * @since 0.8.6
 */
class Plugin {
	/**
	 * Constructs a new `Plugin`.
	 * It is not recommended to use this constructor. You should instead
	 * use a `PluginController`, or just load one directly with `PluginLoader`.
	 * If you use this constructor, this `Plugin` will be comeletely blank.
	 * 
	 * @since 0.8.6
	 */
	public function new() {}

	/**
	 * A function to run when this plugin should be loaded.
	 * 
	 * @since 0.10.0
	 */
	public function onPluginInit() {}
}
