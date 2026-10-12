package backend.ui;

enum HMenuBarAlignment {
	TOP;
	BOTTOM;
	LEFT;
	RIGHT;
}

enum HMenuBarObjectType {
	HTEXT;
	HSPRITE;
	HBUTTON;
	HCHECKBOX;
	// todo: support more if needbe
}

typedef HMenuBarObjectIdentifier = {
	var type:HMenuBarObjectType;
	@:optional var text:String;
	@:optional var size:HPoint;
	@:optional var enabled:Bool;
	@:optional var color:HColor;
	@:optional var onClick:(Dynamic) -> Void;
};

class HMenuBar extends HSprite {
	public var members:Array<HSprite> = [];

	public static final TBHeight:Int = 20;

	public var backing:HSprite;
	public var objects:Array<{key:String, object:HSprite}> = [];
	public var align(default, set):HMenuBarAlignment = TOP;

	public function set_align(a:HMenuBarAlignment):HMenuBarAlignment {
		align = a;
		return align;
	}

	public function new(align:HMenuBarAlignment, butts:Array<HMenuBarObjectIdentifier>) {
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
			switch (possibleButton.type) {
				case HBUTTON:
					var newButton:HButton = new HButton(possibleButton.text,
						new Rectangle(0 + offset, targetPos.y, possibleButton.size.x, possibleButton.size.y), possibleButton.onClick);
					objects.push({key: possibleButton.text, object: newButton});
					add(newButton);
					offset += newButton.width + 5;
				case HTEXT:
					var newText:HText = new HText(0 + offset, targetPos.y, possibleButton.size.x, possibleButton.text, 12);
					objects.push({key: possibleButton.text, object: newText});
					add(newText);
					offset += newText.width + 5;
				case HSPRITE:
					var newSprite:HSprite = new HSprite(0 + offset,
						targetPos.y).makeGraphic(possibleButton.size.iX, possibleButton.size.iY, possibleButton.color);
					objects.push({key: possibleButton.text, object: newSprite});
					add(newSprite);
					offset += newSprite.width + 5;
				case HCHECKBOX:
					var newCheckbox:HCheckbox = new HCheckbox(0 + offset, targetPos.y, possibleButton.text, possibleButton.onClick);
					objects.push({key: possibleButton.text, object: newCheckbox});
					add(newCheckbox);
					if (possibleButton.enabled)
						newCheckbox.value = possibleButton.enabled;
					offset += newCheckbox.width + 5;
				default:
					trace('Unknown HMenuBar object type "${possibleButton.type}".');
					continue; // skip over the invalid one.
			}
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
