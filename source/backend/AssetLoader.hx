package backend;

class AssetLoader {
    public static function getMusic(name:String, ?ext:String="wav"):String return 'assets/audio/music/$name.$ext';
    public static function getSound(name:String, ?ext:String="wav"):String return 'assets/audio/sounds/$name.$ext';
    public static function getImage(name:String, ?ext:String="png"):String return 'assets/images/$name.$ext';
    public static function getIcon(name:String):String return getImage('icons/$name', 'png');
}