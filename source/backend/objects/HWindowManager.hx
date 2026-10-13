package backend.objects;

import backend.ui.HTabStack;

/**
 * manager for in-window windows
 * @since 0.2.0
 */
class HWindowManager {
	/**
	 * the window that is currently being dragged
	 * @since 0.2.0
	 */
	public static var heldWindow:Null<HWindow> = null;

	/**
	 * all currently open windows
	 * @since 0.2.0
	 */
	public static var windows:Array<HWindow> = [];

	/**
	 * initiate
	 * @since 0.2.0
	 */
	public function new() {
		if (windows == null)
			windows = [];
	}

	/**
	 * add a window both to the manager and the stage
	 * @param win window to add
	 * @return HWindow window that was added
	 * @since 0.6.0
	 */
	public function addWindow(win:HWindow):HWindow {
		windows.push(win);
		Main.instance.addToMainStage(win);
		focusWindow(win);
		HSoundManager.playSound("assets/sounds/popup.wav", 1.0); // TODO: implement volume
		return win;
	}

	/**
	 * make a new window, generally paired with `addWindow`
	 * @param title window title 
	 * @param x x
	 * @param y y
	 * @param w width
	 * @param h height
	 * @param borderless borderless
	 * @param resizeable resizable
	 * @return window that was made
	 * @since 0.2.0
	 */
	public inline function makeWindow(title:String, x:Int, y:Int, w:Int, h:Int, borderless:Bool = false, resizeable:Bool = false):HWindow
		return addWindow(new HWindow(title, x, y, w, h, borderless, resizeable));

