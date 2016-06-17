package 
{
	
	/**
	 * ...
	 * @author Marco
	 */
	public class Assets 
	{
		// background
		[Embed(source = "../bin/assets/graphics/background.png")] public static var ImgBackground:Class;
		
		// sound
		[Embed(source = "../bin/assets/sounds/jump.mp3")] public static var Mp3Jump:Class;
		
		// txtmap
		[Embed(source = '../bin/assets/texts/map.txt', mimeType = "application/octet-stream")] public static var TxtMap:Class;
		
		// tiles used in the map
		[Embed(source = "../bin/assets/graphics/map.png")] public static var ImgMap:Class;
		
		// player
		[Embed(source = "../bin/assets/graphics/player.png")] public static var ImgPlayer:Class;
		[Embed(source = "../bin/assets/graphics/player2.png")] public static var ImgPlayer2:Class;
		
		// platform
		[Embed(source = "../bin/assets/graphics/platform.png")] public static var ImgPlatform:Class;
		
		// health box
		[Embed(source = "../bin/assets/graphics/healthBox.png")] public static var ImgHealthBox:Class;
		
		// ammo crate
		[Embed(source = "../bin/assets/graphics/ammo.png")] public static var ImgAmmoCrate:Class;
	}

}