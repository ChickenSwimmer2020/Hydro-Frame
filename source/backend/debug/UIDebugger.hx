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
						{
							text: "button",
							closeOnClick: false,
							keys: [],
							disabled: false,
							func: (_) -> {
								trace("dropdown button");
							}
						},
						{
							text: "button(Close)",
							closeOnClick: true,
							keys: [],
							disabled: false,
							func: (_) -> {
								trace("dropdown button (closeOnClick)");
							}
						},
						{
							text: "button(Disabled)",
							closeOnClick: false,
							keys: [],
							disabled: true,
							func: (_) -> {
								trace("dropdown button (closeOnClick)");
							}
						},
						{
							text: "seperator",
							closeOnClick: false,
							keys: [],
							disabled: true,
							func: null
						},
						{
							text: "Sub dropdown",
							closeOnClick: false,
							keys: [],
							disabled: false,
							func: (b) -> {
								HDropdown.openSubDropdownMenu(b, [
									{
										text: "sub button",
										closeOnClick: false,
										keys: [],
										disabled: false,
										func: (_) -> {
											trace("sub dropdown button");
										}
									},
									{
										text: "seperator",
										closeOnClick: false,
										keys: [],
										disabled: true,
										func: null
									},
									{
										text: "sub button(Close)",
										closeOnClick: true,
										keys: [],
										disabled: false,
										func: (_) -> {
											trace("sub dropdown button (closeOnClick)");
										}
									},
									{
										text: "seperator",
										closeOnClick: false,
										keys: [],
										disabled: true,
										func: null
									},
									{
										text: "sub button(Disabled)",
										closeOnClick: false,
										keys: [],
										disabled: true,
										func: (_) -> {
											trace("sub dropdown button (closeOnClick)");
										}
									},
									{
										text: "seperator",
										closeOnClick: false,
										keys: [],
										disabled: true,
										func: null
									},
									{
										text: "sub button(Close full)",
										closeOnClick: false,
										closeFullDropdown: true,
										keys: [],
										disabled: false,
										func: (_) -> {
											trace("sub dropdown button (close full dropdown)");
										}
									},
								]);
							}
						},
					]);
				}
			},
		]);
		add(testingDropdown);

		add(testingInput = new HTextInputBox(80, 20, 20, 500, null, "input test!", 12, (_:String) -> {
			trace('Submitting a textbox with text: "$_"');
		}));
	}
}
