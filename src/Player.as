package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class Player extends Character{
		//Embed the resources
		[Embed(source = "../data/Sprites/joe.png")] private var imgJoe:Class;
		[Embed(source = "../data/Sounds/jump.mp3")] private var jumpSound:Class;
		
		//Is the player falling or moving
		public var isFalling:Boolean = true;
		public var isMoving:Boolean = false;
		public var isExcited:Boolean = false;
		
		public function Player(x:Number){
			super(x, 0, null);
						
			//Load the Sprite Sheet
			loadGraphic(imgJoe, true, true, 21, 24, false);			
			health = 100;
			
			//Set up the animations
			var runRight:Array = new Array();
			runRight = [1, 2, 3];
			var runRightExcited:Array = new Array();
			runRightExcited = [5, 6, 7];
			
			var runLeft:Array = new Array();
			runLeft = [9, 10, 11];
			var runLeftExcited:Array = new Array();
			runLeftExcited = [13, 14, 15];
			
			var idleRight:Array = new Array();
			idleRight = [0];
			var idleRightExcited:Array = new Array();
			idleRightExcited = [4];
			
			var idleLeft:Array = new Array();
			idleLeft = [8];
			var idleLeftExcited:Array = new Array();
			idleLeftExcited = [12];
			
			var jumpRight:Array = new Array();
			jumpRight = [19];
			var jumpRightExcited:Array = new Array();
			jumpRightExcited = [18];

			var jumpLeft:Array = new Array();
			jumpLeft = [17];
			var jumpLeftExcited:Array = new Array();
			jumpLeftExcited = [16];
			
			addAnimation("runRight", runRight, 12, false);
			addAnimation("runRightExcited", runRightExcited, 12, false);
			
			addAnimation("runLeft", runLeft, 12, false);
			addAnimation("runLeftExcited", runLeftExcited, 12, false);
			
			addAnimation("idleRight", idleRight, 0, false);
			addAnimation("idleRightExcited", idleRightExcited, 0, false);
			
			addAnimation("idleLeft", idleLeft, 0, false);
			addAnimation("idleLeftExcited", idleLeftExcited, 0, false);
			
			addAnimation("jumpRight", jumpRight, 0, false);
			addAnimation("jumpRightExcited", jumpRightExcited, 0, false);
			
			addAnimation("jumpLeft", jumpLeft, 0, false);
			addAnimation("jumpLeftExcited", jumpLeftExcited, 0, false);
		}
		
		override public function update():void {
			super.update();
			
			drag.x = maxVelocity.x * 6;
			acceleration.x = 0;
			
			//If the playstate is frozen the player freezes
			if (PlayState.freeze) {
				maxVelocity.y = 0;
				velocity.x = 0;
				isFalling = false;
				isMoving = false;
			}
			
			else {
				maxVelocity.y = 250;
								
				//If the player is not touching the floor, he should be falling
				if (!isTouching(FlxObject.FLOOR)) {
					isFalling = true;
				}

				//If the player is falling, play the jump animation
				if (isFalling) {
					if (dir == "RIGHT") {
						if (isExcited) play("jumpRightExcited");
						else play("jumpRight");
					}
					if(dir == "LEFT") {
						if (isExcited) play("jumpLeftExcited");
						else play("jumpLeft");
					}
				}
				
				//If the player is not falling and not moving he should be idle
				if (!isFalling && !isMoving) {
					if (dir == "RIGHT") {
						if (isExcited) play("idleRightExcited");
						else play("idleRight");
					}
					
					if (dir == "LEFT") { 
						if (isExcited) play("idleLeftExcited");
						else play("idleLeft");
					}
				}
				
				//Handle movements
				if (FlxG.keys.LEFT) { 
					dir = "LEFT";
					isMoving = true;
					acceleration.x = -maxVelocity.x * 6;
					
					if(!isFalling){
						if (isExcited) play("runLeftExcited");
						else  play("runLeft");
					}
				}
				
				else if (FlxG.keys.RIGHT) { 
					dir = "RIGHT";
					isMoving = true;
					acceleration.x = maxVelocity.x * 6;
					
					if (!isFalling) {
						if (isExcited) play("runRightExcited");
						else play("runRight");
					}
				}
				
				//If a key has just been released the player is not moving anymore
				if (FlxG.keys.justReleased("RIGHT")) {
					if (isMoving) isMoving = false;
				}
				
				if (FlxG.keys.justReleased("LEFT")) {
					if (isMoving) isMoving = false;
				}
				
				//Handle Jumping
				if (FlxG.keys.justPressed("SPACE") && isTouching(FlxObject.FLOOR)) {
					trace(-maxVelocity.y / 2);
					velocity.y = -maxVelocity.y / 2;
					FlxG.play(jumpSound);
					isFalling = true;
				}
				
			}
		}
	}

}