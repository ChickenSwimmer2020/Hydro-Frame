package engine.nauticink;

import engine.rendering.nauticink.NauticRenderer;
import engine.nauticink.brush.NauticBrush;

/**
 * The `NauticInk` brush engine.
 */
class NauticInk {
	/**
	 * The current brush.
	 * 
	 * @since 0.9.0
	 */
	public static var brush(default, null):NauticBrush = null;

	/**
	 * The renderers which render `NauticInk`.
	 * 
	 * @since 0.9.0
	 */
	public static var renderers(default, null):Array<NauticRenderer> = [];

	/**
	 * Initialises `NauticInk`.
	 */
	public static function init() {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	/**
	 * Unloads `NauticInk`.
	 */
	public static function unload() {
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		brush = null;
	}

	static function onMouseDown(e:MouseEvent) {
		if (brush != null)
			brush.onDown(e.stageX, e.stageY, 1);
		updateRenderers();
	}

	static function onMouseMove(e:MouseEvent) {
		if (brush != null)
			brush.onMove(e.stageX, e.stageY, 1);
		updateRenderers();
	}

	static function onMouseUp(e:MouseEvent) {
		if (brush != null)
			brush.onUp();
		updateRenderers();
	}

	/**
	 * Updates all registered renderers.
	 * Register/Unregister renderers using `NauticInk.registerRenderer()` and `NauticInk.unregisterRenderer()`.
	 * 
	 * @since 0.9.0
	 * @see `NauticInk.registerRenderer()`
	 * @see `NauticInk.unregisterRenderer()`
	 */
	public static function updateRenderers()
		for (renderer in renderers)
			renderer.updateRender();

	/**
	 * Registers a renderer for `NauticInk`.
	 * 
	 * @param renderer The renderer to register.
	 * @since 0.9.0
	 */
	public static function registerRenderer(renderer:NauticRenderer) {
		if (renderers == null)
			renderers = [];
		renderers.push(renderer);
	}

	/**
	 * Unregisters a renderer for `NauticInk`.
	 * 
	 * @param renderer The renderer to unregister.
	 * @since 0.9.0
	 */
	public static function unregisterRenderer(renderer:NauticRenderer) {
		if (renderers != null)
			renderers.remove(renderer);
	}

	/**
	 * Loads a brush for `NauticInk`.
	 * 
	 * @param brush The brush to load.
	 */
	public static function loadBrush(brush:NauticBrush)
		NauticInk.brush = brush;
}
