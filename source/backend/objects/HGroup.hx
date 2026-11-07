package backend.objects;

/**
 * group extending HSprite
 * @since 0.2.0
 */
class HGroup<T:HSprite> extends HSprite {
	/**
	 * members of the group
	 * @since 0.2.0
	 */
	public var members:Array<T>;

	/**
	 * maximum size of the group
	 * @since 0.2.0
	 */
	public var maxSize(default, set):Int = -1;

	public function set_maxSize(a:Int):Int {
		maxSize = a;
		return a;
	}

	/**
	 * make a new group
	 * @param x x position
	 * @param y y position
	 * @param maxSize maximum size (optional)
	 * @since 0.2.0
	 */
	public function new(x:Float, y:Float, ?maxSize:Int) {
		super(x, y);
		members = []; // initiate.
		if (maxSize != null) {
			members.resize(maxSize);
			this.maxSize = maxSize;
		}
	}

	/**
	 * Add a T to the group
	 * @param a object to add
	 * @return T object that was added
	 * @since 0.2.0
	 */
	public function add(a:T):T {
		if (maxSize == -1 || members.length < maxSize) {
			members.push(a);
			trace('Added basic $a to an HGroup');
			addChild(a);
		} else {
			trace('Couldnt add, group is full!');
		}
		return a;
	}

	/**
	 * remove an object from the group
	 * @param a object to remove
	 * @return Bool was it removed
	 * @since 0.2.0
	 */
	public function remove(a:T):Bool {
		if (members.indexOf(a) == -1) {
			trace('Couldnt remove $a from the group, its not in members!');
			return false;
		}
		var b = members.remove(a);
		removeChild(a);
		trace('Removed $a from an HGroup');
		return b;
	}

	/**
	 * destroy the group and every object in it
	 * @since 0.2.0
	 */
	override public function destroy() {
		for (member in members) {
			switch (Type.getClass(member)) {
				case HSprite:
					members.remove(member);
					removeChild(member);
					cast(member, HSprite).destroy();
				case HButton:
					members.remove(member);
					removeChild(member);
					cast(member, HButton).destroy();
				case HGroup:
					members.remove(member);
					removeChild(member);
					cast(member, HGroup<Dynamic>).destroy();
				case HText:
					members.remove(member);
					removeChild(member);
					cast(member, HText).destroy();
				default:
					trace('Unknown class: ${Type.getClass(member)}');
			}
		}
		members = [];
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}
