package engine.nauticink.brush.v1;

import engine.nauticink.brush.data.*;
import format.svg.Path;

class NauticBrushV1 implements NauticBrush {
	/**
	 * The configuration of this `NauticBrushV1`.
	 * 
	 * @since 0.9.0
	 */
	public var config:NauticBrushConfig = null;

	/**
	 * The preset of this `NauticBrushV1`.
	 * 
	 * @since 0.9.0
	 */
	public var preset:NauticBrushPreset = null;

	/**
	 * The current stroke of this `NauticBrushV1`.
	 * 
	 * @since 0.9.0
	 */
	public var activeStroke:NauticStroke = null;

	/**
	 * The raw input buffer of this `NauticBrushV1`.
	 * 
	 * @since 0.9.0
	 */
	public var inputBuffer:Array<NauticStrokePoint> = [];

	/**
	 * The strokes of this `NauticBrushV1`.
	 * 
	 * @since 0.9.0
	 */
	public var strokes:Array<NauticStroke> = [];

	/**
	 * Creates a new `NauticBrushV1`.
	 * 
	 * @param config The configuration of this `NauticBrushV1`.
	 * @since 0.9.0
	 */
	public function new(config:NauticBrushConfig, preset:NauticBrushPreset) {
		this.config = config;
		this.preset = preset;
	}

	/**
	 * On input down.
	 * 
	 * @param x The x position.
	 * @param y The y position.
	 * @param pressure The pressure, 0 to 1.
	 */
	public function onDown(x:Float, y:Float, pressure:Float) {
		if (activeStroke == null) {
			activeStroke = new NauticStroke();
			activeStroke.preset = preset;
			activeStroke.color = config.color;
		}

		onMove(x, y, pressure);
	}

	/**
	 * On input move.
	 * 
	 * @param x The x position.
	 * @param y The y position.
	 * @param pressure The pressure, 0 to 1.
	 */
	public function onMove(x:Float, y:Float, pressure:Float) {
		if (activeStroke == null)
			return;

		var point:NauticStrokePoint = {
			x: x,
			y: y,
			width: config.thickness * pressure
		}
		inputBuffer.push(point);
		activeStroke.points.push(point);

		activeStroke.buildPath();
	}

	/**
	 * On input up.
	 * 
	 * @return `NauticStroke` The final stroke.
	 */
	public function onUp():NauticStroke {
		if (activeStroke == null)
			return null;

		var res = activeStroke;
		activeStroke = null;
		inputBuffer = [];
		strokes.push(res);
		return res;
	}
}
