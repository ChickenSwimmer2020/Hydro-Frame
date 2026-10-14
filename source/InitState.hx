package;

import backend.plugins.Skin;
import backend.plugins.SkinLoader;

class InitState extends HState {
	var wallpaperBackground:HSprite;
	var toolBar:HMenuBar;
	var welcomeText:HText;

	public static var appliedDarkenOnlyOnce:Bool = false;

	final totalLaunchMessages:Int = 4;

	override function create() {
		super.create();
		FileSystem.createDirectory("plugins");
		FileSystem.createDirectory("plugins/skins");
		SkinLoader.write("plugins/skins/default.hfsf", Skin.defaultThemes);

		// overrides for normal application actions with keys.
		Main.addKeyPressed("toggleFullscreenWithF11", Keyboard.F11, false, (_:KeyboardEvent) -> {
			WindowUtil.toggleFullscreen();
		});
		// we have to do these here so they dont start on the splash screen.
		HSoundManager.playMusic("assets/sounds/Vectors.wav", UPrefs.mainMenuMuted.value ? 0.0 : 0.35);

		Mouse.show();

		wallpaperBackground = new HSprite(0, 0);
		wallpaperBackground.loadGraphic(HSprite.getDesktopWallpaper(1280, 720), true);
		add(wallpaperBackground);

		// holy shit, didnt realize there was a bug here!
		if (!appliedDarkenOnlyOnce)
			reapplyDarken();

		welcomeText = new HText(0, 20, 600, Locale.get("title.welcomeMSG", [
			"{USER}" => Locale.getUser(),
			"{MSGOFLAUNCH}" => Locale.get('title.launchMSG${Std.string(HMath.random(0, totalLaunchMessages))}')
		]), 12);
		add(welcomeText);
		welcomeText.textColor = HColor.WHITE;

		add(new HButton(Locale.get("title.newProject"), new Rectangle(5, 235, 80, 20), (_:HButton) -> {
			Main.windowManager.makePrefabWindow("makeProject");
		}));
		add(new HButton(Locale.get("title.loadProject"), new Rectangle(90, 235, 80, 20), (_:HButton) -> {
			trace("TODO: Open project file popup");
		}));

		function createPresent(width:Int, height:Int, fps:Int, platformType:String, units:String) {
			return Main.StateSystem.switchState(EditorState, [width, height, fps, platformType, units]);
		}

		var presents:Array<HButton->Void> = [
			btn -> createPresent(1920, 1080, 30, "HScript 2.7", "pixels"),
			btn -> createPresent(1280, 720, 30, "HTML5", "pixels"),
			btn -> createPresent(468, 60, 24, "HTML5", "pixels"),
			btn -> createPresent(2048, 1536, 30, "HTML5", "pixels"),
			btn -> createPresent(550, 400, 24, "HTML5", "pixels"),
			newProject,
		];

		for (i => present in presents)
			add(new HButton(Locale.get('title.presetButton$i'), new Rectangle(7 + ((82 * i) + (14 * i)), 40, 82, 140), present));

		toolBar = new HMenuBar(TOP, [
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.File"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					HDropdown.openDropdownMenu(_, false, [
						new HDropdownOption('${Locale.get("title.menuBar.File.New")}...', newProject).set_keys([Keyboard.CONTROL, Keyboard.N]),
						new HDropdownOption(Locale.get("title.menuBar.File.Open"), null),
						new HDropdownOption(Locale.get("title.menuBar.File.OpenRecent"), null).set_closeOnClick(),
						new HDropdownOption(Locale.get("title.menuBar.File.Close"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.File.CloseAll"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.File.Save"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.File.SaveAs"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.File.SaveAsTemplate"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.File.Revert"), null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.File.Import"), null),
						new HDropdownOption(Locale.get("title.menuBar.File.Export"), null),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.File.ConvertTo"), null),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.File.DistrobutionSettings"), null),
						new HDropdownOption(Locale.get("title.menuBar.File.Distrobute"), null),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.File.HScriptSettings"), null),
						#if sys
						new HDropdownOption('seperator', null), new HDropdownOption(Locale.get("title.menuBar.File.Exit"), (butt:HButton) -> {
							// TODO: check for open projects and prompt user to save before actually closing
							Sys.exit(0);
						}),
						#end
					], 200);
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Edit"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					HDropdown.openDropdownMenu(_, [
						new HDropdownOption(Locale.get("title.menuBar.Edit.Undo"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Redo"), null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Cut"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Copy"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.PasteCenter"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.PastePlace"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Clear"), null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Duplicate"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.SelectAll"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.DeselectAll"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.InvertSelection"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.FindandReplace"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.FindNext"), null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.Edit.TimeLine"), timelineShit),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.Edit.EditObjects"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.EditSelected"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.EditRig"), null).set_disabled(),
						new HDropdownOption('seperator', null),
						new HDropdownOption(Locale.get("title.menuBar.Edit.Preferences"),
							(butt:HButton) -> {
								var returnEater:HWindow = Main.windowManager.makePrefabWindow("preferences"); // only has a variable because otherwise the compiler complains.
							}),
						new HDropdownOption(Locale.get("title.menuBar.Edit.FontMapping"), null).set_disabled(),
						new HDropdownOption(Locale.get("title.menuBar.Edit.KeyboardShortcuts"), null).set_disabled(),
					], 200);
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.View"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("View menu");
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Insert"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Insert menu");
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Modify"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Modify menu");
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Text"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Text menu");
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Commands"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Commands menu");
				}
			},
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Control"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Controls menu");
				}
			},
			#if debug // debug exclusive options, like the UI debugger system.
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Debug"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					/*8*/
					HDropdown.openDropdownMenu(_, false, [
						new HDropdownOption(Locale.get("title.menuBar.Debug.UIDebugger"), (butt:HButton) -> {
							Main.StateSystem.switchState(UIDebugger);
						}),
						new HDropdownOption(Locale.get("title.menuBar.Debug.SymbolEditor"), (butt:HButton) -> {
							Main.StateSystem.switchState(SymbolEditor);
						}),
					]);
				}
			},
			#end
			#if sys
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Window"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					trace("Window menu");
				}
			},
			#end
			{
				type: HBUTTON,
				text: Locale.get("title.menuBar.Help"),
				size: new HPoint(50, 20),
				onClick: (_:HButton) -> {
					HDropdown.openDropdownMenu(_, false, [
						// {
						// 	text: Locale.get("title.menuBar.Help.Help"),
						// 	text: '${Locale.get("title.menuBar.Help.ReportBug")}...',
						// {text: 'seperator', func: null},
						// 	text: '${Locale.get("title.menuBar.Help.OnlineTutorial")}...',
						// 	text: '${Locale.get("title.menuBar.Help.HandsOnTutorial")}  >',
						// {text: 'seperator', func: null},
						// 	text: '${Locale.get("title.menuBar.Help.ManagePlugins")}...',
						// {text: 'seperator', func: null},
						new HDropdownOption(Locale.get("title.menuBar.Help.CheckforUpdates"), checkForUpdates),
						// },
						// {text: 'seperator', func: null},
						new HDropdownOption(Locale.get("title.menuBar.Help.AboutHydro-Frame"), about),
						// },
					], 200);
				}
			}
		]);
		add(toolBar);

		var isMuted:Bool = false;
		var muteButton:HButton = new HButton("[SYM: SOUND]", new Rectangle(toolBar.width - 20, 0, 20, 20), (_:HButton) -> {
			isMuted = !isMuted;
			_.changeSymbol(isMuted ? "MUTE" : "SOUND");
			HSoundManager.music.volume = isMuted ? 0.0 : 0.35;
			UPrefs.mainMenuMuted.value = isMuted;
		});
		if (UPrefs.mainMenuMuted.value) { // auto mute and shtuff.
			isMuted = true;
			muteButton.changeSymbol("MUTE");
		}
		add(muteButton);

		var projectScroller:ScrollableArea = new ScrollableArea(Main.pWidth - 350, 35);
		add(projectScroller);
		for (i in 0...15) {
			var pBox:ProjectBox = new ProjectBox(0, 0 + ((75 + 15) * i));
			pBox.loadData(i % 2 == 0 ? "TestFlashProject" : "TestHydro-FrameProjet", i % 2 == 0 ? "Flash" : "HFPF", "Yesterday");
			projectScroller.add(pBox); // for testing and getting it ready.
		}
	}

	function newProject(butt:HButton) {
		Main.windowManager.makePrefabWindow("makeProject");
	}

	function timelineShit(butt:HButton) {
		// 		HDropdown.openSubDropdownMenu(butt, [
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.RemoveFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Remove Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{text: 'seperator', func: null},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.CutFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Cut Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Copy Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Paste Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteOverwriteFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Paste and Overwrite Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.ClearFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Clear Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.SelectAllFrames")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Select All Frames Timeline (in-project)");
		// 				}
		// 			},
		// 			{text: 'seperator', func: null},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.CutLayers")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Cut Layers Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyLayers")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Copy Layers Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteLayers")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Paste Layers Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.DuplicateLayers")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Duplicate Layers Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.MergeLayers")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Merge Layers Timeline (in-project)");
		// 				}
		// 			},
		// 			{text: 'seperator', func: null},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyMotion")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Copy Motion Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteMotion")}',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Paste Motion Timeline (in-project)");
		// 				}
		// 			},
		// 			{
		// 				text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteMotionSpecial")}...',
		// 				keys: [],
		// 				disabled: true,
		// 				func: (butt:HButton) -> {
		// 					trace("Paste Motion Special Timeline (in-project)");
		// 				}
		// 			},
		// 		]);
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
		// Main.StateSystem.state.canInteract=false; //TODO: make this stupid thing work properly.

		var logo:HSprite = new HSprite(0, 0).loadGraphic("assets/images/ICON48.png");
		var name:HText = new HText(0 + logo.width, 5, 100, "Hydro-Frame V{MAJORVER}.{MIDVER}.{MINORVER}", 12);

		infoWindow.addContent(logo);
		infoWindow.addContent(name);
	}

	function reapplyDarken() {
		// projects list darken.
		wallpaperBackground.applyLocalFilter(new Rectangle(wallpaperBackground.width - wallpaperBackground.width / 2 + 150, 0,
			wallpaperBackground.width / 3 + 200, wallpaperBackground.height),
			new BlurFilter(32, 8, 3), {
				colorTransform: HColor.MAINMENU_PROJECTSLIST_DARKEN,
				offsets: new Rectangle(50, -100, 200, 200)
			});

		// top left darken area for the presets
		wallpaperBackground.applyLocalFilter(new Rectangle(0, 0, 600, 260), new BlurFilter(32, 32, 3), {colorTransform: HColor.MAINMENU_PROJECTSLIST_DARKEN});
		appliedDarkenOnlyOnce = true;
	}
}
