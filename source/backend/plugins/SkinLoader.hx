package backend.plugins;

import backend.plugins.Skin.SkinData;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

/**
 * Allows loading skin files.
 * @since 0.8.6
 */
class SkinLoader {
	public static function load(path:String):SkinData {
		final bytes:Bytes = File.getBytes(path);
		if (bytes == null) {
			throw 'Failed to load skin at $path! -- NULL BYTES!';
			return null;
		}
		var input:BytesInput = new BytesInput(bytes);
		input.bigEndian = false;
		var themes:Map<String, Map<String, HColor>> = [];

		if (input.readString(4) != "HFSF") {
			throw 'Failed to load skin at $path! -- MISSING HEADER';
			return Skin.defaultThemes;
		}
		var themeCount:Int = input.readInt8(); // total ammount of themes
		final skinLength:Int = input.readUInt16();
		var skinName:String = input.readString(skinLength);
		var skinversion:Float = input.readDouble();

		for (themeIndex in 0...themeCount) {
			final themeNameLength:Int = input.readUInt16();
			var themeName:String = input.readString(themeNameLength);
			var themeData:Map<String, HColor> = [];

			final themeColorDefsLength:Int = input.readUInt24();
			for (themeColorDef in 0...themeColorDefsLength) {
				final colorDefKeyLength:Int = input.readUInt16();
				var colorDefKey:String = input.readString(colorDefKeyLength);
				themeData.set(colorDefKey, input.readInt32());
			}
			themes.set(themeName, themeData);
		}
		input.close();
		if (skinName == "" || skinversion == -1 || themes == []) {
			throw 'Failed to load skin at $path! -- UNKNOWN ERROR!';
			return null;
		}

		return {
			name: skinName,
			version: skinversion,
			themes: themes
		};
	}

	/**
	 * Write a skin to a path
	 * @param path path to write too
	 * @param data skin data to save
	 * @return Bytes
	 * @since 0.8.6
	 * NOTES: this is probably really bad way to do it, but i dont know how binary works so gimmie a break solar.
	 */
	public static function write(path:String, data:SkinData) {
		var bytes:BytesOutput = new BytesOutput();
		bytes.bigEndian = false;

		// It's not quite a 'magic number'. I'd treat it like a header. I actually used that in the VFS just to have a better
		// chance at not loading completely corrupt scripts. - ZSolarDev
		bytes.writeBytes(Bytes.ofString("HFSF"), 0, Bytes.ofString("HFSF").length); // magic number, for detecting skin corruption, i think.

		bytes.writeInt8(Lambda.count(data.themes)); // the first 32 bytes are the themes count, since customs are allowed.
		bytes.writeUInt16(Bytes.ofString(data.name)
			.length); // the next 16 bytes are for storing the length of the skin name string, these are somewhat important.
		bytes.writeBytes(Bytes.ofString(data.name), 0,
			Bytes.ofString(data.name).length); // then the string comes next, since we have the 8 bytes storing its length, Hydro-Frame knows when it ends
		bytes.writeDouble(data.version);

		for (themeTitle => themeInfo in data.themes) {
			var tBytes:Bytes = Bytes.ofString(themeTitle);
			bytes.writeUInt16(tBytes.length);
			bytes.writeBytes(tBytes, 0, tBytes.length);
			bytes.writeUInt24(Lambda.count(themeInfo));
			for (key => value in themeInfo) {
				var kBytes:Bytes = Bytes.ofString(key);
				bytes.writeUInt16(kBytes.length); // key string length
				bytes.writeBytes(kBytes, 0, kBytes.length); // color key.
				bytes.writeInt32(value); // the color itself.
			}
		}
		bytes.close(); // stop writing to it so that we can return it.
		File.saveBytes(path, bytes.getBytes());
	}
}
