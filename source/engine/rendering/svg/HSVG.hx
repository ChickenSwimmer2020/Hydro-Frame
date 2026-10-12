package engine.rendering.svg;

import lime.utils.Assets;
import format.SVG;

/**
 * SVG Sprite
 * @since SVG_Rendering
 */
class HSVG extends HSprite {
	public static function fromFile(filepath:String) {
		return new HSVG(Assets.getText(filepath) ?? '');
	}

	var svg:SVG;

	override public function new(content:String, x = 0.0, y = 0.0) {
		super(x, y, null);

		svg = new SVG(content);
		reRender();
	}

	override function reRender():HSVG {
		svg.render(this.graphics, this.x, this.y);
		super.reRender();
		return this;
	}

	override function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):HSVG {
		trace('loadGraphic unsupported by HSVG');
		return this;
	}
}
