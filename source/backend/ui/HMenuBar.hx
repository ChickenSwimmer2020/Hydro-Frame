package backend.ui;

enum HMenuBarAlignment {
	TOP;
	BOTTOM;
	LEFT;
	RIGHT;
}

class HMenuBar extends HSprite {
	public var members:Array<HUISprite> = [];

	public static final TBHeight:Int = 20;

	public var backing:HSprite;
	public var align(default, set):HMenuBarAlignment = TOP;

	public function set_align(a:HMenuBarAlignment):HMenuBarAlignment {
		align = a;
		return align;
	}

	public function new(align:HMenuBarAlignment, butts:Array<HUISprite>) {
		super(0, 0);
		this.align = align;
		var targetPos:HPoint = new HPoint(0, 0);
		var targetSize:HPoint = new HPoint(WindowUtil.window_width, TBHeight);
		switch (align) {
			case LEFT:
				targetPos.set(0, 0); // position doesnt change, but the dimensions will
				targetSize.set(TBHeight, WindowUtil.window_height);

			case RIGHT:
				targetPos.set(WindowUtil.window_width - TBHeight, 0);
				targetSize.set(TBHeight, WindowUtil.window_height);

			case BOTTOM:
				targetPos.set(0, WindowUtil.window_height - TBHeight);
				targetSize.set(WindowUtil.window_width, TBHeight);

			default:
				targetPos.set(0, 0);
				targetSize.set(WindowUtil.window_width, TBHeight);
		}
		backing = new HSprite(targetPos.x, targetPos.y).makeGraphic(Math.floor(targetSize.x), Math.floor(targetSize.y), HColor.MENUBAR_BACKGROUND);
		add(backing);

		var offset:Float = 0;
		for (i => possibleButton in butts) {
			members.push(possibleButton);
			add(possibleButton);
			possibleButton.x+=offset;
			offset+=possibleButton.width;
		}
	}

	private inline function add(a:HSprite):HSprite {
		members.push(a);
		addChild(a);
		return a;
	}

	private inline function remove(a:HSprite):Bool {
		members.remove(a);
		cast(a, HSprite).destroy(); // auto calls `removeChild` from it.
		return a == null;
	}
}
