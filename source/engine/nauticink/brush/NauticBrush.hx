package engine.nauticink.brush;

import engine.nauticink.brush.data.*;
import engine.nauticink.brush.v1.NauticStroke;

/**
 * The base interface for a `NauticBrush`.
 * 
 * @since 0.9.0
 */
interface NauticBrush {
	/**
	 * The configuration of this `NauticBrush`.
	 * 
	 * @since 0.9.0
	 */
	var config:NauticBrushConfig;

	/**
	 * The current stroke of this `NauticBrush`.
	 * 
	 * @since 0.9.0
	 */
	var activeStroke:NauticStroke;

	/**
	 * The raw input buffer of this `NauticBrush`.
	 * 
	 * @since 0.9.0
	 */
	var inputBuffer:Array<NauticStrokePoint>;

	/**
	 * The strokes of this `NauticBrush`.
	 * 
	 * @since 0.9.0
	 */
	var strokes:Array<NauticStroke>;

	/**
	 * On input down.
	 * 
	 * @param x The x position.
	 * @param y The y position.
	 * @param pressure The pressure, 0 to 1.
	 */
	function onDown(x:Float, y:Float, pressure:Float):Void;

	/**
	 * On input move.
	 * 
	 * @param x The x position.
	 * @param y The y position.
	 * @param pressure The pressure, 0 to 1.
	 */
	function onMove(x:Float, y:Float, pressure:Float):Void;

	/**
	 * On input up.
	 * 
	 * @return `NauticStroke` The final stroke.
	 */
	function onUp():NauticStroke;
}
