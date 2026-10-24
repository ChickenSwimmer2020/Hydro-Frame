package backend.utils;

class InputUtil {
    private static var activeKeys:Array<InputObject> = [];
    public static var A:InputObject;
    public static var B:InputObject;
    public static var C:InputObject;
    public static var D:InputObject;
    public static var E:InputObject;
    public static var F:InputObject;
    public static var G:InputObject;
    public static var H:InputObject;
    public static var I:InputObject;
    public static var J:InputObject;
    public static var K:InputObject;
    public static var L:InputObject;
    public static var M:InputObject;
    public static var N:InputObject;
    public static var O:InputObject;
    public static var P:InputObject;
    public static var Q:InputObject;
    public static var R:InputObject;
    public static var S:InputObject;
    public static var T:InputObject;
    public static var U:InputObject;
    public static var V:InputObject;
    public static var W:InputObject;
    public static var X:InputObject;
    public static var Y:InputObject;
    public static var Z:InputObject;

    public static var NUMBER_0:InputObject;
    public static var NUMBER_1:InputObject;
    public static var NUMBER_2:InputObject;
    public static var NUMBER_3:InputObject;
    public static var NUMBER_4:InputObject;
    public static var NUMBER_5:InputObject;
    public static var NUMBER_6:InputObject;
    public static var NUMBER_7:InputObject;
    public static var NUMBER_8:InputObject;
    public static var NUMBER_9:InputObject;

    public static var NUMPAD_0:InputObject;
    public static var NUMPAD_1:InputObject;
    public static var NUMPAD_2:InputObject;
    public static var NUMPAD_3:InputObject;
    public static var NUMPAD_4:InputObject;
    public static var NUMPAD_5:InputObject;
    public static var NUMPAD_6:InputObject;
    public static var NUMPAD_7:InputObject;
    public static var NUMPAD_8:InputObject;
    public static var NUMPAD_9:InputObject;
    public static var NUMPAD_ADD:InputObject;
    public static var NUMPAD_DECIMAL:InputObject;
    public static var NUMPAD_DIVIDE:InputObject;
    public static var NUMPAD_ENTER:InputObject;
    public static var NUMPAD_MULTIPLY:InputObject;
    public static var NUMPAD_SUBTRACT:InputObject;

    public static var F1:InputObject;
    public static var F2:InputObject;
    public static var F3:InputObject;
    public static var F4:InputObject;
    public static var F5:InputObject;
    public static var F6:InputObject;
    public static var F7:InputObject;
    public static var F8:InputObject;
    public static var F9:InputObject;
    public static var F10:InputObject;
    public static var F11:InputObject;
    public static var F12:InputObject;
    //? Keyboard has these, what the fuck is function key 13-15 ????
    public static var F13:InputObject;
    public static var F14:InputObject;
    public static var F15:InputObject;

    public static var UP:InputObject;
    public static var DOWN:InputObject;
    public static var LEFT:InputObject;
    public static var RIGHT:InputObject;

    public static var HOME:InputObject;
    public static var END:InputObject;
    public static var PAGE_UP:InputObject;
    public static var PAGE_DOWN:InputObject;
    public static var INSERT:InputObject;
    public static var DELETE:InputObject;
    public static var BACKSPACE:InputObject;
    public static var ENTER:InputObject;
    public static var ESCAPE:InputObject;
    public static var SPACE:InputObject;
    public static var TAB:InputObject;

    public static var SHIFT:InputObject;
    public static var CONTROL:InputObject;
    public static var ALTERNATE:InputObject;
    #if mac public static var COMMAND:InputObject; #end //* Macintosh only.
    public static var CAPS_LOCK:InputObject;

    public static var BACKQUOTE:InputObject;
    public static var BACKSLASH:InputObject;
    public static var COMMA:InputObject;
    public static var EQUAL:InputObject;
    public static var LEFTBRACKET:InputObject;
    public static var MINUS:InputObject;
    public static var PERIOD:InputObject;
    public static var QUOTE:InputObject;
    public static var RIGHTBRACKET:InputObject;
    public static var SEMICOLON:InputObject;
    public static var SLASH:InputObject;

