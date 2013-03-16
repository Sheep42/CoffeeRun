package  
{
	import org.flixel.*;
	
	public class CreditState extends FlxState{
		
		private var credits:FlxText;
		
		[Embed(source = "../data/Music/credits.mp3")] private var creditsMusic:Class;
		
		public function CreditState() {
			
			//Background color = black
			FlxG.bgColor = 0xff000000;
			
			//Fade in music
			FlxG.music.loadEmbedded(creditsMusic, true, false);
			FlxG.music.fadeIn(10);
			
			//set up the credits
			credits = new FlxText(90, 360, FlxG.width, 
				"Coffee Run!\n\n" +
				"Made by: Dan Shedd\n\n" +
				"Sprites by: Dan Shedd\n\n" +
				"Music by: http://www.playonloop.com/\n"+
				"Based on the EZ Platformer found at http://www.flashgamedojo.com/"
			);
			
			add(credits);
		}
		
		override public function update():void {
			//scroll until the credits are off the screen
			credits.y-=.5;
			if (credits.y + credits.height < 0) {
				FlxG.music.fadeOut(1);
				FlxG.fade(0xff000000, 2, afterFade);
			}
			super.update();
		}
		
		private function afterFade():void {
			PlayState.reset = true;
			FlxG.switchState(new MenuState());
		}
		
	}

}