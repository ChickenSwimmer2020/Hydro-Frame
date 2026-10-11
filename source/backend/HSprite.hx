package backend;

import openfl.display.Bitmap;
import openfl.display3D.textures.TextureBase;

/**
 * used for creation of local filters
 * @since 0.1.0
 */
typedef ExtraFilterParams = {
	@:optional var colorTransform:Null<HColor>;
	@:optional var offsets:Null<Rectangle>;
}

/**
 * HSprite is the building block of Hydro-Frame, as 90% of classes end up extending this.
 * @since 0.0.0
 */
class HSprite extends Sprite implements IHasAttributes<String, Dynamic> implements IDestroyable {
	/**
	 * attributes, currently only used for dropdowns.
	 * @since 0.2.0
	 */
	public var attributes:Map<String, Dynamic>;

	/**
	 * The array of `DisplayObject` objects that are children of this `HSprite` object that need to be cleared on any re-render.
	 * 
	 * @since 0.8.2
	 */
	public var clearObjects:Array<DisplayObject> = [];

	/**
	 * set an attribute to this object
	 * @param a key
	 * @param b value
	 * @return String
	 * @since 0.2.0
	 */
	public function setAttribute(a:String, b:Dynamic):String {
		attributes.set(a, b);
		return a;
	}

	/**
	 * get an attribute from this object
	 * @param a key
	 * @return Dynamic
	 * @since 0.2.0
	 */
	public inline function getAttribute(a:String):Dynamic
		return attributes.get(a);

	/**
	 * remove an attribute from this object
	 * @param a key
	 * @return Bool return attributes.remove(a)
	 * @since 0.2.0
	 */
	public inline function removeAttribute(a:String):Bool
		return attributes.remove(a);

	/**
	 * Color transform of the Sprite, affects sub-objects as well.
	 * @since 0.2.0
	 */
	public var color(default, set):HColor = HColor.WHITE;

	/**
	 * set the color transform of this sprite
	 * @param c transform
	 * @return HColor
	 * @since 0.2.0
	 */
	public function set_color(c:HColor):HColor {
		color = c;
		trace(c);
		trace('transform: ${HColor.toTransform(c)}');
		transform.colorTransform = HColor.toTransform(c);
		return c;
	}

	/**
	 * scale of the sprite.
	 * @since 0.2.0
	 */
	public var scale(default, set):HPoint = new HPoint(1.0, 1.0);

	/**
	 * should the sprite antialias
	 * @since 0.2.0 
	 */
	public var antialiasing:Bool = true;

	/**
	 * frame width of the sprite
	 * @since 0.2.0
	 */
	public var frameWidth:Float = 0;

	/**
	 * frame height of the sprite
	 * @since 0.2.0
	 */
	public var frameHeight:Float = 0;

	@:noCompletion private var gColor:HColor;
	@:noCompletion private var gWidth:Int = 0;
	@:noCompletion private var gHeight:Int = 0;
	@:noCompletion private var _bitmap:Bitmap = null;
	@:noCompletion private var _bitmapData:BitmapData = null;

	/**
	 * set the scale of the sprite.
	 * @param value scale to set.
	 * @return HPoint
	 * @since 0.2.0
	 */
	public function set_scale(value:HPoint):HPoint {
		@:bypassAccessor scale.x = value.x;
		@:bypassAccessor scale.y = value.y;
		scaleX = value.x;
		scaleY = value.y;
		return scale;
	}

	/**
	 * make a new sprite
	 * @param x position
	 * @param y position
	 * @param graphic image to load
	 * @since 0.0.0
	 */
	public function new(x:Float, y:Float, ?graphic:OneOfThree<String, Image, BitmapData>) {
		super();
		attributes = new Map<String, Dynamic>();
		this.x = 0;
		this.y = 0;
		if (graphic != null)
			loadGraphic(graphic);
		setPosition(x, y);
	}

	/**
	 * make a graphic without loading bitmap data.
	 * @param width width
	 * @param height height
	 * @param color HColor
	 * @return HSprite
	 * @since 0.0.0
	 */
	public function makeGraphic(width:Int, height:Int, color:HColor = HColor.TRANSPARENT):HSprite {
		gColor = color;
		return loadGraphic(new BitmapData(width, height, true, color));
	}

	// ^^^
	// graphics.clear();
	// graphics.beginFill(color.rgb, color.a);
	// graphics.drawRect(0, 0, width, height);
	// graphics.endFill();
	// gWidth = width;
	// gHeight = height;

	/**
	 * Rerender the current graphic of the sprite.
	 * Only works if the sprite is made with `makeGraphic()`.
	 * 
	 * @return `HSprite` This sprite, for chaining.
	 * @since 0.2.0
	 */
	public function reRenderMakeGraphic():HSprite {
		makeGraphic(gWidth, gHeight, gColor);
		return this;
	}

