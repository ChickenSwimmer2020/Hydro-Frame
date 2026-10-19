package backend.plugins.data;

/**
 * Used for reconstructing the hxscript's "Result" object.
 * 
 * @since 0.10.0
 * @see `hxscript.compile.GlobalUse`
 */
typedef PluginGlobalUse = {
	var module:String;
	var name:String;
	var spelling:String;
}
