package backend.macro;

import haxe.macro.Context;
import sys.io.Process;
import backend.debug.logging.Logger;

class GitMacro {
	static var didHash:Bool = false; //fix for intellisense getting trace messages it shouldnt on init.
	public static macro function gitHash() {
		if(Context.defined("display-details")
			|| Context.defined("display-stdin")
			|| Context.defined("no-compilation")
			|| Context.getDisplayMode() != haxe.macro.DisplayMode.None) return macro '';

		if(!didHash) {
			didHash = true;
			var commitHashSplice:String = "";
			Context.onAfterGenerate(()->{
				var process = new Process('git', ['rev-parse', 'HEAD']);

				if (process.exitCode() != 0)
					Context.info(process.stderr.readAll().toString(), Context.currentPos());

				commitHashSplice = process.stdout.readLine().substr(0, 7);
				process.close();

				Logger.log('MACRO: Your building Hydro-Frame:${gitBranchStore}($commitHashSplice)!');
			});
		}
		return macro ''; //wait, why does this even need a return?
	}
	public static var gitBranchStore:String = "";
	public static macro function gitBranch() {
		if(Context.defined("display-details") || Context.defined("display-stdin")) return macro '';

		var process = new Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);

		if (process.exitCode() != 0)
			Context.info(process.stderr.readAll().toString(), Context.currentPos());

		var branch:String = process.stdout.readLine();
		process.close();

		gitBranchStore = branch; 
		//haxe.macro.Context.info('Git Branch: $branch', Context.currentPos());
		return macro $v{branch};
	}
}
