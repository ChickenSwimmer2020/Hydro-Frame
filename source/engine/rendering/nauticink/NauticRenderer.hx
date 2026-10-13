package engine.rendering.nauticink;

import format.svg.Group;
import format.svg.SVGData;
import engine.nauticink.NauticInk;
import engine.rendering.svg.HSVG;

/**
 * The main renderer for `NauticInk`.
 * 
 * @since 0.9.0
 */
class NauticRenderer extends HSprite {
	/**
	 * The current `HSVG` being rendered.
	 * 
	 * @since 0.9.0
	 */
	public static var svg:HSVG;

	/**
	 * Creates a new `NauticRenderer`.
	 * 
	 * @param x The x position of the `NauticRenderer`.
	 * @param y The y position of the `NauticRenderer`.
	 * @param width The width of the `NauticRenderer`.
	 * @param height The height of the `NauticRenderer`.
	 * @since 0.9.0
	 */
	override public function new(x:Float = 0, y:Float = 0, width:Float = 0, height:Float = 0) {
		super(x, y);
		svg = new HSVG();
		svg.svg.data = new SVGData(Xml.parse('<svg width="$width" height="$height"></svg>'));
		addChild(svg);
	}

	/**
	 * Updates the `NauticRenderer` by rendering the current `NauticInk` stroke.
	 * 
	 * @since 0.9.0
	 */
	public function updateRender() {
		if (svg?.svg?.data == null && NauticInk.brush != null)
			return;
		var paths = [];
		for (stroke in NauticInk.brush.strokes)
			paths.push(DisplayPath(stroke.path));
		if (NauticInk.brush.activeStroke != null && NauticInk.brush.activeStroke.path != null)
			paths.push(DisplayPath(NauticInk.brush.activeStroke.path));
		svg.svg.data.children = paths;
		svg.reRender();
	}

	/**
	 * Disposes of this `NauticRenderer`.
	 * 
	 * @since 0.9.0
	 */
	override public function destroy() {
		if (svg != null) {
			removeChild(svg);
			svg.destroy();
		}
		super.destroy();
	}

	/**
	 * A `NauticRenderer` cannot load graphics via `loadGraphic()`.
	 * 
	 * @return `NauticRenderer` This `NauticRenderer`, for chaining.
	 * @since 0.9.0
	 */
	override function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):NauticRenderer {
		trace('loadGraphic unsupported by NauticRenderer');
		return this;
	}
}
