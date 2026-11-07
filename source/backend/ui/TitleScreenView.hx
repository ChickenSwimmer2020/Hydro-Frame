package backend.ui;

import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.windows.WindowManager;
import haxe.ui.containers.VBox;
import haxe.ui.notifications.NotificationType;
import haxe.ui.notifications.NotificationManager;

using haxe.ui.animation.AnimationTools;

@:build(haxe.ui.ComponentBuilder.build("assets/data/ui/MainMenu.xml"))
class TitleScreenView extends VBox {
    public function new() {
        super();


		var isMuted:Bool = false;
		muteButton.onClick = (_)->{
			isMuted = !isMuted;
			muteButton.icon = AssetLoader.getIcon(isMuted?"unmute":"mute");
			HSoundManager.music.volume = (isMuted?0.0:0.35);
			UPrefs.mainMenuMuted=isMuted;
		};
		if (UPrefs.mainMenuMuted) { // auto mute and shtuff.
			isMuted = true;
			muteButton.icon=AssetLoader.getIcon("mute");
		}
        morePresetsButton.onClick = (_)->{
            var window = new NewProjectWindow();
            WindowManager.instance.addWindow(window);
        };
    }
}

@:build(haxe.ui.macros.ComponentMacros.build("assets/data/ui/dialog/PresetDialog.xml"))
class PresetDialog extends Dialog {
	final mappings:Map<String, Map<String, {w:Int, h:Int, fps:Int, plat:String, measure:String}>> = [
		"CharAnimTab" => [
			"SD" => {w: 640, h: 480, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
			"HD" => {w: 1280, h: 720, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
			"Full HD" => {w: 1920, h: 1080, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
			"4K" => {w: 3840, h: 2160, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
		],
		"SocialTab" => [
			"Small" => {w: 256, h: 144, fps: 30, plat: "HScript 2.7", measure: "Pixels"},
			"Large" => {w: 3840, h: 2160, fps: 30, plat: "HScript 2.7", measure: "Pixels"},
			"Landscape" => {w: 600, h: 315, fps: 30, plat: "HScript 2.7", measure: "Pixels"},
			"Square" => {w: 600, h: 600, fps: 30, plat: "HScript 2.7", measure: "Pixels"},
			"Vertical" => {w: 600, h: 750, fps: 30, plat: "HScript 2.7", measure: "Pixels"},
			"In-stream Photo" => {w: 440, h: 220, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
			"Profile Photo" => {w: 400, h: 400, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
			"Header Photo" => {w: 1500, h: 500, fps: 24, plat: "HScript 2.7", measure: "Pixels"},
		],
		"GameTab" => [
			"Low" => {w: 640, h: 480, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Medium" => {w: 800, h: 600, fps: 30, plat: "HTML5", measure: "Pixels"},
			"High" => {w: 960, h: 640, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Very High" => {w: 1024, h: 768, fps: 30, plat: "HTML5", measure: "Pixels"},
			"iPhone-5" => {w: 1136, h: 640, fps: 30, plat: "HTML5", measure: "Pixels"},
			"iPhone-4" => {w: 960, h: 640, fps: 30, plat: "HTML5", measure: "Pixels"},
			"iPhone 1-3 Gen" => {w: 480, h: 320, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Android 16:9" => {w: 1280, h: 720, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Android 16:10" => {w: 1680, h: 1050, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Android 5:3" => {w: 1280, h: 768, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Android 3:2" => {w: 960, h: 640, fps: 30, plat: "HTML5", measure: "Pixels"},
			"Android 4:3" => {w: 1024, h: 768, fps: 30, plat: "HTML5", measure: "Pixels"},
			"iPad 3-4 Gen" => {w: 2048, h: 1536, fps: 30, plat: "HTML5", measure: "Pixels"},
			"iPad 1-3 Gen" => {w: 1024, h: 768, fps: 30, plat: "HTML5", measure: "Pixels"}
		],
		"WebTab" => [
			"Low" => {w: 640, h: 480, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Medium" => {w: 800, h: 600, fps: 24, plat: "HTML5", measure: "Pixels"},
			"High" => {w: 960, h: 640, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Very High" => {w: 1024, h: 768, fps: 24, plat: "HTML5", measure: "Pixels"},
			"iPhone-5" => {w: 1136, h: 640, fps: 24, plat: "HTML5", measure: "Pixels"},
			"iPhone-4" => {w: 960, h: 640, fps: 24, plat: "HTML5", measure: "Pixels"},
			"iPhone 1-3 Gen" => {w: 480, h: 320, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Android 16:9" => {w: 1280, h: 720, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Android 16:10" => {w: 1680, h: 1050, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Android 5:3" => {w: 1280, h: 768, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Android 3:2" => {w: 960, h: 640, fps: 24, plat: "HTML5", measure: "Pixels"},
			"Android 4:3" => {w: 1024, h: 768, fps: 24, plat: "HTML5", measure: "Pixels"},
			"iPad 3-4 Gen" => {w: 2048, h: 1536, fps: 24, plat: "HTML5", measure: "Pixels"},
			"iPad 1-3 Gen" => {w: 1024, h: 768, fps: 24, plat: "HTML5", measure: "Pixels"}
		]
	];
	public function new(win:NewProjectWindow) {
		super();

		var selectedPreset:Array<String> = [];
		for (child in presetsList.findComponents(haxe.ui.components.Button)) {
			child.onClick = (_)->{
				selectedPreset = [child.userData, child.text];
			};
			child.onDblClick = (_)->{
				selectedPreset = [child.userData, child.text];
				win.applyPreset(mappings[selectedPreset[0]][selectedPreset[1]]??{w: 1, h: 1, fps: 1, plat: "HScript 2.7", measure: "Pixels"});
				hide();
			};
		}
		selectPresetButton.onClick = (_)->{
			var preInfo:{w:Int, h:Int, fps:Int, plat:String, measure:String} = mappings[selectedPreset[0]][selectedPreset[1]]??{w: 1, h: 1, fps: 1, plat: "HScript 2.7", measure: "Pixels"};
			win.applyPreset(preInfo);
			hide();
		};
	}
}

@:build(haxe.ui.ComponentBuilder.build("assets/data/ui/windows/NewProject.xml"))
class NewProjectWindow extends haxe.ui.containers.windows.Window {
        var targetProjectWidth:Int = 1280;
        var targetProjectHeight:Int = 720;
        var targetProjectFPS:Int = 24;
        var targetProjectCodeType:String = "HScript 2.7";
        var targetProjectMeasurementType:String = "Pixels";
		public function applyPreset(info:{w:Int, h:Int, fps:Int, plat:String, measure:String}) {
			targetProjectWidth = info.w;
			targetProjectHeight = info.h;
			targetProjectFPS = info.fps;
			targetProjectCodeType = info.plat;
			targetProjectMeasurementType = info.measure;

			projectWidthInput.text = Std.string(info.w);
			projectHeightInput.text = Std.string(info.h);
			projectFPSInput.value = info.fps;
			projectPlatformInput.text = info.plat;
			projectMeasurementInput.text = info.measure;
		}

       	function onProjectCreate() {
       	    Main.StateSystem.switchState(EditorState, [
				projectNameInput.text,
				projectDescription.text,
       	        targetProjectWidth,
       	        targetProjectHeight,
       	        targetProjectFPS,
       	        targetProjectCodeType,
       	        targetProjectMeasurementType
       	    ]);
       	}

		public function new() {
			super();

			openAPresetButton.onClick = (_)->{
				var dialog = new PresetDialog(this);
				//dialog.dialogParent = findComponent("windowContent", VBox);
				dialog.showDialog();
			};

			createProject.onClick = (_)->{
				if(projectNameInput.text == null) {
					NotificationManager.instance.addNotification({
						title: "Error!",
						body: "You need to give your project a name!",
						type: NotificationType.Error
					});
					projectNameInput.flash();
				}else{
					this.hide();
					onProjectCreate();
				}
			};

			cancelCreation.onClick = (_) -> {
				this.hide();
			};
		}


		//	premade.addContent(tabGroup);
		//	var detailsArea:HSprite = premade.addContent(new HSprite(width / 2,
		//		0).makeGraphic((width / 2).floor(), height, HColor.MENUBAR_DROPDOWN_BACKGROUND));
		//	premade.addContent(new HText(detailsArea.x + 2, 2, detailsArea.width - 10, "Details", 12));
		//	premade.addContent(new HText(detailsArea.x + 2, 22, detailsArea.width - 10, "Width", 12));
		//	projectWidthInput = cast premade.addContent(new HTextInputBox(detailsArea.x + 2, 42, 20, (((detailsArea.width - 10) / 2) - 10).floor(), "1280",
		//		"1280", 12, (_:String) -> {
		//			trace('Target Project Width was changed to $_!');
		//			projWidth = Std.parseInt(_);
		//		}));
		//	premade.addContent(new HText((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 22, detailsArea.width - 10, "Height", 12));
		//	projectHeightInput = cast premade.addContent(new HTextInputBox((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 42, 20,
		//		(((detailsArea.width - 10) / 2) - 10).floor(), "720", "720", 12, (_:String) -> {
		//			trace('Target Project Height was changed to $_!');
		//			projHeight = Std.parseInt(_);
		//		}));
		//	premade.addContent(new HText(detailsArea.x + 2, 62, detailsArea.width - 10, "Units", 12));
		//	//
		//	function onProjectTypeSelected(a:HButton, b:HButton)
		//		a.label.text = b.label.text;
		//	// 
		//	projectMeasureDropdown = cast premade.addContent(new HButton("Pixels", new Rectangle(detailsArea.x + 2, 82, 120, 20), (_:HButton) -> {
		//		HDropdown.openDropdownMenu(_, false, [
		//			new HDropdownOption('Inches', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('Inches (Decimal)', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('Points', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('Centimeters', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('Millimeters', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('Pixels', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//		]);
		//	}));
		//	premade.addContent(new HText((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 62, detailsArea.width - 10, "Frame Rate",
		//		12));
		//	projectFpsInput = cast premade.addContent(new HTextInputBox((detailsArea.x + 2) + (((detailsArea.width - 10) / 2) - 10).floor() + 15, 82, 20,
		//		(((detailsArea.width - 10) / 2) - 10).floor(), "30", "30", 12, (_:String) -> {
		//			trace('Target Project FPS was changed to $_!');
		//			projFPS = Std.parseInt(_);
		//		}));
		//	premade.addContent(new HText(detailsArea.x + 2, 102, detailsArea.width - 10, "Platform Type", 12));
		//	projectTypeDropdown = cast premade.addContent(new HButton("HScript 2.7", new Rectangle(detailsArea.x + 2, 122, 120, 20), (_:HButton) -> {
		//		HDropdown.openDropdownMenu(_, false, [
		//			new HDropdownOption('HScript 2.7', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//			new HDropdownOption('seperator', null),
		//			new HDropdownOption('HTML5', b -> onProjectTypeSelected(_, b)).set_closeOnClick(true),
		//		]);
		//	}));
		//	premade.addContent(new HButton("Create", new Rectangle(((detailsArea.x + detailsArea.width) - 82), height - 42, 80, 20),
		//		(_:HButton) -> onProjectCreate(), ACCENT));
		//	return premade;
}

