package engine.vfs;

import engine.vfs.HFile;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Path;

using StringTools;

/**
 * Basic file data, giving its path and contents in bytes.
 * 
 * @since 0.8.0
 */
typedef HFileData = {
	filePath:String,
	fileContents:Bytes
};

/**
 * A VFS that's savable and loadable to a file.
 * 
 * Files are stored as a tree of `HFolder`s rooted at `files['/']`.
 * 
 * @since 0.8.0
 */
class HFileSystem {
	/**
	 * The files that belong to this `HFileSystem`.
	 * 
	 * @since 0.8.0
	 */
	public var files:Map<String, HFileObj> = [];

	/**
	 * Creates a new `HFileSystem`.
	 * 
	 * @since 0.8.0
	 */
	public function new() {}

	// ----------------- FILE OPERATIONS ----------------- //

	/**
	 * Retrieves the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `HFile` The file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.8.0
	 */
	public function getFile(filePath:String):HFile {
		var pathInfo = navigatePath(filePath);
		var parent = pathInfo?.parent;
		var fileName = pathInfo?.fileName;

		if (parent == null) {
			trace('ERROR:Failed to navigate to target file path to read bytes at path "$filePath". Returning null.');
			return null;
		}

		var file = parent.contents.get(fileName);
		if (file == null)
			return null;

		if (Std.isOfType(file, HFile))
			return cast file;

		trace('ERROR:Found a folder instead for requested file at path "$filePath". Returning null.');
		return null;
	}

	/**
	 * Gets the string contents of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `String` The string contents of the file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.8.0
	 */
	public function getContent(filePath:String):String {
		var file = getFile(filePath);
		return file != null ? file.contents.toString() : null;
	}

	/**
	 * Gets the bytes of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @return `Bytes` The bytes of the file at the given path, or `null` if it doesn't exist or it failed.
	 * @since 0.8.0
	 */
	public function getBytes(filePath:String):Bytes {
		var file = getFile(filePath);
		return file != null ? file.contents : null;
	}

	/**
	 * Saves the string contents of the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @param content The string contents of the file.
	 * @since 0.8.0
	 */
	public function saveContent(filePath:String, content:String)
		saveBytes(filePath, Bytes.ofString(content));

	/**
	 * Saves the bytes of the file at the given path.
	 * Creates the file (and any missing directories) if it doesn't exist.
	 * Will not overwrite a folder.
	 * 
	 * @param filePath The path of the file.
	 * @param bytes The bytes of the file.
	 * @since 0.8.0
	 */
	public function saveBytes(filePath:String, bytes:Bytes)
		writeFile(filePath, bytes);

	/**
	 * Appends new bytes to the file at the given path.
	 * Creates a new file if it doesn't exist.
	 * 
	 * @param filePath The path of the file.
	 * @param bytes The bytes to append.
	 * @since 0.8.0
	 */
	public function appendBytes(filePath:String, bytes:Bytes) {
		var file = getFile(filePath);

		if (file != null) {
			var buffer = new BytesBuffer();
			buffer.add(file.contents);
			buffer.add(bytes);
			file.contents = buffer.getBytes();
		} else
			saveBytes(filePath, bytes);
	}

	/**
	 * Appends new string contents to the file at the given path.
	 * 
	 * @param filePath The path of the file.
	 * @param content The string contents to append.
	 * @since 0.8.0
	 */
	public function appendContent(filePath:String, content:String)
		appendBytes(filePath, Bytes.ofString(content));

	/**
	 * Copies the file at the given path to the target path.
	 * The copy gets its own bytes, so editing one file does not affect the other.
	 * 
	 * @param startFilePath The path of the file to copy.
	 * @param targetFilePath The path to copy the file to.
	 * @return `Bool` `true` if the file was copied, `false` if it failed.
	 * @since 0.8.0
	 */
	public function copyTo(startFilePath:String, targetFilePath:String):Bool {
		var file = getFile(startFilePath);

		if (file == null) {
			trace('ERROR:Failed to find file at path "$startFilePath" to copy it to path "$targetFilePath".');
			return false;
		}

		if (isSamePath(startFilePath, targetFilePath))
			return true;

		if (!writeFile(targetFilePath, file.contents.sub(0, file.contents.length))) {
			trace('ERROR:Failed to navigate to target file path to copy file from path "$startFilePath" to path "$targetFilePath".');
			return false;
		}

		return true;
	}

