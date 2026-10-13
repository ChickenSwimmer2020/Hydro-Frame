package backend.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

@:dox(hide) @:noCompletion class SafeBuild {
	/**
	 * List of class names to ignore when running `build()`
	 * @since 0.8.8
	 */
	static var classesToIgnore:Array<String> = ['Safe', 'MethodUtil'];

	@:dox(hide) @:noCompletion public static function build():Array<Field> {
		var local = Context.getLocalClass();
		if (local == null)
			return null;

		var cls = local.get();
		if (classesToIgnore.contains(cls.name))
			return null;

		switch (cls.kind) {
			case KAbstractImpl(_):
				return null;
			default:
		}

		var fields = Context.getBuildFields();

		for (f in fields) {
			switch (f.kind) {
				case FFun(fn):
					if (fn.expr == null || fn.ret == null || f.name == 'new')
						continue;
					if (f.access.contains(AInline) || f.access.contains(AMacro))
						continue;
					if (f.meta != null && Lambda.exists(f.meta, m -> m.name == ':unwrapSafe'))
						continue;
					if (usesSuper(fn.expr))
						continue;

					var label = cls.name + '.' + f.name;
					var body = fn.expr;
					var ret = fn.ret;

					if (isVoid(ret))
						fn.expr = macro backend.utils.Safe.run(function():Void$body, $v{label});
					else {
						var fallback = fallbackFor(ret);
						fn.expr = macro return backend.utils.Safe.runR(function():$ret$body, $fallback, $v{label}); // line 38
					}
				default:
			}
		}
		return fields;
	}

	private static function isVoid(t:ComplexType):Bool
		return switch (t) {
			case TPath({name: 'Void', pack: []}): true;
			default: false;
		}

	private static function fallbackFor(ct:ComplexType):Expr {
		var t:Null<Type> = try Context.resolveType(ct, Context.currentPos()) catch (_:Dynamic) null;
		return zero(t, 0);
	}

	private static function zero(t:Null<Type>, depth:Int):Expr {
		if (t == null || depth > 8)
			return macro null;
		return switch (Context.follow(t)) {
			case TAbstract(ref, _):
				var a = ref.get();
				switch (a.name) {
					case 'Int' | 'UInt': macro 0;
					case 'Float': macro 0.0;
					case 'Bool': macro false;
					case 'Null': macro null;
					default:
						var inner = zero(a.type, depth + 1);
						macro cast $inner;
				}
			default: macro null;
		}
	}

	static function usesSuper(e:Expr):Bool {
		var found = false;
		function scan(e:Expr):Void {
			if (found || e == null)
				return;
			switch (e.expr) {
				case EConst(CIdent('super')):
					found = true;
				default:
					ExprTools.iter(e, scan);
			}
		}
		scan(e);
		return found;
	}
}
#end
