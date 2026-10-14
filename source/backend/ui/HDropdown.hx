package backend.ui;

class HDropdown extends HSprite {
	public static var members:Array<HSprite> = [];
	public static var canCloseInstace:Bool = false;
	public static var canCloseSubInstace:Bool = false;
	public static var dropdownOpen:Bool = false;
	public static var subDropdownOpen:Bool = false;
	public static var dropdownBG:HSprite;
	public static var subDropdownBG:HSprite;
	static var dropdownButtons:Array<OneOfTwo<HSprite, HButton>> = [];
	static var subDropdownButtons:Array<OneOfTwo<HSprite, HButton>> = [];
	static var increment:Float = 0.0;
	static var subIncrement:Float = 0.0;
	public static var dropdownKeys:Map<Array<Int>, String> = [];
	public static var subDropdownKeys:Map<Array<Int>, String> = [];

	// TODO: fix the backgrounds extending past the total ammount of buttons.
	public static function openDropdownMenu(target:HSprite, ?isSub:Bool = false, options:Array<HDropdownOption>, ?overWidth:Int) {
		if (dropdownOpen)
			return;
		var button = target;
		// TODO: fix not positioning based on stage position.
		var targetPosition:HPoint = new HPoint(0, 0);
		targetPosition.set(target.getBounds(Main.instance).x + (isSub ? button.width : 0), target.getBounds(Main.instance).y + (isSub ? 0 : button.height));

		dropdownBG = new HSprite(targetPosition.x,
			targetPosition.y).makeGraphic(Math.floor(overWidth ?? button.width), Math.floor(button.height * (options.length - 1)),
				HColor.MENUBAR_DROPDOWN_BACKGROUND);
		addM(dropdownBG);
		var ind:Int = 0;
		increment = 0.0;
		for (t in options) {
			var shouldCloseWhenClicked:Bool = t.closeOnClick ?? true;
			var disabled = t.disabled ?? false;
			if (t.keys != null)
				dropdownKeys.set(t.keys, t.text);

			switch (t.text) {
				case 'seperator':
					var seperator:HSprite = new HSprite(targetPosition.x, targetPosition.y + increment);
					seperator.makeGraphic(Math.floor(overWidth != null ? (overWidth / 2) : (button.width / 2)), Math.floor(button.height / 4),
						HColor.MENUBAR_DROPDOWN_SEPERATOR);
					dropdownButtons.push(seperator);
					addM(seperator);
					seperator.setAttribute("isDropdownObject", true);
					seperator.setAttribute("closeOnClick", false);
					increment += seperator.gHeight;
				default:
					var button:HButton = new HButton(t.text,
						new Rectangle(targetPosition.x, targetPosition.y + increment, overWidth ?? button.width, button.height), t.func);
					dropdownButtons.push(button);
					addM(button);
					button.setAttribute("isDropdownObject", true);
					button.setAttribute("closeOnClick", disabled ? false : shouldCloseWhenClicked);
					button.disabled = disabled;
					increment += button.gHeight;
			}

			ind++;
		}

		dropdownOpen = true;
		HTimer.start(0.02, () -> {
			canCloseInstace = true;
		});
	}

	public static function openSubDropdownMenu(target:HSprite, options:Array<{
		text:String,
		?closeOnClick:Bool,
		?closeFullDropdown:Bool,
		?keys:Array<Int>,
		?disabled:Bool,
		func:HButton->Void
	}>, ?overWidth:Int) {
		if (subDropdownOpen)
			return;
		var button = target;
		var targetPosition:HPoint = new HPoint(button.x + button.width, button.y);

		subDropdownBG = new HSprite(targetPosition.x,
			targetPosition.y).makeGraphic(Math.floor(overWidth ?? button.width), Math.floor(button.height * (options.length - 1)),
				HColor.MENUBAR_DROPDOWN_BACKGROUND);
		addM(subDropdownBG);
		var ind:Int = 0;
		subIncrement = 0.0;
		for (t in options) {
			var shouldCloseWhenClicked:Bool = t.closeOnClick ?? true;
			var closeFullDropdown:Bool = t.closeFullDropdown ?? false;
			var disabled = t.disabled ?? false;
			var text = t.text;
			if (t.keys != null)
				subDropdownKeys.set(t.keys, text);

			if (text == 'seperator') {
				var seperator:HSprite = new HSprite(targetPosition.x, targetPosition.y + subIncrement);
				seperator.makeGraphic(Math.floor(overWidth != null ? (overWidth / 2) : (button.width / 2)), Math.floor(button.height / 4),
					HColor.MENUBAR_DROPDOWN_SEPERATOR);
				subDropdownButtons.push(seperator);
				addM(seperator);
				seperator.setAttribute("isSubDropdownObject", true);
				seperator.setAttribute("closeOnClick", false);
				seperator.setAttribute("closeFullDropdown", false);
				subIncrement += seperator.height;
			} else {
				var func = t.func;
				var button:HButton = new HButton(text,
					new Rectangle(targetPosition.x, targetPosition.y + subIncrement, overWidth ?? button.width, button.height), func);
				subDropdownButtons.push(button);
				addM(button);
				button.setAttribute("isSubDropdownObject", true);
				button.setAttribute("closeOnClick", disabled ? false : shouldCloseWhenClicked);
				button.setAttribute("closeFullDropdown", disabled ? false : closeFullDropdown);
				button.disabled = disabled;
				subIncrement += button.height;
			}
			ind++;
		}

		subDropdownOpen = true;
		HTimer.start(0.02, () -> {
			canCloseSubInstace = true;
		});
	}

	public static function closeDropdownMenu() {
		trace("Destroying HDropdown");
		for (button in dropdownButtons) { // stupid casting requirements.
			if (button is HSprite)
				removeM((button : HSprite));
			if (button is HButton)
				removeM((button : HButton));
		}
		for (keys => key in dropdownKeys)
			dropdownKeys.remove(keys);
		removeM(dropdownBG);
		dropdownOpen = false;
		canCloseInstace = false;
	}

	public static function closeSubDropdownMenu() {
		trace("Destroying the subDropdownMenu");
		for (button in subDropdownButtons) { // stupid casting requirements.
			if (button is HSprite)
				removeM((button : HSprite));
			if (button is HButton)
				removeM((button : HButton));
		}
		for (keys => key in subDropdownKeys)
			subDropdownKeys.remove(keys);
		removeM(subDropdownBG);
		subDropdownOpen = false;
		canCloseSubInstace = false;
	}

	private static inline function addM(a:HSprite):HSprite {
		members.push(a);
		Main.instance.addChild(a);
		return a;
	}

	private static inline function removeM(a:HSprite):Bool {
		members.remove(a);
		cast(a, HSprite).destroy(); // auto calls `removeChild` from it.
		return a == null;
	}
}
