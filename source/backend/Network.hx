package backend;

import sys.io.Process;

class Network {
	/**
	 * Location of the file containing the current newest version of Hydro-Frame
	 * @since 0.3.0
	 */
	public static final updateCheckLocation:String = "https://raw.githubusercontent.com/ChickenSwimmer2020/Hydro-Frame/refs/heads/main/README.md";

	/**
	 * Check to see if Hydro-Frame needs an update
	 * @return Int is an update needed? 0 is yes, 1 is no, -1 is no connection, and -2 is error.
	 * @since 0.2.0
	 */
	public static function checkForUpdates():Int {
		var data:String = get(updateCheckLocation);
		if (data.startsWith("SysError(Unresolved host "))
			return -1;
		if (data.contains("#404"))
			return -4;
		if (data == "THIS IS A PROBLEM!")
			return -5;
		var newestVersion:String = data.split("\n")[0].split('-->')[0].replace('<!-- Version:', "").trim();
		if (newestVersion != Application.current.meta.get("version")) {
			return 0;
		} else
			return 1;

		return -3;
	}

	/**
	 * Used to get the file data from the file at `updateCheckLocation`
	 * @param url 
	 * @return String
	 * @since 0.2.0
	 */
	private static function get(url:String):String {
		var h = new Http(url);
		var r = "THIS IS A PROBLEM!";
		h.onData = function(d) {
			r = d;
		}
		h.onError = function(e) {
			r = e;
		}
		h.request(false);
		return r;
	}
}