	/**
	 * Rerender the current graphic of the sprite, and puts it on top.
	 * 
	 * @return `HSprite` This sprite, for chaining.
	 * @since 0.8.0
	 */
	public function reRender():HSprite {
		var highestIdx = 0;
		if (bitmapIsChild) {
			highestIdx = getChildIndex(_bitmap);
			removeChild(_bitmap);
		}

		for (clearObj in clearObjects)
			if (highestIdx < getChildIndex(clearObj))
				highestIdx = getChildIndex(clearObj);

		_bitmap = new Bitmap(_bitmapData, null, antialiasing);
		addChildAt(_bitmap, highestIdx);
		bitmapIsChild = true;

		return this;
	}

	var bitmapIsChild:Bool = false;

	/**
	 * load a graphic
	 * @param graphic graphic to make 
	 * @param takeOwnership no clue what this does :/
	 * @return HSprite
	 * @since 0.0.0
	 */
	public function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):HSprite {
		// dispose previous bitmap if we own it
		if (_bitmapData != null) {
			_bitmapData.dispose();
			_bitmapData = null;
		}
		// graphics.clear();

		var Graphics:BitmapData = new BitmapData(1, 1, false, HColor.WHITE);
		switch (Type.getClass(graphic)) {
			case String:
				Graphics = Assets.getBitmapData(graphic);
				_bitmapData = Graphics; // we own this, so we dispose it later
			case Image:
				Graphics = BitmapData.fromImage(graphic);
				_bitmapData = Graphics;
			case BitmapData:
				Graphics = graphic; // caller owns this, so we dont dispose it
				if (takeOwnership)
					_bitmapData = Graphics; // sprite auto-disposes later i guess
		}

		var oldIdx = 0;
		if (bitmapIsChild) {
			oldIdx = getChildIndex(_bitmap);
			removeChild(_bitmap);
		}

		for (clearObj in clearObjects)
			removeChild(clearObj);

		_bitmap = new Bitmap(Graphics, null, antialiasing);
		addChildAt(_bitmap, oldIdx);
		bitmapIsChild = true;

		// graphics.beginBitmapFill(Graphics, new Matrix(), false, antialiasing);
		// graphics.drawRect(0, 0, Graphics.width, Graphics.height);
		// graphics.endFill();
		frameWidth = Graphics.rect.width;
		frameHeight = Graphics.rect.height;
		gWidth = Math.floor(Graphics.rect.width);
		gHeight = Math.floor(Graphics.rect.height);
		return this;
	}

	/**
	 * change the color of the sprite background without affecting sub-objects (hopefully)
	 * @param color HColor
	 * @return HSprite
	 * @since 0.2.0
	 */
	public function setGraphicColor(color:HColor):HSprite {
		makeGraphic(gWidth, gHeight, color);
		return this;
	}

	/**
	 * Center the sprite on the screen
	 * @return HSprite
	 * @since 0.2.0
	 */
	public function screenCenter():HSprite {
		x = Main.pWidth / 2 - width / 2;
		y = Main.pHeight / 2 - height / 2;
		return this;
	}

	/**
	 * change the graphic size.
	 * @param width 
	 * @param height 
	 * @since 0.0.0
	 */
	public function setGraphicSize(width:Float, height:Float) {
		if (width <= 0 && height <= 0)
			return;
		var newScaleX:Float = width / frameWidth;
		var newScaleY:Float = height / frameHeight;
		scale = new HPoint(newScaleX, newScaleY);
		if (width <= 0)
			scale.x = newScaleY;
		else if (height <= 0)
			scale.y = newScaleX;
		gWidth = Math.floor(width);
		gHeight = Math.floor(height);
	}

	/**
	 * set position
	 * @param x 
	 * @param y 
	 * @since 0.0.0
	 */
	public function setPosition(x:Float, y:Float) {
		this.x = x + width / 2;
		this.y = y + height / 2;
	}

	/**
	 * set the position without doing +width/2
	 * @param x 
	 * @param y 
	 * @since 0.4.0
	 */
	public function setPositionRaw(x:Float, y:Float) {
		this.x = x;
		this.y = y;
	}

	/**
	 * self explanitory.
	 * @since 0.0.0
	 */
	public function destroy() {
		// graphics.clear();
		// dispose our bitmap if we own it
		if (_bitmapData != null) {
			_bitmapData.dispose();
			_bitmapData = null;
		}

		if (parent != null)
			parent.removeChild(this);
		if (bitmapIsChild)
			removeChild(_bitmap);
	}

	/**
	 * apply a global filter to the entire sprite.
	 * @param filter 
	 * @return HSprite
	 * @since 0.1.0
	 */
	public function applyFilter(filter:BitmapFilter):HSprite {
		if (filters == null)
			filters = ([] : Array<BitmapFilter>);
		var list = filters.copy(); // filters can be null on some versions, see below
		list.push(filter);
		filters = list; // the assignment is what actually applies it
		trace('Added a global filter to sprite (SPRITE INDEX IN MEMBERS) with a filter index of ${filters.indexOf(filter)}');
		return this;
	}

	/**
	 * Remove a global filter from the sprite
	 * @param index was filter.
	 * @return Bool was the filter removed
	 * @since 0.1.0
	 */
	public function removeGlobalFilter(index:Int):Bool
		return ((filters[index] != null) ? filters.remove(filters[index]) : false);

	/**
	 * Apply a filter to a local area of the sprite
	 * 
	 * TODO: find workaround for removing local baked filters
	 * 
	 * TODO: fix this.
	 * 
	 * @param size rectangle of where to add the filter
	 * @param filter what filter to add
	 * @param extraParams extra parameters
	 * @return HSprite
	 * @since 0.1.0
	 */
	public function applyLocalFilter(size:Rectangle, filter:BitmapFilter, ?extraParams:ExtraFilterParams):HSprite {
		if (_bitmapData == null) {
			trace('applyLocalFilter: sprite does not own its bitmap, skipping');
			return this;
		}

		var region = size.intersection(_bitmapData.rect);
		if (region.width <= 0 || region.height <= 0)
			return this;

		// 1. temporary sprite that shows only the region, moved to (0, 0)
		var src = new Sprite();
		var targetBitmap:BitmapData = _bitmapData.clone();
		if (extraParams != null) {
			if (extraParams.colorTransform != null) {
				targetBitmap.colorTransform(targetBitmap.rect, HColor.toTransform(extraParams.colorTransform));
			}
		}
		src.graphics.beginBitmapFill(targetBitmap, new Matrix(1, 0, 0, 1, -region.x, -region.y), false, true);
		if (extraParams != null && extraParams.offsets != null) {
			src.graphics.drawRect(0
				+ extraParams.offsets.x, 0
				+ extraParams.offsets.y, region.width
				+ extraParams.offsets.width,
				region.height
				+ extraParams.offsets.height);
		} else
			src.graphics.drawRect(0, 0, region.width, region.height);
		src.graphics.endFill();

		// 2. the live filter, the same mechanism that works for you globally
		src.filters = [filter];

		// 3. bake the filtered sprite into a temp bitmap
		var tmp = new BitmapData(Std.int(region.width), Std.int(region.height), true, 0);
		tmp.draw(src);

		// 4. write it back where the region came from
		_bitmapData.copyPixels(tmp, tmp.rect, new Point(region.x, region.y), null, null, true);

		// 5. clean up temporaries
		tmp.dispose();
		src.graphics.clear();
		src.filters = null;

		// 6. redraw this sprite's fill so it shows the new pixels
		var oldIdx = 0;
		if (bitmapIsChild) {
			oldIdx = getChildIndex(_bitmap);
			removeChild(_bitmap);
		}

		for (clearObj in clearObjects)
			removeChild(clearObj);

		_bitmap = new Bitmap(_bitmapData, null, antialiasing);
		addChildAt(_bitmap, oldIdx);
		bitmapIsChild = true;
		// graphics.clear();
		// graphics.beginBitmapFill(_bitmapData, new Matrix(), false, antialiasing);
		// graphics.drawRect(0, 0, _bitmapData.width, _bitmapData.height);
		// graphics.endFill();
		return this;
	}

	/**
	 * check if the sprite contains a point.
	 * @param point point to check.
	 * @return Bool return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint())
	 * @since 0.2.0 
	 */
	public inline function containsPoint(point:HPoint):Bool
		return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint());

	/**
	 * check if the mouse is contained within the object
	 * @return Bool if the mouse is contained
	 * @since 0.2.0
	 */
	public inline function containsMouse():Bool
		return containsPoint(Main.vMouse);

	/**
	 * get the desktop wallpaper to the sprite, windows only for now.
	 * @param maxWidth max width of the graphic
	 * @param maxHeight max height of the graphic
	 * @return BitmapData the desktop wallpaper.
	 * @since 0.1.0
	 */
	public static function getDesktopWallpaper(maxWidth:Int, maxHeight:Int):BitmapData {
		#if windows // TODO: support getting desktop background on MacOS
		var original = BitmapData.fromFile('C:\\Users\\${Sys.getEnv("USERNAME")}\\AppData\\Roaming\\Microsoft\\Windows\\Themes\\TranscodedWallpaper');
		if (original == null)
			return BitmapData.fromFile('assets/images/Background.png');

		// if the bitmap isnt 16:9
		if (!(Math.abs((original.width / original.height) - (16 / 9)) < 0.01))
			return BitmapData.fromFile('assets/images/Background.png');

		var scaleX = maxWidth / original.width;
		var scaleY = maxHeight / original.height;
		var scale = Math.min(scaleX, scaleY);
		var newWidth = Std.int(original.width * scale);
		var newHeight = Std.int(original.height * scale);
		var scaled = new BitmapData(newWidth, newHeight, false, 0);
		var m = new Matrix();
		m.scale(scale, scale);
		scaled.draw(original, m, null, null, null, true);
		original.dispose(); // always dispose the 4k original
		return scaled;
		#end
		return Assets.getBitmapData('assets/images/Background.png'); // return this as a default fallback.
	}
}
