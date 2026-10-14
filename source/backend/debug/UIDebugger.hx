package backend.debug;

class UIDebugger extends HState {
	var background:HSprite;

	var testingButton:HButton;
	var testingDropdown:HMenuBar;
	var testingInput:HTextInputBox;

	override function create() {
		super.create();
		Main.addKeyPressed("UIDebuggerExitKey", Keyboard.ESCAPE, true, (_:KeyboardEvent) -> {
			Main.StateSystem.switchState(InitState);
		});
		background = new HSprite(0, 0).makeGraphic(Main.pWidth, Main.pHeight, HColor.LOADINGIND_MAINCOLOR);
		add(background);

		add(testingButton = new HButton("Testing", new Rectangle(0, 20, 80, 20), (a:HButton) -> {
			trace("This button works!");
		}));

		testingDropdown = new HMenuBar(TOP, [
			{
				type: HBUTTON,
				text: "Button",
				size: new HPoint(100, 20),
				onClick: (_) -> {
					trace("Normal button go brr!!");
				}
			},
			{
				type: HBUTTON,
				text: "Dropdown",
				size: new HPoint(100, 20),
				onClick: (_) -> {
					HDropdown.openDropdownMenu(_, [
						new HDropdownOption('button', null),
						new HDropdownOption('button(Close)', null).set_closeOnClick(true),
						new HDropdownOption('button(Disabled)', null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption('Sub dropdown', onSubdropdown),
					]);
				}
			},
		]);
		add(testingDropdown);

		add(testingInput = new HTextInputBox(80, 20, 20, 500, null, "input test!", 12, (_:String) -> {
			trace('Submitting a textbox with text: "$_"');
		}));
	}

	function onSubdropdown(b:HButton) {
		HDropdown.openSubDropdownMenu(b, [
			new HDropdownOption('sub button', null).set_closeOnClick(false),
			new HDropdownOption('seperator', null),
			new HDropdownOption('sub button(Close)', null).set_closeOnClick(true),
			new HDropdownOption('seperator', null),
			new HDropdownOption('sub button(Disabled)', null).set_disabled(true),
			new HDropdownOption('seperator', null),
			new HDropdownOption('sub button(Close full)', null).set_closeFullDropdown(true),
		]);
	}
}
