package engine.scripts;

import engine.vfs.*;
import haxe.io.Path;
import hxscript.Config;
import hxscript.Environment;
import hxscript.Module;
import hxscript.compile.Compiler;
import hxscript.compile.Result;
import hxscript.types.ScriptedClass;
import hxscript.types.ScriptedTools;

/**
 * A manager for loading and compiling scripts.
 * Compilation is only available on Windows, MacOS, and Linux.
 * 
 * @since 0.10.0
 */
class ScriptManager {
	/**
	 * The world that every loaded script and type lives in.
	 * 
	 * @since 0.10.0
	 */
	public var world:Environment;

	/**
	 * Creates a new `ScriptManager`.
	 * 
	 * @param jit Whether to use JIT compilation. Only available on Windows, MacOS, and Linux.
	 */
	public function new(jit:Bool = true) {
		world = new Environment();
		#if hxscript_cppia
		Compiler.jit = jit;
		#end
	}

	/**
	 * Loads a folder of scripts into `Module`s.
	 * 
	 * @param folder The path to the folder to load.
	 * @param rules An array of `ModuleRule`s. The first rule that matches a file will be used.
	 * @param pack The package that everything in this folder is under. Ex: If the source starts
	 * at `source/` but the folder you're trying to load is `source/objs`, then you would set
	 * `pack` to `['objs']`. But if the source starts at `source/`, and the folder you're trying
	 * to load is `source/`, then you would set `pack` to `[]` or `null`.
	 * @param compiled An optional map of compiled modules. `['file.package.here.File.hx' -> Result]` 
	 * If not null, the compiler will use this instead of recompiling. Only available on Windows, MacOS, and Linux.
	 * @return `Array<ModuleResult>` Each module that was loaded. If not on
	 * Windows, MacOS, or Linux, `compileResult` will always be `null`. Otherwise, it depends on the rules.
	 * @see `ModuleRule`
	 * @since 0.10.0
	 */
	public function loadFolder(folder:String, rules:Array<ModuleRule>, ?pack:Array<String>, ?compiled:Map<String, Result>):Array<ModuleResult> {
		var modules = [];

		if (FileSystem.exists(folder)) {
			if (pack == null)
				pack = [];

			var pExts:Map<Array<Dynamic>, ModuleRule> = [];
			var exts:Map<String, ModuleRule> = [];
			for (rule in rules)
				if (rule.pack != null)
					pExts[([rule.extension, rule.pack] : Array<Dynamic>)] = rule;
				else
					exts[rule.extension] = rule;

			for (item in FileSystem.readDirectory(folder)) {
				var fullPath = Path.join([folder, item]);
				if (FileSystem.isDirectory(fullPath))
					modules = modules.concat(loadFolder(fullPath, rules, pack.concat([item]), compiled));
				else {
					var ext = '.${item.split('.').pop()}';

					function pushModule(rule:ModuleRule) {
						var name = item.replace(ext, '');
						var getName = rule.getName ?? (fName) -> '[Script $fName]';
						var module = loadModule(File.getContent(fullPath), getName(name), name, pack, rule.addToWorld, rule.compile,
							compiled != null ? compiled.get(pack.concat([item]).join('.')) : null);
						module.path = Path.join([pack.join('/'), item]);
						if (rule.onFound != null)
							rule.onFound(module);
						modules.push(module);
					}

					function pGet(ext, pack):Null<ModuleRule> {
						var rule = null;
						for (key in pExts.keys()) {
							if (key[0] == ext) {
								if (key[1] == null && pack == [] || key[1] == pack) {
									rule = pExts[key];
									break;
								}
								var success = true;
								for (pkId in 0...key[1].length) {
									if (key[1][pkId] != pack[pkId]) {
										success = false;
										break;
									}
								}
								if (success) {
									rule = pExts[key];
									break;
								}
							}
						}
						return rule;
					}

					if (exts.exists(ext))
						pushModule(exts[ext]);
					else if (pGet(ext, pack) != null)
						pushModule(pGet(ext, pack));
				}
			}
		}

		return modules;
	}

