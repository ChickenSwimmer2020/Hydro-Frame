package engine.scripts;

/**
 * A rule for loading a script. A rule is activated either when the package and extension match, 
 * or when the extension matches and there is no package to match. A rule determines whether to
 * add the file to the world, and whether to compile it. The rule can also have a callback to
 * call when the file is found.
 * 
 * ---
 * 
 * Examples:
 * 
 * - If you wanted to load all `.hx` files add them to the world and compile them, your rule
 * would be `{extension: '.hx', addToWorld: true, compile: true}`.
 *   - But if you wanted to run a callback when the file is found, your rule would be
 *   `{extension: '.hx', onFound: (moduleRes) -> { trace(moduleRes.module.name); }, addToWorld: true, compile: true}`
 * 
 * - If you only wanted to compile, lets say `.nhx` files, but not add them to the world,
 * your rule would be `{extension: '.nhx', addToWorld: false, compile: true}`.
 *   - But if you only wanted to capture those `.nhx` files but only if they were under the
 *   package `backend.network`, your rule would be
 *   `{extension: '.nhx', pack: ['backend', 'network'], addToWorld: false, compile: true}`.
 *   - Or maybe you wanted to make the display name of the file `Custom::ScriptHere` instead of
 *   `[Script ScriptHere]`. In that case, your rule would be
 *   `{extension: '.nhx', addToWorld: false, compile: true, getName: (name) -> 'Custom::$name'}`
 * 
 * @since 0.10.0
 */
typedef ModuleRule = {
	/**
	 * The extension this rule applies to.
	 * 
	 * @since 0.10.0
	 */
	var extension:String;

	/**
	 * The callback to call when the file is found.
	 * Can be left null for no callback.
	 * 
	 * @since 0.10.0
	 */
	var ?onFound:ModuleResult->Void;

	/**
	 * The package this rule applies to.
	 * Can be left null for any package.
	 * 
	 * @since 0.10.0
	 */
	var ?pack:Array<String>;

	/**
	 * Whether to add this file to the world and initialize it.
	 * 
	 * @since 0.10.0
	 */
	var addToWorld:Bool;

	/**
	 * Whether to compile this file. Only available on Windows, MacOS, and Linux.
	 * 
	 * @since 0.10.0
	 */
	var compile:Bool;

	/**
	 * A function to get the display name of the module. Used
	 * for logging. Can be left null for the default display name.
	 * 
	 * @since 0.10.0
	 */
	var ?getName:String->String;
}
