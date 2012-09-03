﻿/** * DR SUESS INTERACTIVE ANIMATION * --------------------- * VERSION: 0.1 * DATE: 3/9/2012 * AS3 **/package  {	import com.freeactionscript.ParallaxField;	import flash.display.MovieClip;		import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.events.MouseEvent;	import flash.ui.Keyboard	import org.fwiidom.osc.OSCConnection;	import org.fwiidom.osc.OSCConnectionEvent;	import org.fwiidom.osc.OSCPacket;	import Vars;		public class Main extends Vars	{		private var parallaxField:ParallaxField;				// OSC connection settings		private var oscConn:OSCConnection;				private var bg:MovieClip;				public function Main() 		{						// instantiate parallax class			parallaxField = new ParallaxField();						balloonScene.background = bg;			parallaxField.createField(balloonScene);						// add keyboard listeners			stage.addEventListener(KeyboardEvent.KEY_DOWN, onMyKeyDown);			stage.addEventListener(KeyboardEvent.KEY_UP, onMyKeyUp);						oscConn = new OSCConnection(STR_LOCAL_IP, NUM_PORT);			oscConn.addEventListener(OSCConnectionEvent.ON_CONNECT, onConnect);			oscConn.addEventListener(OSCConnectionEvent.ON_CONNECT_ERROR, onConnectError);			oscConn.addEventListener(OSCConnectionEvent.ON_CLOSE, onClose);			oscConn.connect();						oscConn.addEventListener(OSCConnectionEvent.ON_PACKET_IN, onPacketIn);			oscConn.addEventListener(OSCConnectionEvent.ON_PACKET_OUT, onPacketOut);		}				/**		 * Keyboard Handlers		 */		private function onMyKeyDown(event:KeyboardEvent):void		{			switch( event.keyCode )			{				case Keyboard.UP:					parallaxField.upPressed = true;									case Keyboard.DOWN:					parallaxField.downPressed = true;					break;									case Keyboard.LEFT:					parallaxField.leftPressed = true;					break;									case Keyboard.RIGHT:					parallaxField.rightPressed = true;					break;			}						event.updateAfterEvent();		}				private function onMyKeyUp(event:KeyboardEvent):void		{			switch( event.keyCode )			{				case Keyboard.UP:					parallaxField.upPressed = false;									case Keyboard.DOWN:					parallaxField.downPressed = false;					break;									case Keyboard.LEFT:					parallaxField.leftPressed = false;					break;									case Keyboard.RIGHT:					parallaxField.rightPressed = false;					break;			}		}				private function onConnect(evtEvent:OSCConnectionEvent):void {			trace("Connection established");			//Draw a sprite in the middle of the stage and assign a listener			//var btnSendOSC:Sprite = new Sprite();			//btnSendOSC.graphics.beginFill(0x666666);			//var uintWidth:uint = 100;			//var uintHeight:uint = 30;			//btnSendOSC.graphics.drawRect(stage.stageWidth / 2 - uintWidth / 2, stage.stageHeight / 2 - uintHeight / 2, uintWidth, uintHeight);			//btnSendOSC.buttonMode = true;			//btnSendOSC.addEventListener(MouseEvent.CLICK, onSendOSCClick);			//addChild(btnSendOSC);		} 		private function onConnectError(evtEvent:OSCConnectionEvent):void {			trace("Connection error");		}		 		private function onClose(evtEvent:OSCConnectionEvent):void {			trace("Connection closed");		} 		private function onSendOSCClick(evtClick:MouseEvent):void {			//Send the actual OSC packet			oscConn.sendOSCPacket(new OSCPacket("/appled/0/state", [1], STR_REMOTE_IP, NUM_PORT));		}				private function onPacketIn(evtOSC:OSCConnectionEvent):void {			//trace(this + ": onPacketIn: " + evtOSC.data.name + " Data:" + evtOSC.data.data);						var n = evtOSC.data.name;			var a = createArrFromStr(evtOSC.data.data);						//trace(a[0] + " " + a[1]);						if (n == "/accelerometer") {								a[0] = 60 - a[0];				a[1] = a[1] - 60;								parallaxField.accelerometer = a;								/*				if  (a[0] > 100) {						parallaxField.leftPressed = true;						parallaxField.rightPressed = false;											trace("Left");				} else if (a[0] < 20) {						parallaxField.rightPressed = true;						parallaxField.leftPressed = false;						trace("Right");				} else {					parallaxField.rightPressed = false;					parallaxField.leftPressed = false;				}								if  (a[1] < 20) {						parallaxField.upPressed = true;						parallaxField.downPressed = false;											trace("Up");				} else if (a[1] > 100) {						parallaxField.upPressed = false;						parallaxField.downPressed = true;						trace("Down");				} else {					parallaxField.upPressed = false;					parallaxField.downPressed = false;										}				*/			}						if (n== "/mrmr/pushbutton/15/Sunandas-iPad") {								}		}		 		private function onPacketOut(evtOSC:OSCConnectionEvent):void {			trace(this + ": onPacketOut: " + evtOSC.data.name + " " + evtOSC.data.data);		}				function createArrFromStr(s:String) : Array {			var a = s.split(",");			return a;		}			}	}