	/**
	 * prefab windows, for `makePrefabWindow`
	 * @since 0.6.0
	 */
	final prefabWindows:Map<String, Void->HWindow> = [
		"makeProject" => () -> {
			// for project creation.
			var projWidth:Int = 1280;
			var projHeight:Int = 720;
			var projFPS:Int = 30;
			// ui
			var projectWidthInput:HTextInputBox = null;
			var projectHeightInput:HTextInputBox = null;
			var projectFpsInput:HTextInputBox = null;
			var projectTypeDropdown:HButton = null;
			var projectMeasureDropdown:HButton = null;
			final width:Int = 775;
			final height:Int = (740 / 2).floor();
			var premade:HWindow = new HWindow("New Project", Main.pWidth / 2 - width / 2, Main.pHeight / 2 - height / 2, width, height, false, false);
			function onProjectCreate() {
				Main.StateSystem.switchState(EditorState, [
					projWidth,
					projHeight,
					projFPS,
					projectTypeDropdown.label.text,
					projectMeasureDropdown.label.text
				]);
				premade.destroy();
			}
			var tabGroup:HTabMenu = new HTabMenu(0, 0, new HPoint(width / 2, height));
			var charAnimGroup:HGroup<HButton> = new HGroup(0, 0);
			for (i in 0...4) {
				final names:Array<String> = ["Standard\n640x480", "HD\n1280x720", "Full HD\n1920x1080", "4K\n3840x2160"];
				var button:HButton = new HButton(names[i], new Rectangle(5 + (90 * i), 5, 85, 85), (_:HButton) -> {
					final w:String = names[i].split("\n")[1].split('x')[0];
					final h:String = names[i].split("\n")[1].split('x')[1];
					projectWidthInput.text = w;
					projectHeightInput.text = h;
					projectFpsInput.text = "30";
					projWidth = Std.parseInt(projectWidthInput.text);
					projHeight = Std.parseInt(projectHeightInput.text);
					projFPS = Std.parseInt(projectFpsInput.text);
					projectTypeDropdown.label.text = "HScript 2.7";
					projectMeasureDropdown.label.text = "Pixels";
				});
				charAnimGroup.add(button);
			}
			tabGroup.addGroup("Character Animation", charAnimGroup); // we dont use locales yet, fuck you copilot.
			var socialGroup:HGroup<HButton> = new HGroup(0, 0);
			for (i in 0...12) {
				final names:Array<String> = [
					"Standard\n640x480\nYouTube",
					"HD\n1280x720\nYouTube",
					"Full HD\n1920x1080\nYouTube",
					"4K\n3840x2160\nYouTube",
					"Small\n256x144\nFaceBook",
					"Large\n3840x2160\nFaceBook",
					"Landscape\n600x315\nFaceBook",
					"Square\n600x600\nFaceBook",
					"Vertical\n600x750\nFaceBook",
					"In-stream Photo\n440x220\nTwitter",
					"Profile Photo\n400x400\nTwitter",
					"Header Photo\n1500x500\nTwitter"
				];
				var button:HButton = new HButton(names[i], new Rectangle(5 + (90 * (i % 4)), 5 + (90 * (Math.floor(i / 4))), 85, 85), (_:HButton) -> {
					final w:String = names[i].split("\n")[1].split('x')[0];
					final h:String = names[i].split("\n")[1].split('x')[1];
					projectWidthInput.text = w;
					projectHeightInput.text = h;
					projectFpsInput.text = names[i].split("\n")[2] == "Twitter" ? "24" : "30";
					projWidth = Std.parseInt(projectWidthInput.text);
					projHeight = Std.parseInt(projectHeightInput.text);
					projFPS = Std.parseInt(projectFpsInput.text);
					projectTypeDropdown.label.text = "HScript 2.7";
					projectMeasureDropdown.label.text = "Pixels";
				});
				socialGroup.add(button);
			}
			tabGroup.addGroup("Social", socialGroup);
			var gameGroup:HGroup<HButton> = new HGroup(0, 0);
			for (i in 0...14) {
				final names:Array<String> = [
					"Low\n640x480\nWeb",
					"Medium\n800x600\nWeb",
					"High\n960x640\nWeb",
					"Very High\n1024x768\nWeb",
					"iPhone-5\n1136x640\nphone",
					"iPhone-4\n960x640\nphone",
					"iPhone 1-3 Gen\n480x320\nphone",
					"Android 16:9\n1280x720\nphone",
					"Android 16:10\n1680x1050\nphone",
					"Android 5:3\n1280x768\nphone",
					"Android 3:2\n960x640\nphone",
					"Android 4:3\n1024x768\nphone",
					"iPad 3-4 Gen\n2048x1536\ntablet",
					"iPad 1-3 Gen\n1024x768\ntablet",
				];
				var button:HButton = new HButton(names[i], new Rectangle(5 + (90 * (i % 4)), 5 + (90 * (Math.floor(i / 4))), 85, 85), (_:HButton) -> {
					final w:String = names[i].split("\n")[1].split('x')[0];
					final h:String = names[i].split("\n")[1].split('x')[1];
					projectWidthInput.text = w;
					projectHeightInput.text = h;
					projectFpsInput.text = "30";
					projWidth = Std.parseInt(projectWidthInput.text);
					projHeight = Std.parseInt(projectHeightInput.text);
					projFPS = Std.parseInt(projectFpsInput.text);
					projectTypeDropdown.label.text = "HTML5";
					projectMeasureDropdown.label.text = "Pixels";
				});
				gameGroup.add(button);
			}
			tabGroup.addGroup("Game", gameGroup);
			var webGroup:HGroup<HButton> = new HGroup(0, 0);
			for (i in 0...14) {
				final names:Array<String> = [
					"Low\n640x480\nWeb",
					"Medium\n800x600\nWeb",
					"High\n960x640\nWeb",
					"Very High\n1024x768\nWeb",
					"iPhone-5\n1136x640\nphone",
					"iPhone-4\n960x640\nphone",
					"iPhone 1-3 Gen\n480x320\nphone",
					"Android 16:9\n1280x720\nphone",
					"Android 16:10\n1680x1050\nphone",
					"Android 5:3\n1280x768\nphone",
					"Android 3:2\n960x640\nphone",
					"Android 4:3\n1024x768\nphone",
					"iPad 3-4 Gen\n2048x1536\ntablet",
					"iPad 1-3 Gen\n1024x768\ntablet",
				];
				var button:HButton = new HButton(names[i], new Rectangle(5 + (90 * (i % 4)), 5 + (90 * (Math.floor(i / 4))), 85, 85), (_:HButton) -> {
					final w:String = names[i].split("\n")[1].split('x')[0];
					final h:String = names[i].split("\n")[1].split('x')[1];
					projectWidthInput.text = w;
					projectHeightInput.text = h;
					projectFpsInput.text = "24";
					projWidth = Std.parseInt(projectWidthInput.text);
					projHeight = Std.parseInt(projectHeightInput.text);
					projFPS = Std.parseInt(projectFpsInput.text);
					projectTypeDropdown.label.text = "HTML5";
					projectMeasureDropdown.label.text = "Pixels";
				});
				webGroup.add(button);
			}
			tabGroup.addGroup("Web", webGroup);
			premade.addContent(tabGroup);
			var detailsArea:HSprite = premade.addContent(new HSprite(width / 2,
				0).makeGraphic((width / 2).floor(), height, HColor.MENUBAR_DROPDOWN_BACKGROUND));
			premade.addContent(new HText(detailsArea.x + 2, 2, detailsArea.width - 10, "Details", 12));
			premade.addContent(new HText(detailsArea.x + 2, 22, detailsArea.width - 10, "Width", 12));
			projectWidthInput = cast premade.addContent(new HTextInputBox(detailsArea.x + 2, 42, 20, (((detailsArea.width - 10) / 2) - 10).floor(), "1280",
				"1280", 12, (_:String) -> {
					trace('Target Project Width was changed to $_!');
					projWidth = Std.parseInt(_);
				}));
			premade.addContent(new HText((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 22, detailsArea.width - 10, "Height", 12));
			projectHeightInput = cast premade.addContent(new HTextInputBox((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 42, 20,
				(((detailsArea.width - 10) / 2) - 10).floor(), "720", "720", 12, (_:String) -> {
					trace('Target Project Height was changed to $_!');
					projHeight = Std.parseInt(_);
				}));
			premade.addContent(new HText(detailsArea.x + 2, 62, detailsArea.width - 10, "Units", 12));
			projectMeasureDropdown = cast premade.addContent(new HButton("Pixels", new Rectangle(detailsArea.x + 2, 82, 120, 20), (_:HButton) -> {
				HDropdown.openDropdownMenu(_, false, [
					{text: "Inches", closeOnClick: true, func: (b:HButton) -> _.label.text = "Inches"},
					{text: "Inches (Decimal)", closeOnClick: true, func: (b:HButton) -> _.label.text = "Inches (Decimal)"},
					{text: "Points", closeOnClick: true, func: (b:HButton) -> _.label.text = "Points"},
					{text: "Centimeters", closeOnClick: true, func: (b:HButton) -> _.label.text = "Centimeters"},
					{text: "Millimeters", closeOnClick: true, func: (b:HButton) -> _.label.text = "Millimeters"},
					{text: "Pixels", closeOnClick: true, func: (b:HButton) -> _.label.text = "Pixels"},
				]);
			}));
			premade.addContent(new HText((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 62, detailsArea.width - 10, "Frame Rate",
				12));
			projectFpsInput = cast premade.addContent(new HTextInputBox((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 82, 20,
				(((detailsArea.width - 10) / 2) - 10).floor(), "30", "30", 12, (_:String) -> {
					trace('Target Project FPS was changed to $_!');
					projFPS = Std.parseInt(_);
				}));
			premade.addContent(new HText(detailsArea.x + 2, 102, detailsArea.width - 10, "Platform Type", 12));
			projectTypeDropdown = cast premade.addContent(new HButton("HScript 2.7", new Rectangle(detailsArea.x + 2, 122, 120, 20), (_:HButton) -> {
				HDropdown.openDropdownMenu(_, false, [
					{text: "HScript 2.7", closeOnClick: true, func: (b:HButton) -> _.label.text = "HScript 2.7"},
					{text: "seperator", func: null},
					{text: "HTML5", closeOnClick: true, func: (b:HButton) -> _.label.text = "HTML5"},
				]);
			}));
			premade.addContent(new HButton("Create", new Rectangle(((detailsArea.x + detailsArea.width) - 82), height - 42, 80, 20),
				(_:HButton) -> onProjectCreate(), ACCENT));
			return premade;
		},
		"preferences" => () -> {
			final width:Int = (775 / 2).floor();
			final height:Int = (775 / 2).floor();
			var premade:HWindow = new HWindow(Locale.get("prefsWindow.title"), Main.pWidth / 2 - width / 2, Main.pHeight / 2 - height / 2, width, height,
				false, false);
			var tabGroup:ATabStack = new ATabStack(0, 0, new HPoint(width, height));
			tabGroup.addGroup("General", new HGroup(0, 0)); // we dont use locales yet, fuck you copilot.
			tabGroup.addGroup("Code Editor", new HGroup(0, 0));
			tabGroup.addGroup("Scripter", new HGroup(0, 0));
			tabGroup.addGroup("Compiler", new HGroup(0, 0));
			tabGroup.addGroup("Text", new HGroup(0, 0));
			tabGroup.addGroup("Drawing", new HGroup(0, 0));
			premade.addContent(tabGroup);
			premade.addContent(new HButton(Locale.get("prefsWindow.cancel"), new Rectangle(width - 85, height - 45, 80, 20), (_:HButton) -> {
				premade.destroy(); // cuz it cancels, so we dont save anything.
			}));
			premade.addContent(new HButton(Locale.get("prefsWindow.accept"), new Rectangle(width - 170, height - 45, 80, 20), (_:HButton) -> {
				trace("TODO: save preferences");
			}));
			return premade;
		}
	];

	/**
	 * make a pre-made window, so we dont clutter other places in code.
	 * @param type what prefab to use
	 * @return HWindow the window that was generated
	 * @since 0.6.0
	 */
	public function makePrefabWindow(type:String):HWindow
		return addWindow(prefabWindows.get(type)());

	/**
	 * focus a window to the front
	 * @param w what window to focus
	 * @since 0.2.0
	 */
	public static function focusWindow(w:HWindow):Void {
		if (w == null || w.stage == null)
			return;

		w.stage.setChildIndex(w, w.stage.numChildren - 1); // didnt know i could do this!

		if (windows.contains(w)) {
			windows.remove(w);
			windows.push(w);
		}
	}
}

/**
 * an in-window window.
 * @since 0.2.0
 */
class HWindow extends HGroup<HSprite> {
	/**
	 * Triggered when the window moves.
	 * @since 0.7.2
	 */
	public var onWindowMove:Null<HPoint->Void> = null;

	@:isVar public var dragBar(get, null):Null<HSprite> = null;

	public function get_dragBar():Null<HSprite>
		return dragBar ?? null;

	@:isVar public var dragBarButtons(get, null):Null<Array<HButton>> = null;

	public function get_dragBarButtons():Null<Array<HButton>>
		return dragBarButtons ?? null;

	@:isVar public var windowTitle(get, null):Null<HText> = null;

	public function get_windowTitle():Null<HText>
		return windowTitle ?? null;

	public var isBorderless(default, set):Bool = false;

	public function set_isBorderless(a:Bool):Bool {
		isBorderless = a;
		return isBorderless;
	}

	public var content:HGroup<HSprite>;
	public var TBHeight:Float = 0;

	var dragOffset:HPoint = new HPoint(0, 0);

	public function new(title:String, x:Float, y:Float, w:Int, h:Int, borderless:Bool = false, resizeable:Bool = false) {
		super(x, y);
		isBorderless = borderless;

		if (!isBorderless) {
			dragBar = new HSprite(0, 0).makeGraphic(w, 20, HColor.WHITE);
			add(dragBar);
			windowTitle = new HText(0, 0, dragBar.width / 2, title, 12);
			add(windowTitle);
			dragBarButtons = [];
			for (i in 0...3) {
				var b:HButton = new HButton('[SYM: ${["WIN_CLOSE", "WIN_MAX", "WIN_MIN"][i]}]', new Rectangle(dragBar.width - (20 + (20 * i)), 0, 20, 20), [
					(_:HButton) -> {
						destroy();
					},
					(_:HButton) -> {
						trace("maximize");
					},
					(_:HButton) -> {
						trace("minimize");
					}
				][i]);
				dragBarButtons.push(b);
				add(b);
			}

			WindowUtil.window.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragBar_onMove);
			TBHeight = 20;
		}

		content = new HGroup(0, 0);
		add(content);
		content.add(new HSprite(0, TBHeight).makeGraphic(w, h, HColor.WHITE));
		content.scrollRect = new Rectangle(0, 0, w, h);

		// Bring to top whenever the user clicks anywhere inside this window
		this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}

	private function onMouseDown(e:MouseEvent) {
		HWindowManager.focusWindow(this);
	}

	var dragging:Bool = false;

	public function dragBar_onMove(a:MouseEvent) {
		if (dragBar == null)
			return;

		var localMouse = dragBar.globalToLocal(new HPoint(a.stageX, a.stageY).toOpenflPoint());
		var isOverDragBar = dragBar.containsPoint(HPoint.fromOpenflPoint(localMouse));

		for (button in dragBarButtons) {
			if (button.containsPoint(HPoint.fromOpenflPoint(localMouse))) {
				return; // if the button is overlapped, cancel and dont drag.
			}
		}

		// convert raw stage coords into Main's virtual/local space
		var vx:Float = (a.stageX - Main.instance.x) / Main.instance.scaleX;
		var vy:Float = (a.stageY - Main.instance.y) / Main.instance.scaleY;

		if (a.buttonDown && isOverDragBar) {
			if (!dragging) {
				if (HWindowManager.heldWindow != null)
					return; // dont even try.
				dragging = true;
				HWindowManager.focusWindow(this);
				// Record grab offset so window doesn't snap its top-left corner to the mouse
				dragOffset.x = vx - this.x;
				dragOffset.y = vy - this.y;
				HWindowManager.heldWindow = this;
			}
		} else {
			if (dragging && !a.buttonDown) {
				dragging = false;
				HWindowManager.heldWindow = null;
			}
		}

		if (dragging) {
			if (HWindowManager.heldWindow != this) {
				trace("Held window isnt this! returning.");
				return;
			}
			setPosition(vx - dragOffset.x, vy - dragOffset.y);
			if (onWindowMove != null)
				onWindowMove(new HPoint(this.x, this.y));
		}
	}

	/**
	 * set the window position
	 * @param x x
	 * @param y y
	 * @since 0.2.0
	 */
	override public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;

		if (members != null) {
			for (i => member in members) {
				if (member == null) {
					trace('Tried to set position of member $i but it was null!\nMake sure it gets removed!!');
					continue;
				}
				member.x = 0;
				member.y = 0;
			}
		}

		if (dragBarButtons != null && dragBar != null) {
			for (i => b in dragBarButtons) {
				b.x = dragBar.width - (20 + (20 * i));
				b.y = 0;
			}
		}
	}

	/**
	 * add content to the window
	 * @param a what to add
	 * @return HSprite sprite that was added
	 * @since 0.2.0
	 */
	public function addContent(a:HSprite):HSprite {
		a.y += TBHeight;
		content.add(a);
		return a;
	}

	/**
	 * destroy the window
	 * @since 0.2.0
	 */
	override public function destroy() {
		this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);

		if (!isBorderless && Application.current != null && WindowUtil.window != null) {
			WindowUtil.window.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragBar_onMove);
		}

		HWindowManager.windows.remove(this);
		if (this.parent != null) {
			this.parent.removeChild(this);
		}

		super.destroy();
	}
}
