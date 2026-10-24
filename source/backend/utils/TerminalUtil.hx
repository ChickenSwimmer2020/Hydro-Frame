package backend.utils;

class TerminalUtil {
    /**
     * Escape character, makes this all possible. very important.
     * @since 0.10.1
    **/
    public static final escape:String = "\x1b";
    /**
     * Resets the console text colors, DO NOT FORGET TO USE THIS WHEN USING `setColor`!!!!
     * @since 0.10.1
    **/
    public static final reset:String = '$escape[0m';
    /**
     * Change the current color of text rendering in the console.
     * @since 0.10.1
    **/
    public static function setColor(fg:#if macro Int#else HColor#end, ?bg:#if macro Int#else HColor#end):String {
        var s:String = '$escape[38;2;${(fg>>16)&0xFF};${(fg>>8)&0xFF};${fg&0xFF}m';
        if(bg!=null) s+='$escape[48;2;${(bg>>16)&0xFF};${(bg>>8)&0xFF};${bg&0xFF}m';
        return s;
    }

    /**
     * Clear the console output, hopefully.
     * @since 0.10.1
    **/
    public static function clearConsole() Sys.println("\x1b[3J\x1b[2J\x1b[H");
}