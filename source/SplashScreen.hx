package;

import engine.project.HProjectFactory;

class SplashScreen extends HState {
	var introSprite:HSprite;

	override function create() {
		super.create();
		introSprite = new HSprite(0, 0).makeGraphic(100, 100, HColor.TRANSPARENT);
		add(introSprite);

		HTimer.start(1.25, () -> {
			startIntro();
		});
	}

	public function startIntro() {
		HSoundManager.playSound("assets/sounds/Startup.wav");
		WindowUtil.resizeWindow(640, 360);
		introSprite.screenCenter();

		// FlashReader.parseFlaFile('IntroAnim.fla');
		for (i in 0...2) {
			HTimer.start([0.041, 0.184][i], [() -> drawHaxe(), () -> beginBetterIntro()][i]);
		}
	}

	public function beginBetterIntro() {
		var properSprite:HSprite = new HSprite(-640 / 2, -360 / 2, 'assets/images/splash/art.png');
		properSprite.alpha = 0;
		add(properSprite);

		new HTween().tween(properSprite, {alpha: 1}, 1.25, null, AEase.quadInOut);
		new HTween().tween(introSprite, {alpha: 0}, 1.25, () -> {
			introSprite.destroy();
			remove(introSprite);

			var nameText:HText = new HText(0, 0, 640, Locale.get("Splash"), 24);
			add(nameText);
			nameText.alignment = CENTER;
			nameText.y = -100;
			new HTween().tween(nameText, {y: 0}, 1.25, AEase.expoOut);

			var loadingIndicator:LoadingIndicator = new LoadingIndicator(300, 200);
			add(loadingIndicator);
			loadingIndicator.screenCenter();
			loadingIndicator.alpha = 0;
			loadingIndicator.y = 360;
			new HTween().tween(loadingIndicator, {alpha: 1, y: (Main.pHeight / 2 - loadingIndicator.height / 2)}, 1.25, AEase.expoOut);

			HTimer.start(5, () -> { // placeholder for how long preloading will take.
				HTimer.start(0.75, () -> {
					final onWindowComplete:Void->Void = () -> {
						Mouse.hide();
						WindowUtil.resizeWindow(1280, 720);
						Main.StateSystem.switchState(InitState);
					};
					Mouse.show(); // so you can see what ur doing.
					if (UPrefs.perferredReference.value.get("NOT SELECTED") == false) {
						onWindowComplete(); // if its been selected before, then we want to skip all this.
					} else {
						var referallWindow:HWindow = Main.windowManager.makeWindow(Locale.get("splash.referall.windowTitle"), (640 / 2 - 320 / 2).floor(),
							(360 / 2 - 180 / 2).floor(), 320, 180, false, false);
						for (button in referallWindow.dragBarButtons) {
							button.disabled = true; // disable the dragbar buttons.
							button.visible = false;
						}
						referallWindow.addContent(new HText(0, 0, referallWindow.width,
							"We noticed this is your first time launching!\nSince we don't use an account system, you have the choice!\nwhat should we call you?",
							12));
						var customtextInput:HTextInputBox = cast(referallWindow.addContent(new HTextInputBox(0, 105, 20, 320, null, "{Custom Name Here}", 12,
							null)), HTextInputBox);
						#if (sys)
						referallWindow.addContent(new HButton('"${Sys.getEnv(#if (windows)"COMPUTERNAME" #else "HOSTNAME" #end)}"',
							new Rectangle(0, 145, 106, 20), (_:HButton) -> {
								trace('User wants to be referred to as: "${Sys.getEnv(#if (windows)"COMPUTERNAME" #else "HOSTNAME" #end)}"!');
								UPrefs.perferredReference.value = ["Custom" => false, "WINUser" => false, "PCName" => true, "NOT SELECTED" => false];
								referallWindow.destroy();
								onWindowComplete();
							}));
						referallWindow.addContent(new HButton('"${Sys.getEnv("USERNAME")}"', new Rectangle(106, 145, 106, 20), (_:HButton) -> {
							UPrefs.perferredReference.value = ["Custom" => false, "WINUser" => true, "PCName" => false, "NOT SELECTED" => false];
							referallWindow.destroy();
							onWindowComplete();
						}));
						#end
						referallWindow.addContent(new HButton("Custom", new Rectangle(#if (sys)214 #else 0 #end, 145, #if (sys)106 #else 180 #end, 20),
							(_:HButton) -> {
								UPrefs.perferredReference.value = ["Custom" => true, "WINUser" => false, "PCName" => false, "NOT SELECTED" => false];
								UPrefs.customReferenceName.value = customtextInput.text;
								referallWindow.destroy();
								onWindowComplete();
							}));
					}
				});
			});
		}, AEase.quadInOut);
	}

	function drawHaxe() {
		introSprite.graphics.beginFill(0x00b922);
		introSprite.graphics.moveTo(0, -37);
		introSprite.graphics.lineTo(1, -37);
		introSprite.graphics.lineTo(37, 0);
		introSprite.graphics.lineTo(37, 1);
		introSprite.graphics.lineTo(1, 37);
		introSprite.graphics.lineTo(0, 37);
		introSprite.graphics.lineTo(-37, 1);
		introSprite.graphics.lineTo(-37, 0);
		introSprite.graphics.lineTo(0, -37);
		introSprite.graphics.endFill();

		introSprite.screenCenter();
	}
}
