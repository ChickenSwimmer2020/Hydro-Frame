package engine.macro;

import sys.io.File;
#if macro
import backend.debug.logging.Logger;
import haxe.Serializer;
import haxe.Unserializer;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;
using haxe.macro.TypeTools;

/**
 * A merged/modified version of [this](https://github.com/MeguminBOT/hxscript/blob/main/examples/battle/macros/BridgeMacro.hx)
 * and [this.](https://github.com/MeguminBOT/hxscript/blob/main/examples/battle/macros/AbstractsMacro.hx)
 */
class BridgeMacro {
	/** The list of generated bridges. For use in the `typedScripted` meta in `hxscript.macro.Scripted`. */
	static var bridgePaths:Array<String> = [];

	/** The name of the generated package. */
	static var PACK:String = 'bridges';

	/** Packages to generate bridges for. */
	static final PACKAGES:Array<String> = ['backend', 'engine'];

	/** Abstracts the generator cannot wrap, by fully-qualified name. */
	static final EXCLUDE:Array<String> = ['engine.scripts.ScriptedClassProxy', 'engine.scripts.ScriptedInstanceProxy'];

	/** Classes that couldn't be resolved, with the reason. */
	static var failures:Array<String> = [];

	/** Reports a failure. */
	static function report(name:String, reason:String)
		failures.push('Bridge failure for "\x1b[38;5;79m$name\x1b[0m", because \x1b[38;5;187m$reason\x1b[0m.');

	/** Defines one bridge class per entry, plus the array that keeps them alive. */
	public static function generate() {
		if (Context.defined("display") || Compiler.getConfiguration().args.indexOf("--no-output") != -1)
			return;
		var all = 0;
		Context.onAfterTyping((types) -> {
			for (type in types) {
				switch (type) {
					case TClassDecl(c):
						var cData = c.get();
						for (PACK in PACKAGES) {
							if (cData.pack.join('.').startsWith(PACK)) {
								var finalModule = cData.module;
								var finalName = cData.name;
								var finalTypeName = finalModule + (finalModule.endsWith(finalName) ? '' : '.' + finalName);

								if (finalTypeName.startsWith('backend.macro') || finalTypeName.startsWith('engine.macro'))
									break;

								if (finalTypeName.endsWith('_Impl_'))
									break;

								if (cData.isAbstract)
									break;

								all++;

								if (cData.isInterface) {
									report(finalTypeName, 'it\'s an interface');
									break;
								}

								if (cData.isExtern) {
									report(finalTypeName, 'it\'s an extern');
									break;
								}

								if (cData.isFinal) {
									report(finalTypeName, 'it\'s declared as final');
									break;
								}

								if (cData.isPrivate) {
									report(finalTypeName, 'it\'s declared as private');
									break;
								}

								if (cData.params.length > 0) {
									report(finalTypeName, 'it has type parameters');
									break;
								}

								processBase({module: finalModule, name: finalName});
								break;
							}
						}
					case TAbstract(a):
						var aData = a.get();
						for (PACK in PACKAGES) {
							if (aData.pack.join('.').startsWith(PACK)) {
								var finalTypeName = aData.module + (aData.module.endsWith(aData.name) ? '' : '.' + aData.name);
								all++;
								if (EXCLUDE.contains(finalTypeName)) {
									report(finalTypeName, 'it\'s an excluded abstract');
									break;
								}
								Compiler.addMetadata('@:build(hxscript.macro.Abstract.build())', aData.module + '.' + aData.name);
								break;
							}
						}
					default:
				}
			}

			// We need this to make them actually scriptable, because we may not be before hxscript.
			// Unfortunately, this means we overwrite hxscripts list, but oh well. It causes no issues right now.
			var self = TypeTools.getClass(Context.getType('hxscript.macro.Scripted'));

			// First, we start from whatever hxscript already recorded.
			var registered:Array<String> = [];
			for (entry in self.meta.extract('typedScripted')) {
				if (entry.params == null || entry.params.length == 0)
					continue;
				switch (entry.params[0].expr) {
					case EConst(CString(s, _)):
						var existing:Array<String> = Unserializer.run(s);
						for (path in existing)
							if (!registered.contains(path))
								registered.push(path);
					default:
				}
			}

			// Then we add the bridges, plus anything the scan finds that isn't already there.
			for (path in bridgePaths)
				if (!registered.contains(path))
					registered.push(path);

			for (type in types) {
				switch (type) {
					case TClassDecl(r):
						var c = r.get();
						if (c.interfaces.length > 0 && c.interfaces[0].t.get().name == 'IScriptedInstance') {
							var path = c.pack.concat([c.name]).join('.');
							if (!registered.contains(path))
								registered.push(path);
						}
					default:
				}
			}

			self.meta.remove('typedScripted');
			self.meta.add('typedScripted', [macro $v{Serializer.run(registered)}], self.pos);
		});

		Context.onAfterGenerate(() -> {
			var pos = Context.currentPos();
			Context.defineModule('$PACK.Bridges', [
				{
					pack: PACK.split('.'),
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
				Logger.log('WARNING:${failures.length}${(failures.length == 1 ? '' : '/$all')} bridge${(failures.length == 1 ? '' : 's')} failed:\n    ... ${failures.join('\n    ... ')}\n${(failures.length == 1 ? 'This type' : 'These types')} won\'t be bridged. Any classes in this list won\'t be extendable by scripts, and any abstracts in this list won\'t be usable by scripts.\n');
		});
	}

	static var refs:Array<Expr> = [];

	static function processBase(base:{module:String, name:String}) {
		var pos:Position = Context.currentPos();
		var pack:Array<String> = PACK.split('.');

		var moduleParts = base.module.split('.');
		var superPath:TypePath = {
			name: moduleParts.pop(), // the module's own name
			pack: moduleParts,
			sub: base.module.endsWith(base.name) ? null : base.name // sub-type if different
		};
		var name:String = 'Scripted' + base.name;

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
}
#end
