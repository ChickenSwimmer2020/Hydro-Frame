package backend.ui;

// TODO: fix the bugs and make it work properly. cuz its being stupid
// TODO: find way to not use multiple event listeners on stage.
class HTextInputBox extends HText {
	public var onSubmit:String->Void;

	private var placeholderText:HText;

	public static var selectedTextBox:Null<HTextInputBox> = null;

	public function new(x:Float, y:Float, height:Float, width:Float, ?text:String, placeholder:String, fontSize:Int, oS:String->Void) {
		super(x, y, width, text ?? "", fontSize);

		makeGraphic(width.floor(), height.floor(), HColor.MAGENTA);
		placeholderText = new HText(0, 0, width, placeholder, fontSize);
		placeholderText.mouseEnabled = false; // let clicks fall through to the box
		addChild(placeholderText);

		onSubmit = oS;
		// selectable = false; // we handle input ourselves, no native focus needed
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.ENTER_FRAME, onFrame);
		setFieldSize(width, height);
	}

	function onAdded(_:Event) {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
	}

	function onFrame(_:Event) {
		placeholderText.visible = (text == "");
	}

	override public function destroy() {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
		removeEventListener(Event.ENTER_FRAME, onFrame);
		if (selectedTextBox == this)
			selectedTextBox = null;
		super.destroy();
	}

	function onMouseDown(_:MouseEvent)
		selectedTextBox = this;

	function onStageMouseDown(e:MouseEvent) {
		if (e.target == this || Std.isOfType(e.target, HTextInputBox))
			return;
		selectedTextBox = null;
	}

	public function onKeyPressed(event:KeyboardEvent) {
		if (selectedTextBox != this)
			return;
		switch (event.keyCode) {
			case Keyboard.ENTER:
				event.shiftKey ? text = text += "\n" : {onSubmit(text); selectedTextBox = null;};
			case Keyboard.ESCAPE:
				selectedTextBox = null;
			case Keyboard.BACKSPACE:
				text = text.substr(0, text.length - 1);
			default:
				if (event.charCode >= 32 && event.charCode <= 126)
					text += String.fromCharCode(event.charCode);
		}
	}
}
