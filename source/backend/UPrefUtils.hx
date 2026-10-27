package backend;

import backend.macro.PreferencesMacro.GlobalPrefs;
import backend.plugins.Skin;

/**
 * User Preference utilities.
 * @since 0.3.0
 */
class UPrefUtils {
	/**
	 * Gets the current theme as a `Skin`.
	 * 
	 * @since 0.10.2
	 */
	public static function getCurrentSkin():Skin
		return UPrefs.currentSkin;

	/**
	 * Return a target preference
	 * @param a What we what to try to find
	 * @since 0.3.0
	 */
	public static function getFromFile(a:String):Dynamic {
		var v:Dynamic = Reflect.getProperty(Json.parse(getPrefsFile()), a); // inital json data.
		if (v != null && Type.typeof(v) == TObject) { // map fix, so maps can be parsed correctly cuz apparently casting is stupid.
			var m = new Map<Dynamic, Dynamic>();
			for (f in Reflect.fields(v))
				m.set(f, Reflect.field(v, f));
			return m;
		}
		return v;
	}

	/**
	 * check through a mapped preference for the selected index
	 * @param a 
	 * @return String selected key
	 * @since 0.8.3
	 */
	public static function getSelected(a:Map<String, Bool>):String {
		for (key => value in a)
			!value?continue:return key;
		return "";
	}

	/**
	 * Return a target workspace object
	 * @param a What we what to try to find
	 * @since 0.7.2
	 */
	public static function getFromWorkspace(a:String):Dynamic {
		var v:Dynamic = Reflect.getProperty(Json.parse(getWorkspaceFile()), a); // inital json data.
		if (v != null && Type.typeof(v) == TObject) { // map fix, so maps can be parsed correctly cuz apparently casting is stupid.
			var m = new Map<Dynamic, Dynamic>();
			for (f in Reflect.fields(v))
				m.set(f, Reflect.field(v, f));
			return m;
		}
		return v;
	}

	/**
	 * Write to preferences
	 * @param a key
	 * @param b value
	 * @return Dynamic returns whatever `b` was
	 * @since 0.3.0
	 */
	public static function writeToFile(a:String, b:Dynamic):Dynamic {
		var json:Dynamic = Json.parse(getPrefsFile());
		Reflect.setField(json, a, b);
		trace('Setting field $a to $b in UPrefs.');
		File.saveContent("uPrefs.json", Json.stringify(json, null, "    "));
		return b;
	}

	public static function writeToWorkspace(a:String, b:Dynamic):Dynamic {
		var json:Dynamic = Json.parse(getWorkspaceFile());
		Reflect.setField(json, a, b);
		trace('Setting field $a to $b in workspace.');
		File.saveContent("workspace.json", Json.stringify(json, null, "    "));
		return b;
	}

	/**
	 * Returns the preferences file, and makes it if it doesnt exist (SYS ONLY)
	 * @return String json file
	 */
	public static inline function getPrefsFile():String
		return(FileSystem.exists("uPrefs.json")) ? File.getContent("uPrefs.json") : makePrefsFile();

	/**
	 * get the workspace file, and make it if it doesnt exist.
	 * @return String the workspace save data
	 * @since 0.7.2
	 */
	public static inline function getWorkspaceFile():String
		return(FileSystem.exists("workspace.json")) ? File.getContent("workspace.json") : makeWorkspacefile();

	/**
	 * Makes the preferences file (SYS ONLY)
	 * @return String the content of the file
	 * @since 0.3.0
	 */
	public static function makePrefsFile():String {
		File.saveContent("uPrefs.json", Json.stringify(GlobalPrefs.DEFAULT_PREFERENCES, null, "    "));
		return File.getContent("uPrefs.json");
	}

	/**
	 * make the workspace json file.
	 * @return String the new workspace file data
	 * @since 0.7.2
	 */
	public static function makeWorkspacefile():String {
		File.saveContent("workspace.json", Json.stringify({}, null, "    "));
		return File.getContent("workspace.json");
	}
}
