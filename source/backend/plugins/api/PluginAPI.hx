package backend.plugins.api;

import backend.plugins.*;
import backend.plugins.api.io.*;
import backend.plugins.api.permission.*;
import backend.plugins.api.process.*;
import backend.plugins.data.*;
import engine.vfs.HFileSystem;

/**
 * The API for `Plugin`s to use.
 * 
 * To initialize the API, you need to ensure to call this where you
 * have access to your main plugin class. It's recommended to use
 * your main plugin class for this, even though it isn't required.
 * When initializing, don't make it on `new()` during module construction.
 * Instead, put it on any code that runs at or after `onPluginInit()`. If
 * this condition is not satisfied, it will throw an error because your
 * plugin has not been globally bound yet.
 * 
 * The API allows you to manipulate files within the plugins, exposing APIs
 * similar to `haxe.FileSystem` and `haxe.io.File`. It works the same way
 * for both packed and unpacked plugins.
 * 
 * @since 0.10.2
 */
class PluginAPI {
	/**
	 * The file API for plugins. Exposes methods simialar to `haxe.io.File`.
	 * 
	 * @since 0.10.2
	 */
	public var fileAPI:PluginFileHelper = null;

	/**
	 * The file system API for plugins. Exposes methods simialar to `haxe.FileSystem`.
	 * 
	 * @since 0.10.2
	 */
	public var fileSystemAPI:PluginFSHelper = null;

	/**
	 * The process API for plugins. Lets you run processes inside the plugin.
	 * 
	 * @since 0.10.2
	 */
	public var processAPI:PluginProcessHelper = null;

	/**
	 * The permissions that this `Plugin` is allowed to use.
	 * 
	 * @since 0.10.2
	 */
	public var permissions:Array<PluginPermission> = [];

	/**
	 * The `PluginData` this `PluginAPI` belongs to.
	 * 
	 * @since 0.10.2
	 */
	public var data:PluginData = null;

	/**
	 * Creates a new `PluginAPI` for the given plugin. This does not need to be created/stored
	 * in your main class, but it is reccomended to do so.
	 * 
	 * ***DO NOT*** call this in your plugins constructor. At the time the constructor
	 * is called, the plugin has not been globally bound yet, and it will throw an error.
	 * Instead, put this on any code that runs at or after `onPluginInit()`.
	 * 
	 * @param plugin The plugin to create the API for. In a plugin, in your main class
	 * you should have `new PluginAPI(this);`.
	 * @since 0.10.2
	 */
	public function new(plugin:Plugin) {
		var bound = PluginController.boundPlugins[plugin];
		data = bound.data;
		var name = bound.name;
		if (name == null)
			throw 'Failed to bind the PluginAPI to plugin: Plugin has not been bound.';

		var method:PluginIOMethod = Unpacked(name);
		if (name.endsWith('.hfp'))
			method = Packed(new HFileSystem().loadFileSystem('plugins/$name'), name);

		// TODO: let the user allow specific permissions instead of accepting defaults.
		permissions = Requester.requestDefaultFrom(data.meta?.requestedPermissions ?? []);

		fileAPI = new PluginFileHelper(method, this);
		fileSystemAPI = new PluginFSHelper(method, this);
		processAPI = new PluginProcessHelper(this);
	}
}
