package backend.utils;

/**
 * Uiltity file for window management
 * @since 0.8.7
 */
class WindowUtil {
	/**
	 * Variable representing `openfl.Lib.application.window`
	 * @since 0.8.7
	 */
	public static var window(get, never):Window;

	static function get_window():Window
		return Lib.application.window;

	/**
	 * Variable representing the window width
	 * @since 0.8.7
	 */
	public static var window_width(get, never):Int;

	static function get_window_width():Int
		return window.width;

	/**
	 * Variable representing the window height
	 * @since 0.8.7
	 */
	public static var window_height(get, never):Int;

	static function get_window_height():Int
		return window.height;

	/**
	 * Variable representing the window title
	 * @since 0.8.7
	 */
	public static var window_title(get, set):String;

	static function get_window_title():String
		return window.title;

	static function set_window_title(title:String):String
		return window.title = title ?? 'N / A';

	/**
	 * Method for resizing the window to Float dimensions (rounding up)
	 * @param width Target Width (if not provided or is `null` it will stay as it currently is)
	 * @param height Target Height (if not provided or is `null` it will stay as it currently is)
	 * @since 0.8.7
	 */
	public static function resizeWindow(?width:Null<Float>, ?height:Null<Float>) {
		#if sys
		if (width != null)
			Main.pWidth = window.width = Math.round(width);

		if (height != null)
			Main.pHeight = window.height = Math.round(height);

		centerWindow();
		#end
	}

	/**
	 * Method for quickly centering the window
	 * @since 0.8.7
	 */
	public static function centerWindow() {
		setWindowX(Capabilities.screenResolutionX / 2 - window.width / 2);
		setWindowY(Capabilities.screenResolutionY / 2 - window.height / 2);
	}

	/**
	 * Method for toggling fullscreen
	 * @since 0.8.7
	 */
	public static function toggleFullscreen() {
		window.fullscreen = !window.fullscreen;
	}

	/**
	 * Method for quickly centering the window
	 * @since 0.8.7
	 */
	public static function setTitle(title:String) {
		window_title = title ?? 'N / A';
	}

	/**
	 * Method for setting the window X position to an integer value
	 * @param x new value
	 * @since 0.8.7
	 */
	overload inline public static extern function setWindowX(x:Int) {
		#if sys window.x = x; #end
	}

	/**
	 * Method for setting the window X position to a float value (rounding up)
	 * @param x new value
	 * @since 0.8.7
	 */
	overload inline public static extern function setWindowX(x:Float) {
		#if sys window.x = Math.round(x); #end
	}

	/**
	 * Method for setting the window Y position to an integer value
	 * @param y new value
	 * @since 0.8.7
	 */
	overload inline public static extern function setWindowY(y:Int) {
		#if sys window.y = y; #end
	}

	/**
	 * Method for setting the window Y position to a float value (rounding up)
	 * @param y new value
	 * @since 0.8.7
	 */
	overload inline public static extern function setWindowY(y:Float) {
		#if sys window.y = Math.round(y); #end
	}
}
