package  
{
	import org.flixel.*;
	
	public class Coworker extends Character{
		//Embed the resources
		[Embed(source = "../data/Sprites/coworker.png")] private var imgCoworker:Class;
		
		private var level:FlxGroup;

		public function Coworker(x:Number, y:Number, lvl:FlxGroup) {
			super(x, y, null);
			
			level = lvl;
			maxVelocity.x = 40;
			
			//Load the sprite sheet
			loadGraphic(imgCoworker, true, true, 21, 24, false);
			
			//Set up the animations
			var runRight:Array = new Array();
			runRight = [1, 2, 3];
			
			var runLeft:Array = new Array();
			runLeft = [5, 6, 7];

			var idleRight:Array = new Array();
			idleRight = [0];
			
			var idleLeft:Array = new Array();
			idleLeft = [4];
			
			addAnimation("runRight", runRight, 12, false);
			addAnimation("runLeft", runLeft, 12, false);
			addAnimation("idleRight", idleRight, 0, false);
			addAnimation("idleLeft", idleLeft, 0, false);
			
		}
		
		override public function update():void{
			super.update();
			
			if (PlayState.freeze) {
				velocity.x = 0;
				acceleration.x = 0;
			}
			
			else{
				//This if/else if block controls the coworker platform edge detection
				if (dir == "RIGHT" && !overlapsAt(x + width, y + 1, level)) {
					velocity.x = 0;
					acceleration.x = -acceleration.x;
					dir = "LEFT";
				}
				else if (dir == "LEFT" && !overlapsAt(x - width, y + 1, level)) {
					velocity.x = 0;
					acceleration.x = -acceleration.x;
					dir = "RIGHT";
				}
				
				//If the coworker hits a wall they turn around
				if (isTouching(FlxObject.WALL)) {
					
					acceleration.x = -acceleration.x;
					
					if (dir == "RIGHT") {
						dir = "LEFT";
					}
					else if (dir == "LEFT") {
						dir = "RIGHT";
					}
				}
				
				//Play the animations based on the direction that the coworker is facing
				if (dir == "RIGHT") {
					play("runRight");
					
					acceleration.x = maxVelocity.x * 4;
				}
				
				else if (dir == "LEFT") {
					play("runLeft");
					acceleration.x = -maxVelocity.x * 4;
				}
			}
		}
		
	}

}