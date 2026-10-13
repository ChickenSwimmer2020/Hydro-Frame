package engine.rendering.nauticink;

import engine.nauticink.NauticInk;
import engine.nauticink.brush.v1.NauticBrushV1;

/**
 * Dummy screen to test NauticInk
 * 
 * @since 0.9.0
 */
class NauticScreen extends HState {
	var renderer:NauticRenderer;

	override function create() {
		super.create();

		HTimer.start(0.1, () -> {
			Mouse.show();
		});
		Mouse.show();

		NauticInk.init();

		renderer = new NauticRenderer(0, 0, 1280, 720);
		add(renderer);

		NauticInk.registerRenderer(renderer);

		var brush = new NauticBrushV1({
			thickness: 10,
			color: 0xFFFFFFFF
		}, {
			pressureCurve: 1,
			smoothingPasses: 5,
			taperStart: 2.5,
			taperEnd: 4,
			capStyle: POINT,
			widthSmoothing: 1
		});
		NauticInk.loadBrush(brush);
	}
}
