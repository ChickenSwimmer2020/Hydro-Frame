package backend.palette;

class HPalette { //TODO: expand on this.
    public var colors:Array<HColor> = [];
    public var names:Array<OneOfTwo<Null<Any>, String>> = []; //can hold null or string
    public var desc:Null<String> = null; //only really set with GPL so far.
    
    public function new(c:Array<HColor>) {
        colors = c;
    }
    public function setExtras(names:Array<OneOfTwo<Null<Any>, String>>, description:String):HPalette {
        this.names = names;
        this.desc = description;
        return this;
    }








    //conversion functions
    public static function fromASE():HPalette return null; //! NOT IMPLEMENTED
    public static function fromACO():HPalette return null; //! NOT IMPLEMENTED
    public static function fromFLC():HPalette return null; //! NOT IMPLEMENTED
    public static function fromFLI():HPalette return null; //! NOT IMPLEMENTED
    public static function fromPCX():HPalette return null; //! NOT IMPLEMENTED
    public static function fromPCC():HPalette return null; //! NOT IMPLEMENTED
    public static function fromQOI():HPalette return null; //! NOT IMPLEMENTED
    /**
     * Return an HPalette from a .act Palette file
     * @since 0.10.1
    **/
    public static function fromACT(path:String):HPalette{
        if(FileSystem.exists(path)) {
            var bytes:Bytes = File.getBytes(path);
            if(bytes.length!=768&&bytes.length!=772) {
                trace('ERROR: $path is not a valid .act palette!');
                return null;
            }

            var count:Int = 256;
            var transparent:Int = -1;
            if(bytes.length==772) {
                count = (bytes.get(768)<<8)|bytes.get(769);
                transparent = (bytes.get(770) << 8) | bytes.get(771);
                if (count > 256) count = 256;
            }
            var colors:Array<HColor> = [];
            for (i in 0...count) {
                var o = i * 3;
                var a = (i == transparent) ? 0x00 : 0xFF;
                colors.push((a << 24) | (bytes.get(o) << 16) | (bytes.get(o + 1) << 8) | bytes.get(o + 2));
            }
            return new HPalette(colors);
        }else {
            trace('ERROR: Couldnt find a .act palette at $path!');
            return null;
        }
        return null;
    }
    public static function fromCOL():HPalette return null; //! NOT IMPLEMENTED
    /**
     * Read a .GPL and return a Hydro-Frame Palette
     * @since 0.10.1
    **/
    public static function fromGPL(path:String):HPalette {
        if(FileSystem.exists(path)) {
            trace('INFO: Trying to parse a .GPL palette file...');
            var data:String = File.getContent(path);
            if(data.startsWith("GIMP Palette")) {
                var toDesc:String = "";
                var colors:Array<HColor> = [];
                var names:Array<OneOfTwo<Null<Any>, String>> = [];
                final lineReg:EReg = ~/(\d+)\s+(\d+)\s+(\d+)(?:\s+(.*))?/; //UGH I HATE THESE STUPID THINGS.
                for(i=>line in data.split("\n")) {
                    switch(i) {
                        case 0: //donothing, contains GIMP Palette
                        default:
                            if(line.startsWith("Name:")||line.startsWith("Columns:")) continue; //optional parts of .gpl palettes we dont need.
                            if(line.startsWith("#")) toDesc += line.substr(1).trim() + "\n";

                            if(lineReg.match(line)) {
                                var r = Std.parseInt(lineReg.matched(1));
                                var g = Std.parseInt(lineReg.matched(2));
                                var b = Std.parseInt(lineReg.matched(3));
                                var name = lineReg.matched(4);

                                colors.push((0xFF << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF));
                                names.push(name);
                            }
                    }
                }

                return new HPalette(colors).setExtras(names, toDesc);
            }else{
                trace("ERROR: palette is not a gimp palette!");
                return null;
            }
        }else {
            trace('ERROR: Couldnt find a .gpl palette at $path!');
            return null;
        }
        return null;
    }
    /**
     * Return a Hydro-Frame Palette file from a .HEX Palette file
     * @since 0.10.1
    **/
    public static function fromHEX(path:String):HPalette{
        if(FileSystem.exists(path)) {
            var colors:Array<HColor> = [];
            var data:String = File.getContent(path);
            //woah, .hex is really simple!!
            for(line in data.split("\n")) {
                line = line.trim().replace("#", "");
                if(line==""||~/[0-9A-Fa-f]/.match(line)) continue;
                if(line.length==6){ //no alpha :/
                    colors.push(0xFF000000|Std.parseInt('0x$line'));
                }else if(line.length==8){ //yayyy alpha!
                    colors.push(((Std.parseInt('0x$line')&0xFF)<<24)|((Std.parseInt('0x$line')>>>8)&0xFFFFFF));
                }
            }
            return new HPalette(colors);
        }else {
            trace('ERROR: Couldnt find a .hex palette at $path!');
            return null;
        }
        return null;
    }
    /**
     * Read a JASC-PAL/RIFF Palette file and return a Hydro-Frame Palette
     * @since 0.10.1
    **/
    public static function fromPAL(path:String):HPalette return HPALPaletteParser.parse(path);
}