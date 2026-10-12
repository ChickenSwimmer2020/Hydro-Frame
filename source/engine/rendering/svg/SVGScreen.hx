package engine.rendering.svg;

import openfl.ui.Keyboard.*;

/**
 * Dummy screen to test SVG Rendering
 * @since SVG_Rendering
 */
class SVGScreen extends HState {
	/**
	 * using scratch SVG files to test SVG Rendering
	 * @since SVG_Rendering
	 */
	var scratchCat:HSVG;

	override function create() {
		super.create();

		add(scratchCat = HSVG.fromFiles(['assets/scratch/costume1.svg', 'assets/scratch/costume2.svg']));
		scratchCat.switchToCostume('costume1');

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	}

	final movementSpeed = 10;

	function onKeyDown(event:KeyboardEvent) {
		if ([LEFT, A].contains(event.keyCode))
			scratchCat.x -= movementSpeed;

		if ([RIGHT, D].contains(event.keyCode))
			scratchCat.x += movementSpeed;

		if ([UP, W].contains(event.keyCode))
			scratchCat.y -= movementSpeed;

		if ([DOWN, S].contains(event.keyCode))
			scratchCat.y += movementSpeed;

		scratchCat.switchToCostume(scratchCat.costume == 'costume1' ? 'costume2' : 'costume1');

		// scratchCat.reRender();

		// trace(event);
	}
}
