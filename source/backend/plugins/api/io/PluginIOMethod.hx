package backend.plugins.api.io;

import engine.vfs.HFileSystem;

/**
 * The IO method to used to access the files of a plugin.
 * 
 * @since 0.10.2
 */
enum PluginIOMethod {
	/**
	 * Uses the unpacked plugin files.
	 * 
	 * @param path The path to the `.uhpf`.
	 * @since 0.10.2
	 */
	Unpacked(path:String);

	/**
	 * Uses the packed plugin files.
	 * 
	 * @param vfs The `HFileSystem` to use.
	 * @param path The path to the `.hpf`.
	 * @since 0.10.2
	 */
	Packed(vfs:HFileSystem, path:String);
}
