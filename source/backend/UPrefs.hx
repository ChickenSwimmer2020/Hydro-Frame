package backend;

import backend.plugins.Skin;

/**
 * User Preferences system.
 * @since 0.3.0
 */
class UPrefs {
    public static var currentSkin:Null<Skin>; //for accessing color c
    /**
     * Default Preferences
     * * These get written to the UPrefs file if the file isnt found.
     * @since 0.3.0
     */
    private static final DEFAULT_PREFERENCES:Dynamic = {
        mainMenuMuted: false,
        #if debug
            debuggerVisible: true,
        #end
        //editor
        undoType: ["DocumentLevel"=>true, "ObjectLevel"=>false],
        undoLevels: 100,
        autoRecovery: true,
        autoRecoveryTime: 10,
        uiTheme: ["Darkest"=>false, "Dark"=>true, "Light"=>false, "Lightest"=>false],
        uiAppearance: ["Comfortable"=>true, "Compact"=>false],
        enableShading: true,
        hideStageBorder: false,
        useOutlinesForPanning: false,
        autoCollapseIconPanels: true,
        seperateProjectsAndScriptWindows: false,
        useCustomColorsForHighlights: false,
        groupCustomColor: 0xFF1cbbb4,
        objectCustomColor: 0xFF00a8ff,
        otherCustomColor: 0xFF0066ff,
        perferredReference: ["Custom"=>false, "WINUser"=>false, "PCName"=>false, "NOT SELECTED"=>true],
        customReferenceName: ""
    };
    //settings (non-editor settings)
    public static var perferredReference:Preference<Map<String, Bool>> = new Preference("perferredReference", ["Custom"=>false, "WINUser"=>false, "PCName"=>false, "NOT SELECTED"=>true]);
    public static var customReferenceName:Preference<String> = new Preference("customReferenceName", "");
    public static var mainMenuMuted:Preference<Bool> = new Preference("mainMenuMuted", false); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.

    //settings (editor)
    public static var undoType:Preference<Map<String, Bool>> = new Preference("undoType", ["DocumentLevel"=>true, "ObjectLevel"=>false]);
    public static var undoLevels:Preference<Int> = new Preference("undoLevels", 100);
    public static var autoRecovery:Preference<Bool> = new Preference("autoRecovery", true);
    public static var autoRecoveryTime:Preference<Int> = new Preference("autoRecoveryTime", 10);
    public static var uiTheme:Preference<Map<String, Bool>> = new Preference("uiTheme", ["Midnight"=>false, "Dark"=>true, "Bright"=>false, "Ultra Bright"=>false]);
    public static var uiAppearance:Preference<Map<String, Bool>> = new Preference("uiAppearance", ["Comfortable"=>true, "Compact"=>false]);
    public static var enableShading:Preference<Bool> = new Preference("enableShading", true);
    public static var hideStageBorder:Preference<Bool> = new Preference("hideStageBorder", false);
    public static var useOutlinesForPanning:Preference<Bool> = new Preference("useOutlinesForPanning", false);
    public static var autoCollapseIconPanels:Preference<Bool> = new Preference("autoCollapseIconPanels", true);
    public static var seperateProjectsAndScriptWindows:Preference<Bool> = new Preference("seperateProjectsAndScriptWindows", false);
    public static var useCustomColorsForHighlights:Preference<Bool> = new Preference("useCustomColorsForHighlights", false);
    public static var groupCustomColor:Preference<HColor> = new Preference("groupCustomColor", 0xFF1cbbb4);
    public static var objectCustomColor:Preference<HColor> = new Preference("objectCustomColor", 0xFF00a8ff);
    public static var otherCustomColor:Preference<HColor> = new Preference("otherCustomColor", 0xFF0066ff);
    //SETTINGS TO ADD AND MAKE FUNCTIONAL
    public static var inverseScrollDirection:Preference<Bool> = new Preference("inverseScrollDirection", false);


    #if debug
        public static var debuggerVisible:Preference<Bool> = new Preference("debuggerVisible", true); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.
    #end



