package
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Marco
	 */
	
	public class Game extends FlxGame
	{
		private const resolution:FlxPoint = new FlxPoint(1280, 1280);	// the game size is 1280x1280
		private const zoom:uint = 2;	// and zoom in 2 times so is 640x640
		private const fps:uint = 60;	// 60 fps
		
		public function Game()
		{
			// launching the game with the above settings
			super(resolution.x / zoom, resolution.y / zoom, PlayState, zoom);
			FlxG.flashFramerate = fps;
		}
	}
}