    /**
     * Init listeners
     * @since 0.10.1
    **/
    public static function init() {
        A = new InputObject(Keyboard.A, "A");
        B = new InputObject(Keyboard.B, "B");
        C = new InputObject(Keyboard.C, "C");
        D = new InputObject(Keyboard.D, "D");
        E = new InputObject(Keyboard.E, "E");
        F = new InputObject(Keyboard.F, "F");
        G = new InputObject(Keyboard.G, "G");
        H = new InputObject(Keyboard.H, "H");
        I = new InputObject(Keyboard.I, "I");
        J = new InputObject(Keyboard.J, "J");
        K = new InputObject(Keyboard.K, "K");
        L = new InputObject(Keyboard.L, "L");
        M = new InputObject(Keyboard.M, "M");
        N = new InputObject(Keyboard.N, "N");
        O = new InputObject(Keyboard.O, "O");
        P = new InputObject(Keyboard.P, "P");
        Q = new InputObject(Keyboard.Q, "Q");
        R = new InputObject(Keyboard.R, "R");
        S = new InputObject(Keyboard.S, "S");
        T = new InputObject(Keyboard.T, "T");
        U = new InputObject(Keyboard.U, "U");
        V = new InputObject(Keyboard.V, "V");
        W = new InputObject(Keyboard.W, "W");
        X = new InputObject(Keyboard.X, "X");
        Y = new InputObject(Keyboard.Y, "Y");
        Z = new InputObject(Keyboard.Z, "Z");

        NUMBER_0 = new InputObject(Keyboard.NUMBER_0, "0");
        NUMBER_1 = new InputObject(Keyboard.NUMBER_1, "1");
        NUMBER_2 = new InputObject(Keyboard.NUMBER_2, "2");
        NUMBER_3 = new InputObject(Keyboard.NUMBER_3, "3");
        NUMBER_4 = new InputObject(Keyboard.NUMBER_4, "4");
        NUMBER_5 = new InputObject(Keyboard.NUMBER_5, "5");
        NUMBER_6 = new InputObject(Keyboard.NUMBER_6, "6");
        NUMBER_7 = new InputObject(Keyboard.NUMBER_7, "7");
        NUMBER_8 = new InputObject(Keyboard.NUMBER_8, "8");
        NUMBER_9 = new InputObject(Keyboard.NUMBER_9, "9");

        NUMPAD_0 = new InputObject(Keyboard.NUMPAD_0, "0");
        NUMPAD_1 = new InputObject(Keyboard.NUMPAD_1, "1");
        NUMPAD_2 = new InputObject(Keyboard.NUMPAD_2, "2");
        NUMPAD_3 = new InputObject(Keyboard.NUMPAD_3, "3");
        NUMPAD_4 = new InputObject(Keyboard.NUMPAD_4, "4");
        NUMPAD_5 = new InputObject(Keyboard.NUMPAD_5, "5");
        NUMPAD_6 = new InputObject(Keyboard.NUMPAD_6, "6");
        NUMPAD_7 = new InputObject(Keyboard.NUMPAD_7, "7");
        NUMPAD_8 = new InputObject(Keyboard.NUMPAD_8, "8");
        NUMPAD_9 = new InputObject(Keyboard.NUMPAD_9, "9");
        NUMPAD_ADD = new InputObject(Keyboard.NUMPAD_ADD, "NUMPAD_ADD");
        NUMPAD_DECIMAL = new InputObject(Keyboard.NUMPAD_DECIMAL, "NUMPAD_DECIMAL");
        NUMPAD_DIVIDE = new InputObject(Keyboard.NUMPAD_DIVIDE, "NUMPAD_DIVIDE");
        NUMPAD_ENTER = new InputObject(Keyboard.NUMPAD_ENTER, "NUMPAD_ENTER");
        NUMPAD_MULTIPLY = new InputObject(Keyboard.NUMPAD_MULTIPLY, "NUMPAD_MULTIPLY");
        NUMPAD_SUBTRACT = new InputObject(Keyboard.NUMPAD_SUBTRACT, "NUMPAD_SUBTRACT");

        F1 = new InputObject(Keyboard.F1, "F1");
        F2 = new InputObject(Keyboard.F2, "F2");
        F3 = new InputObject(Keyboard.F3, "F3");
        F4 = new InputObject(Keyboard.F4, "F4");
        F5 = new InputObject(Keyboard.F5, "F5");
        F6 = new InputObject(Keyboard.F6, "F6");
        F7 = new InputObject(Keyboard.F7, "F7");
        F8 = new InputObject(Keyboard.F8, "F8");
        F9 = new InputObject(Keyboard.F9, "F9");
        F10 = new InputObject(Keyboard.F10, "F10");
        F11 = new InputObject(Keyboard.F11, "F11");
        F12 = new InputObject(Keyboard.F12, "F12");
        F13 = new InputObject(Keyboard.F13, "F13");
        F14 = new InputObject(Keyboard.F14, "F14");
        F15 = new InputObject(Keyboard.F15, "F15");

        UP = new InputObject(Keyboard.UP, "UP");
        DOWN = new InputObject(Keyboard.DOWN, "DOWN");
        LEFT = new InputObject(Keyboard.LEFT, "LEFT");
        RIGHT = new InputObject(Keyboard.RIGHT, "RIGHT");

        HOME = new InputObject(Keyboard.HOME, "HOME");
        END = new InputObject(Keyboard.END, "END");
        PAGE_UP = new InputObject(Keyboard.PAGE_UP, "PAGE_UP");
        PAGE_DOWN = new InputObject(Keyboard.PAGE_DOWN, "PAGE_DOWN");
        INSERT = new InputObject(Keyboard.INSERT, "INSERT");
        DELETE = new InputObject(Keyboard.DELETE, "DELETE");
        BACKSPACE = new InputObject(Keyboard.BACKSPACE, "BACKSPACE");
        ENTER = new InputObject(Keyboard.ENTER, "ENTER");
        ESCAPE = new InputObject(Keyboard.ESCAPE, "ESCAPE");
        SPACE = new InputObject(Keyboard.SPACE, "SPACE");
        TAB = new InputObject(Keyboard.TAB, "TAB");

        SHIFT = new InputObject(Keyboard.SHIFT, "SHIFT");
        CONTROL = new InputObject(Keyboard.CONTROL, "CONTROL");
        ALTERNATE = new InputObject(Keyboard.ALTERNATE, "ALTERNATE");
        #if mac COMMAND = new InputObject(Keyboard.COMMAND, "COMMAND"); #end //* Macintosh only.
        CAPS_LOCK = new InputObject(Keyboard.CAPS_LOCK, "CAPS_LOCK");
        
        BACKQUOTE = new InputObject(Keyboard.BACKQUOTE, "BACKQUOTE");
        BACKSLASH = new InputObject(Keyboard.BACKSLASH, "BACKSLASH");
        COMMA = new InputObject(Keyboard.COMMA, "COMMA");
        EQUAL = new InputObject(Keyboard.EQUAL, "EQUAL");
        LEFTBRACKET = new InputObject(Keyboard.LEFTBRACKET, "LEFTBRACKET");
        MINUS = new InputObject(Keyboard.MINUS, "MINUS");
        PERIOD = new InputObject(Keyboard.PERIOD, "PERIOD");
        QUOTE = new InputObject(Keyboard.QUOTE, "QUOTE");
        RIGHTBRACKET = new InputObject(Keyboard.RIGHTBRACKET, "RIGHTBRACKET");
        SEMICOLON = new InputObject(Keyboard.SEMICOLON, "SEMICOLON");
        SLASH = new InputObject(Keyboard.SLASH, "SLASH");
    }

