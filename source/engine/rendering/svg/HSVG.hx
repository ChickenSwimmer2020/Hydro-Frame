package engine.rendering.svg;

import format.SVG;
import format.svg.SVGData;
import haxe.io.Path;

/**
 * An `HSprite` that renders an SVG.
 * An `HSVG` cannot load graphics via `loadGraphic()`.
 * 
 * @since 0.8.7
 */
class HSVG extends HSprite {
	/**
	 * Creates an `HSVG` using an SVG file.
	 * 
	 * @since 0.8.7
	 */
	public static function fromFile(filepath:String)
		return new HSVG().addCostume(new Path(filepath).file, File.getContent(filepath));

	/**
	 * Creates an `HSVG` using multiple SVG file paths.
	 * 
	 * @since 0.8.7
	 */
	public static function fromFiles(filepaths:Array<String>) {
		var hsvg = new HSVG();

		for (filepath in filepaths)
			if (filepath != null && Assets.exists(filepath))
				hsvg.addCostume(new Path(filepath).file, File.getContent(filepath));

		return hsvg;
	}

	/**
	 * For loading and rendering the actual SVG.
	 * 
	 * @since 0.8.7
	 */
	public var svg(default, null):SVG;

	/**
	 * Current costume name. Get the costume data from `costumes`.
	 * 
	 * @see `costumes`
	 * @since 0.8.7
	 */
	public var costume(default, null):String = null;

	/**
	 * Map of all availible costume names and their data.
	 * A costume is a string of XML SVG data.
	 * 
	 * @since 0.8.7
	 */
	public var costumes(default, null):Map<String, String> = [];

	/**
	 * Add costume of name "`name`" with the data of `costume` if both are not null.
	 * 
	 * @param name The name of the costume.
	 * @param costume The XML SVG data of the costume.
	 * @since 0.8.7
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
	 * Remove `costume` from the costumes map if it's not in use.
	 * 
	 * @param costume The costume to remove.
	 * @since 0.8.7
	 */
	public function removeCostume(costume:String) {
		if (costume == this.costume) {
			trace('Refusing to remove current costume');
			return;
		}

		costumes.remove(costume);
	}

	/**
	 * Switch costume to `costume` if it exists.
	 * 
	 * @param costume The costume to switch to.
	 * @since 0.8.7
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

	/**
	 * Create a new `HSVG`.
	 * 
	 * @param x The x position.
	 * @param y The y position.
	 * @since 0.8.7
	 */
	override public function new(x = 0.0, y = 0.0) {
		super(x, y, null);

		svg = new SVG(null);
	}

	/**
	 * Re-renders this `HSVG` and puts it on top.
	 * Clears `clearObjects`.
	 * 
	 * @return `HSVG` This `HSVG`, for chaining.
	 * @since 0.8.7
	 */
	override public function reRender():HSVG {
		graphics.clear();

		if (svg?.data != null)
			svg.render(graphics, 0, 0, cast svg.data.width, cast svg.data.height);

		super.reRender();
		return this;
	}

	/**
	 * An `HSVG` cannot load graphics via `loadGraphic()`.
	 * 
	 * @return `HSVG` This `HSVG`, for chaining.
	 * @since 0.8.7
	 */
	override function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):HSVG {
		trace('loadGraphic unsupported by HSVG');
		return this;
	}
}
