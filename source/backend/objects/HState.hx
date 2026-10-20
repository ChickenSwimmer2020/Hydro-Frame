package backend.objects;

/**
 * HState, its a state. functions like FlxState from Flixel
 * @since 0.0.0
 */
class HState extends HBasic {
	/**
	 * members of the state
	 * @since 0.0.0
	 */
	public var members:Array<Dynamic> = [];

	/**
	 * UNFINISHED
	 * @since 0.4.0
	 */
	public var canInteract(default, set):Bool = true;

	/**
	 * UNFINISHED
	 * @since 0.4.0
	 */
	private var lastButtonStates:Map<HButton, Bool> = new Map<HButton, Bool>();

	/**
	 * UNFINISHED
	 * @param a UNFINISHED
	 * @since 0.4.0
	 */
	public function set_canInteract(a:Bool):Bool {
		canInteract = a;
		for (member in members) {
			if (member is HButton) {
				if (a) {
					(member : HButton).disabled = lastButtonStates.get((member : HButton));
					(member : HButton).doDisabledColor = false;
					lastButtonStates.remove((member : HButton));
				} else {
					lastButtonStates.set((member : HButton), (member : HButton).disabled);
					(member : HButton).doDisabledColor = false;
					(member : HButton).disabled = true;
				}
			}
		}
		return canInteract;
	}

	/**
	 * make a new state
	 * @since 0.0.0
	 */
	public function new() {
		super(0, 0);
	}

	/**
	 * For when the state is switched to
	 * @since 0.8.7
	 */
	public function create() {}

	/**
	 * add a new object to the state
	 * @param basic basic to add
	 * @return Dynamic the basic that was added
	 * @since 0.0.0
	 */
	public function add(basic:Dynamic):Dynamic {
		trace('added basic $basic');
		addChild(basic);
		members.push(basic);
		return basic;
	}

	/**
	 * remove an object from the state
	 * @param basic object to remove
	 * @return Bool was it removed successfully
	 * @since 0.0.0
	 */
	public function remove(basic:Dynamic):Bool {
		if (basic == null)
			return false;
		if (contains(basic))
			removeChild(basic);
		members.remove(basic);
		return true;
	}

	/**
	 * destroy the state
	 * @since 0.0.0
	 */
	override public function destroy() {
		// iterate a copy so removing mid-loop doesnt cause skips
		for (thing in members.copy()) {
			// call destroy on children that support it
			if (Std.isOfType(thing, HState))
				(cast thing : HState).destroy();
			else if (Reflect.hasField(thing, "destroy"))
				Reflect.callMethod(thing, Reflect.field(thing, "destroy"), []);

			// dispose BitmapData if it has any
			if (Reflect.hasField(thing, "bitmapData") && Reflect.field(thing, "bitmapData") != null)
				Reflect.callMethod(thing, Reflect.field(thing, "bitmapData"), []).dispose();

			// TODO: auto-remove event listeners added via in-line event listening.

			if (contains(thing))
				removeChild(thing);
		}
		members = [];

		//removes itself from parent now.
		super.destroy();
	}
}
