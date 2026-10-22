package backend.macro;

import haxe.macro.Context;
import sys.io.Process;
import backend.debug.logging.Logger;

class GitMacro {
	static var didHash:Bool = false; //fix for intellisense getting trace messages it shouldnt on init.
	public static macro function gitHash() {
		if (Context.defined('display')) return macro '';

		var process = new Process('git', ['rev-parse', 'HEAD']);

		if (process.exitCode() != 0)
			Context.info(process.stderr.readAll().toString(), Context.currentPos());

		var commitHashSplice:String = process.stdout.readLine().substr(0, 7);
		process.close();

		Logger.log('MACRO: Your building Hydro-Frame:${gitBranchStore}($commitHashSplice)!');
		return macro $v{commitHashSplice};
	}
	public static var gitBranchStore:String = "";
	public static macro function gitBranch() {
		if(Context.defined("display-details") || Context.defined("display-stdin")) return macro '';
		if (Context.defined('display')) return macro '';

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