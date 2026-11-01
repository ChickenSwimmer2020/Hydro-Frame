package engine.macro;

import haxe.macro.*;
import haxe.macro.Type.ClassType;

class MacroUtil {
	public static function extendsHaxeUI(cls:ClassType):Bool {
		if (cls.superClass == null)
			return false;
		var superCls = cls.superClass.t.get();
		if (superCls.pack.toString().startsWith('haxe.ui'))
			return true;
		return extendsHaxeUI(superCls);
	}
}
