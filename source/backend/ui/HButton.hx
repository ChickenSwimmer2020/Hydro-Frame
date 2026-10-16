package backend.ui;

enum ButtonStyle {
	DEFAULT;
	ACCENT;
}

// TODO: support double clicking.
class HButton extends HUISprite {
	/**
	 * label access
	 * @since 0.7.0
	 */
	public var label:Null<HText> = null;

	public var disabled(default, set):Bool = false;
	public var doDisabledColor:Bool = true;

	public function set_disabled(a:Bool):Bool {
		disabled = a;
		if (disabled == true) {
			removeEventListener(MouseEvent.CLICK, onMouseClick);
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			if (doDisabledColor)
				setGraphicColor(HColor.BUTTON_DISABLED);
		} else {
			setGraphicColor(HColor.BUTTON_IDLE);
			if (!hasEventListener("click"))
				addEventListener(MouseEvent.CLICK, onMouseClick);
			if (!hasEventListener("mouseOver"))
				addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			if (!hasEventListener("mouseOut"))
				addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		return disabled;
	}

	public var onC:HButton->Void;
	public var hasSymbol:Bool = false;
	public var targetSymbol:String = "";
	public var symbolParams:Array<Dynamic> = [];

	public function new(text:String, rect:Rectangle, onClick:HButton->Void, ?buttonStyle:ButtonStyle = DEFAULT) {
		super(rect.x, rect.y);
		onC = onClick;
		makeGraphic(Math.floor(rect.width), Math.floor(rect.height), buttonStyle == ACCENT ? Native.getAccentColor() : HColor.BUTTON_IDLE);

		if (text.trim().startsWith("[SYM:") && text.trim().endsWith(']')) {
			this.drawIcon(text.split(':')[1].replace("]", "").trim(), 1, HColor.BLACK, HColor.TRANSPARENT);

			hasSymbol = true;
			targetSymbol = text.split(':')[1].replace("]", "").trim();
			symbolParams = [1, HColor.BLACK, HColor.TRANSPARENT];
		} else {
			label = new HText(0, 0, rect.width, text, 12);
			label.setFieldSize(rect.width, rect.height);
			label.alignment = CENTER;
			addChild(label);
		}

		addEventListener(MouseEvent.CLICK, onMouseClick);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}

	// TODO: add system to fix text width when button is resized. or to uniformly scale the text proportionately

	public function onMouseClick(e:MouseEvent) {
		setGraphicColor(HColor.BUTTON_CLICK);
		if (hasSymbol) {
			this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
		}
		if (onC != null) {
			HSoundManager.playSound("assets/sounds/buttonClick.wav", 1.0); // TODO: implement volume
			onC(this);
		}
	}

	public function onMouseOver(e:MouseEvent) {
		setGraphicColor(HColor.BUTTON_HOVER);

		if (hasSymbol) {
			this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
		}
	}

	public function changeSymbol(a:String) {
		if (!hasSymbol)
			return; // cancel.
		targetSymbol = a;
		this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]); // then redraw the icon.
	}

	public function onMouseOut(e:MouseEvent) {
		setGraphicColor(HColor.BUTTON_IDLE);
		if (hasSymbol) {
			this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
		}
	}

	override public function destroy() {
		removeEventListener(MouseEvent.CLICK, onMouseClick);
		removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		super.destroy();
	}
}
