package backend.objects;

/**
 * openfl.geom.point, but float. with int options.
 * @since 0.0.0
 */
class HPoint {
	public var x:Float = 0;
	public var y:Float = 0;
	public var iX(get, never):Int;

	public function get_iX():Int
		return Math.floor(x);

	public var iY(get, never):Int;

	public function get_iY():Int
		return Math.floor(y);

	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	public function set(x:Float, y:Float):HPoint {
		this.x = x;
		this.y = y;
		return this;
	}

	public function toOpenflPoint():Point
		return new Point(x, y);

	public static function fromOpenflPoint(p:Point):HPoint
		return new HPoint(p.x, p.y);

	public function toString():String
		return 'HPoint: [$x, $y]';
}
