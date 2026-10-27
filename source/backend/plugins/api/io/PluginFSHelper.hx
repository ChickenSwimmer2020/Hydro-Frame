package backend.plugins.api.io;

import backend.plugins.api.permission.Enforcer;
import haxe.io.Path;

/**
 * The file system API for plugins. Exposes methods simialar to `haxe.FileSystem`.
 * Use this to access the file system of a plugin.
 * 
 * Note that all paths are relative to the plugins root.
 * 
 * @since 0.10.2
 */
class PluginFSHelper {
	/**
	 * The API this `PluginFSHelper` belongs to.
	 * 
	 * @since 0.10.2
	 */
	private var api(default, null):PluginAPI;

	/**
	 * The IO method to use for the plugin.
	 * 
	 * @since 0.10.2
	 */
	private var ioMethod(default, null):PluginIOMethod = null;

	/**
	 * Creates a new `PluginFSHelper`.
	 * 
	 * @param method The IO method to use for the plugin.
	 * @param api The API this `PluginFSHelper` belongs to.
	 * @since 0.10.2
	 */
	@:allow(backend.plugins.api.PluginAPI)
	private function new(method:PluginIOMethod, api:PluginAPI) {
		ioMethod = method;
		this.api = api;
	}

	/**
	 * Creates a new directory within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the directory to create.
	 * @since 0.10.2
	 */
	public function createDirectory(path:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				FileSystem.createDirectory('plugins/$pPath/$path');
			case Packed(vfs, vfsPath):
				vfs.makeDir(path);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Deletes a directory within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the directory to delete.
	 * @since 0.10.2
	 */
	public function deleteDirectory(path:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				function rmDir(path:String) {
					for (entry in FileSystem.readDirectory(path)) {
						var entryPath = Path.join([path, entry]);
						if (FileSystem.isDirectory(entryPath))
							rmDir(entryPath);
						else
							FileSystem.deleteFile(entryPath);
					}
				}

				rmDir('plugins/$pPath/$path');
			case Packed(vfs, vfsPath):
				vfs.rmDir(path);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Deletes a file within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to delete.
	 * @since 0.10.2
	 */
	public function deleteFile(path:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				FileSystem.deleteFile('plugins/$pPath/$path');
			case Packed(vfs, vfsPath):
				vfs.rmFile(path);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Checks if a file or directory exists within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the file or directory to check.
	 * @return `Null<Bool>` Whether the file or directory exists. `null` if permissions
	 * can't be enforced.
	 * @since 0.10.2
	 */
	public function exists(path:String):Null<Bool>
		return Enforcer.enforce(api) ? switch (ioMethod) {
			case Unpacked(pPath): FileSystem.exists('plugins/$pPath/$path');
			case Packed(vfs, vfsPath): vfs.fileExists(path) || vfs.dirExists(path);
		} : null;

	/**
	 * Checks if a directory exists within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the directory to check.
	 * @return `Null<Bool>` Whether the directory exists.
	 * @since 0.10.2
	 */
	public function isDirectory(path:String):Null<Bool>
		return Enforcer.enforce(api) ? switch (ioMethod) {
			case Unpacked(pPath): FileSystem.isDirectory('plugins/$pPath/$path');
			case Packed(vfs, vfsPath): vfs.dirExists(path);
		} : null;

	/**
	 * Returns the contents of a directory within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to check.
	 * @return `Array<String>` The contents of the directory.
	 * @since 0.10.2
	 */
	public function readDirectory(path:String):Array<String>
		return Enforcer.enforce(api) ? switch (ioMethod) {
			case Unpacked(pPath): FileSystem.readDirectory('plugins/$pPath/$path');
			case Packed(vfs, vfsPath):
				var res:Array<String> = [];
				@:privateAccess
				for (name => data in vfs.navigateDirectory(path)?.contents)
					res.push(name);
				res;
		} : null;
}
