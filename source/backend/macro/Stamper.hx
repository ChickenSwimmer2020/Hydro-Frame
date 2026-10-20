package backend.macro;

#if macro
import haxe.macro.Compiler;
import haxe.macro.Context;

@:dox(hide) @:noCompletion class Stamper {
	@:dox(hide) @:noCompletion public static function generate():Void {
		if (Context.defined("display")) return;
		for (pkg in ['backend', 'engine']) {
			Compiler.addGlobalMetadata(pkg, '@:rtti', true, true, false);
			Compiler.addGlobalMetadata(pkg, '@:build(backend.macro.SafeBuild.build())', true, true, false);
		}
		for (file in ['EditorState', 'InitState', 'Main', 'SplashScreen']) {
			Compiler.addMetadata('@:rtti', file);
			Compiler.addMetadata('@:build(backend.macro.SafeBuild.build())', file);
		}
	}
}
#end
