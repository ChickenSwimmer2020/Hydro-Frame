package backend.utils;

import openfl.display.Bitmap;

/**
 * Drawing util, used mostly for adding icons to Buttons
 * @since 0.1.0
 */
class DrawUtil {
	/**
	 * Draw a rectangle onto the given `HSprite`.
	 * This is not persistent, as it will be cleared on every `loadGraphic()`, `makeGraphic()`,
	 *  `reRenderMakeGraphic()`, and `applyLocalFilter()`.
	 * 
	 * @param spr The sprite to draw the rectangle on.
	 * @param rect The rectangle to draw.
	 * @param color The color of the rectangle.
	 * @return `HSprite` This `HSprite`, for chaining.
	 * @since 0.1.0
	 */
	public static function addRect(spr:HSprite, rect:Rectangle, color:HColor):HSprite {
		@:privateAccess
		if(spr._bitmap != null) {
			@:privateAccess
			var bitmap:Bitmap = new Bitmap(new BitmapData(cast rect.width, cast rect.height, true, color));
			bitmap.x = rect.x;
			bitmap.y = rect.y;
			spr.addChild(bitmap);
			spr.clearObjects.push(bitmap);
			spr.reRender();
		}
		return spr;
	}

	/**
	 * draw an icon to  Sprite
	 * 
	 * TODO: support scaling on the icon from the graphic
	 * 
	 * @param spr sprite to draw icon too
	 * @param icon icon to draw
	 * @param thickness line thickness
	 * @param outlineColor outline color
	 * @param fillColor fill color
	 * @return HSprite spr
	 * @since 0.2.0
	 */
	public static function drawIcon(spr:HSprite, icon:String, thickness:Int, outlineColor:HColor, fillColor:HColor):HSprite {
		if (!Reflect.hasField(HDrawableIcons, icon)) {
			trace('Unrecognized icon $icon, aborting!');
			return spr;
		}
		spr.reRenderMakeGraphic();

		var nSpr = new Sprite();
		nSpr.graphics.lineStyle(thickness, outlineColor.rgb ?? HColor.BLACK.rgb, outlineColor.a ?? 1.0); // set line style
		nSpr.graphics.beginFill(fillColor.rgb, fillColor.a);
		for (command in(Reflect.field(HDrawableIcons, icon) : Array<HDrawableIconCommand>)) {
			switch (command.t) {
				case MOVE:
					nSpr.graphics.moveTo(command.a.x, command.a.y);
				case LINE:
					nSpr.graphics.lineTo(command.a.x, command.a.y);
			}
		}
		nSpr.graphics.endFill();
		nSpr.graphics.lineStyle(null, 0, 1); // reset linestyle to default.

		spr.addChild(nSpr);
		spr.clearObjects.push(nSpr);

		return spr;
	}
}

/**
 * draw command style for icons
 * @since 0.2.0
 */
enum HDrawableIconCommandType {
	MOVE;
	LINE;
}

/**
 * drawable icon command.
 * @since 0.2.0
 */
typedef HDrawableIconCommand = {t:HDrawableIconCommandType, a:{x:Float, y:Float}};

/**
	do **NOT** make these manually.
	use the utility.
	accessable in debug build, launch SymbolEditor from the `debug` dropdown on a -debug build
	@since 0.2.0
 */
