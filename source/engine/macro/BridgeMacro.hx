package engine.macro;

#if macro
import backend.debug.logging.Logger;
import haxe.Exception;
import haxe.PosInfos;
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.FileSystem;

using StringTools;

/**
 * Taken and modified from [here.](https://github.com/MeguminBOT/hxscript/blob/main/examples/battle/macros/BridgeMacro.hx)
 * 
 * The other way to make classes scriptable: generate the bridges instead of writing them.
 *
 * `bridges/ScriptedEntity.hx` is the manual form, and for one or two bases it is the clearer one.
 * Past that it is a folder of empty classes that all say the same thing, and every one of them has
 * to be kept in the build by hand. This generates the same classes from a list, and emits a
 * `Bridges.all` array that references them, which is what keeps them from being dropped: nothing
 * else refers to a bridge, since they are only ever built reflectively.
 */
class BridgeMacro {
	static inline var PACK:String = 'bridges';

	/** Scans a package for classes. */
	static function scan(pack:String):Array<String> {
		var out:Array<String> = [];
		var rel:String = pack.split('.').join('/');

		for (cp in Context.getClassPath()) {
			var dir:String = Path.join([cp, rel]);
			if (!FileSystem.exists(dir) || !FileSystem.isDirectory(dir))
				continue;

			for (f in FileSystem.readDirectory(dir)) {
				var full:String = Path.join([dir, f]);

				if (FileSystem.isDirectory(full))
					out = out.concat(scan(pack + '.' + f));
				else if (f.endsWith('.hx'))
					out.push(pack + '.' + f.substr(0, f.length - 3));
			}
		}
		return out;
	}

	/** Classes that couldn't be resolved, with the reason. */
	static var failures:Array<String> = [];

	/** Checks if a class is bridgeable. */
	static function bridgeable(name:String):Bool {
		if (name.startsWith('backend.macro') || name.startsWith('engine.macro'))
			return false;

		var type:Null<Type> = null;
		try {
			type = Context.getType(name);
		} catch (e:Exception) {
			report(name, e.message);
			return false;
		}

		return switch type {
			case TInst(c, _): var ct = c.get(); !ct.isInterface && !ct.isExtern && !ct.isFinal && ct.params.length == 0;
			default:
				false;
		}
	}

	/** Reports a failure. */
	static function report(name:String, reason:String)
		failures.push('Type resolution failed for "\x1b[38;5;79msource/${name.replace('.', '/')}.hx\x1b[0m", because \x1b[38;5;187m$reason\x1b[0m.');

	/** Defines one bridge class per entry, plus the array that keeps them alive. */
	public static function generate() {
		var BASES:Array<String> = [for (n in scan('backend').concat(scan('engine'))) if (bridgeable(n))n];
		var pos:Position = Context.currentPos();
		var pack:Array<String> = PACK.split('.');
		var refs:Array<Expr> = [];

		for (base in BASES) {
			var parts:Array<String> = base.split('.');
			var superPath:TypePath = {name: parts.pop(), pack: parts};
			var name:String = 'Scripted' + superPath.name;

			// A module of its own per bridge: defined as a sub-type of another module, a bridge could
			// only ever be named through that module.
			Context.defineModule('$PACK.$name', [
				{
					pack: pack,
					name: name,
					pos: pos,
					meta: [{name: ':keep', pos: pos}],
					kind: TDClass(superPath, [{pack: ['hxscript'], name: 'IScripted'}], false, false, false),
					fields: []
				}
			]);

			refs.push(macro $p{pack.concat([name])});
		}

		Context.defineModule('$PACK.Bridges', [
			{
				pack: pack,
				name: 'Bridges',
				pos: pos,
				meta: [{name: ':keep', pos: pos}],
				kind: TDClass(null, [], false, false, false),
				fields: [
					{
						name: 'all',
						access: [APublic, AStatic],
						pos: pos,
						doc: 'Every generated bridge. Referenced so the classes survive dead-code elimination.',
						kind: FVar(macro :Array<Class<Dynamic>>, {
							expr: EArrayDecl(refs),
							pos: pos
						})
					}
				]
			}
		]);

		if (failures.length > 0)
			Logger.log('WARNING:${failures.length} type resolution failures:\n    ... ${failures.join('\n    ... ')}\nThese types won\'t be bridged, and cannot be extended by scripts.\n');
	}
}
#end