	/**
	 * Loads a virtual folder of scripts into `Module`s.
	 * 
	 * @param vfs The virtual file system to load from.
	 * @param folder The path to the folder to load.
	 * @param rules An array of `ModuleRule`s. The first rule that matches a file will be used.
	 * @param pack The package that everything in this folder is under. Ex: If the source starts
	 * at `source/` but the folder you're trying to load is `source/objs`, then you would set
	 * `pack` to `['objs']`. But if the source starts at `source/`, and the folder you're trying
	 * to load is `source/`, then you would set `pack` to `[]` or `null`.
	 * @param compiled An optional map of compiled modules. `['file.package.here.File.hx' -> Result]` 
	 * If not null, the compiler will use this instead of recompiling. Only available on Windows, MacOS, and Linux.
	 * @return `Array<ModuleResult>` Each module that was loaded. If not on
	 * Windows, MacOS, or Linux, `compileResult` will always be `null`. Otherwise, it depends on the rules.
	 * @see `ModuleRule`
	 * @since 0.10.0
	 */
	public function loadFolderFromVFS(vfs:HFileSystem, folder:String, rules:Array<ModuleRule>, ?pack:Array<String>,
			?compiled:Map<String, Result>):Array<ModuleResult> {
		var modules = [];

		if (vfs.dirExists(folder)) {
			if (pack == null)
				pack = [];

			var pExts:Map<Array<Dynamic>, ModuleRule> = [];
			var exts:Map<String, ModuleRule> = [];
			for (rule in rules)
				if (rule.pack != null)
					pExts[([rule.extension, rule.pack] : Array<Dynamic>)] = rule;
				else
					exts[rule.extension] = rule;

			@:privateAccess
			for (fPath => fObj in vfs.navigateDirectory(folder).contents) {
				var fullPath = Path.join([folder, fPath]);
				if (fObj is HFolder)
					modules = modules.concat(loadFolderFromVFS(vfs, fullPath, rules, pack.concat([fPath]), compiled));
				else {
					var file = (cast fObj : HFile);
					var ext = '.${file.name.split('.').pop()}';

					function pushModule(rule:ModuleRule) {
						var name = file.name.replace(ext, '');
						var getName = rule.getName ?? (fName) -> '[Script $fName]';
						var module = loadModule(file.contents.toString(), getName(name), name, pack, rule.addToWorld, rule.compile,
							compiled != null ? compiled.get(pack.concat([file.name]).join('.')) : null);
						module.path = Path.join([pack.join('/'), file.name]);
						if (rule.onFound != null)
							rule.onFound(module);
						modules.push(module);
					}

					function pGet(ext, pack:Array<String>):Null<ModuleRule> {
						var rule = null;
						for (key in pExts.keys()) {
							if (key[0] == ext) {
								var keyPack:Array<String> = key[1];
								if (keyPack == null && pack.length == 0) {
									rule = pExts[key];
									break;
								}
								if (keyPack == null || keyPack.length != pack.length)
									continue;
								var success = true;
								for (pkId in 0...keyPack.length) {
									if (keyPack[pkId] != pack[pkId]) {
										success = false;
										break;
									}
								}
								if (success) {
									rule = pExts[key];
									break;
								}
							}
						}
						return rule;
					}

					if (exts.exists(ext))
						pushModule(exts[ext]);
					else if (pGet(ext, pack) != null)
						pushModule(pGet(ext, pack));
				}
			}
		}

		return modules;
	}

	/**
	 * Loads a script into a `Module`.
	 * 
	 * @param data The source code of the `Module`.
	 * @param id The id of the `Module`. Used for error reporting or logging. Defaults to `Script`.
	 * @param name The name of the `Module`. Defaults to `Unknown`.
	 * @param pack The package that this `Module` is located in. Ex: if it's under source/game/objs, the pack would be `['game', 'objs']`.
	 * @param addToWorld Whether to add the `Module` to the world and initializes it.
	 * @param compile Whether to compile the script. Only available on Windows, MacOS, and Linux.
	 * @param lastCompiled The result of the last compilation. Optional. If not null, the compiler will use this instead of recompiling.
	 * Only available on Windows, MacOS, and Linux.
	 * @return `ModuleResult` if not on Windows, MacOS, or Linux, or `compile` is `false`, `compileResult` will be `null`.
	 * @since 0.10.0
	 */
	public function loadModule(data:String, id:String = 'Script', name:String = 'Unknown', pack:Array<String> = null, addToWorld:Bool = true,
			compile:Bool = true, ?lastCompiled:Result = null):ModuleResult {
		if (pack == null)
			pack = [];
		var module = new Module(data, name, pack, id);
		if (addToWorld) {
			world.addModule(module);
			module.init(world);
			module.start(world);
			module.startTypes(world);
		}
		#if hxscript_cppia
		var cRes = null;
		if (compile)
			cRes = Compiler.compileSingular(world, module, lastCompiled);
		#end
		return {
			module: module,
			compileResult: cRes
		};
	}
}