    /**
     * Disables Input.
     * @since 0.10.1
    **/
    public static function destroy() {
        for(key in activeKeys) key.destroy();
    }

    /**
     * Returns all currently pressed keys
     * @return keyboard indexes of all pressed keys.
     * @since 0.10.1
    **/
    public static function getPressedKeys():Array<Int> return [for(key in activeKeys) (key.pressed||key.justPressed)?key.key:continue];

    public static function getFromCode(a:Int):InputObject {
        for(key in activeKeys) {
            if(key.key == a) return key;
            else continue;
        }

        return null;
    }
}

final class InputObject extends HBasic{
    public var pressed:Bool = false;
    public var justPressed:Bool = false;
    public var released:Bool = false;
    public var justReleased:Bool = false;
    public var key:Int = -1;
    public var label:String = '<!>';
    private final TIME:Float = 0.15;

    private var onDownTimer:HTimer;
    private var onReleaseTimer:HTimer;
    private var keyIsDown:Bool=false;
    private function onDown(a:KeyboardEvent) {
        if(a.keyCode!=key || keyIsDown) return;
        keyIsDown = true;
        justPressed = true;
        pressed = false;
        justReleased = false;
        released = false;
        if(onReleaseTimer!=null && onReleaseTimer._timer.running) onReleaseTimer.stop(); //cancel the timer.
        if(onDownTimer==null){
            onDownTimer = new HTimer();
            onDownTimer.run(TIME, (_:HTimer)->{
                justPressed = false;
                pressed = true;
            });
        }else onDownTimer.reset();
    };
    private function onRelease(a:KeyboardEvent) {
        if(a.keyCode!=key) return;
        keyIsDown = false;
        if(onDownTimer!=null && onDownTimer._timer.running) onDownTimer.stop(); //cancel the timer.
        justPressed = false;
        justReleased = true;
        pressed = false;
        released = false;
        if(onReleaseTimer==null){
            onReleaseTimer = new HTimer();
            onReleaseTimer.run(TIME, (_:HTimer)->{
                justReleased = false;
                released = true;
            });
        }else onReleaseTimer.reset();
    };
    public function new(k:Int, l:String) {
        super(0, 0);
        key = k;
        label = l;
        Main.instance.addChild(this); //THIS, is stupid.
        @:privateAccess InputUtil.activeKeys.push(this);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onDown);
        stage.addEventListener(KeyboardEvent.KEY_UP, onRelease);
    }

    override public function destroy() {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onDown);
        stage.removeEventListener(KeyboardEvent.KEY_UP, onRelease);

        @:privateAccess InputUtil.activeKeys.remove(this);
        Main.instance.removeChild(this);
        super.destroy();
    }
}