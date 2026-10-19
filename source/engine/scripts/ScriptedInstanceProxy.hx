package engine.scripts;

import hxscript.types.IScriptedInstance;

/**
 * A proxy class for `IScriptedInstance`.
 * Makes it easier to use scripted instances.
 * Wrap a `IScriptedInstance` in a `ScriptedInstanceProxy` via `ScriptClassProxy.__new()`.
 * 
 * @see `ScriptClassProxy`
 * @since 0.10.0
 */
abstract ScriptedInstanceProxy(ScriptedInstanceProxyImpl) {
	@:allow(engine.scripts.ScriptedClassProxy)
	private function new(instance:IScriptedInstance) {
		if (instance == null)
			throw 'Cannot create proxy for a null IScriptedInstance.';
		for (shadowed in ['__instance', '__get', '__set'])
			if (instance.reflectHasField(shadowed))
				@:privateAccess
				trace('Warning. Instance of ${instance.__base.name} has a field named "$shadowed". This field will be shadowed.');
		this = new ScriptedInstanceProxyImpl(instance);
	}

	@:op(a.b)
	public function __get(name:String):Dynamic {
		if (name == '__instance')
			return this.__instance;
		var instance:IScriptedInstance = this.__instance;
		if (!instance.reflectHasField(name))
			@:privateAccess
			throw 'Failed to get field $name on instance of ${instance.__base.name}: Field does not exist.';
		return instance.reflectGetField(name);
	}

	@:op(a.b)
	public function __set(name:String, value:Dynamic):Dynamic {
		if (name == '__instance')
			@:privateAccess
			throw 'Failed to set field $name on instance of ScriptedInstanceProxy: Forbidden.';
		var instance:IScriptedInstance = this.__instance;
		if (!instance.reflectHasField(name))
			@:privateAccess
			throw 'Failed to set field $name on instance of ${instance.__base.name}: Field does not exist.';
		if (Reflect.isFunction(instance.reflectGetField(name)))
			@:privateAccess
			throw 'Failed to set field $name on instance of ${instance.__base.name}: Field is a function.';
		return instance.reflectSetField(name, value);
	}
}

private class ScriptedInstanceProxyImpl {
	public var __instance:IScriptedInstance;

	public function new(__instance:IScriptedInstance)
		this.__instance = __instance;
}
