package backend.plugins.data;

/**
 * Used for reconstructing the hxscript's "Result" object.
 * 
 * @since 0.10.0
 * @see `hxscript.compile.Skip`
 */
typedef PluginSkip = {
	var name:String;
	var reason:String;
	var ?origin:String;
	var line:Int;
}
