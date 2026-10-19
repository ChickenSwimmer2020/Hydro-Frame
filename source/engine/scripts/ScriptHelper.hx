package engine.scripts;

import hxscript.Environment;
import hxscript.Module;
import hxscript.types.ScriptedClass;

class ScriptHelper {
	/**
	 * returns a list of every script-declared class in the world, by name, in a stable order.
	 *
	 * @return `Array<ScriptedClass>` The loaded scripted classes.
	 * @since 0.10.0
	 */
	public static function getClasses(world:Environment):Array<ScriptedClass> {
		var found:Map<String, ScriptedClass> = [];
		for (module in world.modules)
			for (name => type in module.types)
				if (type is ScriptedClass)
					found.set(name, cast type);

		var names:Array<String> = [for (name in found.keys()) name];
		names.sort(Reflect.compare);
		return [for (name in names) found.get(name)];
	}

	/**
	 * returns a list of every script-declared class in this `Module`, by name, in a stable order.
	 *
	 * @return `Array<ScriptedClass>` The loaded scripted classes.
	 * @since 0.10.0
	 */
	public static function getClassesFrom(module:Module):Array<ScriptedClass> {
		var found:Map<String, ScriptedClass> = [];
		for (name => type in module.types)
			if (type is ScriptedClass)
				found.set(name, cast type);

		var names:Array<String> = [for (name in found.keys()) name];
		names.sort(Reflect.compare);
		return [for (name in names) found.get(name)];
	}

	/**
	 * Returns whether a scripted class descends from a native one.
	 *
	 * @param cls The scripted class.
	 * @param base The native base to look for.
	 * @return `Bool` True if `base` is somewhere up the chain.
	 * @since 0.10.0
	 */
	public static function nativeDescendsFrom(cls:ScriptedClass, base:Class<Dynamic>):Bool {
		var native:Dynamic = cls.instanceClass;
		while (native != null) {
			if (native == base)
				return true;
			native = Type.getSuperClass(native);
		}
		return false;
	}

	/**
	 * Returns whether a scripted class descends from a scripted one.
	 *
	 * @param cls The scripted class.
	 * @param base The scripted base to look for.
	 * @return `Bool` True if `base` is somewhere up the chain.
	 * @since 0.10.0
	 */
	public static function scriptedDescendsFrom(cls:ScriptedClass, base:ScriptedClass):Bool {
		var scripted:Dynamic = cls.extending;
		while (scripted != null) {
			if (scripted == base)
				return true;
			scripted = scripted.extending;
		}
		return false;
	}

	/**
	 * Returns whether a scripted class descends from another class, either native or scripted.
	 *
	 * @param cls The scripted class.
	 * @param base The base to look for. Either `Class` or `ScriptedClass`. If
	 * `base` is `Class`, `nativeDescendsFrom` is called. If `base` is `ScriptedClass`,
	 * `scriptedDescendsFrom` is called. Otherwise `false` is returned.
	 * @return `Bool` True if `base` is somewhere up the chain.
	 * @since 0.10.0
	 */
	public static function descendsFrom(cls:ScriptedClass, base:Dynamic):Bool {
		if (base is Class)
			return nativeDescendsFrom(cls, (cast base : Class<Dynamic>));
		if (base is ScriptedClass)
			return scriptedDescendsFrom(cls, (cast base : ScriptedClass));
		return false;
	}

	/**
	 * Wraps a `ScriptedClass` in a `ScriptedClassProxy`.
	 * 
	 * @param cls The `ScriptedClass` to proxy.
	 * @return `ScriptedClassProxy` The wrapped `ScriptedClass`.
	 * @since 0.10.0
	 */
	public static function proxy(cls:ScriptedClass):ScriptedClassProxy
		return new ScriptedClassProxy(cls);
}
