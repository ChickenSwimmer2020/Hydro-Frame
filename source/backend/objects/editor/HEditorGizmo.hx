package backend.objects.editor;

class HEditorGizmo extends HSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        makeGraphic(50, 50, HColor.BLACK);
        this.addRect(new Rectangle(25, 25, 25, 25), HColor.WHITE);
    }
}