	/**
	 * Moves the file at the given path to the target path by copying then deleting the original.
	 * The original is only deleted if the copy succeeded.
	 * 
	 * @param startFilePath The path of the file to move.
	 * @param targetFilePath The path to move the file to.
	 * @return `Bool` `true` if the file was moved, `false` if it failed.
	 * @since 0.8.0
	 */
	public function moveTo(startFilePath:String, targetFilePath:String):Bool {
		if (!copyTo(startFilePath, targetFilePath))
			return false;

		if (!isSamePath(startFilePath, targetFilePath))
			rmFile(startFilePath);

		return true;
	}

	//----------------- FILE SYSTEM OPERATIONS -----------------//

	/**
	 * Creates a new directory at the given path.
	 * Cannot create a folder the same name as a file.
	 * 
	 * @param dirPath The path of the directory to create.
	 * @since 0.8.0
	 */
	public function makeDir(dirPath:String) {
		if (walkFolders(splitPath(dirPath), true) == null)
			trace('ERROR:Folder already exists as a file, cannot create directory: ' + dirPath);
	}

	/**
	 * Removes the directory at the given path.
	 * 
	 * @param dirPath The path of the directory to remove.
	 * @since 0.8.0
	 */
	public function rmDir(dirPath:String) {
		if (splitPath(dirPath).length == 0) {
			files.remove('/');
			return;
		}

		var pathInfo = navigatePath(dirPath);
		var parent = pathInfo?.parent;
		var dirName = pathInfo?.fileName;

		if (parent == null || !parent.contents.exists(dirName)) {
			trace('ERROR:Failed to navigate to directory "$dirPath" to remove it. It does not exist.');
			return;
		}

		if (!Std.isOfType(parent.contents.get(dirName), HFolder)) {
			trace('ERROR:Failed to remove directory "$dirPath". It is a file.');
			return;
		}

		parent.contents.remove(dirName);
	}

	/**
	 * Sets the directory at the given path. Alternatively, you can use `makeDir()` to create
	 * a directory from a path without manually creating an `HFolder`.
	 * 
	 * @param dirPath The path of the directory to set.
	 * @param folder The `HFolder` to set the directory to.
	 * @since 0.8.0
	 * @see `makeDir()`
	 */
	public function setDir(dirPath:String, folder:HFolder) {
		if (splitPath(dirPath).length == 0) {
			files.set('/', folder);
			return;
		}

		var pathInfo = navigatePath(dirPath, true);
		var parent = pathInfo?.parent;
		var dirName = pathInfo?.fileName;

		if (parent == null) {
			trace('ERROR:Failed to set directory "$dirPath": parent directory is not a folder.');
			return;
		}

		if (Std.isOfType(parent.contents.get(dirName), HFile)) {
			trace('ERROR:Failed to set directory "$dirPath": a file already exists there.');
			return;
		}

		parent.contents.set(dirName, folder);
	}

	/**
	 * Checks if the directory exists.
	 * 
	 * @param dirPath The path of the directory to check.
	 * @return `Bool` `true` if the directory exists, `false` otherwise.
	 * @since 0.8.0
	 */
	public function dirExists(dirPath:String):Bool
		return Std.isOfType(lookup(dirPath), HFolder);

	/**
	 * Creates a file at the given path.
	 * 
	 * @param path The path to create the file at.
	 * @param name The name of the file to create, including the extension(if present).
	 * @param makeDirectory If `true`, the directory at the given path will be created if it does not exist.
	 * @param fileContent The content of the file to create. Optional.
	 * @return `HFile` The created file, or `null` if it failed.
	 * @since 0.8.0
	 */
	public function makeFile(path:String, name:String, makeDirectory:Bool = false, ?fileContent:OneOfTwo<String, Bytes>):HFile {
		var content:Bytes = Bytes.alloc(0);
		if (fileContent != null)
			content = Std.isOfType(fileContent, String) ? Bytes.ofString(fileContent) : fileContent;

		var fullPath = (path.endsWith('/') ? path + name : path + '/' + name);
		var folder:HFolder = navigateDirectory(path, makeDirectory);

		if (folder == null) {
			trace('ERROR:Failed to navigate to directory("$path") to create file "$fullPath".${(makeDirectory ? ' Failed to create file directories.' : ' It does not exist.')}');
			return null;
		}

		if (Std.isOfType(folder.contents.get(name), HFolder)) {
			trace('ERROR:Failed to create file "$fullPath". A folder already exists there.');
			return null;
		}

		var newFile = new HFile(name, content);
		folder.contents.set(name, newFile);
		return newFile;
	}

