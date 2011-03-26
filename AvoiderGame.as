﻿package{		/*	...	author:wargfn@wargfndev.blogspot.com	Main Game Loop		Game Based on Frozen Haddock and Michael James Williams	*/		import flash.display.MovieClip;	import flash.utils.Timer;	import flash.events.TimerEvent;	import flash.text.TextField;	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.media.SoundChannel;		import Classes.Enemy;	import Classes.Avatar;	import Classes.PixelPerfectCollisionDetection;		public class AvoiderGame extends MovieClip	{				public var army:Array;		public var avatar:Avatar;		public var gameTimer:Timer;		public var playScreen:AvoiderGame;		public var useMouseControl:Boolean;		public var downKeyIsBeingPressed:Boolean;		public var upKeyIsBeingPressed:Boolean;		public var leftKeyIsBeingPressed:Boolean;		public var rightKeyIsBeingPressed:Boolean;		public var mKeyIsBeingPressed:Boolean;		public var soundOn:Boolean;				public var backgroundMusic:BackgroundMusic;		public var bgmSoundChannel:SoundChannel;	//bgm for BackGround Music		public var enemyAppearSound:EnemyAppearSound;		public var sfxSoundChannel:SoundChannel;	//sfx for Sound FX				public function AvoiderGame()		{			/* Originally used to display the			background, but it seems that it was unneeded			playScreen = new PlayScreen();			playScreen.x = 0;			playScreen.y = 0;			addChild(playScreen); */			//setting up to use mouse			useMouseControl = false;			downKeyIsBeingPressed = false;			upKeyIsBeingPressed = false;			leftKeyIsBeingPressed = false;			rightKeyIsBeingPressed = false;			soundOn = true;						backgroundMusic = new BackgroundMusic();			bgmSoundChannel = backgroundMusic.play();			bgmSoundChannel.addEventListener( Event.SOUND_COMPLETE, onBackgroundMusicFinished );			enemyAppearSound = new EnemyAppearSound();						army = new Array();			//pushing one starting enemy just to be sure			var newEnemy = new Enemy(100, -15);			army.push(newEnemy);			addChild(newEnemy);									avatar = new Avatar();			addChild(avatar);						if(useMouseControl == true)			{				avatar.x = mouseX;				avatar.y = mouseY;			}			else			{				avatar.x = 200;				avatar.y = 250;			}						gameTimer = new Timer( 25 );			gameTimer.addEventListener(TimerEvent.TIMER, onTick);			gameTimer.start();						addEventListener( Event.ADDED_TO_STAGE, onAddToStage );			addEventListener( MouseEvent.CLICK, onMouseClick );								}				public function getFinalScore():Number		{			return gameScore.currentValue;		}				public function getFinalClockTime():Number		{			return gameClock.currentValue;		}				public function onTick(timerEvent:TimerEvent):void		{						gameClock.addToValue(25);						if ( Math.random() < 0.1)			{								var randomX:Number = Math.random() * 400;				var newEnemy:Enemy = new Enemy(randomX, -15);				army.push(newEnemy);				addChild(newEnemy);				gameScore.addToValue(10);				//trace(randomX.toString());				if (soundOn == true)				{					sfxSoundChannel = enemyAppearSound.play();				}						}						var avatarHasBeenHit:Boolean = false;						for each (var enemy:Enemy in army)			{								enemy.moveABit();				if( enemy.x > (400 - (enemy.width / 2)))				{					enemy.x = (400 - (enemy.width / 2));					enemy.xSpeed = -(enemy.xSpeed);				}				else if ( enemy.x < (0 + (enemy.width / 2)))				{					enemy.x = ( 0 + (enemy.width / 2));					enemy.xSpeed = -(enemy.xSpeed);				}																					//Old BOX based collions				//if(avatar.hitTestObject(enemy))				if ( PixelPerfectCollisionDetection.isColliding( avatar, enemy, this, true ) )				{									gameTimer.stop();					//dispatchEvent( new AvatarEvent (AvatarEvent.DEAD) );					avatarHasBeenHit = true;								}								//okay wife wants scoring to happen when smiles leave the screen!!				// remember that its either side <0 400> and bottom >300				//so that means rolling through each element in the array one at a time							if(enemy.x < (0 - enemy.width) || enemy.x > (400 + enemy.width) || enemy.y > (300 + enemy.height))				{					//playScreen.removeChild(enemy);				}											}									if(avatarHasBeenHit == true)			{								dispatchEvent(new AvatarEvent(AvatarEvent.DEAD));				bgmSoundChannel.stop();				bgmSoundChannel.removeEventListener( Event.SOUND_COMPLETE, onBackgroundMusicFinished );				if (soundOn == true)				{					sfxSoundChannel = enemyAppearSound.play();				}							}						if(useMouseControl == true)			{				avatar.x = mouseX;				avatar.y = mouseY;			}			else			{				//right some controls initially just four directions				//now in eight directions test combo keys first!!!				if (downKeyIsBeingPressed && leftKeyIsBeingPressed)				{					avatar.moveABit( -1, 1, 2);				}				else if (downKeyIsBeingPressed && rightKeyIsBeingPressed)				{					avatar.moveABit(1, 1, 2);				}				else if (upKeyIsBeingPressed && leftKeyIsBeingPressed)				{					avatar.moveABit( -1, -1, 2);				}				else if (upKeyIsBeingPressed && rightKeyIsBeingPressed)				{					avatar.moveABit(1, -1, 2);				}				//old four direction movement				else if ( downKeyIsBeingPressed )				{					avatar.moveABit( 0, 1, 3 );				}				else if ( upKeyIsBeingPressed )				{						avatar.moveABit( 0, -1, 3 );				}				else if ( leftKeyIsBeingPressed )				{					avatar.moveABit( -1, 0, 3 );				}				else if ( rightKeyIsBeingPressed )				{					avatar.moveABit( 1, 0, 3 );				}							}									//Keep Avatar on the Screen			if ( avatar.x < ( avatar.width / 2 ) )			{				avatar.x = avatar.width / 2;			}			if ( avatar.y < ( avatar.height / 2))			{				avatar.y = avatar.height / 2;			}			if ( avatar.x > 400 - avatar.width / 2 )			{				avatar.x = 400 - avatar.width / 2;			}			if ( avatar.y > 300 - avatar.height / 2)			{				avatar.y = 300 - avatar.height / 2;			}		}				public function onMouseClick( mouseClick:MouseEvent ):void		{			if ( useMouseControl == false)			{				useMouseControl = true;			}			else			{				useMouseControl = false;			}					}				public function onKeyPress(keyboardEvent:KeyboardEvent):void		{						if ( keyboardEvent.keyCode == Keyboard.DOWN )			{				downKeyIsBeingPressed = true;			}			else if ( keyboardEvent.keyCode == Keyboard.UP )			{				upKeyIsBeingPressed = true;			}			else if ( keyboardEvent.keyCode == Keyboard.LEFT )			{				leftKeyIsBeingPressed = true;			}			else if ( keyboardEvent.keyCode == Keyboard.RIGHT )			{				rightKeyIsBeingPressed = true;			}			else if ( keyboardEvent.keyCode == 77 )			{				mKeyIsBeingPressed = true;			}		}				public function onKeyRelease(keyboardEvent:KeyboardEvent):void		{						if ( keyboardEvent.keyCode == Keyboard.DOWN )			{				downKeyIsBeingPressed = false;			}			else if ( keyboardEvent.keyCode == Keyboard.UP )			{				upKeyIsBeingPressed = false;			}			else if ( keyboardEvent.keyCode == Keyboard.LEFT )			{				leftKeyIsBeingPressed = false;			}			else if ( keyboardEvent.keyCode == Keyboard.RIGHT )			{				rightKeyIsBeingPressed = false;			}			else if ( keyboardEvent.keyCode == 77 )			{				mKeyIsBeingPressed = false;				soundMusicOnOff(keyboardEvent);			}					}				public function onAddToStage( event:Event ):void		{			stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyPress );			stage.addEventListener( KeyboardEvent.KEY_UP, onKeyRelease );		}				public function onBackgroundMusicFinished( event:Event):void		{						bgmSoundChannel = backgroundMusic.play();			bgmSoundChannel.addEventListener( Event.SOUND_COMPLETE, onBackgroundMusicFinished );					}		public function soundMusicOnOff (event:KeyboardEvent):void		{			if (soundOn == true)			{				bgmSoundChannel.stop();				bgmSoundChannel.removeEventListener( Event.SOUND_COMPLETE, onBackgroundMusicFinished );								soundOn = false;			}			else 			{				bgmSoundChannel = backgroundMusic.play();				bgmSoundChannel.addEventListener( Event.SOUND_COMPLETE, onBackgroundMusicFinished );								soundOn = true;			}						}			}	}