package backend.objects;

/**
 * text alignment
 * @since 0.2.0
 */
enum abstract HTextAlign(String) {
	var LEFT;
	var RIGHT;
	var CENTER;

	public static function toOpenflAlign(a:HTextAlign):TextFormatAlign {
		switch (a) {
			case LEFT:
				return TextFormatAlign.LEFT;
			case CENTER:
				return TextFormatAlign.CENTER;
			case RIGHT:
				return TextFormatAlign.RIGHT;
		}
		return TextFormatAlign.LEFT;
	}
}

/**
 * its text, not much more to it.
 * @since 0.2.0
 */
class HText extends HSprite implements IDestroyable {
	@:noCompletion private var format:TextFormat; // dumb way to do it but yeahh
	@:noCompletion private var field:TextField; // dumb way to do it but yeahh

	/**
	 * text alignment
	 * @since 0.2.0
	 */
	public var alignment(default, set):HTextAlign = LEFT;

	public function set_alignment(a:HTextAlign):HTextAlign {
		alignment = a;
		format.align = HTextAlign.toOpenflAlign(a);
		field.setTextFormat(format);
		return a;
	}

	/**
	 * font size
	 * @since 0.2.0
	 */
	public var fontSize(default, set):Int = 12;

	public function set_fontSize(a:Int):Int {
		fontSize = a;
		format.size = a;
		field.setTextFormat(format);
		return a;
	}

	// gets and setters so that this *acts* like a TextField when its actuall a HSprite
	public var text(get, set):String;

	public function get_text():String
		return field.text;

	public function set_text(t:String):String
		return(field.text = t);

	public var textWidth(get, never):Float;

	public function get_textWidth():Float
		return field.textWidth;

	public var textHeight(get, never):Float;

	public function get_textHeight():Float
		return field.textHeight;

	public var textColor(get, set):HColor;

	public function get_textColor():HColor
		return HColor.fromInt(field.textColor);

	public function set_textColor(a:HColor):HColor
		return(field.textColor = a);

	public var defaultTextFormat(get, set):TextFormat;

	public function get_defaultTextFormat():TextFormat
		return field.defaultTextFormat;

	public function set_defaultTextFormat(f:TextFormat):TextFormat
		return field.defaultTextFormat = f;

	public var selectable(get, set):Bool;

	public function get_selectable():Bool
		return field.selectable;

	public function set_selectable(a:Bool):Bool
		return field.selectable = a;

	/**
	 * make a new instance of HText
	 * @param x x position
	 * @param y y position
	 * @param width field width
	 * @param text text to show
	 * @param fontSize font size
	 * @since 0.2.0
	 */
	public function new(x:Float = 0, y:Float = 0, width:Float = 0, text:String = "", fontSize:Int = 12) {
		super(x, y);
		if (field == null)
			field = new TextField();
		if (format == null)
			format = new TextFormat();
		field.width = width;
		field.selectable = false;
		field.mouseEnabled = false;
		field.text = text;
		this.fontSize = fontSize;
		addChild(field);
	}

	/**
	 * set the text internal field size
	 * @param x x size
	 * @param y y size
	 * @since 0.2.0
	 */
	public function setFieldSize(x:Float, y:Float) {
		if (x != -1)
			field.width = x;
		if (y != -1)
			field.height = y;
	}

	/**
	 * destroy the text
	 * @since 0.2.0
	 */
	override public function destroy() {
		super.destroy();
		if (parent != null)
			parent.removeChild(this);
	}
}