class HDrawableIcons {
	/**
	 * sound icon
	 * @since 0.2.0
	 */
	public static final SOUND:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 7, y: 5}},
		{t: LINE, a: {x: 7, y: 14}},
		{t: LINE, a: {x: 3, y: 11}},
		{t: LINE, a: {x: 3, y: 8}},
		{t: LINE, a: {x: 7, y: 5}},
		{t: MOVE, a: {x: 9, y: 3}},
		{t: LINE, a: {x: 11, y: 4}},
		{t: LINE, a: {x: 12, y: 7}},
		{t: LINE, a: {x: 12, y: 11}},
		{t: LINE, a: {x: 11, y: 14}},
		{t: LINE, a: {x: 9, y: 16}},
		{t: LINE, a: {x: 10, y: 14}},
		{t: LINE, a: {x: 11, y: 11}},
		{t: LINE, a: {x: 11, y: 7}},
		{t: LINE, a: {x: 10, y: 4}},
		{t: LINE, a: {x: 9, y: 3}},
		{t: MOVE, a: {x: 12, y: 1}},
		{t: LINE, a: {x: 14, y: 2}},
		{t: LINE, a: {x: 16, y: 6}},
		{t: LINE, a: {x: 16, y: 12}},
		{t: LINE, a: {x: 15, y: 15}},
		{t: LINE, a: {x: 12, y: 17}},
		{t: LINE, a: {x: 14, y: 15}},
		{t: LINE, a: {x: 15, y: 12}},
		{t: LINE, a: {x: 15, y: 6}},
		{t: LINE, a: {x: 13, y: 2}},
		{t: LINE, a: {x: 12, y: 1}},
	];

	/**
	 * mute icon
	 * @since 0.2.0
	 */
	public static final MUTE:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 7, y: 5}},
		{t: LINE, a: {x: 7, y: 14}},
		{t: LINE, a: {x: 3, y: 11}},
		{t: LINE, a: {x: 3, y: 8}},
		{t: LINE, a: {x: 7, y: 5}},
		{t: MOVE, a: {x: 9, y: 3}},
		{t: LINE, a: {x: 11, y: 4}},
		{t: LINE, a: {x: 12, y: 7}},
		{t: LINE, a: {x: 12, y: 11}},
		{t: LINE, a: {x: 11, y: 14}},
		{t: LINE, a: {x: 9, y: 16}},
		{t: LINE, a: {x: 10, y: 14}},
		{t: LINE, a: {x: 11, y: 11}},
		{t: LINE, a: {x: 11, y: 7}},
		{t: LINE, a: {x: 10, y: 4}},
		{t: LINE, a: {x: 9, y: 3}},
		{t: MOVE, a: {x: 12, y: 1}},
		{t: LINE, a: {x: 14, y: 2}},
		{t: LINE, a: {x: 16, y: 6}},
		{t: LINE, a: {x: 16, y: 12}},
		{t: LINE, a: {x: 15, y: 15}},
		{t: LINE, a: {x: 12, y: 17}},
		{t: LINE, a: {x: 14, y: 15}},
		{t: LINE, a: {x: 15, y: 12}},
		{t: LINE, a: {x: 15, y: 6}},
		{t: LINE, a: {x: 13, y: 2}},
		{t: LINE, a: {x: 12, y: 1}},
		{t: MOVE, a: {x: 0, y: 20}},
		{t: LINE, a: {x: 1, y: 20}},
		{t: LINE, a: {x: 20, y: 0}},
		{t: LINE, a: {x: 19, y: 0}},
		{t: LINE, a: {x: 0, y: 20}},
		{t: MOVE, a: {x: 0, y: 0}},
		{t: LINE, a: {x: 1, y: 0}},
		{t: LINE, a: {x: 20, y: 20}},
		{t: LINE, a: {x: 19, y: 20}},
		{t: LINE, a: {x: 0, y: 0}},
	];

	/**
	 * window close icon
	 * @since 0.2.0
	 */
	public static final WIN_CLOSE:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 3, y: 3}},
		{t: LINE, a: {x: 16, y: 17}},
		{t: LINE, a: {x: 17, y: 17}},
		{t: LINE, a: {x: 4, y: 3}},
		{t: LINE, a: {x: 3, y: 3}},
		{t: MOVE, a: {x: 17, y: 3}},
		{t: LINE, a: {x: 4, y: 17}},
		{t: LINE, a: {x: 3, y: 17}},
		{t: LINE, a: {x: 16, y: 3}},
		{t: LINE, a: {x: 17, y: 3}},
	];

	/**
	 * window maximize icon
	 * @since 0.2.0
	 */
	public static final WIN_MAX:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 3, y: 3}},
		{t: LINE, a: {x: 3, y: 3}},
		{t: LINE, a: {x: 17, y: 3}},
		{t: LINE, a: {x: 17, y: 17}},
		{t: LINE, a: {x: 3, y: 17}},
		{t: LINE, a: {x: 3, y: 3}},
	];

	/**
	 * window minimize icon
	 * @since 0.2.0
	 */
	public static final WIN_MIN:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 3, y: 7}},
		{t: LINE, a: {x: 3, y: 7}},
		{t: LINE, a: {x: 17, y: 7}},
		{t: LINE, a: {x: 17, y: 14}},
		{t: LINE, a: {x: 3, y: 14}},
		{t: LINE, a: {x: 3, y: 7}},
	];

	/**
	 * .FLA Project Icon
	 * @since 0.3.0
	 */
	public static final FILE_FLASH:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 15, y: 67}},
		{t: LINE, a: {x: 60, y: 67}},
		{t: LINE, a: {x: 60, y: 29}},
		{t: LINE, a: {x: 43, y: 8}},
		{t: LINE, a: {x: 15, y: 8}},
		{t: LINE, a: {x: 15, y: 67}},
		{t: MOVE, a: {x: 17, y: 55}},
		{t: LINE, a: {x: 21, y: 55}},
		{t: LINE, a: {x: 21, y: 38}},
		{t: LINE, a: {x: 26, y: 38}},
		{t: LINE, a: {x: 26, y: 35}},
		{t: LINE, a: {x: 21, y: 35}},
		{t: LINE, a: {x: 21, y: 31}},
		{t: LINE, a: {x: 30, y: 31}},
		{t: LINE, a: {x: 30, y: 27}},
		{t: LINE, a: {x: 17, y: 27}},
		{t: LINE, a: {x: 17, y: 55}},
		{t: MOVE, a: {x: 32, y: 56}},
		{t: LINE, a: {x: 42, y: 56}},
		{t: LINE, a: {x: 42, y: 53}},
		{t: LINE, a: {x: 36, y: 53}},
		{t: LINE, a: {x: 36, y: 27}},
		{t: LINE, a: {x: 32, y: 27}},
		{t: LINE, a: {x: 32, y: 56}},
		{t: MOVE, a: {x: 44, y: 56}},
		{t: LINE, a: {x: 50, y: 26}},
		{t: LINE, a: {x: 56, y: 56}},
		{t: MOVE, a: {x: 48, y: 45}},
		{t: LINE, a: {x: 52, y: 45}},
		{t: LINE, a: {x: 50, y: 37}},
		{t: MOVE, a: {x: 54, y: 56}},
		{t: LINE, a: {x: 52, y: 47}},
		{t: LINE, a: {x: 48, y: 47}},
		{t: LINE, a: {x: 46, y: 56}},
		{t: MOVE, a: {x: 56, y: 56}},
		{t: LINE, a: {x: 54, y: 56}},
		{t: MOVE, a: {x: 46, y: 56}},
		{t: LINE, a: {x: 44, y: 56}},
		{t: MOVE, a: {x: 50, y: 37}},
		{t: LINE, a: {x: 48, y: 45}},
		{t: MOVE, a: {x: 44, y: 56}},
		{t: LINE, a: {x: 50, y: 26}},
		{t: LINE, a: {x: 56, y: 56}},
		{t: MOVE, a: {x: 54, y: 56}},
		{t: LINE, a: {x: 52, y: 47}},
		{t: LINE, a: {x: 48, y: 47}},
		{t: LINE, a: {x: 46, y: 56}},
		{t: MOVE, a: {x: 48, y: 45}},
		{t: LINE, a: {x: 50, y: 37}},
		{t: LINE, a: {x: 52, y: 45}},
		{t: MOVE, a: {x: 17, y: 55}},
		{t: LINE, a: {x: 21, y: 55}},
		{t: LINE, a: {x: 21, y: 38}},
		{t: LINE, a: {x: 26, y: 38}},
		{t: LINE, a: {x: 26, y: 35}},
		{t: LINE, a: {x: 21, y: 35}},
		{t: LINE, a: {x: 21, y: 31}},
		{t: LINE, a: {x: 30, y: 31}},
		{t: LINE, a: {x: 30, y: 27}},
		{t: LINE, a: {x: 17, y: 27}},
		{t: LINE, a: {x: 17, y: 55}},
		{t: MOVE, a: {x: 32, y: 56}},
		{t: LINE, a: {x: 42, y: 56}},
		{t: LINE, a: {x: 42, y: 53}},
		{t: LINE, a: {x: 36, y: 53}},
		{t: LINE, a: {x: 36, y: 27}},
		{t: LINE, a: {x: 32, y: 27}},
		{t: LINE, a: {x: 32, y: 56}},
	];

	/**
	 * .APF Project Icon
	 * @since 0.3.0
	 */
	public static final FILE_HFPF:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 15, y: 67}},
		{t: LINE, a: {x: 60, y: 67}},
		{t: LINE, a: {x: 60, y: 29}},
		{t: LINE, a: {x: 43, y: 8}},
		{t: LINE, a: {x: 15, y: 8}},
		{t: LINE, a: {x: 15, y: 67}},
		{t: MOVE, a: {x: 17, y: 56}},
		{t: LINE, a: {x: 20, y: 56}},
		{t: LINE, a: {x: 24, y: 35}},
		{t: LINE, a: {x: 27, y: 56}},
		{t: LINE, a: {x: 29, y: 56}},
		{t: LINE, a: {x: 24, y: 31}},
		{t: LINE, a: {x: 17, y: 56}},
		{t: MOVE, a: {x: 20, y: 56}},
		{t: LINE, a: {x: 27, y: 56}},
		{t: LINE, a: {x: 26, y: 49}},
		{t: LINE, a: {x: 22, y: 46}},
		{t: MOVE, a: {x: 30, y: 56}},
		{t: LINE, a: {x: 30, y: 31}},
		{t: LINE, a: {x: 40, y: 31}},
		{t: LINE, a: {x: 43, y: 32}},
		{t: LINE, a: {x: 45, y: 35}},
		{t: LINE, a: {x: 45, y: 37}},
		{t: LINE, a: {x: 43, y: 40}},
		{t: LINE, a: {x: 40, y: 42}},
		{t: LINE, a: {x: 33, y: 42}},
		{t: LINE, a: {x: 33, y: 56}},
		{t: LINE, a: {x: 30, y: 56}},
		{t: MOVE, a: {x: 33, y: 35}},
		{t: LINE, a: {x: 33, y: 39}},
		{t: LINE, a: {x: 37, y: 39}},
		{t: LINE, a: {x: 41, y: 38}},
		{t: LINE, a: {x: 41, y: 36}},
		{t: LINE, a: {x: 37, y: 35}},
		{t: LINE, a: {x: 33, y: 35}},
		{t: MOVE, a: {x: 46, y: 56}},
		{t: LINE, a: {x: 46, y: 31}},
		{t: LINE, a: {x: 56, y: 31}},
		{t: LINE, a: {x: 56, y: 36}},
		{t: LINE, a: {x: 49, y: 36}},
		{t: LINE, a: {x: 49, y: 39}},
		{t: LINE, a: {x: 52, y: 39}},
		{t: LINE, a: {x: 52, y: 42}},
		{t: LINE, a: {x: 49, y: 42}},
		{t: LINE, a: {x: 49, y: 56}},
		{t: LINE, a: {x: 46, y: 56}},
		{t: MOVE, a: {x: 30, y: 56}},
		{t: LINE, a: {x: 33, y: 56}},
		{t: LINE, a: {x: 33, y: 42}},
		{t: LINE, a: {x: 40, y: 42}},
		{t: LINE, a: {x: 43, y: 40}},
		{t: LINE, a: {x: 45, y: 37}},
		{t: LINE, a: {x: 45, y: 35}},
		{t: LINE, a: {x: 43, y: 32}},
		{t: LINE, a: {x: 40, y: 31}},
		{t: LINE, a: {x: 30, y: 31}},
		{t: MOVE, a: {x: 49, y: 56}},
		{t: LINE, a: {x: 49, y: 42}},
		{t: LINE, a: {x: 52, y: 42}},
		{t: LINE, a: {x: 52, y: 39}},
		{t: LINE, a: {x: 49, y: 39}},
		{t: LINE, a: {x: 49, y: 36}},
		{t: LINE, a: {x: 56, y: 36}},
		{t: LINE, a: {x: 56, y: 31}},
		{t: LINE, a: {x: 46, y: 31}},
		{t: LINE, a: {x: 46, y: 56}},
		{t: MOVE, a: {x: 33, y: 39}},
		{t: LINE, a: {x: 37, y: 39}},
		{t: LINE, a: {x: 41, y: 38}},
		{t: LINE, a: {x: 41, y: 36}},
		{t: LINE, a: {x: 37, y: 35}},
		{t: LINE, a: {x: 33, y: 35}},
		{t: LINE, a: {x: 33, y: 39}},
		{t: MOVE, a: {x: 17, y: 56}},
		{t: LINE, a: {x: 24, y: 31}},
		{t: LINE, a: {x: 29, y: 56}},
		{t: LINE, a: {x: 27, y: 56}},
		{t: LINE, a: {x: 24, y: 35}},
		{t: LINE, a: {x: 20, y: 56}},
		{t: LINE, a: {x: 17, y: 56}},
		{t: MOVE, a: {x: 20, y: 56}},
		{t: LINE, a: {x: 22, y: 46}},
		{t: MOVE, a: {x: 20, y: 56}},
		{t: LINE, a: {x: 27, y: 56}},
		{t: LINE, a: {x: 26, y: 49}},
		{t: LINE, a: {x: 22, y: 46}},
		{t: LINE, a: {x: 20, y: 56}},
	];

	/**
	 * checkbox check.
	 * @since 0.3.0
	 */
	public static final UICHECK:Array<HDrawableIconCommand> = [
		{t: MOVE, a: {x: 5, y: 10}},
		{t: LINE, a: {x: 10, y: 14}},
		{t: LINE, a: {x: 20, y: 0}},
		{t: LINE, a: {x: 19, y: 0}},
		{t: LINE, a: {x: 10, y: 12}},
		{t: LINE, a: {x: 4, y: 8}},
		{t: LINE, a: {x: 5, y: 10}}
	];
}
