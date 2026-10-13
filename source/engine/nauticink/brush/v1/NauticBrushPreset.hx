package engine.nauticink.brush.v1;

/**
 * A preset for a `NauticBrush`.
 * 
 * @since 0.9.0
 */
typedef NauticBrushPreset = {
	/**
	 * The pressure curve of this `NauticBrushPreset`.
	 * This is an exponent value:
	 * 1: Linear
	 * <1: Sensitive
	 * >1: Resistant
	 * 
	 * @since 0.9.0
	 */
	var pressureCurve:Float;

	/**
	 * The smoothing passes of this `NauticBrushPreset`.
	 * 
	 * @since 0.9.0
	 */
	var smoothingPasses:Int;

	/**
	 * The starting taper of this `NauticBrushPreset`.
	 * 
	 * @since 0.9.0
	 */
	var taperStart:Float;

	/**
	 * The ending taper of this `NauticBrushPreset`.
	 * 
	 * @since 0.9.0
	 */
	var taperEnd:Float;

	/**
	 * How to draw the cap of this `NauticBrushPreset`.
	 * 
	 * @since 0.9.0
	 */
	var capStyle:NauticCapStyle;

	/**
	 * How much to smooth the width of this `NauticBrushPreset`.
	 * Separate from the positional smoothing.
	 * 0-1.
	 * 
	 * @since 0.9.0
	 */
	var widthSmoothing:Float;
}
