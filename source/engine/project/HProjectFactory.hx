package engine.project;

import engine.project.data.HProject;
import engine.project.data.HRawProjectFile;

/**
 * A factory for creating Hydro-Frame projects.
 * 
 * @since 0.8.0
 */
class HProjectFactory {
	/**
	 * Creates a new `HRawProjectFile` from scratch.
	 * 
	 * @param name The name of the project.
	 * @param version The version of the project.
	 * @return `HRawProjectFile` The new `HRawProjectFile`.
	 * @since 0.8.0
	 */
	public static function makeProjectVFS(name:String, version:String):HRawProjectFile {
		var vfs = new HRawProjectFile();
		vfs.saveContent('meta.json', Json.stringify({
			name: name,
			version: version,
			authors: []
		}, null, '    '));
		return vfs;
	}

	/**
	 * Creates a new `HProject` from scratch.
	 * Utilizes `makeProjectVFS()` under the hood.
	 * 
	 * @param name The name of the project.
	 * @param version The version of the project.
	 * @return `HProject` The new `HProject`.
	 * @since 0.8.0
	 */
	public static function makeProject(name:String, version:String):HProject
		return {
			meta: {
				name: name,
				version: version,
				authors: []
			},
			raw: makeProjectVFS(name, version)
		};

	/**
	 * Creates a new `HProject` from scratch with a `HProjectHandler`.
	 * Utilizes `makeProject()`/`makeProjectVFS()` under the hood.
	 * 
	 * @param name The name of the project.
	 * @param version The version of the project.
	 * @return `HProjectHandler` The new `HProjectHandler`.
	 * @since 0.8.0
	 */
	public static function makeProjectWithHandler(name:String, version:String):HProjectHandler
		return new HProjectHandler(makeProject(name, version));
}