	/**
	 * Removes the file at the given path.
	 * 
	 * @param path The path of the file to remove.
	 * @since 0.8.0
	 */
	public function rmFile(path:String) {
		var pathInfo = navigatePath(path);
		var parent = pathInfo?.parent;
		var fileName = pathInfo?.fileName;

		if (parent == null || !parent.contents.exists(fileName)) {
			trace('ERROR:Failed to navigate to file "$path" to remove it. It does not exist.');
			return;
		}

		if (!Std.isOfType(parent.contents.get(fileName), HFile)) {
			trace('ERROR:Failed to remove file "$path". It is a folder.');
			return;
		}

		parent.contents.remove(fileName);
	}

	/**
	 * Sets a file at the given path. Alternatively, use `makeFile()` to create
	 * a file from a path without manually creating an `HFile` object.
	 * 
	 * @param path The path to set the file at.
	 * @param file The file to set.
	 * @since 0.8.0
	 */
	public function setFile(path:String, file:HFile) {
		var pathInfo = navigatePath(path, true);
		var parent = pathInfo?.parent;
		var fileName = pathInfo?.fileName;

		if (parent == null) {
			trace('ERROR:Failed to set file "$path": parent file is not a folder.');
			return;
		}

		if (Std.isOfType(parent.contents.get(fileName), HFolder)) {
			trace('ERROR:Failed to set file "$path": a folder already exists there.');
			return;
		}

		parent.contents.set(fileName, file);
	}

	/**
	 * Checks if the file exists.
	 * 
	 * @param filePath The path of the file to check.
	 * @return `Bool` `true` if the file exists, `false` otherwise.
	 * @since 0.8.0
	 */
	public function fileExists(filePath:String):Bool
		return Std.isOfType(lookup(filePath), HFile);

	/**
	 * Imports a real directory from disk into the file system at the given path.
	 * All files and subdirectories are copied in recursively.
	 * 
	 * @param folder The path on disk to read from.
	 * @param vfsPath The path in this file system to write to.
	 * @since 0.10.0
	 */
	public function importDirectory(folder:String, vfsPath:String) {
		if (!FileSystem.exists(folder) || !FileSystem.isDirectory(folder)) {
			trace('ERROR:Failed to import directory "$folder": it does not exist or is not a directory.');
			return;
		}

		for (entry in FileSystem.readDirectory(folder)) {
			var diskEntryPath = Path.join([folder, entry]);
			var vfsEntryPath = Path.join([vfsPath, entry]);

			if (FileSystem.isDirectory(diskEntryPath))
				importDirectory(diskEntryPath, vfsEntryPath);
			else
				writeFile(vfsEntryPath, File.getBytes(diskEntryPath));
		}
	}

	// ----------------- FILE SYSTEM SAVING/LOADING ----------------- //

	/**
	 * Saves the file system to a file.
	 * Empty folders are saved as entries with a trailing `/` and no contents.
	 * 
	 * @param fileName The name of the file to save the file system to.
	 * @since 0.8.0
	 */
	public function saveFileSystem(fileName:String) {
		var root = getRoot();
		var finalFiles:Array<HFileData> = root != null ? lookThroughFolders(root, '') : [];
		var bytesOutput = new BytesOutput();

		bytesOutput.writeString('HPFVFS');

		for (file in finalFiles) {
			var pathBytes = Bytes.ofString(file.filePath);
			bytesOutput.writeInt32(pathBytes.length);
			bytesOutput.write(pathBytes);

			bytesOutput.writeInt32(file.fileContents.length);
			bytesOutput.write(file.fileContents);
		}

		var outputBytes = bytesOutput.getBytes();
		File.saveBytes(fileName, outputBytes);
	}

