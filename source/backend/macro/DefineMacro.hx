package backend.macro;

/**
 * A macro for helping with defines
 * @since 0.8.7
 */
class DefineMacro {
	/**
	 * Returns the value of the define provided
	 * @param define define you want to get the value of
	 * @param ifNull edge case where the define value is null so you can have a default message
	 * @since 0.8.7
	 */
	public static macro function defineValue(define:String, ?ifNull:String = '') {
		return macro $v{haxe.macro.Context.definedValue(define) ?? ifNull};
	}

	/**
	 * Returns if the provided define is defined
	 * @param define provided define
	 * @since 0.8.8
	 */
	public static macro function defined(define:String) {
		return macro $v{haxe.macro.Context.defined(define)};
	}
}
