package  
{
	import adobe.utils.CustomActions;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PlayState extends FlxState{
		
		//Embed data sources
			
			//Levels
			[Embed(source = "../data/Levels/level-1.txt", mimeType="application/octet-stream")] private var level1:Class;
			[Embed(source = "../data/Levels/level-2.txt", mimeType = "application/octet-stream")] private var level2:Class;

			//Sound Effects
			[Embed(source = "../data/Sounds/powerup.mp3")] public var itemSound:Class;
			
			//Music
			[Embed(source = "../data/Music/level1.mp3")] public var level1Song:Class;
			[Embed(source = "../data/Music/level2.mp3")] public var level2Song:Class;
			
			//Images
			[Embed(source = "../data/Sprites/Items/coffee.png")] public var coffeeImg:Class;
			[Embed(source = "../data/Sprites/Items/termPaper.png")] public var termPaperImg:Class;

		//Level Items
		public var level1Items:Array = [
			["Instructions", "Welcome to Coffee Run!"],
			["Instructions", "You control Joe. Joe needs coffee to work."],
			["Instructions", "Use the arrow keys to move, and space to jump!"],
			["Instructions", "Now go grab the coffees to get energized!"],
			["Coffee", 10, 7],
			["Coffee", 20, 7],
			["Coffee", 26, 10],
			["Coffee", 33, 10],
			["Coffee", 41, 15],
			["Coffee", 48, 15],
			["Coffee", 56, 13],
			["Coffee", 63, 11],
			["Coffee", 68, 8],
			["Coffee", 74, 5],
			["Special", 8, 7, termPaperImg]
		];
		
		public var level2Items:Array = [
			["Instructions", "Awesome job! Now avoid your coworkers and get that coffee!"],
			["Coworker", 30, 35],
			["Coworker", 40, 8],
			["Coworker", 50, 8],
			["Coworker", 60, 40],
			["Coworker", 70, 8],
			["Coffee", 35, 8],
			["Coffee", 53, 8],
			["Coffee", 70, 22],
			["Coffee", 64, 35],
			["Coffee", 45, 38],
			["Coffee", 27, 45],
			["Coffee", 12, 58],
			["Coffee", 25, 66],
			["Coffee", 45, 73],
			["Coffee", 60, 79],
			["Special", 72, 87, termPaperImg]
		];
		
		//Levels
		public var level:Level;
		public static var levelIndex:int = 0;
		
		public var levels:Array = [
			level1, 
			level2
		];
		
		public var levelItems:Array = [
			level1Items,
			level2Items,
		];
			
		public var levelSongs:Array = [
			level1Song,
			level2Song
		];
		
		public var levelEndings:Array = [
			"Now go find your term paper!",
			"Go get the TPS Reports!"
		];
		
		//Sprites
		public var player:Player;
		public var special:FlxSprite;
		private var healthBar:FlxBar;

		//Groups
		public var GUI:FlxGroup = new FlxGroup();
		public var objects:FlxGroup = new FlxGroup();
		public var coworkers:FlxGroup = new FlxGroup();
		public var foreground:FlxGroup = new FlxGroup();
		public var background:FlxGroup = new FlxGroup();
		public var itemsLayer:FlxGroup = new FlxGroup();
		
		//Text
		public var instructionsArray:Array = new Array();
		public var instructions:FlxText;
		public var instructionsIndex:uint;
		public var instructionsBG:FlxSprite;
				
		//State Variables
		public static var freeze:Boolean = false;
		public static var reset:Boolean = false;
		
		//Score
		public var coffeesCollected:uint = 0;
		public var score:FlxText = new FlxText(27, 13, 100, "x "+coffeesCollected);
		public var scoreImg:FlxSprite = new FlxSprite(10, 10, coffeeImg);

		//Constructor
		public function PlayState() {
			add(background);
			add(objects);
			add(coworkers);
			add(foreground);
			add(GUI);
		}
		
		//Runs on state init
		override public function create():void {
			
			if (reset) {
				levelIndex = 0;
				reset = false;
			}
			
			instructionsIndex = 0;
			
			//Set the container's background color
			FlxG.bgColor = 0xffaaaaaa;
			
			//Hide the cursor now that the game has loaded
			FlxG.mouse.hide();
			
			//Fade the screen in from black
			FlxG.flash(0xff000000, 1);
			
			//Start the music
			FlxG.music.loadEmbedded(levelSongs[levelIndex], true, false);
			FlxG.music.fadeIn(10);
						
			//Begin Level creation			
			level = new Level(levels[levelIndex]);
			background.add(level);
			
			//Add itemsLayer
			special = new FlxSprite();
			addObjects();
			
			objects.add(itemsLayer);
			//End Level
			
			FlxG.worldBounds = new FlxRect(0, 0, level.width, level.height);
			
			//Add the score
			scoreImg.scrollFactor.x = scoreImg.scrollFactor.y = 0; //This makes the image have a fixed position
			score.scrollFactor.x = score.scrollFactor.y = 0; //This makes the text have a fixed position
			foreground.add(scoreImg);
			foreground.add(score);
			
			//Create Our Player
			player = new Player(FlxG.width / 2 - 5);
			healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 20, 5, player, "health");
			healthBar.trackParent(0, -8);

			foreground.add(player);
			foreground.add(healthBar);
			
			//Instructions
			instructions = new FlxText(0, FlxG.height / 2, FlxG.width);
			instructions.size = 24;
			instructions.shadow = 0xff000000;
			instructions.alignment = "center";
			instructions.visible = false;
			instructions.scrollFactor.x = instructions.scrollFactor.y = 0;
			
			instructionsBG = new FlxSprite();
			instructionsBG.makeGraphic(level.width, level.height, 0xff333333);
			instructionsBG.alpha = 0.75;
			instructionsBG.visible = false;
			
			GUI.add(instructionsBG);
			GUI.add(instructions);
		}
		
		
		//Runs on game update(Every frame)
		override public function update():void {
			super.update();
			
			//Set up camera
			FlxG.camera.follow(player);
			FlxG.camera.setBounds(0, 0, level.width, level.height);
			
			//Handle overlapping and collision
			FlxG.overlap(objects, player, getItems);
			FlxG.overlap(special, player, levelClear);
			FlxG.overlap(coworkers, player, playerHit);
			
			FlxG.collide(level, player, collideCb);
			FlxG.collide(level, coworkers);
			
			//If the player is flickering, they have been hit less than 1 second ago
			//Therefore we skip the coworker collision detection
			if(!player.flickering){
				FlxG.collide(coworkers, player);
			}
			
			//If the player falls past the end of the level, the level restarts
			if (player.y > level.height){
				FlxG.resetState();
			}
			
			//The player becomes excited after collecting 5 coffees
			if (coffeesCollected >= 5) {
				player.isExcited = true;
			}
			
			//Display the score
			score.text = "x " + coffeesCollected;
			
			//When frozen display instructions and when space or enter is pressed, progress through them
			if (freeze) {
				displayInstructions();
				
				if (FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE") ) {
					instructionsIndex += 1;
					if (instructionsIndex >= instructionsArray.length) {
						freeze = false;
						instructions.visible = false;
						instructionsBG.visible = false;
					}
				}
			}
			
		}
		
		//Callback on collide, used when player collides with the level
		//This function makes the player
		public function collideCb(Background:FlxTilemap, plyr:Player):void {
			if(plyr.isFalling){
				plyr.isFalling = false;
			}
		}
		
		//When the player collects a coffee we remove it, play a sound
		//and check how many coffees are left
		public function getItems(Item:FlxSprite, plyr:Player):void{
			Item.kill();
			FlxG.play(itemSound);
			
			coffeesCollected += 1;
			
			if (itemsLayer.countLiving() == 0){
				special.exists = true;
				instructionsArray[instructionsIndex] = levelEndings[levelIndex];
				freeze = true;
			}
		}
		
		//When the player clears the level move to the next or win the game
		public function levelClear(Special:FlxSprite, plyr:Player):void {
			var sound:FlxSound = FlxG.play(itemSound);
			levelIndex += 1;
			Special.kill();

			if (levelIndex > 1) {
				plyr.kill();
				win();
			}
			else {
				FlxG.fade(0xff000000, 2, FlxG.resetState);
			}
		}	
		
		//Add all of our level objects from our levelItems array
		public function addObjects():void {
			var currItems:Array = levelItems[levelIndex];
			
			for each (var currItem:Array in currItems) {
				var x:uint = currItem[1];
				var y:uint = currItem[2];
				
				if(currItem[0] == "Coffee" || currItem[0] == "coffee"){
					var coffee:FlxSprite = new FlxSprite(x * 8 - 8, y * 8 - 16);
					coffee.loadGraphic(coffeeImg, false, false);
					itemsLayer.add(coffee);
				}
				
				if (currItem[0] == "Special" || currItem[0] == "Special"){
					special = new FlxSprite(x * 8 - 8, y * 8 -16);
					special.loadGraphic(currItem[3], false, false);
					special.exists = false;
					foreground.add(special);
				}
				
				if (currItem[0] == "Instructions" || currItem[0] == "instructions") {
					instructionsArray.push(currItem[1]);
					freeze = true;
				}
				
				if (currItem[0] == "Coworker" || currItem[0] == "coworker") {
					var coworker:Coworker = new Coworker(currItem[1] * 8 - 8, currItem[2] * 8 - 16, background);
					coworkers.add(coworker);
				}
			}
		}
		
		//Function to print instructions on the screen
		public function displayInstructions():void {
			instructions.text = instructionsArray[instructionsIndex];
			instructions.x = FlxG.width - instructions.width;
			instructions.y = FlxG.height / 2 - instructions.height;
			instructions.visible = true;
			instructionsBG.visible = true;
		}
		
		//When the player gets hit we reduce health and cause a 1 second flicker
		public function playerHit(cw:Coworker, plyr:Player):void {
			if(! plyr.flickering && !freeze){
				if (plyr.health > 10){ 
					plyr.health -= 10;
					plyr.flicker(1);
				}
				
				else {
					playerDie();
				}
			}
		}
		
		//When the player is dead we reset the state
		public function playerDie():void {
			FlxG.resetState();
		}
		
		//When the player wins the game switch to the credits state
		public function win():void {
			FlxG.music.stop();
			FlxG.switchState(new CreditState());
		}
	}

}