	/**
	 * Loads a file system from a file into the current file system.
	 * If this file system is not empty, the behavior is *undefined*.
	 * 
	 * @param fileName The name of the file to load the file system from.
	 * @return `HFileSystem` This file system, for chaining.
	 * @since 0.8.0
	 */
	public function loadFileSystem(fileName:String):HFileSystem {
		var bytes = File.getBytes(fileName);
		var bytesInput = new BytesInput(bytes);

		var header:String = '';
		try {
			header = bytesInput.readString(6);
		} catch (e:Dynamic) {
			throw 'Failed to read HPFVFS data: ${e.toString()}';
		}
		if (header != 'HPFVFS')
			throw 'Invalid HPFVFS header.';

		try {
			while (bytesInput.position < bytes.length) {
				var pathLength = bytesInput.readInt32();
				if (pathLength < 0 || pathLength > bytes.length - bytesInput.position)
					throw 'Invalid path length ($pathLength).';
				var pathBytes = bytesInput.read(pathLength);
				var path = pathBytes.toString();

				var contentLength = bytesInput.readInt32();
				if (contentLength < 0 || contentLength > bytes.length - bytesInput.position)
					throw 'Invalid content length ($contentLength) for "$path".';
				var contentBytes = bytesInput.read(contentLength);

				if (path.endsWith('/'))
					makeDir(path);
				else
					writeFile(path, contentBytes);
			}
		} catch (e:Dynamic) {
			throw 'Error reading HPFVFS data: ${e.toString()}';
		}

		return this;
	}

	// ----------------- PRIVATE CALLS ----------------- //

	private function splitPath(path:String):Array<String> {
		var parts:Array<String> = [];
		for (part in path.split('/')) {
			if (part == '' || part == '.')
				continue;
			if (part == '..') {
				parts.pop();
				continue;
			}
			parts.push(part);
		}
		return parts;
	}

	private function isSamePath(pathA:String, pathB:String):Bool
		return splitPath(pathA).join('/') == splitPath(pathB).join('/');

	private function getRoot(createMissing:Bool = false):HFolder {
		var root = files.get('/');

		if (root == null) {
			if (!createMissing)
				return null;
			root = new HFolder();
			files.set('/', root);
		}

		if (!Std.isOfType(root, HFolder)) {
			trace('ERROR:Root is a file, not a folder.');
			return null;
		}

		return cast root;
	}

	private function walkFolders(parts:Array<String>, createMissing:Bool):HFolder {
		var currentFolder = getRoot(createMissing);

		for (folderName in parts) {
			if (currentFolder == null)
				return null;

			var next = currentFolder.contents.get(folderName);
			if (next == null) {
				if (!createMissing)
					return null;
				next = new HFolder();
				currentFolder.contents.set(folderName, next);
			} else if (!Std.isOfType(next, HFolder))
				return null;

			currentFolder = cast next;
		}

		return currentFolder;
	}

	private function lookup(path:String):HFileObj {
		var parts = splitPath(path);
		if (parts.length == 0)
			return files.get('/');

		var fileName = parts.pop();
		var parent = walkFolders(parts, false);
		return parent?.contents.get(fileName);
	}

	private function navigateDirectory(path:String, createMissing:Bool = false):HFolder
		return walkFolders(splitPath(path), createMissing);

	private function navigatePath(path:String, createMissing:Bool = false):{parent:HFolder, fileName:String} {
		var parts = splitPath(path);
		if (parts.length == 0)
			return null;

		var fileName = parts.pop();
		var parent = walkFolders(parts, createMissing);
		if (parent == null)
			return null;

		return {parent: parent, fileName: fileName};
	}

	private function writeFile(filePath:String, bytes:Bytes):Bool {
		var pathInfo = navigatePath(filePath, true);
		var parent = pathInfo?.parent;
		var fileName = pathInfo?.fileName;

		if (parent == null) {
			trace('ERROR:Failed to navigate to target file path to save bytes at path "$filePath".');
			return false;
		}

		var existing = parent.contents.get(fileName);
		if (existing == null)
			parent.contents.set(fileName, new HFile(fileName, bytes));
		else if (Std.isOfType(existing, HFile))
			(cast existing : HFile).contents = bytes;
		else {
			trace('ERROR:Found a folder instead for requested file at path "$filePath". Not saving.');
			return false;
		}

		return true;
	}

	private function lookThroughFolders(folder:HFolder, basePath:String):Array<HFileData> {
		var foundFiles:Array<HFileData> = [];
		var isEmpty = true;

		for (fileName => fileObj in folder.contents) {
			isEmpty = false;
			var currentPath = basePath + fileName;
			if (Std.isOfType(fileObj, HFile))
				foundFiles.push({filePath: currentPath, fileContents: (cast fileObj : HFile).contents});
			else if (Std.isOfType(fileObj, HFolder))
				foundFiles = foundFiles.concat(lookThroughFolders((cast fileObj : HFolder), currentPath + '/'));
		}

		if (isEmpty && basePath != '')
			foundFiles.push({filePath: basePath, fileContents: Bytes.alloc(0)});

		return foundFiles;
	}
}
