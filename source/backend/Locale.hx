package backend;

/**
 * Localization system to allow for different languages to enjoy Hydro-Frame!
 * @since 0.3.0
 */
class Locale { // overrall, very simple system. for now.

	/**
	 * Current target language
	 * @since 0.3.0
	 */
	public static var lang:String = "en_US";

	/**
	 * Get a localized string based on a key
	 * @param key key to get
	 * @param replacer if words need to be replaced, use this
	 * @param overrideLanguage if the language needs to be overriden, use this.
	 * @return String translated key
	 * @since 0.3.0
	 */
	public static function get(key:String, ?replacer:Map<String, Dynamic>, ?overrideLanguage:String):String {
		var target:String = Reflect.getProperty(getLocaleFile(overrideLanguage ?? lang), key);
		if (target == null)
			return '[[$key]]';
		else {
			var toReturn:String = target;
			if (replacer != null) {
				for (get => to in replacer) {
					toReturn = toReturn.replace(get, Std.string(to)); // whoops.
				}
				return toReturn; // whoopsies, forgot to do this.
			} else
				return toReturn;
		}
		return '[[$key]]';
	}

	/**
	 * get the current referall name, set on first program launch
	 * @since 0.7.0
	 */
	public static function getUser():String {
		for (target => enabled in UPrefs.perferredReference.value) {
			if (enabled) {
				switch (target) {
					case "WINUser":
						return Sys.getEnv("USERNAME");
					case "PCName":
						return Sys.getEnv(#if (windows)"COMPUTERNAME" #else "HOSTNAME" #end);
					case "Custom":
						return UPrefs.customReferenceName.value ?? "[[USER]]";
					default:
						return "[[USER]]";
				}
			}
		}
		return "[[USER]]";
	}

	/**
	 * get a locale file
	 * @param t target lang
	 * @return Dynamic data from file
	 * @since 0.3.0
	 */
	private static inline function getLocaleFile(t:String):Dynamic
		return Json.parse(Assets.getText('assets/data/locale/$t.locale') ?? "{}");
}
