package backend.plugins.data;

/**
 * The compiled Cppia for a plugin.
 * 
 * @since 0.10.0
 */
typedef PluginCppiaData = {
	/**
	 * The source-relative path to the compiled Cppia.
	 * 
	 * @since 0.10.0
	 */
	var path:String;

	/**
	 * The content of the compiled Cppia.
	 * 
	 * @since 0.10.0
	 */
	var data:String;

	// The rest of these fields are purely for reconstructing the hxscript's "Result" object.
	// I don't need docs for these, it's note like anyone is gonna use them
	var compiled:Array<String>;
	var skipped:Array<PluginSkip>;
	var globals:Array<PluginGlobalUse>;
}
