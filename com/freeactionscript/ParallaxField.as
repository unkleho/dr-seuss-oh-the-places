﻿/** * Endless Field - Parallax Scrolling * --------------------- * VERSION: 1.0 * DATE: 2/9/2012 * AS3 * BASED ON Endless Starfield from http://www.FreeActionScript.com **/package com.freeactionscript{	import flash.display.MovieClip;	import flash.display.Sprite;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.utils.getDefinitionByName;	import flash.filters.*;	import flash.geom.ColorTransform;	import fl.motion.Color;		public class ParallaxField extends MovieClip	{		// settings & vars		private var acceleration:Number = 2;		private var maxSpeedX = 100;		private var maxSpeedY = 100;				private var starBox:Sprite;		private var starsArray:Array = [];		private var starArrayLength:int;				private static var STAR_SMALL:String = "small";		private static var STAR_NORMAL:String = "normal";		private static var STAR_LARGE:String = "large";				private var pathToContainer:MovieClip;				private var containerX:int;		private var containerY:int;				private var containerWidth:int;		private var containerHeight:int;				private var speedX:Number;		private var speedY:Number;				private var isStarted:Boolean = false;				private var _upPressed:Boolean = false;		private var _downPressed:Boolean = false;		private var _leftPressed:Boolean = false;		private var _rightPressed:Boolean = false;		private var _xy:Array;				private var bg:MovieClip;		private var bgX:int;		private var bgY:int;				private var isContinuous:Boolean = true;				/**		 * Creates Parallax Field		 * 		 * @param	$container		The container that holds all our starfield assets. Must be created and added to stage before being used here.		 * @param	$x				The X position of our starfield.		 * @param	$y				The Y position of our starfield.		 * @param	$width			The width of our starfield.		 * @param	height			The height of our starfield.		 * @param	$numberOfStars	Number of stars to create.		 * @param	$speedX			The initial X speed of our starfield.		 * @param	$speedY			The initial Y speed of our starfield.		 */		public function createField($sceneObject):void		{			trace("ParallaxField:createField");						var obj:Object = $sceneObject;			var $container = obj.container;			var $x = obj.x;			var $y = obj.y;			var $width = obj.width;			var $height = obj.height;			var $numberOfStars = obj.numberOfItems;			var $speedX = obj.speedX;			var $speedY = obj.speedY;			var $isContinuous = obj.isContinuous;			var $bg = obj.bg;									// save property references			pathToContainer = $container;						containerX = $x;			containerY = $y;						containerWidth = $width;			containerHeight = $height;						speedX = $speedX;			speedY = $speedY;						isContinuous = $isContinuous;						if (bg != null) {				bg = $bg;				bgX = bg.x;				bgY = bg.y;			}						// create everything			createStarBox();			//addStars($numberOfStars, "small");			//addStars($numberOfStars, "normal");			addStars($numberOfStars, "large");						// enable			enable();		}				/**		 * Adds stars to star container		 * 		 * @param	$numberOfStars 	Amount of stars to create		 */		public function addStars($numberOfStars:int, $type:String):void		{						trace("Adding stars...");						var newNumberOfStars:Number;			var graphic:String;			var speedModifier:Number;			var ClassReference:Class;						// set star properties			if ($type == STAR_LARGE)			{				graphic =  "StarLarge";				speedModifier = 1;				newNumberOfStars = Math.round($numberOfStars * 1);			}			else if ($type == STAR_NORMAL)			{				graphic = "StarNormal";				speedModifier = .66;				newNumberOfStars = Math.round($numberOfStars * .60);			}			else if ($type == STAR_SMALL)			{				newNumberOfStars = Math.round($numberOfStars * 1);				graphic = "StarSmall";				speedModifier = .33;			}						trace(" type:   " + graphic);			trace(" amount: " + newNumberOfStars);						// run a for loop to create new stars (based on numberOfStars)			var i:int;			for (i = 0; i < newNumberOfStars; i++) 			{				// get class via string name				ClassReference = getDefinitionByName(graphic) as Class;								var scaleModifier = (i/newNumberOfStars) * 0.8;				var randomFrame = Math.ceil(Math.random() * 3);				var myBlur:BlurFilter = new BlurFilter();				myBlur.blurX = (1- scaleModifier) * 5;								myBlur.blurY = (1- scaleModifier) * 5;								// create class				var tempStar:MovieClip = new ClassReference();								/////////////////////////////////								// Tint stars further away white				//tintColor(tempStar, 0xFFFFFF, 1-scaleModifier);				// set random starting position				tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;				tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;								tempStar.scaleX = scaleModifier;				tempStar.scaleY = scaleModifier;								// give the star its own speed modifier				tempStar.speedModifier = speedModifier * scaleModifier;								tempStar.balloon.gotoAndStop(randomFrame);				//tempStar.filters = [myBlur];												// add new star to array that tracks all stars				starsArray.push(tempStar);				var storeX = tempStar.x;				var storeY = tempStar.y;				starsArray[i].sx = storeX;				starsArray[i].sy = storeY;								// add to display list				pathToContainer.addChild(tempStar);			}						trace("Stars Added \n");		}		/**		 * Activates parallax effect		 */		public function enable():void		{			if (!isStarted)			{				trace("Starting parallax effect...");				isStarted = true;								// add enter frame				pathToContainer.addEventListener(Event.ENTER_FRAME, gameLoop);			}			else			{				trace("Parallax effect already running.");			}					}				/**		 * Disables parallax effect		 */		public function disable():void		{			if (isStarted)			{				trace("Stopping parallax effect...");				isStarted = false;								// remove enter frame				pathToContainer.removeEventListener(Event.ENTER_FRAME, gameLoop);			}			else			{				trace("Parallax effect is not running.");			}					}				/**		 * key press getters and setters		 */		public function get upPressed():Boolean { return _upPressed; }				public function set upPressed(value:Boolean):void 		{			_upPressed = value;		}				public function get downPressed():Boolean { return _downPressed; }				public function set downPressed(value:Boolean):void 		{			_downPressed = value;		}				public function get leftPressed():Boolean { return _leftPressed; }				public function set leftPressed(value:Boolean):void 		{			_leftPressed = value;		}				public function get rightPressed():Boolean { return _rightPressed; }				public function set rightPressed(value:Boolean):void 		{			_rightPressed = value;		}				public function get accelerometer():Array { return _xy; }				public function set accelerometer(value:Array):void 		{			_xy = value;		}				/*************************************************************************/				/**		 * @private		 * Creates a star container		 */		private function createStarBox():void		{			trace("Creating star container...");			trace(" path:   " + pathToContainer);			trace(" x:      " + containerX);			trace(" y:      " + containerY);			trace(" width:  " + containerWidth);			trace(" height: " + containerHeight);		}				/**		 * @private 		 * This function is executed every frame.		 */		private function gameLoop(event:Event):void 		{						updateSpeed();			updateStars();			if (bg != null) {				updateBackground();			}		}				/**		 * @private		 * This function updates the movement speed		 */		private function updateSpeed():void		{			var tSpeedX;			var tSpeedY;						if (upPressed)			{				tSpeedY = speedY - acceleration;				if (tSpeedY > -maxSpeedY) {					speedY = tSpeedY;				}			}			else if (downPressed)			{				tSpeedY = speedY + acceleration;				if (tSpeedY < maxSpeedY) {					speedY = tSpeedY;				}			} else {								if (!isContinuous) 				{					// Deccelerate to full stop 					if (speedY > 0.5) {						speedY -= acceleration;					} else if (speedY < -0.5) {						speedY += acceleration;					} else {						speedY = 0;					}				}			}						if (rightPressed)			{				tSpeedX = speedX + acceleration;				if (tSpeedX < maxSpeedX) {					speedX = tSpeedX;				}			}			else if (leftPressed)			{				tSpeedX = speedX - acceleration;				if (tSpeedX > -maxSpeedX) {					speedX = tSpeedX;				}						} else {				if (!isContinuous) {					// Deccelerate to full stop 					if (speedX > 0.5) {						speedX -= acceleration;					} else if (speedX < -0.5) {						speedX += acceleration;					} else {						speedX = 0;					}				}			}			//trace(speedX);			//trace(speedY);		}				/**		 * @private		 * This function updates all the objects in the stars array		 */		private function updateStars():void		{			// setting the array length variable outside of the for loop improves speed			starArrayLength = starsArray.length;						// setting the "tempStar" variable outside of the for loop improves speed			var tempStar:MovieClip;						// setting the "i" variable outside of the for loop improves speed			var i:int;									var a = accelerometer;									// run for loop						for(i = 0; i < starArrayLength; i++)			{				tempStar = starsArray[i];								tempStar.x += speedX * tempStar.speedModifier;				tempStar.y += speedY * tempStar.speedModifier;								var sy:Number = starsArray[i].sy;				var sx:Number = starsArray[i].sx;								//var yDistance:Number = stageRef.mouseY - y;				//var xDistance:Number = stageRef.mouseX - x;				//var radian:Number = Math.atan2(yDistance, xDistance);				//rotation = radian * 180 / Math.PI;	 				if (a != null) {									tempStar.x = tempStar.x - (((tempStar.x - a[0]*3 - sx) / 7)*tempStar.speedModifier) ;	//easing					tempStar.y = tempStar.y - (((tempStar.y - a[1]*3 - sy) / 7)*tempStar.speedModifier) ; 	//easing				}								if (i == starArrayLength - 1) {					//trace(tempStar.x, tempStar.y, speedX, speedY, starsArray[i].sy);										//trace(a[0],a[1]);				}								//Star boundres				//check X boudries				if (!isContinuous) 				{					if (tempStar.x >= containerWidth - tempStar.width + containerX) 					{						//outside right boundry, move to other side of container						tempStar.x = containerX;						tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;						starsArray[i].sx = tempStar.x;						starsArray[i].sy = tempStar.y;											}					else if (tempStar.x <= containerX) 					{						//outside boundry, move to other side of container						tempStar.x = containerWidth + containerX - tempStar.width;						tempStar.y = (Math.random() * (containerHeight - tempStar.height)) + containerY;						starsArray[i].sx = tempStar.x;						starsArray[i].sy = tempStar.y;					}										//check Y boudries					else if (tempStar.y >= containerHeight - tempStar.height + containerY)					{						//outside boundry, move to other side of container						tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;						tempStar.y = containerY;						starsArray[i].sy = tempStar.y;						starsArray[i].sx = tempStar.x;					}					else if (tempStar.y <= containerY) 					{						//outside boundry, move to other side of container						tempStar.x = (Math.random() * (containerWidth - tempStar.width)) + containerX;						tempStar.y = containerHeight + containerY - tempStar.height;						starsArray[i].sy = tempStar.y;						starsArray[i].sx = tempStar.x;					}				}			}		}						private function updateBackground():void		{			var mc:MovieClip = bg;			var speedModifier = 0.2;						var a = accelerometer;						//mc.x += speedX * mc.speedModifier;			//mc.y += speedY * mc.speedModifier;						if (a != null) {				var sy:Number = bgY;				var sx:Number = bgX;				mc.x -= (((mc.x - a[0]*3 - sx) / 7)*speedModifier) ;	//easing				mc.y -= (((mc.y - a[1]*3 - sy) / 7)*speedModifier) ; 	//easing			}		}				private function tintColor(mc:MovieClip, colorNum:Number, alphaSet:Number):void {			var cTint:Color = new Color();			cTint.setTint(colorNum, alphaSet);			mc.transform.colorTransform = cTint;		}			}	}