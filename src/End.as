package 
{
	import org.flixel.*;
	import flash.external.ExternalInterface;

	/**
	 * ...
	 * @author Marco
	 */
	public class End extends FlxState
	{
		
		public function End() 
		{
			var t:FlxText;
			t = new FlxText(0, 100, FlxG.width, PlayState.win);
			t.size = 32;
			t.alignment = "center";
			add(t);
		}

	}

}