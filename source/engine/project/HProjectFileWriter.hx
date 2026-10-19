package engine.project;

import engine.project.data.*;
import engine.utils.HProjectUtils;

/**
 * A writer for Hydro-Frame project files(`.hfpf`).
 * 
 * @since 0.8.0
 */
class HProjectFileWriter {
	/**
	 * Saves a Hydro-Frame project file(`.hfpf`) from a raw VFS.
	 * 
	 * @param project The raw VFS.
	 * @param path The path to save the Hydro-Frame project file to.
	 * @since 0.8.0
	 */
	public static function writeRaw(project:HRawProjectFile, path:String) {
		HProjectUtils.validateRaw(project, true);
		project.saveFileSystem(path);
	}

	/**
	 * Saves a Hydro-Frame project file(`.hfpf`) from a Hydro-Frame project.
	 * Calls `writeRaw()` under the hood.
	 * 
	 * @param project The Hydro-Frame project.
	 * @param path The path to save the Hydro-Frame project file to.
	 * @see `writeRaw()`
	 * @since 0.8.0
	 */
	public static function writeProject(project:HProject, path:String)
		writeRaw(project.raw, path);

	/**
	 * Saves a Hydro-Frame project file(`.hfpf`) from a Hydro-Frame project handler.
	 * Calls `writeProject()` under the hood.
	 * 
	 * @param project The Hydro-Frame project.
	 * @param path The path to save the Hydro-Frame project file to.
	 * @see `writeProject()`
	 * @since 0.8.0
	 */
	public static function writeHandler(project:HProjectHandler, path:String)
		writeProject(project.project, path);
}
