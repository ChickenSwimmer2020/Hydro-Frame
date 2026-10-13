package engine.project;

import engine.project.data.*;
import engine.utils.HProjectUtils;

/**
 * A parser for Hydro-Frame project files(`.hpf`).
 * 
 * @since 0.8.0
 */
class HProjectFileParser {
	/**
	 * Parses a Hydro-Frame project file into a raw VFS.
	 * 
	 * @param path The path to the Hydro-Frame project file.
	 * @return `HRawProjectFile` The raw VFS.
	 * @since 0.8.0
	 */
	public static function parseRaw(path:String):HRawProjectFile
		return new HRawProjectFile().loadFileSystem(path);

	/**
	 * Wraps an `HRawProjectFile` into an `HProject`.
	 * 
	 * @param raw The `HRawProjectFile`.
	 * @return `HProject` The wrapped `HRawProjectFile`.
	 * @since 0.8.0
	 */
	public static function wrap(raw:HRawProjectFile):HProject {
		var validationResult = HProjectUtils.validateRaw(raw);
		switch (validationResult) {
			case NO_META:
				throw 'No metadata found in this Hydro-Frame project file VFS.';
			case NULL_PROJECT:
				throw 'This Hydro-Frame project file is null.';
			default:
				return({
					meta: Json.parse(raw.getContent('meta.json')),
					raw: raw
				} : HProject);
		}
	}

	/**
	 * Parses a Hydro-Frame project file into an `HProject`.
	 * 
	 * @param path The path to the Hydro-Frame project file.
	 * @return `HProject` The parsed `HProject`.
	 * @since 0.8.0
	 */
	public static function parse(path:String):HProject
		return wrap(parseRaw(path));
}
