package engine.scripts;

import hxscript.types.ScriptedClass;

/**
 * A proxy class for `ScriptedClass`.
 * Makes it easier to use scripted classes. You can easily access any static fields,
 * and make new instances via `proxy.__new()`.
 * Wrap a `ScriptedClass` in a `ScriptedClassProxy` via `ScriptHelper.proxy()`.
 * 
 * @see `ScriptHelper`
 * @since 0.10.0
 */
abstract ScriptedClassProxy(ScriptedClassProxyImpl) {
	@:allow(engine.scripts.ScriptHelper)
	private function new(cls:ScriptedClass) {
		if (cls == null)
			throw 'Cannot create proxy for a null ScriptedClass.';
		for (shadowed in ['__class', '__get', '__set', '__new'])
			if (cls.reflectHasField(shadowed))
				trace('Warning. Class ${cls.name} has a field named "$shadowed". This field will be shadowed.');
		this = new ScriptedClassProxyImpl(cls);
	}

	@:op(a.b)
	public function __get(name:String):Dynamic {
		if (name == '__class')
			return this.__class;
		var cls:ScriptedClass = this.__class;
		if (!cls.reflectHasField(name))
			throw 'Failed to get field $name on class ${cls.name}: Field does not exist.';
		return cls.reflectGetField(name);
	}

	@:op(a.b)
	public function __set(name:String, value:Dynamic):Dynamic {
		if (name == '__class')
			@:privateAccess
			throw 'Failed to set field $name on instance of ScriptedClassProxy: Forbidden.';
		var cls:ScriptedClass = this.__class;
		if (!cls.reflectHasField(name))
			throw 'Failed to set field $name on class ${cls.name}: Field does not exist.';
		if (Reflect.isFunction(cls.reflectGetField(name)))
			throw 'Failed to set field $name on instance of ${cls.name}: Field is a function.';
		return cls.reflectSetField(name, value);
	}

	/**
	 * Creates an instance of this `ScriptedClass`, wrapped in a `ScriptedInstanceProxy`.
	 * 
	 * ---
	 * 
	 * You can use it like this:
	 * 
	 * ```haxe
	 * var enemy = proxy.__new(arg1, arg2);
	 * ```
	 * 
	 * ---
	 * 
	 * @param args The arguments to pass to the constructor.
	 * @return `ScriptedInstanceProxy` The instance of this `ScriptedClass`.
	 * @since 0.10.0
	 */
	public function __new(...args:Dynamic):ScriptedInstanceProxy
		return new ScriptedInstanceProxy(this.__class.typeCreateInstance(args.toArray() ?? []));
}

private class ScriptedClassProxyImpl {
	public var __class:ScriptedClass;

	public function new(__class:ScriptedClass)
		this.__class = __class;
}
