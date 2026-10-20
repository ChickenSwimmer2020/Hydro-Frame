package backend.plugins;

typedef SkinData = {
	var name:String;
	var version:Float;
	var themes:Map<String, Map<String, HColor>>; // theme name => colorDefs
};

/**
 * Wrapper class, similar to Plugin.
 * @since 0.8.6
 */
class Skin {
	public static final defaultThemes:SkinData = {
		name: "Default",
		version: 1.0,
		themes: [
			"Ultra Bright" => [],
			"Bright" => [
				"LOADINGIND_MAINCOLOR" => 0xFF7c58e2,
				"MAINMENU_PROJECTSLIST_DARKEN" => 0x6A000000,
				"MENUBAR_BACKGROUND" => 0xFF7B7B7B,
				"MENUBAR_DROPDOWN_BACKGROUND" => 0xFF262626,
				"MENUBAR_DROPDOWN_SEPERATOR" => 0xFF000000,
				"BUTTON_IDLE" => 0xFFFFFFFF,
				"BUTTON_HOVER" => 0xFFA3A3A3,
				"BUTTON_CLICK" => 0xFF818181,
				"BUTTON_DISABLED" => 0xFF5A5A5A
			],
			"Dark" => [
				"LOADINGIND_MAINCOLOR" => 0xff513796,
				"MAINMENU_PROJECTSLIST_DARKEN" => 0x6A000000,
				"MENUBAR_BACKGROUND" => 0xFF5B5B5B,
				"MENUBAR_DROPDOWN_BACKGROUND" => 0xFF1E1E1E,
				"MENUBAR_DROPDOWN_SEPERATOR" => 0xFF000000,
				"BUTTON_IDLE" => 0xFF343434,
				"BUTTON_HOVER" => 0xFF4F4F4F,
				"BUTTON_CLICK" => 0xFF212121,
				"BUTTON_DISABLED" => 0xFF1D1D1D
			],
			"Midnight" => []
		]
	};

	public function toString():String
		return data.name ?? "default";

	public var data:Null<SkinData> = defaultThemes; // i should, probably have done this from the start, whoops.

	public function new(skin:String) {
		data = getSkinFile(skin);
	}

	/**
	 * Read skin data from a file
	 * @return SkinData
	 * @since 0.8.6
	 */
	public function getSkinFile(name:String):SkinData {
		if (FileSystem.exists('plugins/skins/$name.hfs')) {
			return data = SkinLoader.load('plugins/skins/$name.hfs');
		} else {
			trace('ERROR: Couldnt find plugins/skins/$name.hfsf!\nDid you type it correctly?');
			return defaultThemes;
		}
		return defaultThemes;
	}

	/**
	 * Write a skin file to an actual file //TODO: skin editor. (should we make this a seperate program?)
	 * @return Bool
	 * @since 0.8.6
	 */
	public function writeToSkinFile():Bool {
		return false;
	}
}
