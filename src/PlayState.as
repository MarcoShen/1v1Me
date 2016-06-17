package
{
	import flash.security.CertificateStatus;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Marco
	 */
	public class PlayState extends FlxState
	{
		/*------------------------------------------------------------------------------------*/
		
		/*						VARIABLES
		
		/*------------------------------------------------------------------------------------*/
		private var map:FlxTilemap;	// the map
		
		private var player:Player;	// first player
		private var player2:Player2;	// second player
		
		private var playerDamage:int = 5;
		private var player2Damage:int = 5;
		
		private var platforms:FlxGroup;	// group of platform
		
		private var bullets:FlxGroup;	// group of bullets
		
		private var timer:FlxTimer;	// flixel timer
		private var sec:int = 0;	// is not in seconds but I just use sec
		
		private var crate:FlxGroup;	// group of crate
		// *** I was intended to make an ammo crate to increase damage, but dont have enough time *** //
		private var cr:FlxSprite = new FlxSprite();	// the crate itself
		private var ammo:FlxSprite = new FlxSprite();	// ammo crate
		private var ammoDropped:Boolean = false;	// dropped ammo?
		private var player1Gun:Boolean = false;	// false = normal, true = shotgun
		private var player2Gun:Boolean = false;
		
		// healthbar player1
		private var frame:FlxSprite = new FlxSprite();
		private var inside:FlxSprite = new FlxSprite();
		private var bar:FlxSprite = new FlxSprite();
		
		// healthbar player2
		private var frame2:FlxSprite = new FlxSprite();
		private var inside2:FlxSprite = new FlxSprite();
		private var bar2:FlxSprite = new FlxSprite();
		
		// Who win?
		public static var win:String = "";
		
		////////////////////////////	VARIABLE END	////////////////////////////
		
		
		
		/*------------------------------------------------------------------------------------*/
		
		/*						CREATE STUFF
		
		/*------------------------------------------------------------------------------------*/
		override public function create():void
		{
			// create background
			var background:FlxSprite = new FlxSprite(0, 0, Assets.ImgBackground);
			add(background);
			
			// convert text map into tile map, 16x16 a tile
			map = new FlxTilemap();
			map.loadMap(new Assets.TxtMap, Assets.ImgMap, 16, 16);	// TxtMap = layout of the map, ImgMap is the tile used
			add(map);
			
			// create the first player
			player = new Player();
			player.health = 100;	// 100 health point
			player.x = 16;	// spawn at the left
			player.y = 16;	// spawn up at the sky to create falling when start
			add(player);
			
			// Same as above
			player2 = new Player2();
			player2.health = 100;	//100 health point
			player2.x = FlxG.width - 16;	//except spawn at the right
			player2.y = 16;	// spawn location
			add(player2);
			
			// create platforms
			platforms = new FlxGroup;
			add(platforms);
			// add the platforms with starting to ending XY coords
			addPlatform(21, 13, 26, 13);
			addPlatform(29, 13, 37, 13);
			
			// add bullets
			bullets = new FlxGroup();
			add(bullets);
			
			// crates
			crate = new FlxGroup();
			add(crate);
			
			// timer
			timer = new FlxTimer();
			timer.start(1, 0, dropCrate);	// count by 1, never loop, call dropCrate()
			
			// health bar //
			// *** The following code was written by Adam Atomic himself in his github FQA section ***//
			// https://github.com/AdamAtomic/flixel/wiki/Flixel-Cheat-Sheet-1:-The-Basics //
			frame = new FlxSprite(4,4);
			frame.makeGraphic(102,10); //White frame for the health bar
			frame.scrollFactor.x = frame.scrollFactor.y = 0;
			add(frame);
			
			inside = new FlxSprite(5,5);
			inside.makeGraphic(100,8,0xff000000); //Black interior, 48 pixels wide
			inside.scrollFactor.x = inside.scrollFactor.y = 0;
			add(inside);

			bar = new FlxSprite(5,5);
			bar.makeGraphic(1,8,0xffff0000); //The red bar itself
			bar.scrollFactor.x = bar.scrollFactor.y = 0;
			bar.origin.x = bar.origin.y = 0; //Zero out the origin
			bar.scale.x = 48; //Fill up the health bar all the way
			add(bar);
			
			// player 2 health bar
			frame2 = new FlxSprite(FlxG.width - 106, 4);
			frame2.makeGraphic(102,10); //White frame for the health bar
			frame2.scrollFactor.x = frame2.scrollFactor.y = 0;
			add(frame2);
			
			inside2 = new FlxSprite(FlxG.width - 105, 5);
			inside2.makeGraphic(100,8,0xff000000); //Black interior, 48 pixels wide
			inside2.scrollFactor.x = inside2.scrollFactor.y = 0;
			add(inside2);

			bar2 = new FlxSprite(FlxG.width - 105, 5);
			bar2.makeGraphic(1,8,0xff0000ff); //The blue bar itself
			bar2.scrollFactor.x = bar2.scrollFactor.y = 0;
			bar2.origin.x = bar2.origin.y = 0; //Zero out the origin
			bar2.scale.x = 100; //Fill up the health bar all the way
			add(bar2);
		}
		
		////////////////////////////	CREATE STUFF END	////////////////////////////
		
		
		/*------------------------------------------------------------------------------------*/
		
		/*						EXECUTE THESE CODE EVERY TICK 
		/*			 			(constantly checking if events happened)
		
		/*------------------------------------------------------------------------------------*/		
		override public function update():void
		{
			super.update();
			
			/*				  */
			/* 	 COLLISIONS   */
			/*				  */		
			
			// player and world collisions
			FlxG.collide(player, map);
			FlxG.collide(player, platforms);
			FlxG.collide(player2, map);
			FlxG.collide(player2, platforms);
			
			// all crates and world collisions
			FlxG.collide(crate, map);
			FlxG.collide(crate, platforms);
			
			// health crate and player collisions (also call functions)
			FlxG.overlap(cr, player, playerGetHealth);
			FlxG.overlap(cr, player2, player2GetHealth);
			
			// ammo crate and player collisions (also call functions)
			FlxG.overlap(ammo, player, playerGetAmmo);
			FlxG.overlap(ammo, player2, player2GetAmmo);
			
			// bullets and player collisions (also call functions)
			FlxG.collide(bullets, player, bulletHitPlayer);
			FlxG.collide(bullets, player2, bulletHitPlayer2);
			
			// bullets and world collisions (also call functions)
			FlxG.collide(bullets, map, bulletCollided);
			FlxG.collide(bullets, platforms, bulletCollided);
			
			// bullets and bullets collisions (also call functions)
			//FlxG.collide(bullets, bullets, bulletHitBullet);	// removed because shotgun will act weird
			
			//////// COLLISION END ////////
			
			
			/*				 */
			/* Shoot bullets */
			/*				 */			
			// here I used justPressed because I dont want players to hold down
			// spacebar and just spam the bullets
			if (FlxG.keys.justPressed("SPACE"))
			{
				// bullet sprite
				var b:FlxSprite = new FlxSprite();
				
				// its behavior
				b.makeGraphic(2, 1, 0xFF000000);	// 1 by 2 pixel bullet
				b.y = player.y + 5;	// adjust the y vaule so it doesnt shoot form his hair lol
				if (player.facing == FlxObject.RIGHT){	// if facing right with speed 200
					b.velocity.x = 200;	// bullets go right
					b.x = player.x + player.width;	// bullet are from the player's right side
				}else{	// if player facing left
					b.velocity.x = -200;	// bullet go wrong (left) with speed 200
					b.x = player.x;	// bullet start from the player's x value (left side)
				}
				bullets.add(b);	//add the sprite
				
				if (player1Gun){
					var d:FlxSprite = new FlxSprite();
					var e:FlxSprite = new FlxSprite();
					d.makeGraphic(2, 1, 0xFF000000);
					e.makeGraphic(2, 1, 0xFF000000);
					d.y = player.y + 5;
					e.y = player.y + 5;
					
					if (player.facing == FlxObject.RIGHT){	// if facing right with speed 200
						d.velocity.x = 200;	// bullets go right
						d.x = player.x + player.width;	// bullet are from the player's right side
						e.velocity.x = 200;	// bullets go right
						e.x = player.x + player.width;	// bullet are from the player's right side
					}else{	// if player facing left
						d.velocity.x = -200;	// bullet go wrong (left) with speed 200
						d.x = player.x;	// bullet start from the player's x value (left side)
						e.velocity.x = -200;	// bullet go wrong (left) with speed 200
						e.x = player.x;	// bullet start from the player's x value (left side)
					}
					// make the two extra bullet go up and go down
					d.velocity.y = 50;
					e.velocity.y = -50;
					bullets.add(d);
					bullets.add(e);
					
				}
			}
			
			// player2 shoot
			if (FlxG.keys.justPressed("ENTER"))
			{
				// bullet sprite
				var c:FlxSprite = new FlxSprite();
				
				// its behavior for player2
				c.makeGraphic(2, 1, 0xFF000000);	// 1 by 2 pixel bullet, white color
				c.y = player2.y + 5;	// adjust the y vaule so it doesnt shoot form his hair lol
				if (player2.facing == FlxObject.RIGHT){	// if facing right with speed 200
					c.velocity.x = 200;	// bullets go right
					c.x = player2.x + player2.width;	// bullet are from the player's right side
				}else{	// if player facing left
					c.velocity.x = -200;	// bullet go wrong (left) with speed 200
					c.x = player2.x;	// bullet start from the player's x value (left side)
				}
				bullets.add(c);	//add the sprite
				
				// if player2 picked up a shotgun
				if (player2Gun){
					var f:FlxSprite = new FlxSprite();
					var g:FlxSprite = new FlxSprite();
					f.makeGraphic(2, 1, 0xFF000000);
					g.makeGraphic(2, 1, 0xFF000000);
					f.y = player2.y + 5;
					g.y = player2.y + 5;
					
					if (player2.facing == FlxObject.RIGHT){	// if facing right with speed 200
						f.velocity.x = 200;	// bullets go right
						f.x = player2.x + player2.width;	// bullet are from the player's right side
						g.velocity.x = 200;	// bullets go right
						g.x = player2.x + player2.width;	// bullet are from the player's right side
					}else{	// if player facing left
						f.velocity.x = -200;	// bullet go (left) with speed 200
						f.x = player2.x;	// bullet start from the player's x value (left side)
						g.velocity.x = -200;	// bullet go (left) with speed 200
						g.x = player2.x;	// bullet start from the player's x value (left side)
					}
					
					// make the two extra bullet go up and go down
					f.velocity.y = 50;
					g.velocity.y = -50;
					bullets.add(f);
					bullets.add(g);
				}
			}
			
			// update the health bar according to player's health
			// so I dont have to update health everytime it changes
			bar.scale.x = player.health;
			bar2.scale.x = player2.health;
			
			// debug
			//trace(sec);
			//trace("Player1's Health: " + player.health);
			//trace("Player2's Health: " + player2.health);dw
		}
		////////////////////////////	UPDATE END	////////////////////////////
		
		
		private function addPlatform(startX:int, startY:int, endX:int, endY:int):void
		{
			// add the platform according to the paramiters
			var platform:FlxSprite = new FlxSprite(startX * 16, startY * 16, Assets.ImgPlatform);
			platform.immovable = true;	// it wont fall if player jump on top
			platforms.add(platform);
			
			//the path of the platform
			platform.followPath(new FlxPath([new FlxPoint(startX * 16 + 8, startY * 16 + 8), new FlxPoint(endX * 16 - 8, endY * 16 + 8)]), 50, FlxObject.PATH_YOYO);
		}
		
		// What happens if bullet collided with the world? //
		private function bulletCollided(b:FlxSprite, a:FlxObject):void
		{
			// remove the bullet sprite
			bullets.remove(b, true);	//remove b from the group
			b = null;
		}
		
		// What happens if bullet hit another bullet? //
		private function bulletHitBullet(b:FlxSprite, c:FlxSprite):void
		{
			// remove bullet from player1
			bullets.remove(b, true);
			b = null;
			// remove bullet from player2
			bullets.remove(c, true);
			c = null;
		}
		
		// What happens if a bullet hit player1? //
		private function bulletHitPlayer(b:FlxSprite, e:FlxObject):void
		{
			bullets.remove(b, true);	// remove bullet
			b = null;
			FlxG.flash(0xffffffff, 0.1);	// flash the screen by a bit
			player.hurt(playerDamage);	// remove health depends if player got crate
			if (player.health <= 0){
				win = "Player2 (Blue) Win!";
				FlxG.switchState(new End());
			}
		}
		
		// What happends if a bullet hit player2? //
		private function bulletHitPlayer2(b:FlxSprite, e:FlxObject):void
		{
			bullets.remove(b, true);	// remove bullet
			b = null;
			FlxG.flash(0xffffffff, 0.1);	// flsah the screen by a bit
			player2.hurt(player2Damage);	// remove health depends if player got crate
			if (player2.health <= 0){
				win = "Player1 (Red) Win!";
				FlxG.switchState(new End());
			}
		}
		
		// This will drop a health crate every 20 seconds
		public function dropCrate(Timer:FlxTimer):void
		{
			var randomX:int;
			
			sec += 1;	// counter
			
			// drop ammo crate at 15 second
			if (sec == 15){
				if (!ammoDropped){
					randomX = FlxG.random() * FlxG.width;	// generate a random X coord
					ammo.loadGraphic(Assets.ImgAmmoCrate, false, false, 16, 16);	// load image
					ammo.x = randomX;	// random ammo x coord drop
					ammo.y = -20;	// drop the ammo crate above the screen
					crate.add(ammo);
					ammoDropped = true;	// set dropped to true so it doesnt drop again
				}
			}
			
			// drop health crate
			if (sec == 20){
				randomX = FlxG.random() * FlxG.width;	// generate a random X coord
				cr.loadGraphic(Assets.ImgHealthBox, false, false,16,16);	// load the graphic
				cr.x = randomX;	// place the crate with the generated coord
				cr.y = -20;	// put the crate outside of the map and fall down slowly, so it doesn't look odd
				crate.add(cr); // add the crate
				sec = 0;	// reset counter to 0, so it drops ever 20 count
			}
			cr.velocity.y = 40;	// drop down speed
			cr.velocity.x = 0;	// very rarely the platform will push the crate, just to make sure
			ammo.velocity.y = 40;
			ammo.velocity.x = 0;
		}
		
		// What happens if player1 touch a health crate? //
		public function playerGetHealth(c:FlxSprite, e:FlxObject):void
		{
			crate.remove(cr, true);	// remove crate
			// make sure health doesnt exceed 100
			if (player.health <= 90){
				player.hurt(-10);	// +10 health
			}else if (player.health > 90 && player.health < 100){
				player.health = 100;
			}
		}
		
		// What happens if player2 touch a health crate? //
		public function player2GetHealth(c:FlxSprite, e:FlxObject):void
		{
			crate.remove(cr, true); //remove crate
			// make sure health doesnt exceed 100
			if (player2.health <= 90){
				player2.hurt(-10);	// +10 health
			}else if (player2.health > 90 && player2.health < 100){
				player2.health = 100;
			}
		}
		
		// What happens if player1 get the ammo crate? //
		public function playerGetAmmo(a:FlxSprite, e:FlxObject):void
		{
			crate.remove(ammo, true);	// remove crate
			player1Gun = true;	// set player picked up shotgun
		}
		
		// What happens of player2 get the ammo crate? //
		public function player2GetAmmo(a:FlxSprite, e:FlxObject):void
		{
			crate.remove(ammo, true);
			player2Gun = true;	// set player2 picked up shotgun
		}
		
	}
}