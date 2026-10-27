package ui;

import backend.objects.editor.HAnimatableObject;

/**
 * The different selectable tools of Hydro-Frame!
 * @since 0.8.0
 */
enum abstract Tool(String) from String to String {
	var TRANSFORM:String = "SELECTION"; // MERGED WITH FREE_TRANSFORM
	var SUBSELECTION:String = "SUBSELECTION";
	var GRADIENT_TRANSFORM:String = "GRADIENT_TRANSFORM";
	var LASSO:String = "LASSO";
	var POLYGON:String = "POLYGON";
	var MAGIC_WAND:String = "MAGIC_WAND";
	var FLUID_BRUSH:String = "FLUID_BRUSH";
	var CLASSIC_BRUSH:String = "CLASSIC_BRUSH";
	var ERASOR:String = "ERASOR";
	var RECTANGLE:String = "RECTANGLE";
	var RECTANGLE_PRIMITIVE:String = "RECTANGLE_PRIMITIVE";
	var OVAL:String = "OVAL";
	var OVAL_PRIMITIVE:String = "OVAL_PRIMITIVE";
	var POLYSTAR:String = "POLYSTAR";
	var LINE:String = "LINE";
	var PEN:String = "PEN";
	var ADD_ANCHOR_POINT:String = "ADD_ANCHOR_POINT";
	var DELETE_ANCHOR_POINT:String = "DELETE_ANCHOR_POINT";
	var CONVERT_ANCHOR_POINT:String = "CONVERT_ANCHOR_POINT";
	var TEXT:String = "TEXT";
	var PAINT_BUCKET:String = "PAINT_BUCKET";
	var INK_BOTTLE:String = "INK_BOTTLE";
	var EYEDROPPER:String = "EYEDROPPER";
	var IMAGE_WARP:String = "IMAGE_WARP"; // asset_warp
	var HAND:String = "HAND";
	var ROTATION:String = "ROTATION";
	var TIME_SCRUB:String = "TIME_SCRUB";
	var ZOOM:String = "ZOOM";
}

/**
 * Information for saving where tab was stored on the editor UI area.
 * dumps to UPrefs on program close.
 * @since 0.8.0
 */
typedef SavedTabInfo = {
	var size:Float;
	var position:HPoint;
};

/**
 * The heart of Hydro-Frame, the editor!
 * this is where drawing, and animation happen!
 * it is also the most COMPLEX state of all of Hydro-Frame.
 * @since 0.8.0
 */
class EditorState extends HState {
	/**
	 * the currently selected tool within the editor
	 * @since 0.8.0
	 */
	public static var currentTool:Tool = TRANSFORM;

	/**
	 * This is the window that contains your tools!
	 * @since 0.8.0
	 */
	public var toolsTabArea:Null<HWindow> = null;

	/**
	 * Initilize Editor state with width, height, fps, scripting format, and measurement!
	 * @param width stage width
	 * @param height stage height
	 * @param fps stage fps
	 * @param scriptType stage script format
	 * @param measureType stage measurement type
	 * @since 0.8.0
	 */
	public function new(width:Float, height:Float, fps:Int, scriptType:String, measureType:String) {
		super();
		// init the windows.
		makeToolsWindow();

		// other init stuff

		// testing stuff
		var testObject:HAnimatableObject = new HAnimatableObject(100, 100);
		add(testObject);

		trace('editorstate made with ${width}x$height @$fps, script mode $scriptType, measure mode $measureType');
	}

	private function makeToolsWindow() {
		toolsTabArea = Main.windowManager.makeWindow("Tools", 0, 20, 125, 125, false, true);

		// for making tool buttons
		for (i in 0...15) {
			var butt:HButton = new HButton("A", new Rectangle(5 + (20 * (i % 5)), 5 + (20 * (Math.floor(i / 5))), 15, 15), (_:HButton) -> {
				// TODO: dropdown on certain buttons.
			});
			toolsTabArea.addContent(butt);
		}

		if (UPrefUtils.getWorkspaceFile() != "{}") {
			var targetPos:HPoint = ((UPrefUtils.getFromWorkspace("WINDOW_TOOLS") : Map<String, Dynamic>).get("position") : HPoint);
			if (targetPos == null) {
				trace("Failed to get last saved position of WINDOW_TOOLS!!!!");
				return;
			}
			toolsTabArea.setPosition(targetPos.x, targetPos.y);
			// toolsTabArea.set(targetPos.x, targetPos.y); //TODO: window resizing.
		}
		toolsTabArea.onWindowMove = (_:HPoint) -> {
			UPrefUtils.writeToWorkspace("WINDOW_TOOLS", {size: new HPoint(295, Main.pHeight - 20), position: _});
		};
	}
}
