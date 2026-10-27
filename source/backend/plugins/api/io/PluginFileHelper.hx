package backend.plugins.api.io;

import backend.plugins.api.permission.Enforcer;
import haxe.io.BytesBuffer;

/**
 * The file API for plugins. Exposes methods simialar to `haxe.io.File`.
 * Use this to interact with individual files within a plugin.
 * 
 * Note that all paths are relative to the plugins root.
 * 
 * @since 0.10.2
 */
class PluginFileHelper {
	/**
	 * The API this `PluginFileHelper` belongs to.
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
	 * Creates a new `PluginFileHelper`.
	 * 
	 * @param method The IO method to use for the plugin.
	 * @param api The API this `PluginFileHelper` belongs to.
	 * @since 0.10.2
	 */
	@:allow(backend.plugins.api.PluginAPI)
	private function new(method:PluginIOMethod, api:PluginAPI) {
		ioMethod = method;
		this.api = api;
	}

	/**
	 * Reads the contents of a file as a `String` within the plugin
	 * denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to read.
	 * @return `String` The contents of the file.
	 * @since 0.10.2
	 */
	public function getContent(path:String):String
		return Enforcer.enforce(api) ? switch (ioMethod) {
			case Unpacked(pPath): File.getContent('plugins/$pPath/$path');
			case Packed(vfs, _): vfs.getContent(path);
		} : null;

	/**
	 * Reads the contents of a file as `Bytes` within the plugin
	 * denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to read.
	 * @return `Bytes` The contents of the file.
	 * @since 0.10.2
	 */
	public function getBytes(path:String):Bytes
		return Enforcer.enforce(api) ? switch (ioMethod) {
			case Unpacked(pPath): File.getBytes('plugins/$pPath/$path');
			case Packed(vfs, _): vfs.getBytes(path);
		} : null;

	/**
	 * Saves the `String` given to a file at the given path within the
	 * plugin denoted by `ioMethod`.
	 * Overwrites the file if it already exists, creates it if it doesn't.
	 * 
	 * @param path The path to the file to save.
	 * @param data The data to save to the file.
	 * @since 0.10.2
	 */
	public function saveContent(path:String, data:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				File.saveContent('plugins/$pPath/$path', data);
			case Packed(vfs, vfsPath):
				vfs.saveContent(path, data);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Saves the `Bytes` given to a file at the given path within the
	 * plugin denoted by `ioMethod`.
	 * Overwrites the file if it already exists, creates it if it doesn't.
	 * 
	 * @param path The path to the file to save.
	 * @param bytes The bytes to save to the file.
	 * @since 0.10.2
	 */
	public function saveBytes(path:String, bytes:Bytes) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				File.saveBytes('plugins/$pPath/$path', bytes);
			case Packed(vfs, vfsPath):
				vfs.saveBytes(path, bytes);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Appends a `String` to a file within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to append to.
	 * @param data The data to append to the file.
	 * @since 0.10.2
	 */
	public function appendContent(path:String, data:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				File.saveContent('plugins/$pPath/$path', File.getContent('plugins/$pPath/$path') + data);
			case Packed(vfs, vfsPath):
				vfs.appendContent(path, data);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Appends `Bytes` to a file within the plugin denoted by `ioMethod`.
	 * 
	 * @param path The path to the file to append to.
	 * @param bytes The `Bytes` to append to the file.
	 * @since 0.10.2
	 */
	public function appendBytes(path:String, bytes:Bytes) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				if (FileSystem.exists('plugins/$pPath/$path')) {
					var oldBytes = File.getBytes('plugins/$pPath/$path');
					var buffer = new BytesBuffer();
					buffer.add(oldBytes);
					buffer.add(bytes);
					File.saveBytes('plugins/$pPath/$path', buffer.getBytes());
				} else
					File.saveBytes('plugins/$pPath/$path', bytes);
			case Packed(vfs, vfsPath):
				vfs.appendBytes(path, bytes);
				vfs.saveFileSystem(vfsPath);
		}
	}

	/**
	 * Copies an item within the plugin denoted by `ioMethod`.
	 * 
	 * @param srcPath The path to the item to copy.
	 * @param dstPath The path to copy the item to.
	 * @since 0.10.2
	 */
	public function copy(srcPath:String, dstPath:String) {
		if (!Enforcer.enforce(api))
			return;
		switch (ioMethod) {
			case Unpacked(pPath):
				File.copy('plugins/$pPath/$srcPath', 'plugins/$pPath/$dstPath');
			case Packed(vfs, vfsPath):
				vfs.copyTo(srcPath, dstPath);
				vfs.saveFileSystem(vfsPath);
		}
	}
}
