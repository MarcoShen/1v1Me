package 
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Marco
	 */
	public class Player extends FlxSprite
	{
		
		public function Player() 
		{
			loadGraphic(Assets.ImgPlayer, true, true, 14, 15); // load the picture for the player
			acceleration.y = 300;	// gravity, constantly pulling the player down
			
			// animations
			addAnimation("idle", [0]);
			addAnimation("walk", [0, 1, 2, 1], 5);
			addAnimation("jump", [3]);
		}
		
		override public function update():void
		{
			super.update();	// update every tick
			velocity.x = 0; //constantly making velocity 0, so player must press to move
			
			// detect what key being pressed
			var right:Boolean = (FlxG.keys.D);
			var left:Boolean = (FlxG.keys.A);
			var up:Boolean = (FlxG.keys.W);
			
			// Movements
			if(touching & DOWN){	// player needs to be touching ground to jump
				if (up) velocity.y =-200;	// make it jump!
				
				if (!left && !right)	// player not moving
				play("idle");	// play animation
				else	//player moving
				play("walk");	//play animation
				
			}else{	// not touching the ground
				play("jump");
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
					velocity.x = 0; // not allow to get off the map
				}
			}
		}

	}

}