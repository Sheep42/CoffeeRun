package  
{
	import org.flixel.*;
	public class Level extends FlxTilemap{
		public function Level(level:Class) {
			loadMap(new level, FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
		}
	}

}