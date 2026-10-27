package backend.plugins.api.process;

import backend.plugins.api.permission.Enforcer;
import sys.io.Process;

/**
 * The process API for plugins. Used to run processes inside the plugin.
 * 
 * @since 0.10.2 
 */
class PluginProcessHelper {
	/**
	 * The API this `PluginProcessHelper` belongs to.
	 * 
	 * @since 0.10.2
	 */
	private var api(default, null):PluginAPI;

	/**
	 * Creates a new `PluginProcessHelper`.
	 * 
	 * @param api The API this `PluginProcessHelper` belongs to.
	 * @since 0.10.2
	 */
	@:allow(backend.plugins.api.PluginAPI)
	private function new(api:PluginAPI) {
		this.api = api;
	}

	/**
	 * Construct a `Process` object, which run the given command immediately.
	 * 
	 * Command arguments can be passed in two ways: 1. using args, 2. appending to `command`
	 * and leaving `args` as null.
	 * 
	 * When using `args` to pass command arguments, each argument will be automatically quoted,
	 * and shell meta-characters will be escaped if needed. `command` should be an executable
	 * name that can be located in the PATH environment variable, or a path to an executable.
	 * 
	 * When `args` is not given or is null, command arguments can be appended to `command`.
	 * No automatic quoting/escaping will be performed. `command ` should be formatted exactly
	 * as it would be when typed at the command line. It can run executables, as well as shell
	 * commands that are not executables (e.g. on Windows: dir, cd, echo etc).
	 * 
	 * `detached` allows the created process to be standalone. You cannot communicate with it
	 * but you can look at its exit code.
	 * 
	 * `close()` should be called when the `Process` is no longer used.
	 * 
	 * @param command The command to run.
	 * @param args The arguments to the command.
	 * @param detached Whether the process should be detached.
	 * @return The created `Process`. `null` if permissions can't be enforced.
	 * @since 0.10.2
	**/
	public function createProcess(command:String, ?args:Array<String>, ?deteched:Bool = false):Process
		return Enforcer.enforce(api) ? new Process(command, args, deteched) : null;
}
