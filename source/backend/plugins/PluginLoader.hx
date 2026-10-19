package backend.plugins;

import backend.plugins.data.*;
import engine.scripts.*;
import engine.vfs.HFileSystem;
import haxe.io.Path;
import hxscript.Module;
import hxscript.compile.GlobalUse;
import hxscript.compile.Result;
import hxscript.compile.Skip;

/**
 * Allows loading plugin files into `Plugin` objects.
 * Used by `PluginController`.
 * 
 * @see `Plugin`
 * @see `PluginController`
 * @since 0.8.6
 */
class PluginLoader {
	/**
	 * The rules for loading a plugin.
	 * 
	 * @since 0.10.0
	 */
	public static final LOAD_RULES:(PluginData, String) -> Array<ModuleRule> = (res, pluginName) -> ([
		{
			extension: '.hx',
			addToWorld: true,
			compile: true,
			getName: (name) -> '$name'
		},
		{
			extension: '.mhx',
			addToWorld: true,
			compile: true,
			pack: [],
			getName: (name) -> '$name',
			onFound: (moduleRes) -> {
				var plugin = moduleRes.module;
				var classProxy = null;
				for (cls in ScriptHelper.getClassesFrom(plugin)) {
					if (ScriptHelper.descendsFrom(cls, Plugin)) {
						classProxy = ScriptHelper.proxy(cls);
						break;
					}
				}
				if (classProxy == null)
					throw 'Failed to load plugin main file for plugin "$pluginName": Module ${plugin.name} does not extend Plugin.';
				res.classProxy = classProxy;
				res.instanceProxy = classProxy.__new();
				res.plugin = res.instanceProxy.__instance;
			}
		}
	] : Array<ModuleRule>);

	/**
	 * Loads a plugin via a `Module`.
	 * 
	 * @param folder The folder to load the plugin from.
	 * @param pluginName The name of the plugin, if there's no `meta.json` file.
	 * @return `PluginData` The data for the plugin.
	 * @since 0.10.0
	 */
	public static function loadPluginFromFolder(folder:String, pluginName:String):PluginData {
		var res:PluginData = {
			classProxy: null,
			instanceProxy: null,
			plugin: null,
			manager: null,
			sourceData: null,
			meta: FileSystem.exists(Path.join([folder, 'meta.json'])) ? Json.parse(File.getContent(Path.join([folder, 'meta.json']))) : null
		};

		res.manager = new ScriptManager();

		if (res.meta != null)
			pluginName = res.meta.displayName;
		res.sourceData = res.manager.loadFolder(folder, LOAD_RULES(res, pluginName));

		return res;
	}

	/**
	 * Loads a plugin from a `.hfp` file.
	 * 
	 * @param path The path to the `.hfp` file.
	 * @param pluginName The name of the plugin. This value
	 * is used for error reporting until `meta.json` is loaded.
	 * @return `PluginData` The data for the plugin.
	 */
	public static function loadPlugin(path:String, pluginName:String):PluginData {
		// Prep the data first.
		var vfs = new HFileSystem().loadFileSystem(path);
		if (!vfs.fileExists('meta.json'))
			throw 'Failed to load plugin "$pluginName": No meta.json file found.';

		var meta:PluginMetadata = null;
		try {
			meta = Json.parse(vfs.getContent('meta.json'));
		} catch (e:Exception) {
			throw 'Failed to load plugin "$pluginName": Failed to parse meta.json file: ${e.message}';
		}

		var compiled:Map<String, Result> = [];
		if (vfs.fileExists('_cppia.json')) {
			var cppiaData:Array<PluginCppiaData> = Json.parse(vfs.getContent('_cppia.json'));
			for (item in cppiaData) {
				compiled.set(item.path.replace('/', '.').replace('\\', '.'), {
					bytes: Bytes.ofString(item.data),
					compiled: item.compiled,
					skipped: [
						for (skip in item.skipped)
							({
								name:skip.name, reason:skip.reason, origin:skip.origin, line:skip.line
							} : Skip)
					],
					globals: [
						for (global in item.globals)
							({
								module:global.module, name:global.name, spelling:global.spelling
							} : GlobalUse)
					]
				});
			}
		}

		// Then load what we prepared.
		var res:PluginData = {
			classProxy: null,
			instanceProxy: null,
			plugin: null,
			manager: null,
			sourceData: null,
			meta: meta
		};

		res.manager = new ScriptManager();

		pluginName = res.meta.displayName;
		res.sourceData = res.manager.loadFolderFromVFS(vfs, meta.sourceFolder, LOAD_RULES(res, pluginName), null, compiled);

		return res;
	}
}
