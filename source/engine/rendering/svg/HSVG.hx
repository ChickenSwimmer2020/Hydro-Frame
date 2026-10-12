package engine.rendering.svg;

import format.svg.SVGData;
import haxe.io.Path;
import lime.utils.Assets;
import format.SVG;

/**
 * SVG Sprite
 * @since SVG_Rendering
 */
class HSVG extends HSprite {
	/**
	 * Create an HSVG Sprite using an SVG file
	 * @since SVG_Rendering
	 */
	public static function fromFile(filepath:String) {
		return new HSVG().addCostume(new Path(filepath).file, Assets.getText(filepath));
	}

	/**
	 * Create an HSVG Sprite using multiple SVG file paths
	 * @since SVG_Rendering
	 */
	public static function fromFiles(filepaths:Array<String>) {
		var hsvg = new HSVG();

		for (filepath in filepaths)
			if (filepath != null && Assets.exists(filepath))
				hsvg.addCostume(new Path(filepath).file, Assets.getText(filepath));

		return hsvg;
	}

	/**
	 * For loading and rendering the actual SVG
	 * @since SVG_Rendering
	 */
	public var svg(default, null):SVG;

	/**
	 * Current costume name
	 * @since SVG_Rendering
	 */
	public var costume(default, null):String = null;

	/**
	 * Map of all availible costume names and their data
	 * @since SVG_Rendering
	 */
	public var costumes(default, null):Map<String, String> = [];

	/**
	 * Add costume of name "`name`" with the data of `costume` if both are not null
	 * @param name new costume name
	 * @param costume new costume data
	 * @since SVG_Rendering
	 */
	public function addCostume(name:String, costume:String):HSVG {
		if (name == null) {
			trace('Cannot have a null costume name');
			return this;
		}

		if (costume == null) {
			trace('Cannot have a costume with null data');
			return this;
		}

		if (costumes.exists(name))
			trace('Costume "$name" is being replaced');

		costumes.set(name, costume);

		return this;
	}

	/**
	 * Remove `costume` from the costumes map if it's not in use
	 * @param costume target costume
	 * @since SVG_Rendering
	 */
	public function removeCostume(costume:String) {
		if (costume == costume) {
			trace('Refusing to remove current costume');
			return;
		}

		costumes.remove(costume);
	}

	/**
	 * Switch costume to `costume` if it exists
	 * @param costume target costume
	 * @since SVG_Rendering
	 */
	public function switchToCostume(costume:String) {
		if (!costumes.exists(costume)) {
			trace('Costume "$costume" does not exist');
			return;
		}

		svg.data = new SVGData(Xml.parse(costumes.get(costume)));
		reRender();

		this.costume = costume;
	}

	override public function new(x = 0.0, y = 0.0) {
		super(x, y, null);

		svg = new SVG(null);
	}

	override function reRender():HSVG {
		this.graphics.clear();

		if (svg != null)
			svg.render(this.graphics, 0, 0, width, height);

		super.reRender();
		return this;
	}

	override function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):HSVG {
		trace('loadGraphic unsupported by HSVG');
		return this;
	}
}
