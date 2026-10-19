package backend.macro;

import haxe.macro.Context;
import sys.io.Process;

class GitMacro {
	public static macro function gitHash() {
		if (Context.defined('display'))
			return macro '';

		var process = new Process('git', ['rev-parse', 'HEAD']);

		if (process.exitCode() != 0)
			Context.info(process.stderr.readAll().toString(), Context.currentPos());

		var commitHashSplice:String = process.stdout.readLine().substr(0, 7);
		process.close();

		Context.info('Git Commit: $commitHashSplice', Context.currentPos());
		return macro $v{commitHashSplice};
	}

	public static macro function gitBranch() {
		if (Context.defined('display'))
			return macro '';

		var process = new Process('git', ['rev-parse', '--abbrev-ref', 'HEAD']);

		if (process.exitCode() != 0)
			Context.info(process.stderr.readAll().toString(), Context.currentPos());

		var branch:String = process.stdout.readLine();
		process.close();

		Context.info('Git Branch: $branch', Context.currentPos());
		return macro $v{branch};
	}
}
