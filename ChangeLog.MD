<!--markdownlint-disable MD024-->
<!--markdownlint-disable MD033 -->

# CHANGELOG

## 0.9.2 (OCD + Hyperfixation Update)  - By V207 / Maki

* One Massive cleanup
  * The `InitState` toolbar creation is VERY optimized now
    * The `HDropdown` option is now a class : `HDropdownOption`

* [MACOS] `InitState` wallpaper background exists again
* The editor now compiles again
* The version suffix has been replaced with git information

## 0.9.1 (OCD Trip) - By V207 / Maki

* `Main.instance.removeFromMainStage` has been removed (just use `Main.instance.removeChild`)
* `Main.instance.addToMainStage` instances have been replaced with `Main.instance.addChild`
* MAJOR `Main` code cleanup
* The desktop wallpaper background is now loaded in `InitState` instead of `Main`
* `EditorState` and `SplashScreen` have been moved to a new `ui` folder
* Dead Code Elimination is enabled on non-debug builds
* Version suffix is now "MMV", standing for "Modified Main Version"
* `InitState`, `SplashScreen`, `SymbolEditor`, and `UIDebugger` now have their `new()` code in `create()`

## 0.9.0 (NauticInk brush engine) - By ZSolarDev

### The brush engine, NauticInk

* Added `engine.nauticink`.
  * Started work on the NauticInk brush engine. We are missing a lot of features here, but I am working on it. The math was tedious.
  * Added `NauticInk` under `engine.nauticink`.
    * This basically manages the entire engine. You can select one brush at a time, and register multiple renderers to render everything belonging to that brush.
  * Added `NauticBrush` under `engine.nauticink.brush`.
  * Added `engine.nauticink.brush.v1`.
    * This is the current V1 implementation of the NauticInk engine. I only made V1 because I expect to make future reworks of this engine and have it selectable, in case people enjoy different versions. This is because this is literally my first time making something like this.
    * Added `NauticStroke` under `engine.nauticink.brush.v1`.
    * Added `NauticCapStyle` under `engine.nauticink.brush.v1` (unused atm).
    * Added `NauticBrushV1` under `engine.nauticink.brush.v1`.
    * Added `NauticBrushPreset` under `engine.nauticink.brush.v1`. (no smoothing or pressure atm).
  * Added `engine.nauticink.brush.data`.
    * Added `NauticStrokePoint` under `engine.nauticink.brush.data`.
    * Added `NauticBrushConfig` under `engine.nauticink.brush.data`.
  * Added `engine.rendering.nauticink`.
    * Added `NauticRenderer` under `engine.rendering.nauticink`.
    * Added `NauticScreen` under `engine.rendering.nauticink`.
      * This is basically a small demo for testing the NauticInk engine. It's simple to use, check it out.
      * Added the `NAUTICINK_SCREEN` define. When defined, Hydro-Frame will load into the NauticInk testing state.

  * Moved `HColor` and `HMath` into `engine.utils` for use in `NauticInk`. Updated `Import` to match.
  * Added `GfxGraphics` under `format.gfx`.
    * This was due to a quirk in openfl's SVG rendering which used an even-odd fill. It messed up `NauticStroke`, making overlaps invert themselves. I fixed this by shadowing and modifying `GfxGraphics`.

### MacOS support

* On 0.8.0, MacOS stopped building. It would crash on startup.
  * This was due to an issue with `cne-lime`'s `develop` branch. It wouldn't request any specific version. On my and others Windows machines, this would default to the highest available version. But on MacOS, it would unfortunately do the opposite, loading up OpenGL 2.1 Metal. Obviously, this is not supported by `lime`, causing a crash the moment an unavailable gl function was called, which unfortunately was the very first call made.
  * I would have simple moved to the `cne` branch, but it didn't build on Windows due to a missing `imgui` header. Not only that, but it only would go as high as OpenGL 4.1.0 on Windows targets. Thus, I made a fork that started at newest OpenGL versions and downgraded until it could succesfully initialize. Based on the `develop` branch. It went as high as 4.6.0 on Windows, and as high as 4.1.0 on MacOS.
  * This means, to update, simply run `haxelib git lime https://github.com/ZSolarDev/cne-lime develop; haxelib run lime setup -y`. I have it ship with the `cpp` and `hl` binaries already. It doesn't currently ship with the `mac` binaries, so those still need to be build locally. I do need to get to getting them built from Rex eventually.
