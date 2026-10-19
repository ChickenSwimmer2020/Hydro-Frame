package backend.plugins;

import backend.plugins.data.*;
import engine.scripts.*;
import engine.vfs.HFileSystem;
import haxe.io.Path;
import hxscript.Module;
import hxscript.compile.GlobalUse;
import hxscript.compile.Result;

class PluginPacker {
	/**
	 * Packs a plugin from a folder into a virtual file system, in the `.hfp` format.
	 * 
	 * @param folder The path to the folder to pack.
	 * @param compile Whether to compile the plugin. Only available on Windows, MacOS, and Linux.
	 * @param pluginMeta The metadata for the plugin. Optional, used if the `.uhfp` folder has
	 * no `meta.json` file.
	 * @return `HFileSystem` The packed plugin.
	 * @since 0.10.0
	 */
	public static function packPluginFromFolder(folder:String, ?compile:Bool = true, ?pluginMeta:PluginMetadata = null):HFileSystem {
		var vfs = new HFileSystem();
		vfs.importDirectory(folder, '/');
		if (!vfs.fileExists('meta.json'))
			vfs.saveContent('meta.json', Json.stringify(pluginMeta));
		else
			pluginMeta = Json.parse(vfs.getContent('meta.json'));
		if (!vfs.fileExists('_cppia.json') && compile)
			vfs.saveContent('_cppia.json', Json.stringify(compilePlugin(Path.join([folder, pluginMeta.sourceFolder]))));
		return vfs;
	}

	/**
	 * Packs a plugin into a virtual file system, in the `.hfp` format.
	 * 
	 * @param name The plugin to pack.
	 * @param compile Whether to compile the plugin. Only available on Windows, MacOS, and Linux.
	 * @param pluginMeta The metadata for the plugin. Optional, used if the `.uhfp` plugin has
	 * no `meta.json` file.
	 * @return `HFileSystem` The packed plugin.
	 * @since 0.10.0
	 */
	public static function packPlugin(name:String, ?compile:Bool = true, ?pluginMeta:PluginMetadata = null):HFileSystem
		return packPluginFromFolder(Path.join(['plugins', name]), compile, pluginMeta);

	/**
	 * Compiles a plugin from its source folder.
	 * Only available on Windows, MacOS, and Linux.
	 * 
	 * @param source The path to the source folder.
	 * @return `Array<PluginCppiaData>` The compiled plugin, or `[]` if nothing
	 * was compiled or you're not on Windows, MacOS, or Linux.
	 * @since 0.10.0
	 */
	public static function compilePlugin(source:String):Array<PluginCppiaData> {
		#if hxscript_cppia
		var mRes = new ScriptManager().loadFolder(source, [
			{
				extension: '.hx',
				compile: true,
				addToWorld: true
			},
			{
				extension: '.mhx',
				compile: true,
				addToWorld: true
			}
		]);

		var result:Array<PluginCppiaData> = [];
		for (item in mRes) {
			var res = item.compileResult.res;
			if (res == null)
				continue;
			result.push({
				path: item.path,
				data: res.bytes.toString(),
				compiled: res.compiled,
				skipped: [
					for (skip in res.skipped)
						({
							name:skip.name, reason:skip.reason, origin:skip.origin, line:skip.line
						} : PluginSkip)
				],
				globals: [
					for (global in res.globals)
						({
							module:global.module, name:global.name, spelling:global.spelling
						} : PluginGlobalUse)
				]
			});
		}
		return result;
		#else
		return [];
		#end
	}
}
