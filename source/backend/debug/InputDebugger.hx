package backend.debug;

import backend.utils.InputUtil.InputObject;

class InputDebugger extends HState {
    public function new() {
        super();
        Main.addKeyPressed("InputDebuggerExit", Keyboard.ESCAPE, true, (c:KeyboardEvent)->{
            this.destroy();
            Main.StateSystem.switchState(InitState);
        });


        @:privateAccess for(i in 0...InputUtil.activeKeys.length) { //no command key on windows.
            var t:KeyTester = new KeyTester(5+(105*(i%12)),5+(30*(Math.floor(i/12))), InputUtil.activeKeys[i].key);
            add(t);

            var label = new HText(5+(105*(i%12)),5+(30*(Math.floor(i/12))), 100, InputUtil.activeKeys[i].label, 12);
            add(label);
        }
    }
}


private class KeyTester extends HSprite {
    var key:Int = -1;
    public function new(x:Float, y:Float, k:Int) {
        super(x, y);

        makeGraphic(100, 25, HColor.MAGENTA);

        key = k;
    }

    public function state(a:String) {
        switch(a) {
            case "justPressed": color!=HColor.LIME?color=HColor.LIME:null;
            case "pressed": color!=HColor.LOADINGIND_MAINCOLOR?color=HColor.LOADINGIND_MAINCOLOR:null;
            case "default": color!=HColor.RED?color=HColor.RED:null;
            default: //donothing
        }
    }

    override public function onEnterFrame(a:Event){
        super.onEnterFrame(a);

        if(InputUtil.getPressedKeys().contains(key)){
            var target:InputObject = InputUtil.getFromCode(key);
            if(target.pressed) state("pressed");
            else if(target.justPressed) state("justPressed");
        }else state("default");
    }
}