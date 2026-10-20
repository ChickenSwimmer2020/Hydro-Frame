package backend.objects.editor;

/**
 * A Sprite that can be moved around, scaled, skewed, and moved around
 * @since 0.10.1
**/
class HAnimatableObject extends HSprite {
	/**
	 * The selected object currently, eg: the one that shows the selection pattern
	 * and has the modifier gizmos
	 * @since 0.10.1
	**/
	public static var selectedObject(default, set):Null<HAnimatableObject> = null;

	public static function set_selectedObject(a:HAnimatableObject):HAnimatableObject { // currently a shell function, will use this to re-render selected pattern and gizmos
		selectedObject = a;
		return a;
	}

	/**
	 * Used while dragging an object
	 * @since 0.10.1
	**/
	public static var heldObject:Null<HAnimatableObject> = null;

	/**
	 * Helper for quickly seeing if we are selected or not
	 * @since 0.10.1
	**/
	public var isSelected(get, never):Bool;

	public function get_isSelected():Bool
		return selectedObject == this;

	/**
	 * For controlling if we need to render the outline again or not
	 * @since 0.10.1
	**/
	public var hasRenderedOutline:Bool = false;

    /**
     * the gizmos that let you modify a sprite.
     * @since 0.10.1
    **/
    public var gizmos:HGroup<HEditorGizmo>;

	/**
	 * Intilize a new HAnimatableObject
	 * @since 0.10.1
	**/
	public function new(x:Float, y:Float) {
		super(x, y);
        gizmos = new HGroup(0, 0);
        addChild(gizmos);
        makeGizmos();


		loadGraphic("assets/images/Procrastination.png"); // this is PURELY for testing purposes.

		Main.instance.addEventListener(MouseEvent.CLICK, onClick);
	}

    function makeGizmos(){ 
        var tlGizmo:HEditorGizmo = new HEditorGizmo(0, 0);

        gizmos.add(tlGizmo);
    }

	function onClick(event:MouseEvent) {
		if (containsMouse()) {
			if (!isSelected){
				selectedObject = this;
                hasRenderedOutline = false;
            }
		} else {
			if (isSelected){
				selectedObject = null;
                hasRenderedOutline = false;

                if(EditorState.currentTool == TRANSFORM) {

                }
            }
		}
	}

	override function onEnterFrame(event:Event) {
        if(!hasRenderedOutline) {
            if(isSelected) {
                gizmos.visible = true;
                this.drawOutline(4,
				    HColor.LOADINGIND_MAINCOLOR); // TODO: get the color for selection out of the UPrefs. and support different outline colors for types
            }else{
                gizmos.visible = false;
                this.removeOutline();
            }
            hasRenderedOutline = true;
        }
	}

	override function destroy() {
		Main.instance.removeEventListener(MouseEvent.CLICK, onClick);
		super.destroy();
	}
}
