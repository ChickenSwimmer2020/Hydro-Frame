package backend.ui;

class ATabStack extends HSprite {
	var order:Array<String> = []; // for positioning fixes
	var targetWidth:Float = 0;

	public function new(x:Float, y:Float, size:HPoint) {
		super(x, y);
		makeGraphic(size.iX, size.iY, HColor.MENUBAR_DROPDOWN_BACKGROUND);
		targetWidth = size.x;
	}

	public var buttons:Map<String, HButton> = [];
	public var groups:Map<String, HGroup<Dynamic>> = [];

	public function addGroup(n:String, gr:HGroup<Dynamic>):HGroup<Dynamic> {
		groups.set(n, gr);
		order.push(n);
		gr.x += 50; // move it aside
		// gr.scrollRect = new Rectangle(x, y+20, width, height-20); //so group cant render outside of the tabmenu

		var button:HButton = new HButton(n, new Rectangle(0, 0, 50, 20), (_:HButton) -> {
			activeGroup = n;
		});
		buttons.set(n, button);
		addChild(gr);
		gr.visible = false;
		addChild(button);
		scaleButtons();
		if (activeGroup == "")
			activeGroup = n; // default to first added group.
		return gr;
	}

	public function removeGroup(a:String):Bool {
		var group = groups.get(a);
		groups.remove(a);
		var button = buttons.get(a);
		buttons.remove(a);
		order.remove(a);
		button.destroy();
		group.destroy();
		scaleButtons();

		return(groups.get(a) == null && buttons.get(a) == null);
	}

	public var activeGroup(default, set):String = "";

	public function set_activeGroup(a:String):String {
		activeGroup = a;

		for (label => group in groups) {
			if (label == a) {
				group.visible = true;
				buttons.get(label).disabled = true;
			} else {
				group.visible = false;
				buttons.get(label).disabled = false;
			}
		}
		scaleButtons();

		return activeGroup;
	}

	private function scaleButtons() {
		if (order.length == 0)
			return;
		for (i in 0...order.length) {
			var button = buttons.get(order[i]);
			button.x = 0;
			button.y = i * button.gHeight;
		}
	}
}
