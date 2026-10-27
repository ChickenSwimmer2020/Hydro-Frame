package backend.ui;

class ScrollableArea extends HGroup<HSprite> {
	public var interactable:Bool = true;
	public var index:Int = 0;
	public var target:Float = 0.0;

	public function new(x:Float, y:Float) {
		super(x, y);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
	}

	override public function onEnterFrame(e:Event) {
		target = HMath.lerp(target, index, 0.1);
		scrollRect = new Rectangle(0, 0 + target, width, height);
	}

	public function onMouseScroll(e:MouseEvent) {
		if (interactable) {
			if (containsMouse()) {
				final delta:Int = (e.delta * 40);
				if (UPrefs.inverseScrollDirection)
					index += delta;
				else
					index -= delta;
				if (index < 0)
					index = 0;
			}
		}
	}

	override public function destroy() {
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
		super.destroy();
	}
}
