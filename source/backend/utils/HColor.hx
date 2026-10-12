package backend.utils;
/**
 * color class for easy access. basically FlxColor but worse.
 * @since 0.1.0
 */
abstract HColor(Int) from Int from UInt to Int to UInt {
	public static inline final TRANSPARENT:HColor = 0x00000000;
	public static inline final BLACK:HColor = 0xFF000000;
	public static inline final WHITE:HColor = 0xFFFFFFFF;
	public static inline final RED:HColor = 0xFFFF0000;
	public static inline final MAGENTA:HColor = 0xFFFF00FF;

	#if debug
	public static inline final DEBUGGER_BACKGROUND:HColor = 0x99000000;
	public static inline final DEBUGGER_CONSOLE_TEXT:HColor = 0xFF00FF00;
	#end
	private static function getColorFromSkin(a:String):Null<HColor> {
		if((UPrefs.currentSkin.data.themes[UPrefs.getSelected(UPrefs.uiTheme.value)].get(a))!=null) return (UPrefs.currentSkin.data.themes[UPrefs.getSelected(UPrefs.uiTheme.value)].get(a));
		else throw 'Failed to get color $a from ${UPrefs.currentSkin.toString()}[${UPrefs.getSelected(UPrefs.uiTheme.value)}]!!';
		return null;
	}
	// ui related colors
	public static var LOADINGIND_MAINCOLOR(get, never):HColor;
	public static function get_LOADINGIND_MAINCOLOR():HColor return getColorFromSkin("LOADINGIND_MAINCOLOR")??0xFF7c58e2;
	public static var MAINMENU_PROJECTSLIST_DARKEN(get, never):HColor;
	public static function get_MAINMENU_PROJECTSLIST_DARKEN():HColor return getColorFromSkin("MAINMENU_PROJECTSLIST_DARKEN")??0x6A000000;
	public static var MENUBAR_BACKGROUND(get, never):HColor;
	public static function get_MENUBAR_BACKGROUND():HColor return getColorFromSkin("MENUBAR_BACKGROUND")??0xFF7B7B7B;
	public static var MENUBAR_DROPDOWN_BACKGROUND(get, never):HColor;
	public static function get_MENUBAR_DROPDOWN_BACKGROUND():HColor return getColorFromSkin("MENUBAR_DROPDOWN_BACKGROUND")??0xFF262626;
	public static var MENUBAR_DROPDOWN_SEPERATOR(get, never):HColor;
	public static function get_MENUBAR_DROPDOWN_SEPERATOR():HColor return getColorFromSkin("MENUBAR_DROPDOWN_SEPERATOR")??0xFF000000;
	public static var BUTTON_IDLE(get, never):HColor;
	public static function get_BUTTON_IDLE():HColor return getColorFromSkin("BUTTON_IDLE")??0xFFFFFFFF;
	public static var BUTTON_HOVER(get, never):HColor;
	public static function get_BUTTON_HOVER():HColor return getColorFromSkin("BUTTON_HOVER")??0xFFA3A3A3;
	public static var BUTTON_CLICK(get, never):HColor;
	public static function get_BUTTON_CLICK():HColor return getColorFromSkin("BUTTON_CLICK")??0xFF818181;
	public static var BUTTON_DISABLED(get, never):HColor;
	public static function get_BUTTON_DISABLED():HColor return getColorFromSkin("BUTTON_DISABLED")??0xFF5A5A5A;

	public function new(v:Int = 0xFF000000)
		this = v;

	public var rgb(get, set):Int;
	public var r(get, set):Float;
	public var g(get, set):Float;
	public var b(get, set):Float;
	public var a(get, set):Float;

	public inline function get_rgb():Int
		return this & 0xFFFFFF;

	public inline function get_r():Float
		return (this >> 16) & 0xFF;

	public inline function get_g():Float
		return (this >> 8) & 0xFF;

	public inline function get_b():Float
		return this & 0xFF;

	public inline function get_a():Float
		return ((this >> 24) & 0xFF) / 255;

	public inline function set_rgb(v:Int):Int {
		this = (this & 0xFF000000) | (v & 0xFFFFFF); // keep alpha
		return v;
	}

	public inline function set_r(v:Float):Float {
		this = (this & 0xFF00FFFF) | (_ch(v) << 16);
		return v;
	}

	public inline function set_g(v:Float):Float {
		this = (this & 0xFFFF00FF) | (_ch(v) << 8);
		return v;
	}

	public inline function set_b(v:Float):Float {
		this = (this & 0xFFFFFF00) | _ch(v);
		return v;
	}

	public inline function set_a(v:Float):Float {
		this = (this & 0x00FFFFFF) | (Math.round(Math.max(0, Math.min(1, v)) * 255) << 24);
		return v;
	}

	// clamp a 0-255 channel value and round to an Int
	static inline function _ch(v:Float):Int
		return Math.round(Math.max(0, Math.min(255, v)));

	public inline function toString():String
		return '[HColor]: rgb:$rgb, r:$r, g:$g, b:$b, a:$a';

	public inline function toHexString():String
		return '#${Std.string(this).substr(3, Std.string(this).length)}'; // string manip :3

	public static inline function fromInt(v:Int):HColor
		return new HColor(v);

	public static inline function toTransform(c:HColor):ColorTransform
		return new ColorTransform(0, 0, 0, ((c >> 24) & 0xFF) / 255, ((c >> 16) & 0xFF), ((c >> 8) & 0xFF), (c & 0xFF), 0);
}
