package engine.nauticink.brush.v1;

import engine.nauticink.brush.data.NauticStrokePoint;
import format.svg.Path;
import format.svg.PathSegment;

/**
 * A brush stroke.
 * 
 * @since 0.9.0
 */
class NauticStroke {
	/**
	 * The midpoints of this `NauticStroke`.
	 * 
	 * @since 0.9.0
	 */
	public var points:Array<NauticStrokePoint> = [];

	/**
	 * The colour of this `NauticStroke`.
	 * 
	 * @since 0.9.0
	 */
	public var color:HColor = 0x000000;

	/**
	 * The preset of this `NauticStroke`.
	 * 
	 * @since 0.9.0
	 */
	public var preset:NauticBrushPreset;

	/**
	 * The `Path` object for this `NauticStroke`. Generated from the `points` array
	 * when `buildPath()` is called.
	 * 
	 * @since 0.9.0
	 */
	public var path:Path = null;

	/**
	 * Creates a new `NauticStroke`.
	 * 
	 * @since 0.9.0
	 */
	public function new() {}

	/**
	 * Builds a `Path` object from the `points` array.
	 * The resulting `Path` object is stored in the `path` property.
	 * 
	 * @return `Path` The resulting `Path` object.
	 * @since 0.9.0
	 */
	public function buildPath():Path {
		if (points.length < 2)
			return null;

		var leftEdge:Array<Point> = [];
		var rightEdge:Array<Point> = [];

		for (i in 0...points.length) {
			var center = points[i];
			var normal = normalAt(i); // Unit vector pointing 'left' of the stroke.
			var halfWidth = center.width * 0.5 * taperAt(i);

			leftEdge.push(offset(center.x, center.y, normal, halfWidth));
			rightEdge.push(offset(center.x, center.y, normal, -halfWidth));
		}

		// Walk up the left side, then back down the right side.
		rightEdge.reverse();
		path = outlineToPath(leftEdge.concat(rightEdge));
		return path;
	}

	// Direction the stroke is travelling at point i, rotated 90 degrees.
	function normalAt(i:Int):Point {
		var before = points[Std.int(Math.max(i - 1, 0))];
		var after = points[Std.int(Math.min(i + 1, points.length - 1))];

		var dirX = after.x - before.x;
		var dirY = after.y - before.y;
		var length = Math.sqrt(dirX * dirX + dirY * dirY);

		if (length < 0.0001)
			return new Point(0, 1); // Points on top of each other.

		// Dividing by length makes it a unit vector (length 1)
		// Swapping x/y and negating one rotates it 90 degrees.
		return new Point(-dirY / length, dirX / length);
	}

	// 0 at the very tips, 1 once you're far enough from both ends.
	function taperAt(i:Int):Float {
		var fromStart = i;
		var fromEnd = points.length - 1 - i;

		var startFactor = preset.taperStart > 0 ? Math.min(fromStart / preset.taperStart, 1) : 1;
		var endFactor = preset.taperEnd > 0 ? Math.min(fromEnd / preset.taperEnd, 1) : 1;

		return Math.min(startFactor, endFactor);
	}

	// Move a point `distance` units along a direction.
	inline function offset(x:Float, y:Float, direction:Point, distance:Float):Point
		return new Point(x + direction.x * distance, y + direction.y * distance);

	// Basic midpoint.
	inline function midpoint(a:Point, b:Point):Point
		return new Point((a.x + b.x) / 2, (a.y + b.y) / 2);

	/* 
		Turns the outline points into a smooth closed shape.
		Each outline point is a curve control point, and the curve
		passes through the midpoints between neighbours.
	 */
	function outlineToPath(outline:Array<Point>):Path {
		var path = newFilledPath();
		var count = outline.length;

		var first = midpoint(outline[count - 1], outline[0]);
		path.segments.push(new MoveSegment(first.x, first.y));

		for (i in 0...count) {
			var control = outline[i];
			var end = midpoint(outline[i], outline[(i + 1) % count]);

			// I'M SO GLAD I don't have to calculate quadratics.
			path.segments.push(new QuadraticSegment(control.x, control.y, end.x, end.y));
		}
		return path;
	}

	// Just a blank path.
	function newFilledPath():Path {
		var p = new Path();
		p.matrix = new Matrix();
		p.name = '';
		p.fill = FillSolid(color);
		p.alpha = 1;
		p.fill_alpha = 1;
		p.stroke_alpha = 1;
		p.stroke_colour = null;
		p.stroke_width = 0;
		p.stroke_caps = CapsStyle.NONE;
		p.joint_style = JointStyle.ROUND;
		p.miter_limit = 3;
		p.segments = [];
		return p;
	}
}
