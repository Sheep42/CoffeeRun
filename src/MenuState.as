package  
{
	import org.flixel.*;
	
	public class MenuState extends FlxState{
		
		[Embed(source = "../data/Music/menu.mp3")] private var menuMusic:Class;
		[Embed(source = "../data/Sounds/coin.mp3")] private var buttonSound:Class;
		private var btnSound:FlxSound;
					
					
		private var title:FlxText;
		private var startButton:FlxButton;
		
		private var started:Boolean = false;
		
		public function MenuState() {
			
			title = new FlxText(80, 80, FlxG.width, "Coffee Run!");
			title.size = 24;
			add(title);
			
			startButton = new FlxButton(125, 130, "Get Coffee!", startGame);
			add(startButton);
			
			FlxG.mouse.show();
		}
		
		override public function create():void {
			FlxG.playMusic(menuMusic);
			
			this.started = false;
			super.create();
		}
		
		override public function update():void {
			if (started == true && !btnSound.active) {
				FlxG.fade(0xFF000000, 2, afterFade);
			}
			super.update();
		}
		
		public function startGame():void {
			if (!started) {
				btnSound = FlxG.play(this.buttonSound, 1, false);
				FlxG.music.fadeOut(2);
			}
			
			this.started = true;
		}
		
		public function afterFade():void {
			FlxG.switchState(new PlayState());
		}
	}

}