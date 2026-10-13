package format.gfx;

import openfl.Vector;
import openfl.display.CapsStyle;
import openfl.display.GradientType;
import openfl.display.Graphics;
import openfl.display.GraphicsPathCommand;
import openfl.display.GraphicsPathWinding;
import openfl.display.InterpolationMethod;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.SpreadMethod;
import openfl.geom.Matrix;

class GfxGraphics extends Gfx {
	var graphics:Graphics;
	var pathCmds:Vector<Int> = new Vector<Int>();
	var pathData:Vector<Float> = new Vector<Float>();

	public function new(inGraphics:Graphics) {
		super();
		graphics = inGraphics;
	}

	function flushPath() {
		if (pathCmds.length > 0)
			graphics.drawPath(pathCmds, pathData, GraphicsPathWinding.NON_ZERO);
		pathCmds = new Vector<Int>();
		pathData = new Vector<Float>();
	}

	override public function beginGradientFill(grad:Gradient) {
		graphics.beginGradientFill(grad.type, grad.colors, grad.alphas, grad.ratios, grad.matrix, grad.spread, grad.interp, grad.focus);
	}

	override public function beginFill(color:Int, alpha:Float) {
		graphics.beginFill(color, alpha);
	}

	override public function endFill() {
		flushPath();
		graphics.endFill();
	}

	override public function lineStyle(style:LineStyle) {
		graphics.lineStyle(style.thickness, style.color, style.alpha, style.pixelHinting, style.scaleMode, style.capsStyle, style.jointStyle, style.miterLimit);
	}

	override public function endLineStyle() {
		flushPath();
		graphics.lineStyle();
	}

	override public function moveTo(inX:Float, inY:Float) {
		pathCmds.push(GraphicsPathCommand.MOVE_TO);
		pathData.push(inX);
		pathData.push(inY);
	}

	override public function lineTo(inX:Float, inY:Float) {
		pathCmds.push(GraphicsPathCommand.LINE_TO);
		pathData.push(inX);
		pathData.push(inY);
	}

	override public function curveTo(inCX:Float, inCY:Float, inX:Float, inY:Float) {
		pathCmds.push(GraphicsPathCommand.CURVE_TO);
		pathData.push(inCX);
		pathData.push(inCY);
		pathData.push(inX);
		pathData.push(inY);
	}
}
