package backend;

#if (windows)
@:headerCode("#pragma comment(lib, \"dwmapi.lib\")
")
@:cppFileCode('
	#include <windows.h>
	#include <dwmapi.h>
	#pragma comment(lib, "dwmapi.lib")

	static int getAccentNative() {
		DWORD color = 0;
		BOOL opaque = FALSE;
		if (FAILED(DwmGetColorizationColor(&color, &opaque)))
			return 0;
		return (int)color;
	}

	static void flashTaskbarNative(int count) {
		HWND hwnd = NULL;

		// find this process\'s own top-level window (no separate function needed)
		EnumWindows([](HWND h, LPARAM lp) -> BOOL {
			DWORD pid = 0;
			GetWindowThreadProcessId(h, &pid);
			if (pid == GetCurrentProcessId() && IsWindowVisible(h) && GetWindow(h, GW_OWNER) == NULL) {
				*(HWND*)lp = h;
				return FALSE; // found it, stop enumerating
			}
			return TRUE;
		}, (LPARAM)&hwnd);

		if (hwnd) {
			FLASHWINFO fInfo = {0};
			fInfo.cbSize = sizeof(FLASHWINFO);
			fInfo.hwnd = hwnd;
			fInfo.uCount = count;
			if(count==0){
				fInfo.dwFlags = FLASHW_ALL | FLASHW_TIMERNOFG;
			}else fInfo.dwFlags = FLASHW_ALL;
			fInfo.dwTimeout = 0; // default flash rate

			FlashWindowEx(&fInfo);
		}
	}
')
#end

/**
 * Native support for computers, including things like getting system accent color, flashing the taskbar
 * and other window things
 * @since 0.4.0
 */
class Native {
	/**
	 * SYS EXCLUSIVE
	 * Flash the taskbar
	 * @since 0.4.0
	 */
	public static function flashTaskbar(?count:Int = 0) {
		#if (windows)
		untyped __cpp__('flashTaskbarNative((int){0});', count);
		#elseif linux
		trace("flashTaskbar: Not Implemented");
		#elseif (ios || android)
		trace("flashTaskbar: Unsupported!");
		#end
	}

	/**
	 * SYS EXCLUSIVE
	 * Get the System accent color
	 * * ! LINUX/MACOS UNTESTED AS OF 0.6.0 !
	 * * ! Someone please test this.
	 * @since 0.4.0
	 */
	public static function getAccentColor():HColor {
		#if (windows)
		var returned:Int = untyped __cpp__("getAccentNative();");
		if (returned == 0)
			return 0xFF000000;
		var toReturn:HColor = HColor.fromInt(returned);
		toReturn.a = 1.0;
		return toReturn;
		#elseif linux
		var env:String = getDesktopEnv();
		trace('HEY, MINT: SEND THIS LINE BACK TO ME!! "DesktopEnv is: $env"');
		switch (env) {
			default:
				return HColor.BUTTON_IDLE;
		}
		#elseif (ios || android)
		trace("getAccentColor: Unsupported!");
		#end
		return HColor.BUTTON_IDLE; // fallback
	}

	#if linux
	/**
	 * LINUX EXCLUSIVE FUNCTION
	 * will be used in tandem with `getAccentColor` so linux desktops can have their colors gotten.
	 * @return String current Desktop Environment
	 * @since 0.4.0
	 */
	private static function getDesktopEnv():String {
		var desktop:String = "FALLBACK";
		final env = Sys.environment();
		desktop = env.get("XDG_CURRENT_DESKTOP");
		if (desktop == null || desktop == "")
			desktop = env.get("DESKTOP_SESSION"); // secondary fallback check
		if (desktop == null || desktop == "")
			return "FALLBACK"; // second check.
		return desktop;
	}
	#end
}
