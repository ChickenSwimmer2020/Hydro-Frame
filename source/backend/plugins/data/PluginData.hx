package backend.plugins.data;

import backend.plugins.Plugin;
import engine.scripts.*;

/**
 * The data for a `Plugin`.
 * 
 * @since 0.10.0
 */
typedef PluginData = {
	/**
	 * The class proxy for the `Plugin`.
	 * Contains the extended class of the `Plugin`. Use this for
	 * static field access and methods.
	 * 
	 * @since 0.10.0
	 */
	var classProxy:ScriptedClassProxy;

	/**
	 * The instance proxy for the `Plugin`.
	 * Contains the instance of the `Plugin`. Use this for
	 * instance field access and methods.
	 * 
	 * @since 0.10.0
	 */
	var instanceProxy:ScriptedInstanceProxy;

	/**
	 * The `Plugin` this `PluginData` belongs to.
	 * This is really just the unproxied instance of `classProxy`.
	 * 
	 * @since 0.10.0
	 */
	var plugin:Plugin;

	/**
	 * The `ScriptManager` this `PluginData`s `Plugin` belongs to.
	 * 
	 * @since 0.10.0
	 */
	var manager:ScriptManager;

	/**
	 * The source data of the `Plugin`. This is set
	 * to the result of a folder load.
	 * 
	 * @since 0.10.0
	 */
	var sourceData:Array<ModuleResult>;

	/**
	 * The metadata of the `Plugin`. This is set
	 * when the plugin is loaded with metadata available.
	 * 
	 * @since 0.10.0
	 */
	var ?meta:PluginMetadata;
}
