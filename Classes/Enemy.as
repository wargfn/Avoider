﻿package Classes{		/*	...	author:wargfn@wargfndev.blogspot.com	*/		import flash.display.MovieClip;		public class Enemy extends MovieClip	{				public var xSpeed:Number;		public var ySpeed:Number;				public function Enemy(startX:Number, startY:Number)		{			xSpeed = ((Math.random() *2) - (Math.random() *2));			ySpeed = Math.random();			x = startX;			y = startY;					}				public function moveABit():void		{						x = x + xSpeed + ((Math.random() * 2) - 1);			y = y + ySpeed + (Math.random() / 10) * (Math.random());					}				public function scoreHit(enemyX:Number, enemyY:Number):void		{			if(enemyX < 0 || enemyX > 400 || enemyY > 300)				{					//removeChild(enemy);					//return true;				}		}			}	}