    /**
     * Return a target preference
     * @param a What we what to try to find
     * @since 0.3.0
     */
    public static function getFromFile(a:String):Dynamic{
        var v:Dynamic = Reflect.getProperty(Json.parse(getPrefsFile()), a); //inital json data.
        if(v!=null&&Type.typeof(v)==TObject) { //map fix, so maps can be parsed correctly cuz apparently casting is stupid.
            var m = new Map<Dynamic, Dynamic>();
            for(f in Reflect.fields(v)) m.set(f, Reflect.field(v, f));
            return m;
        }
        return v;
    }

    /**
     * check through a mapped preference for the selected index
     * @param a 
     * @return String selected key
     * @since 0.8.3
     */
    public static function getSelected(a:Map<String, Bool>):String {
        for(key=>value in a) !value?continue:return key;
        return "";
    }

    /**
     * Return a target workspace object
     * @param a What we what to try to find
     * @since 0.7.2
     */
    public static function getFromWorkspace(a:String):Dynamic{
        var v:Dynamic = Reflect.getProperty(Json.parse(getWorkspaceFile()), a); //inital json data.
        if(v!=null&&Type.typeof(v)==TObject) { //map fix, so maps can be parsed correctly cuz apparently casting is stupid.
            var m = new Map<Dynamic, Dynamic>();
            for(f in Reflect.fields(v)) m.set(f, Reflect.field(v, f));
            return m;
        }
        return v;
    }


    /**
     * Write to preferences
     * @param a key
     * @param b value
     * @return Dynamic returns whatever `b` was
     * @since 0.3.0
     */
    public static function writeToFile(a:String, b:Dynamic):Dynamic {
        var json:Dynamic = Json.parse(getPrefsFile());
        Reflect.setField(json, a, b);
        trace('Setting field $a to $b in UPrefs.');
        File.saveContent("uPrefs.json", Json.stringify(json, null,"    "));
        return b;
    }


    public static function writeToWorkspace(a:String, b:Dynamic):Dynamic {
        var json:Dynamic = Json.parse(getWorkspaceFile());
        Reflect.setField(json, a, b);
        trace('Setting field $a to $b in workspace.');
        File.saveContent("workspace.json", Json.stringify(json, null,"    "));
        return b;
    }

    /**
     * Returns the preferences file, and makes it if it doesnt exist (SYS ONLY)
     * @return String json file
     */
    public static inline function getPrefsFile():String return (FileSystem.exists("uPrefs.json"))?File.getContent("uPrefs.json"):makePrefsFile();

    /**
     * get the workspace file, and make it if it doesnt exist.
     * @return String the workspace save data
     * @since 0.7.2
     */
    public static inline function getWorkspaceFile():String return (FileSystem.exists("workspace.json"))?File.getContent("workspace.json"):makeWorkspacefile();

    /**
     * Makes the preferences file (SYS ONLY)
     * @return String the content of the file
     * @since 0.3.0
     */
    public static function makePrefsFile():String {
        File.saveContent("uPrefs.json", Json.stringify(DEFAULT_PREFERENCES, null, "    "));
        return File.getContent("uPrefs.json");
    }

    /**
     * make the workspace json file.
     * @return String the new workspace file data
     * @since 0.7.2
     */
    public static function makeWorkspacefile():String{ 
        File.saveContent("workspace.json", Json.stringify({}, null, "    "));
        return File.getContent("workspace.json");
    }
}

//TODO: support of maps with .get/.set
/**
 * Preference container class
 * @param <T> Type.
 * @since 0.3.0
 */
class Preference<T> {
    /**
     * Name of the preference.
     * Generally used internally.
     * @since 0.3.0
     */
    public var name:String;
    /**
     * Value, this is what the preference is equal to.
     * uses get/set functions to get/set to the file
     * @since 0.3.0
     */
    @:isVar public var value(get, set):T;
    /**
     * returns the value of the preference
     * @return T the preference (Casted to <T>)
     * @since 0.3.0
     */
    public inline function get_value():T return (UPrefs.getFromFile(name):T); //safety
    /**
     * sets the current value to something
     * @return the input
     * @since 0.3.0
     */
    public inline function set_value(a:T):T return UPrefs.writeToFile(name, a);
    /**
     * Initiate a new Preference
     * @param n the name of the preference
     * @param v the value of the preference
     * @since 0.3.0
     */
    public function new(n:String, v:T) {
        name = n;
        @:bypassAccessor value = v;
    }
}