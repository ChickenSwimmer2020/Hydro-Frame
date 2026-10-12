package format;

import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import format.svg.SVGData;
import format.svg.SVGRenderer;

class SVG {
	public var data:SVGData;

	public function new(content:String) {
		if (content != null) {
			data = new SVGData(Xml.parse(content));
		}
	}

	public function render(graphics:Graphics, x:Float = 0, y:Float = 0, width:Float = -1, height:Float = -1, ?inLayer:String = null) {
		if (data == null)
			return;

		var matrix = new Matrix();
		matrix.identity();
		if (width > -1 && height > -1)
			matrix.scale(width / data.width, height / data.height);
		matrix.translate(x, y);

		new SVGRenderer(data, inLayer).render(graphics, matrix, null, null, width / data.width, height / data.height);
	}
}
