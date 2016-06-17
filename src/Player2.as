package 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Marco
	 */
	public class Player2 extends FlxSprite
	{
		
		public function Player2() 
		{
			loadGraphic(Assets.ImgPlayer2, true, true, 14, 15);	// load the picture for the player
			acceleration.y = 300;	// gravity, constantly pulling the player down
			
			// animations
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2, 1], 5);
			addAnimation("jump", [3]);
		}
		
		override public function update():void
		{
			super.update();	// update every frames
			velocity.x = 0;	//constantly making velocity 0, so player must press to move
			
			// detect what key being pressed
			var right:Boolean = (FlxG.keys.RIGHT);
			var left:Boolean = (FlxG.keys.LEFT);
			var up:Boolean = (FlxG.keys.UP);
			
			// Movements
			if(touching & DOWN){	// player needs to be touching ground to jump
				if (up) velocity.y =-200;	// make it jump!
				
				if (!left && !right)	// player not moving
				play("idle");	// play animation
				else	// player not moving
				play("walk");	// play animation
				
			}else{	// not touching the ground
				play("jump");	// play animation
			}
			
			if (right){
				velocity.x = 75;	// speed
				facing = RIGHT;	// facing right
				if (x > FlxG.width - width){
					velocity.x = 0;	// not allow to get off the map
				}
			}
			
			if (left){
				velocity.x = -75;	// speed
				facing = LEFT;	// facing left
				if (x < 0){
					velocity.x = 0;	// not allow to get off the map
				}
			}
		}
		
	}

}