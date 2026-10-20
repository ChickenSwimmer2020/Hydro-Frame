package backend.palette;

class HPALPaletteParser {
    public static function parse(path:String):HPalette {
        if(FileSystem.exists(path)) {
            var toReturn:Null<HPalette> = null;
            var data:String = File.getContent(path);
            if(data.startsWith("JASC-PAL")) {
                var toColor:Array<HColor> = [];
                for(i=>line in data.split('\n')) {
                    switch(i) {
                        case 0: trace('INFO: Loading a JASC-PAL Palette file...');
                        case 1: //donothing
                        case 2: trace('INFO: Creating palette with $line entries...');
                        default: 
                            var parts:Array<Int> = [for(a in line.trim().split(" ")) Std.parseInt(a)]; //get all four parts
                            var color:Null<HColor> = null;
                            if(parts.length==3) { //RGB color
                                color = new HColor(((parts[0]<<16)|(parts[1]<<8)|parts[2]));
                            }else if(parts.length==4) { //RGBA color
                                color = new HColor(((parts[3]<<24)|(parts[0]<<16)|(parts[1]<<8)|parts[2]));
                            }
                            toColor.push(color);
                    }
                    
                }
                toReturn = new HPalette(toColor);
            }else{ //its binary! MEANING RIFF. AUGHHHHH
                //okay... here we go
                var output:Array<HColor> = [];
                trace("INFO: Attempting to load a RIFF palette file...");
                data=""; //for memory reasons i think or something like that.

                final bytes:Bytes = File.getBytes(path);
                if(bytes.getString(0, 4)!="RIFF" || bytes.getString(8, 4)!="PAL ") {
                    trace('ERROR: $path is not a palette!');
                    return null;
                }
                var pos:Int = 12; //end of header
                while(pos+8<=bytes.length) {
                    var name = bytes.getString(pos, 4);
                    var size = bytes.getInt32(pos+4);
                    if(size<0) break; //catch for coruptted data.
                    var dataStart = pos+8;
                    if(name=="data") {
                        for(i in 0...bytes.getUInt16(dataStart+2)) { //do i understand how this math works? not in the slighest.
                            final o = dataStart+4+i*4;
                            output.push(((0xFF<<24)|(bytes.get(o)<<16)|(bytes.get(o+1)<<8)|(bytes.get(o+2))));
                        }
                        break;
                    }
                    pos = dataStart+size+(size&1);
                }
                toReturn = new HPalette(output);
            }
            return toReturn;
        }else return null;
    }
}