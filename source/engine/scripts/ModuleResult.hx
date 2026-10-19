package engine.scripts;

import hxscript.Module;
import hxscript.compile.Report;
import hxscript.compile.Result;

/**
 * The result of loading and compiling a script.
 * 
 * @since 0.10.0
 */
typedef ModuleResult = {
	/**
	 * The loaded `Module`.
	 * 
	 * @since 0.10.0
	 */
	var module:Module;

	/**
	 * The path to the source code of the `Module`.
	 * Only available if loaded from folder.
	 * 
	 * @since 0.10.0
	 */
	var ?path:String;

	/**
	 * The result of compiling the `Module`.
	 * Always `null` if not on Windows, MacOS, or Linux.
	 * 
	 * @since 0.10.0
	 */
	var compileResult:{rep:Report, res:Result};
};