* The colors on my `cne-lime` branch didn't show correctly. I fixed this by adding some code to manually fix it in the beginning of `Main`, before `super()` is called.
* ***MACOS IS NOT FULLY SUPPORTED.*** Images don't seem to be loading from file properly, and the stage doesn't scale with the window correctly. Those should be the final bugs to fix, on MacOS.

### Other changes

* Cleaned up `HSVG`.
* Fixed a bug in `HSVG` where it would render with its own `width` and `height` rather than the svg's `width` and `height`.
* Removed unused import in `HSprite` (`openfl.display3D.textures.TextureBase`).
* Removed inline imports in `DefineMacro` (`haxe.macro.Context` -> `Context`).
* Removed `Contributers.MD` because it was never updated, and is unnecessary.
* Updated `hxformat.json` to match more closely to the current formatting.
* Reformatted the source folder with the new `hxformat.json`.

## 0.8.8 (Pretty Logging) - By Maki

* Removed `format.SVG` (the changes I did to it weren't functional)
* Added `backend.debug.logging.Logger`
* Added `defined(define)` to `DefineMacro`
* `PRETTY_LOGGING` is defined by default
* `DISABLE_PRETTY_LOGGING` undefines `PRETTY_LOGGING`
* Added `classesToIgnore` variable to `SafeBuild`
* `haxe.Log.trace` is replaced by `Logger.log` if `PRETTY_LOGGING` is defined
* Logs now appear in the format : "[`fileName`:`lineNumber`] : `log`"
* Fixed `VERSION_SUFFIX` being blank and the version suffix in the app title being "1"

## 0.8.7 (SVG Rendering) - By Maki

* Added `SVGScreen`
* Added `HSVG`
* Added `WindowUtil`
* Added `SVG`
* `HMenuBar` now uses `WindowUtil.window_width` instead of `Lib.application.window.width`
* `InitialState` now calls `create` on child states
* `HWindowManager` now uses `WindowUtil`
* `HState` now has an overidable `create` function
* `DefineMacro` for assistance with defines
* `SplashScreen` now uses `WindowUtil.resizeWindow` instead of manual calls
* buncha changes on Main
* `InitState`'s call to enable the F11 fullscreen system now uses `WindowUtil`
* `Import` was optimized (holy shit thanks maki)
* Test .svg sprites (stolen from scratch lol)
* `Project.xml` was rewritten/reformatted
* `gitignore` now ignores files titled `Unreleased.md`

## 0.8.6 (Plugins/Skins) - By ChickenSwimmer2020

> This REALLY should have been part of 0.8.3 but updates got out of hand
>
> I took WAY to long to get this out :/

* New binary Skinning system, loads data for themes and such
* Plugin system shell
* Project.xml has Adobe Animate now has registered symbols
* `HScript` is now a required library

### Native

* `flashTaskbar` is FINALLY functional on windows.

### HPoint

* `set()` now returns `HPoint`

### HDropdown

* FINALLY properly shows on a `HSprite` when called.

### UPrefs

* Works with the new `Skin` system
* New Function `getSelected`
* * This is designed for the maps of `String->Bool` in `UPrefs`, so that you can actually get the selected value.

### HColor

* Uses the new `Skin` system

### InitState

* Added some testing stuff todo with skins.

### Main

* Doesnt try to flash taskbar anymore.
* Initilizes `UPrefs.currentSkin`

## 0.8.5 (HSprite adjustments) - By ZSolarDev

* Cleaned up bitmap ordering code in `HSprite` a bit. I put it into a `replaceBitmap()` function and modified it a little.

## 0.8.4 (Functional audio) - By ZSolarDev

* Replaced the `'<???>'` string in my crash handler with `'<??' + '?>'`, because when compiling to MacOS targets, the compiler would treat it as a trigraph and replace it with `'<?}'`.
* Removed `.vscode/launch.json`, it was old and unused.
* Audio is now functional.
  * We had added audio loading before, but ever since `cne-lime`/`cne-openfl`, it didn't work. However, Chicken and I hadn't bat an eye as the switch came with a whole plethora of issues. But once those were fixed, we remembered the complete lack of audio. In conclusion, after ages of traces through a bunch of files down to openfl's audio and caching, then through lime's audio, then caching, then assets, then native wav lading, I had finally found where everything was failing.
  * This bug was due to some sort of issue when using `drlibs` to load wav's from files. I'm unsure how it was failing, but I do know that the `NativeCFFI` call was returning `null`. The path was completely valid, and the wav file had worked back before when we had been using `lime` for audio loading, rather than `cne-lime` for audio loading, which uses `drlibs`.
  * I fixed this by shadowing `WaveDecoder` in our own source code, and replacing with `NativeCFFI.lime_drlibs_wav_from_file(path)` with `fromBytes(File.getBytes(path))`.

## 0.8.3 (Text box input bug fix) - By ZSolarDev

* Fixed a bug where `HTextInputBox` wouldn't render text.
  * This was due to `HSprite` expecting for `_bitmap` to be the first child of itself, and discarding previous children on `makeGraphic()`/`loadGraphic()`/`applyLocalFilter()`.
  * This was fixed by initializing `oldIdx` as `0` instead of `-1`, and always doing `addChildAt()` instead of doing `addChild()` in the case that `oldIdx` remains `-1`.
* Fixed a bug where `HTextInputBox` wouldn't accept input.
  * This one was interesting. Each text input box would have an event registered on stage click and mouse click. Mouse click would only run if the mouse was hovering over the text input box and clicked, but stage click ran regardless. The intended behavior was that on mouse click, if you werent over any text boxes, it would set the static `selectedTextBox` to null, deselecting any text boxes. However, the way it was implemented was flawed. On mouse click, it would set a static `selectedTextBox` to itself. Then on stage click, it would check if the mouse was hovering over either itself, or if it was hovering over another display object and that display object was a child of itself. However, the stage click logic was incorrect. Another text input box would not be a child of this input box. This means that the entire check would fail if the mouse didn't click this own input box. Now this incorrect condition wouldn't be noticable as long as there weren't multiple text boxes, which is how I assume this snuck by Chicken. But on multiple, even if you select one textbox, the other one's stage mouse down event would set `selectedTextBox` to null.
  * This was fixed by replacing the second condition in the stage mouse down event's or from `(Std.isOfType(e.target, DisplayObject) && contains(cast e.target))` to `Std.isOfType(e.target, HTextInputBox)`.

## 0.8.2 (Compatibility with cne-openfl) - By ZSolarDev

* Fixed a bug where `ScrollableArea` would not scroll when the mouse wasn't hovering over any *children* (not the rect).
  * This was because the mouse scroll event listener were added to the display object, and didn't fire the mouse wheel event when the mouse wasn't hovering over any children of the `ScrollableArea`.
  * This was fixed by adding the mouse scroll event listener to `Lib.current.stage` instead of the `ScrollableArea`.
* Fixed a bug where the desktop background image would be blue.
  * This was due to statically loading the BitmapData instead of waiting for openfl to initialize. This wasn't an issue before switching to `cne-openfl`.
  * This was fixed by only getting the desktop background image at the end of `Main`.
* Removed inline imports in `HTween` (`openfl.display.DisplayObjectContainer` -> `DisplayObjectContainer`).

### Reworked `HSprite`

* Select children of `HSprite` are now removed on every graphic load or filter application. It will be removed if the child is in `clearObjects`.
  * `clearObjects` will not check if the child is actually added to the `HSprite` as a child. It will assume it.
* Instead of using `graphics` to draw, it now uses a `Bitmap` to draw onto.
  * This was because `cne-openfl` seems to have issues rendering some things with `graphics` instead of `Bitmap`.
* The change above warranted a rework of `DrawUtil` as well.
  * Inside of `drawIcon`, `DrawUtil` now creates a separate `Sprite` and adds it as a child of the `HSprite` on top. This child is added to `clearObjects`.
  * Inside of `addRect`, `DrawUtil` now creates a separate `Bitmap` and adds it as a child of the `HSprite` on top. This child is added to `clearObjects`.
* Renamed `reRender()` to `reRenderMakeGraphic()`. It adds nuance to the name and comment, as it only worked as intended when the sprite was made with `makeGraphic()`. This re-creates the `Bitmap`, and does not touch `clearObjects`. It does not put the `Bitmap` on top. For that, use `reRender()`.
* Added `reRender()`, which only re-renders the `Bitmap` and puts it on top of the highest child in `clearObjects`. Does not touch `clearObjects`, and it doesn't re-create the `Bitmap`.

## 0.8.1 (The fucky hotfix!) -- Build 1

* `PULL_REQUEST_TEMPLATE.MD` was reformated/updated.
* `AVOIDS.MD` was removed.
* `CONTRIBUTING.MD` was added.
* `LICENSE`->`LICENSE.MD` (so it actually shows on the github)
* `README.MD` was updated to be *hopefully* more legally protective

## 0.8.1 (The fucky hotfix!)

* Sadly removed the ability to compile to HTML5, due to cne-lime problems. :/ (this angers me.)
* Reformated the new changelog entries because ZSolarDev messed it up.
* Fixed a missing step that prevented lime from compiling.
* This is a REALLY fucky build

## 0.8.0 (Project format(.hfp), Virtual File System, Crash handling, and more.) - By ZSolarDev

* Working on the `engine.` package. This package is only separated from the backend because it contains things that are at the core *functionality* of Hydro-Frame rather than being a part of the UI/Application used to interface with it. Also, this is one of the few packages HScript will be able to access and use. This is so that we can have a slim runtime that only requires `engine.` and some logic to actually load and run the project. Like Adobe Flash Player. This does mean that any code under `source/engine/` shouldn't need any code outside of it, so that the runtime is self contained.

### Added Virtual File System

* Added `HFileSystem` class under `engine.vfs`
* Added `HFile` class under `engine.vfs`
* Added `HFolder` class under `engine.vfs`
* Added `HFileObj` class under `engine.vfs`

### .hfp project parsing, based on VFS for major format flexibility

* Added `HProject` class under `engine.project.data`
* Added `HProjectFileMetadata` class under `engine.project.data`
* Added `HProjectValidationResult` class under `engine.project.data`
* Added `HRawProjectFile` class under `engine.project.data`
* Added `HProjectFactory` class under `engine.project`
* Added `HProjectFileParser` class under `engine.project`
* Added `HProjectFileWriter` class under `engine.project`
* Added `HProjectHander` class under `engine.project`
* Added `HProjectUtils` class under `engine.utils`

### Update Libraries

* Lime->cne-Lime || `haxelib git lime https://github.com/CodenameCrew/cne-lime develop; lime rebuild [platform here]; lime rebuild tools`
* OpenFL->cne-OpenFL || `haxelib git openfl https://github.com/CodenameCrew/cne-openfl develop`
* Added `svg` || `haxelib install svg 1.2.0`

### Crash Handling

* Added `Safe` under `backend.utils` (meant for error handling, don't use).
* Added `MethodUtil` under `backend.utils` (meat for error handling, don't use)
  compiled method *in the codebase*(not in libraries or scripts). Used for error handling.
* Added the `Stamper` and `SafeBuild` classes under `backend.macro` (meant for error handling, don't use). ALSO, any function that you don't want error ensurance for whatever reason, annotate it with `@:unwrapSafe`.

### Other changes

* Added `OneOfTwo` class under `engine.utils`
* Added `resetState()` and `stateFormula` to `InitialState.StateSystemInit`
* I really need to rework the state system soon.
* Updated `LICENSE` to actually fill in the placeholders(`[yyyy] [name of copyright owner]`)

## 0.7.3 (bugfixing, editor improvements, etc)

* `Main:114` no longer refers to Hydro-Frame as a ***"game"***
* Fixed some inconsistancies in the `since` tags in comments on `Main`
* Removed some unneeded traces from `Locale`
* `HPoint` `iX` and `iY` are now `get`/`set`
* `HWindowManager` now has a new Variable `onWindowMove`
* `UPrefs` now has a `workspace` file for `EditorState`
* `EditorState` `Tools` enum is now abstract and `String` based
* `EditorState` Tools window now has non-functional buttons

## 0.7.2 (whoops)

* Fixed a wrong conditional block.

## 0.7.1 (pre-0.8.0)

* `HSprite` fallback graphic is now fixed on `HTML5`
* `HSprite.antialiasing` finally functional.
* `Locale` no longer tries to read `Sys.getEnv` on `HTML5`
* `ProjectBox` now works with new name
* `DrawUtil` now works with new name
* `InitState` quick-start buttons now work
* `Sys` builds no longer attempt to access `UPrefs.prefsData` as thats for `HTML5` only

## 0.7.0 (ui changes, mac support, and building guide)

* MacOS now compiles! (Thanks [Rex](https://github.com/RX-739)!)
* mac is VERY BUGGY at the moment, failes to get desktop wallpaper, or fallback...
  * fails to get the username/pcname, really broken.
* added BUILDING.MD, if applicible someone fix this, it might take me a while
* Added a TODO to `HSprite`
* New Function for `Locale`: `getUser`
* Updated `makeProject` prefab on `HMath`
* `HButton` now has label access
* Added `onGroupChange` to `HTabMenu`
* `HTextInput` no longer gives invalid text output from non-printable keys
* New preference! `inverseScrollDirection`
* `InitState` refers to you by whats set in the popup on `Splash`
* `Main` no longer crashes when *trying* to get desktop wallpaper on MacOS
* `SplashScreen` popup finished.

## 0.6.0 (sounds and input)

* New Sounds! (Thanks [HarukaStudios](https://github.com/HarukaStudios)!)
  * `buttonClick.wav`
  * `buttonClick2X.wav` (currently unused)
  * `ObjectClick.wav` (currently unused)
  * `ObjectClick2X.wav` (currently unused)
  * `popup.wav`
  * `Printer Sound [Begin Export].wav` (currently unused)
* Added `Contributors.MD` (this is a placeholder until the `About Hydro-Frame` window is finished)
* Fixed `DebugDisplay`, it also now shows if a dropdown/subdropdown is open, and if a text input is selected
* `SymbolEditor` got closer to being usable
* `HText` now has access to `.selectable`
* New premade system for `HMath`
* `HButton` has click sounds now.
* `HColorPicker` got slightly updated
* New Class! `ATabStack` its literally just `HTabMenu` but vertical.
* `HTextInputBox` is ***somewhat*** functional now
* `UPrefs` is now functional on `HTML5`
* `HColor` now has `.toString`
* `InitState` preferences button now opens unfinished preferences window.
* `Main` Debugger opening logic is now properly only tied to `F11` being pressed
* `SplashScreen` referall window updated slightly
* `TODO` finally has an entry

## 0.5.0 (No Clue what to name this update. :/)

* Added popup for asking how the user wants to be referred to on first launch.
* Added a lot of new language keys to the locale system
* `HDropdown` was slightly fixed, backgrounds are still fucky.
* `UPrefs` can actually read maps properly now.
* `InitState` edit dropdown implementation
* New popup on Splash screen for first launch to ask what you wanna be referred to.

## 0.4.0 (Debugging, Symbol maker, and sub-dropdowns)

* New ui debugging system.
* `DebugDisplay` only updates fields when needed
* New Class `SymbolEditor`
  * this is being used to replace the stupid ai generated html5 one.
* New Class `UIDebugger`
  * Used for testing UI features, not much else.
* Many classes now use `try` `catch(e)` loops to prevent crashes
* `Locale` no longer imports `openfl.Assets`
* New Class `Native`
  * For accessing native system elements, like accent color!
  * Also the reason that Hashlink compilation was removed :/
* `HGroup` no longer importrs `backend.ui.HButton` or `openfl.display.DisplayObject`
* `HSound` has unused imports removed and a `TODO` added.
* Added a (non-functional) `canInteract` system to `HState`
* Also added a `TODO` for auto-removal of `eventListeners`
  * Solar please fix.
* `HMath` had unused imports removed.
* Untested styling system for `HButton`
* New Class `HCheckbox`
* New Class `HColorPicker` (unfinished and non-functional ATM)
* `HDropdown` is now its own class, and can attach to any `HSprite` instead of being limited to `HButton`/`HMenuBar`
* Removed code pertaining to `HDropdown` from `HMenuBar`
* New Class `HTabMenu`
* New Class `HTextInputBox` (unfinished and non-functional ATM)
* `Uprefs` no longer imports `openfl.Assets`
* `DrawUtil` has a new icon: `"UICHECK"`.
* `DrawUtil` now reset `lineStyle` after drawing an icon.
* Added a `TODO` to `DrawUtil`.
* `InitState` now enables the `F11` key to toggle fullscreen.
* `InitState`'s entire `new` function is now a `try`-`catch(e)` system.
* More keys in `en_US.locale`
* Added the `general` preferences section from `Adobe® Animate®` to `uPrefs`
* `InitState` big updates

### Main

* New Static Final! `desktopBackgroundImage` (Used for caching)
* New Static Variable! `onKeyPressed:Map<String, {String, Bool, KeyboardEvent->Void}>`
* New Public Static Function! `addKeyPressed(String, Dynamic, Bool, KeyboardEvent->Void)`
* New Public Static Function! `removeKeyPressed(String):Bool`
* `New()` is now in a `try`-`catch(e)` system
* Support for Sub-Dropdowns.

### HSprite

* New Function! `SetPositionRaw(x, y)`
* Removed some unneeded imports

### HText

* Full Rewrite, now extends `HSprite`
* New Function! `setFieldSize(w, h)`

### HMath

* New Function! `floor(a)`
* New Function! `random(a,b,c)`

### HColor

* New Systems!
  * r, g, b, rgb, and a now have `get` and `set` functions.

## 0.3.0 (Locales, Preferences, and project boxes)

* Added user preferences system.
* Added en_US.locale
* `HDrawableIconGen.html` was updated with new controls

### Main

* `Lime.utils.Log` no longer crashes game if it cant find an asset

### InitState

* Removed a random unneeded trace message
* Music can now be muted

### Network

* New Variable! `updateCheckLocation:String`

### ProjectBox

* New Function! `loadData()`
* `Kind:HText` -> `Desc:HText`

### ScrollableArea

* Delta fix for HTML5, no longer goes at light speed.

### DrawUtil

* `HDrawableIconCommand` now uses `Float` instead of `Int`
* New Icons!
  * `FILE_ANIMATE`
  * `FILE_Hydro-FramePROJECTFORMAT`

## 0.2.0 (The Flixeling)

### HSound

* Complete rewrite to use `FlxSound`'s backend
  * Literally just `FlxSound` atp.

### HMath

* Added `bound()` (From `FlxMath`)
* Added `even()`
* `lerp()` now uses Flixel style

### New Tools Folder

* New tool for generating `HDrawableIconCommand` arrays.

### DrawUtil

* New system for drawing icons on buttons
* Added `DrawIcon()`
* New Enum! `HDrawableIconCommandType`
* New TypeDef! `HDrawableIconCommand`
* New Class! `HDrawableIcons`
  * `SOUND`
  * `MUTE`
  * `WIN_CLOSE`
  * `WIN_MAX`
  * `WIN_MIN`

### HSprite

* New Variable! `gColor:HColor`
* `makeGraphic` now clears graphic before starting
* New Function! `reRender():HSprite`

### HColor

* Finally fixed alpha being buggy
* Removed `getRGB()`
* `.rgb` is now an accessible field of `HColor`
* `.a` is now an accessible field of `HColor`

### HButton

* New Icon System!
* `onClick` now returns `HButton`
* New Function! `changeSymbol`

### InitState

* Added a mute button for the music

## 0.1.0 (New stuff!)

* New startup sound.
* New Main menu song
* Started Changelog
* Added new `Network` class.
* Added new `HGroup<T:DisplayObject>` class.
* Added new `HSound` class.
* Added new `HMath` class.
* Added new `HWindow` class.
* Added new `HMath` class.
* Added new `IDestroyable` interface.
* BASIC support for HTML5 <br>
  but PLEASE dont compile to it yet.

### Main

* Added `instance` variable.
* Added `vMouse` variable.
* Added `onStageMouseMove()`.
* Added `updateVirtualMouse()`.
* Added `addToMainStage()`.
* Added `removeFromMainStage()`.

### HSprite

* now implements `IDestroyable`.
* `MakeGraphic()` now defaults to `TRANSPARENT`.
* added `screenCenter()`.
* added `containsMouse()`.
* `getDesktopWallpaper()`
  * Returns fallback correctly if null.
  * Returns fallback if wallpaper isnt 16:9

### LoadingIndicator

* `segment` is now `public`
* `bg` tween is now `expoInOut`

### HPoint

* added `fromOpenflPoint()`

### HText

* Now implements `IDestroyable`
* Added `destroy()`

### HTween

* `tween()` now returns `HTween`

### ScrollableArea

* now functional
* now extends `HGroup<T>`

### HasParamsUtil -> HasAttributesUtil

### InitState

* Now plays `Vectors` looping
* "Check for updates..." is now functional.
* "About Hydro-Frame" is now functional.
* `ProjectScroller` is now functional.

### SplashScreen

* Now plays startup sound.
* `loadingIndicator` is now properly centered.
