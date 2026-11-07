package;

import backend.ui.builder.HUIParser;
import backend.ui.builder.HUI;
import lime.ui.FileDialogFilter;
import lime.ui.FileDialog;
import backend.plugins.Skin;
import backend.plugins.SkinLoader;
import lime.ui.FileDialog;
import lime.ui.FileDialogFilter;

class InitState extends HState {
	override function create() {
		super.create();
		FileSystem.createDirectory("plugins");
		FileSystem.createDirectory("plugins/skins");
		SkinLoader.write("plugins/skins/default.hfs", Skin.defaultThemes);

		// overrides for normal application actions with keys.
		Main.addKeyPressed("toggleFullscreenWithF11", Keyboard.F11, false, (_:KeyboardEvent) -> {
			WindowUtil.toggleFullscreen();
		});
		// we have to do these here so they dont start on the splash screen.
		HSoundManager.playMusic(AssetLoader.getMusic("Vectors"), UPrefs.mainMenuMuted ? 0.0 : 0.35);

		Mouse.show();

		var UI = addChild(new TitleScreenView());
		//var UI:HUI = cast(add(HUI.build(HUIParser.parse("assets/data/ui/MainMenu.xml"))), HUI);

		add(new HButton(Locale.get("title.newProject"), new Rectangle(5, 235, 80, 20), (_:HButton) -> {
			Main.windowManager.makePrefabWindow("makeProject");
		}));

		function openFileBrowser() {
			// ik it looks weird, but `getCwd` already adds a trailing slash.
			if (!FileSystem.exists('${Sys.getCwd()}projects\\'))
				FileSystem.createDirectory('${Sys.getCwd()}projects\\'); // make projects folder if missing.
			FileDialog.openFile(Application.current.window, (files, filter) -> {
				if (files.length > 0) {
					var selectedFile:String = files[0];
					if (!selectedFile.endsWith('.fla') && !selectedFile.endsWith('.hfp')) {
						WindowUtil.window.alert(ERROR, "The selected file is not a Hydro-Frame project, or Adobe Animate Flash file!", 'Error!', ['Whoops']);
					}
					if (selectedFile.endsWith(".fla")) {
						switch (WindowUtil.window.alert(WARNING,
							"You have selected an Adobe Animate Flash project.\nPlease note, for legal reasons you cannot save back into this format!\nWould you like to continue?",
							'Heads up!', ['Yes', 'No'])) {
							case 1: return;
						}
					}

					trace('Trying to open: $selectedFile!');
				}
			}, [
				new FileDialogFilter("Hydro-Frame Projects", "hfp"),
				new FileDialogFilter("Adobe Animate Project", "fla"),
				new FileDialogFilter("All files", "*")
			], '${Sys.getCwd()}projects\\', false);
		}

		//add(new HButton(Locale.get("title.loadProject"), new Rectangle(90, 235, 80, 20), (_:HButton) -> {
		//	openFileBrowser();
		//}));

		function createPresent(width:Int, height:Int, fps:Int, platformType:String, units:String) {
			return Main.StateSystem.switchState(EditorState, [width, height, fps, platformType, units]);
		}

		//var projectScroller:ScrollableArea = new ScrollableArea(Main.pWidth - 350, 35);
		//add(projectScroller);
//
		//for (i in 0...15) {
		//	var pBox:ProjectBox = new ProjectBox(0, 0 + ((75 + 15) * i));
		//	pBox.loadData(i % 2 == 0 ? "TestFlashProject" : "TestHydro-FrameProjet", i % 2 == 0 ? "Flash" : "HFPF", "Yesterday");
		//	projectScroller.add(pBox); // for testing and getting it ready.
		//}
	}

	function newProject(butt:HButton) {
		Main.windowManager.makePrefabWindow("makeProject");
	}

	function checkForUpdates(butt:HButton) {
		var value:Int = Network.checkForUpdates();

		var darkenSprite:HSprite = new HSprite(0, 0).makeGraphic(Main.pWidth, Main.pHeight, 0x6E000000);
		Main.instance.addChild(darkenSprite);
		var loader:LoadingIndicator = new LoadingIndicator(0, 0);
		Main.instance.addChild(loader);
		loader.screenCenter();

		final time:Float = 5.0;
		HTimer.start(time / 2, () -> {
			if (value <= -1) {
				loader.destroy();
				darkenSprite.setGraphicColor(0x6EFF0000);
				var text:HText = new HText(0, 0, Main.pWidth, "", 48);
				text.setFieldSize(Main.pWidth, Main.pHeight);
				Main.instance.addChild(text);
				text.text = switch (value) {
					case -1: Locale.get("error.networking.ConnectionFailed", ["{URL}" => Network.updateCheckLocation]);
					case -4: Locale.get("error.networking.NxDomain");
					case -5: Locale.get("error.networking.UnknownError");
					default: Locale.get("error.default");
				}
				text.alignment = CENTER;
				text.x = Main.pWidth / 2 - text.width / 2;
				text.y = Main.pHeight / 2 - text.height / 2;

				HTimer.start(2.5, () -> {
					new HTween().tween(darkenSprite, {alpha: 0}, 1.15, () -> {
						darkenSprite.destroy();
					}, AEase.expoInOut);

					new HTween().tween(text, {alpha: 0}, 1.15, () -> {
						text.destroy();
					}, AEase.expoInOut);
				});
			}
		});

		HTimer.start(time, () -> {
			switch (value) {
				case 1:
					loader.destroy();
					darkenSprite.setGraphicColor(0x6E00FF00);
					var text:HText = new HText(0, 0, Main.pWidth, "", 48);
					Main.instance.addChild(text);
					text.text = Locale.get("autoupdater.check.runningLatest");
					text.alignment = CENTER;
					text.x = Main.pWidth / 2 - text.width / 2;
					text.y = Main.pHeight / 2 - text.height / 2;

					HTimer.start(0.75, () -> {
						new HTween().tween(darkenSprite, {alpha: 0}, 0.575, () -> {
							darkenSprite.destroy();
						}, AEase.expoInOut);

						new HTween().tween(text, {alpha: 0}, 0.575, () -> {
							text.destroy();
						}, AEase.expoInOut);
					});
				case 0:
					new HTween().tween(darkenSprite, {alpha: 0}, 0.575, () -> {
						darkenSprite.destroy();
						var updateWindow:HWindow = Main.windowManager.makeWindow(Locale.get("autoupdater.window.title"),
							Math.floor(Main.pWidth / 2 - 640 / 2), Math.floor(Main.pHeight / 2 - 360 / 2), 640, 360, false, false);
					}, AEase.expoIn);

					new HTween().tween(loader, {alpha: 0}, 0.575, () -> {
						loader.destroy();
					}, AEase.expoIn);
			}
		});
	}

	function about(butt:HButton) {
		var infoWindow:HWindow = Main.windowManager.makeWindow("If you can see this, a mistake was made.", 0, 0, 320, 240, true, false);
		infoWindow.screenCenter();
		var onWindowClick:MouseEvent->Void;
		onWindowClick = (_:MouseEvent) -> {
			infoWindow.removeEventListener(MouseEvent.CLICK, onWindowClick);
			infoWindow.destroy();
		};
		infoWindow.addEventListener(MouseEvent.CLICK, onWindowClick);

		var logo:HSprite = new HSprite(0, 0).loadGraphic(AssetLoader.getImage("ICON48"));
		var name:HText = new HText(0 + logo.width, 5, 100, "Hydro-Frame V{MAJORVER}.{MIDVER}.{MINORVER}", 12);

		infoWindow.addContent(logo);
		infoWindow.addContent(name);
	}
}
