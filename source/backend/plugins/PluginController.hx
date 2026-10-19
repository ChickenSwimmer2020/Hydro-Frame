package backend.plugins;

import backend.plugins.data.PluginData;
import engine.scripts.ScriptHelper;
import engine.scripts.ScriptManager;
import haxe.io.Path;
import hxscript.Module;
import hxscript.types.ScriptedClass;

/**
 * Use this to actually call functions on plugins. This
 * technically is also a `Plugin`, but only so that it can
 * have the same methods as calling other loaded plugins.
 * 
 * @since 0.8.6
 */
class PluginController extends Plugin {
	/**
	 * The global list of plugins.
	 * 
	 * @since 0.10.0
	 */
	public static var pluginList(get, never):Array<String>;

	private static function get_pluginList():Array<String> {
		if (!FileSystem.exists('plugins') || !FileSystem.isDirectory('plugins'))
			return [];

		var contents = FileSystem.readDirectory('plugins');
		var finalRes = [];
		for (content in contents) {
			var finalPath = Path.join(['plugins', content]);
			if (content.endsWith('.uhfp') || content.endsWith('.hfp'))
				finalRes.push(content);
		}
		return finalRes;
	}

	/**
	 * The plugins belonging to this `PluginController`.
	 * 
	 * @since 0.10.0
	 */
	public var plugins:Map<String, PluginData> = [];

	/**
	 * Creates a new `PluginController`.
	 * 
	 * @since 0.10.0
	 */
	public function new() {
		super();
	}

	/**
	 * Registers a plugin to this `PluginController` via a folder.
	 * 
	 * @param folder The plugin's source folder to register.
	 * @param name The plugin's name.
	 * @param id The plugin's ID.
	 * @return `PluginData` The registered plugin.
	 * @since 0.10.0
	 */
	public function registerPluginFromSource(folder:String, name:String, id:String):PluginData {
		var res = PluginLoader.loadPluginFromFolder(folder, name);
		plugins[res?.meta?.id ?? id] = res;
		return res;
	}

	/**
	 * Registers a plugin into this `PluginController` via its name.
	 * Uses `registerPluginFromSource()` under the hood.
	 * 
	 * @param name The plugin's name. Must be under `plugins/`.
	 * @param displayName The plugin's display name. Used if there's no `meta.json`.
	 * Defaults to `Unknown`.
	 * @param id The plugin's ID. Used if there's no `meta.json`.
	 * Defaults to `unknown`.
	 * @return `PluginData` The registered plugin.
	 * @since 0.10.0
	 */
	public function registerPluginFolder(name:String, ?pluginName:String = 'Unknown', ?id:String = 'unknown'):PluginData {
		var pId = id;
		var pName = pluginName;
		if (FileSystem.exists(Path.join(['plugins', name, 'meta.json']))) {
			var meta = Json.parse(File.getContent(Path.join(['plugins', name, 'meta.json'])));
			pId = meta.id;
			pName = meta.name;
		}
		return registerPluginFromSource(Path.join(['plugins', name, 'source']), pName, id);
	}

	/**
	 * Registers a plugin from a file.
	 * 
	 * @param name The path to the plugin.
	 * @param pluginName The name of the plugin, used for error reporting
	 * until `meta.json` is loaded.
	 * @return `PluginData` The registered plugin.
	 */
	public function registerPluginFromFile(name:String, pluginName:String):PluginData {
		var res = PluginLoader.loadPlugin(name, pluginName);
		plugins[res.meta.id] = res;
		return res;
	}

	/**
	 * Registers a plugin.
	 * 
	 * @param name The plugin to register
	 * @param pluginName The name of the plugin, used for error reporting
	 * until `meta.json` is loaded.
	 * @return `PluginData` The registered plugin.
	 */
	public function registerPlugin(name:String, pluginName:String):PluginData
		return registerPluginFromFile(Path.join(['plugins', name]), pluginName);

	/**
	 * Initializes all registered plugins.
	 * 
	 * @since 0.10.0
	 */
	override public function onPluginInit()
		for (plugin in plugins)
			plugin.instanceProxy.onPluginInit();
}
