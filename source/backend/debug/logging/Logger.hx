package backend.debug.logging;

#if macro
import haxe.PosInfos;
import sys.FileSystem;
import sys.io.File;

using StringTools;
#end

/**
 * Log Management Class
 * 
 * @since 0.8.8
 */
class Logger {
	/**
	 * For sending to the debug log file
	 * @since 0.9.3
	 */
	private static var toLog:Array<{
		time:String,
		message:String,
		file:String,
		func:String
	}> = [];

	/**
	 * List of logged logs
	 * 
	 * @since 0.8.8
	 */
	static var logs(default, null):Array<String> = [];

	/**
	 * Log command
	 * @param message Log message
	 * @param posInfos Class information
	 * @since 0.8.8
	 */
	public static function log(message:Dynamic, ?posInfos:PosInfos) {
		var str:String = '';

		var tag:String = "\x1b[38;5;61m[OTHER]\x1b[0m";
		if (Std.string(message).startsWith("INFO:"))
			tag = "[INFO]";
		if (Std.string(message).startsWith("WARNING:") || Std.string(message).startsWith("WARN:"))
			tag = "\x1b[38;5;226m[WARNING]\x1b[0m";
		if (Std.string(message).startsWith("DEBUG:"))
			tag = "\x1b[38;5;22m[DEBUG]\x1b[0m";
		if (Std.string(message).startsWith("ERROR:") || Std.string(message).startsWith("ERR:"))
			tag = "\x1b[38;5;196m[ERROR]\x1b[0m";
		if (Std.string(message).startsWith("FATAL:"))
			tag = "\x1b[38;5;231;48;5;19m[FATAL]";
		// TODO: better way to detect if its a plugin. This is very easy to trip.
		if (posInfos != null && posInfos.methodName == null)
			tag = '\x1b[1;38;5;46m[PLUGIN::${posInfos.fileName}:${posInfos.lineNumber}]\x1b[0m';

		str += '$tag : $message\x1b[0m';
		for (toRemove in ["INFO:", "WARNING:", "WARN:", "DEBUG:", "ERROR:", "ERR:", "FATAL:"])
			str = str.replace(toRemove, "");
		if (posInfos != null && posInfos.methodName != null)
			str += ' : (\x1b[38;5;79m${posInfos.fileName}\x1b[0m:${posInfos.lineNumber} {\x1b[38;5;187m${posInfos.methodName}\x1b[0m()})';

		logs.push(str);
		toLog.push({
			time: Date.now().toString(),
			message: message,
			file: posInfos.fileName,
			func: '${posInfos.methodName}[${posInfos.lineNumber}]'
		});

		// yoinked from haxe.Log.trace
		// except it doesnt crash if it's an unsupported platform
		#if js
		if (js.Syntax.typeof(untyped console) != "undefined" && (untyped console).log != null)
			(untyped console).log(str);
		#elseif sys
		Sys.println(str);
		#else
		// throw new haxe.exceptions.NotImplementedException();
		haxe.Log.trace(str);
		#end
	}

	/**
	 * Generate a debugging log file.
	 * @since 0.9.3
	 */
	public static function makeLogFile() {
		var formatted:String = "";
		for (obj in toLog)
			formatted += '${obj.time} ${(obj.file.replace(".hx", ""))}.${obj.func} - ${obj.message}\n';
		if (!FileSystem.exists("logs"))
			FileSystem.createDirectory("logs");
		File.saveContent('logs/HydroFrame_DebuggingLog[${(Date.now().toString()).replace("/", ",").replace(":", "'")}].log', formatted);
	}
}
