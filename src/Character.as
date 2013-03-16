package  
{
	import org.flixel.*;
	
	public class Character extends FlxSprite{
		//Direction string
		public var dir:String = "RIGHT";
		
		public function Character(x:Number = 0, y:Number = 0, simpleGraphic:Class = null) {
			super(x, y, simpleGraphic);
			
			//Defaults
			maxVelocity.x = 80;
			maxVelocity.y = 250;
			acceleration.y = 200;
			drag.x = maxVelocity.x * 4;
		}
	}

}