package backend.ui;

enum ButtonStyle {
	DEFAULT;
	ACCENT;
}

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

	public var text:String = "";

	public function new(text:String, rect:Rectangle, onClick:HButton->Void, ?buttonStyle:ButtonStyle = DEFAULT) {
		super(rect.x, rect.y);
		onC = onClick;
		this.text = text;
		makeGraphic(Math.floor(rect.width), Math.floor(rect.height), buttonStyle == ACCENT ? Native.getAccentColor() : HColor.BUTTON_IDLE);

		if (text.trim().startsWith("[SYM:") && text.trim().endsWith(']')) {
			this.drawIcon(text.split(':')[1].replace("]", "").trim(), 1, HColor.BLACK, HColor.TRANSPARENT);

			hasSymbol = true;
			targetSymbol = text.split(':')[1].replace("]", "").trim();
			symbolParams = [1, HColor.BLACK, HColor.TRANSPARENT];
		} else initLabel();

		addEventListener(MouseEvent.CLICK, onMouseClick);
		addEventListener(MouseEvent.DOUBLE_CLICK, onMouseClickDouble);
		addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
	}

	private function initLabel() {
		label = new HText(0, 0, width, this.text, 12);
		label.setFieldSize(width, height);
		label.alignment = CENTER;
		addChild(label);
	}

	public function setScale(scale:HPoint):HButton {
		this.scale.set(scale.x, scale.y);
		if(this.label!=null) {
			label.destroy();
			initLabel();
		}
		return this;
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

	public var doubleClickFunction:Null<HButton->Void> = null;
	public function set_onDoubleCLick(a:HButton->Void):HButton {
		doubleClickFunction = a;
		return this;
	}

	public function onMouseClickDouble(e:MouseEvent) {
		setGraphicColor(HColor.BUTTON_CLICK);
		if (hasSymbol) {
			this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
		}
		if(doubleClickFunction != null){
			HSoundManager.playSound("assets/sounds/buttonClick2X.wav", 1.0); // TODO: implement volume
			doubleClickFunction(this);
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
