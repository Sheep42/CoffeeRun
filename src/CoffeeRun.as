package  
{
	
	import org.flixel.*;
	[SWF(width=640, height=480, backgroundColor="#000000")]
	[Frame(factoryClass = "PreLoader")]
	
	public class CoffeeRun extends FlxGame{
		
		public function CoffeeRun(){
			super(320, 240, MenuState, 2);
		}
		
	}

}