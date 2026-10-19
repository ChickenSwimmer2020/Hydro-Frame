package;

#if !macro
// debugging imports
#if debug
import backend.debug.*;
#end
#if PRETTY_LOGGING
import backend.debug.logging.*;
#end
// backend imports
import backend.*;
// objects
import backend.objects.*;
import backend.objects.HTween;
import backend.objects.StateSystem;
import backend.objects.HSound;
import backend.objects.HWindowManager;
// utils
import backend.utils.Type;
import backend.utils.*;
import engine.utils.HColor;
// ui
import backend.ui.*;
import ui.*;
// openfl imports
import openfl.display.*;
import openfl.filters.*;
import openfl.ui.*;
import openfl.events.*;
import openfl.text.*;
import openfl.system.*;
import openfl.geom.*;
import openfl.utils.*;
import openfl.utils.Timer;
import openfl.*;
import openfl.net.*;
import openfl.media.*;
// lime imports
import lime.graphics.Image;
import lime.app.Application;
import lime.utils.AssetLibrary;
import lime.graphics.RenderContext;
import lime.ui.Window;
import lime.utils.Log;
// sys imports
import sys.io.File;
import sys.*;
// haxe imports
import haxe.Json;
import haxe.zip.Reader;
import haxe.io.Bytes;
import haxe.*;

// usings
using backend.utils.DrawUtil;
using backend.utils.ArrayUtil;
using engine.utils.HMath;
using StringTools;
#end
