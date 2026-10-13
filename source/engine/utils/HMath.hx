package engine.utils;

/**
 * Math utilities
 * @since 0.2.0
 */
class HMath {
	private static var iSeed:Float = 1;

	public static inline function lerp(a:Float, b:Float, c:Float):Float
		return(a + c * (b - a));

	public static inline function bound(a:Float, ?b:Float, ?c:Float):Float
		return((c != null && (((b != null && a < b) ? b : a) > c)) ? c : ((b != null && a < b) ? b : a));

	public static inline function even(n:Float):Bool
		return((Std.int(n) & 1) == 0);

	public static inline function floor(a:Float):Int
		return Math.floor(a);

	public static function random(a:Int, b:Int, ?c:Array<Int>):Int {
		function gRand()
			return iSeed = (iSeed * 48271.0) % 0x7FFFFFFF;
		if (a == 0 && b == 0x7FFFFFFF && c == null)
			return Std.int(gRand());
		else if (a == b)
			return a;
		else {
			if (a > b) {
				a = a + b;
				b = a - b;
				a = a - b;
			}
			(c == null) ? return(a + gRand() / 0x7FFFFFFF * (b - a + 1)).floor() : {
				var result:Int = 0;
				do {
					result = (a + gRand() / 0x7FFFFFFF * (b - a + 1)).floor();
				} while (c.indexOf(result) >= 0);
				return result;
			};
		}
	}
}
