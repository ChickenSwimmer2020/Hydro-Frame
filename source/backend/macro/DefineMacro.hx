package backend.macro;

class DefineMacro {
	public static macro function defineValue(define:String, ?ifNull:String = '') {
		return macro $v{haxe.macro.Context.definedValue(define) ?? ifNull};
	}
}
