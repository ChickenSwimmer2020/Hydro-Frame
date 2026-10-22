package backend.debug.logging;

#if macro
import haxe.PosInfos;
import sys.FileSystem;
import sys.io.File;
import backend.utils.TerminalUtil;

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

		var tag:String = '${TerminalUtil.setColor(0xFF3b61bf)}[OTHER]${TerminalUtil.reset}';
		if (Std.string(message).startsWith("INFO:"))
			tag = "[INFO]";
		if (Std.string(message).startsWith("WARNING:") || Std.string(message).startsWith("WARN:"))
			tag = '${TerminalUtil.setColor(0xFFFFFF00)}[WARNING]${TerminalUtil.reset}';
		if (Std.string(message).startsWith("DEBUG:"))
			tag = '${TerminalUtil.setColor(0xFF005F00)}[DEBUG]${TerminalUtil.reset}';
		if (Std.string(message).startsWith("ERROR:") || Std.string(message).startsWith("ERR:"))
			tag = '${TerminalUtil.setColor(0xFFFF0000)}[ERROR]${TerminalUtil.reset}';
		if (Std.string(message).startsWith("FATAL:"))
			tag = '${TerminalUtil.setColor(0xFFFFFFFF, 0xFF000087)}[FATAL]';
		if (Std.string(message).startsWith("GITHUB:"))
			tag = '${TerminalUtil.setColor(0xFFFFFFFF, 0xFFFF00FF)}[GITHUB]';
		// TODO: better way to detect if its a plugin. This is very easy to trip.
		if (posInfos != null && posInfos.methodName == null)
			tag = '${TerminalUtil.setColor(0xFF00ff03)}[PLUGIN::${posInfos.fileName}:${posInfos.lineNumber}]${TerminalUtil.reset}';

		str += '$tag : $message${TerminalUtil.reset}';
		for (toRemove in ["INFO:", "WARNING:", "WARN:", "DEBUG:", "ERROR:", "ERR:", "FATAL:"])
			str = str.replace(toRemove, "");
		if (posInfos != null && posInfos.methodName != null)
			str += ' : (${TerminalUtil.setColor(0xFF5FD7AF)}${posInfos.fileName}${TerminalUtil.reset}:${posInfos.lineNumber} {${TerminalUtil.setColor(0xFFD7D7AF)}${posInfos.methodName}${TerminalUtil.reset}()})';

		
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
