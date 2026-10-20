package backend;

/**
 * The building block of Hydro-Frame. took way too long to make this a thing.
 * @since 0.10.1
**/
class HBasic extends Sprite implements IHasAttributes<String, Dynamic> implements IDestroyable {
	/**
	 * attributes, currently only used for dropdowns.
	 * @since 0.10.1
	 */
	public var attributes:Map<String, Dynamic>;
	/**
	 * set an attribute to this object
	 * @param a key
	 * @param b value
	 * @return String
	 * @since 0.10.1
	 */
	public function setAttribute(a:String, b:Dynamic):String {
		attributes.set(a, b);
		return a;
	}

	/**
	 * get an attribute from this object
	 * @param a key
	 * @return Dynamic
	 * @since 0.10.1
	 */
	public inline function getAttribute(a:String):Dynamic
		return attributes.get(a);

	/**
	 * remove an attribute from this object
	 * @param a key
	 * @return Bool return attributes.remove(a)
	 * @since 0.10.1
	 */
	public inline function removeAttribute(a:String):Bool
		return attributes.remove(a);

	public function new(?x:Float=0, ?y:Float=0) {
		super();
		attributes = new Map<String, Dynamic>();
		this.x = x??0; //null safety ***JUSSTTTT*** in case.
		this.y = y??0;
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	/**
	 * only really good for overrides, but this is an update loop.
	 * @param event Event.ENTER_FRAME
	 * @since 0.10.1
	**/
	function onEnterFrame(event:Event) {}

	/**
	 * Center the sprite on the screen
	 * @return HSprite
	 * @since 0.10.1
	 */
	public function screenCenter():HBasic {
		x = Main.pWidth/2; //OpenFL Sprites have their origin in the center, not the top-left corner.
		y = Main.pHeight/2;
		return this;
	}

	/**
	 * set the position without doing +width/2
	 * @param x 
	 * @param y 
	 * @since 0.10.1
	 */
	public function setPosition(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	/**
	 * check if the sprite contains a point.
	 * @param point point to check.
	 * @return Bool return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint())
	 * @since 0.10.1
	 */
	public inline function containsPoint(point:HPoint):Bool
		return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint());

	/**
	 * check if the mouse is contained within the object
	 * @return Bool if the mouse is contained
	 * @since 0.10.1
	 */
	public inline function containsMouse():Bool
		return containsPoint(Main.vMouse);


	/**
	 * self explanitory.
	 * @since 0.10.1
	 */
	public function destroy() {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);

		if (parent != null)
			parent.removeChild(this);
	}
}