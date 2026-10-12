package backend.debug.logging;

/**
 * Log Management Class
 * 
 * @since Pretty_Logging
 */
class Logger {
	/**
	 * List of logged logs
	 * 
	 * @since Pretty_Logging
	 */
	static var logs(default, null):Array<String> = [];

	/**
	 * Log command
	 * @param message Log message
	 * @param posInfos Class information
	 * @since Pretty_Logging
	 */
	public static function log(message:Dynamic, ?posInfos:PosInfos) {
		var str:String = '';

		if (posInfos != null)
			str += '[${posInfos.fileName}:${posInfos.lineNumber}] : ';

		str += '$message';

		logs.push(str);

		// yoinked from haxe.Log.trace
		// except it doesnt crash if it's an unsupported platform

		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(str);
		#elseif lua
		untyped __define_feature__("use._hx_print", _hx_print(str));
		#elseif sys
		Sys.println(str);
		#else
		// throw new haxe.exceptions.NotImplementedException();
		haxe.Log.vanillaTrace(str);
		#end
	}
}
