package app.Editor {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	
	public class TableElements extends MovieClip {
		public static const  EVT_SELECT_ELMENT = "onSelectElement";
		
		public function TableElements() {
			// constructor code	
			btnBanan.addEventListener(MouseEvent.MOUSE_MOVE,getElementBanan);
			btnGotBlue.addEventListener(MouseEvent.MOUSE_MOVE,getElementGotBlue);
			btnGotPink.addEventListener(MouseEvent.MOUSE_MOVE,getElementGotPink);
			btnYagodaPink.addEventListener(MouseEvent.MOUSE_MOVE,getElementYagodaPink);
			btnZaborGoriz.addEventListener(MouseEvent.MOUSE_MOVE,getElementZaborGoriz);
			btnZaborVert.addEventListener(MouseEvent.MOUSE_MOVE,getElementZaborVert);
			btnYagodaBlue.addEventListener(MouseEvent.MOUSE_MOVE,getElementYagodaBlue);
			btnEmpty.addEventListener(MouseEvent.MOUSE_MOVE,getElementEmpty);
			btnTeleportPink.addEventListener(MouseEvent.MOUSE_MOVE,getElementTeleportPink);
			btnTeleportBlue.addEventListener(MouseEvent.MOUSE_MOVE,getElementTeleportBlue);
			btnSneg.addEventListener(MouseEvent.MOUSE_MOVE,getElementSneg);
			btnMolnia.addEventListener(MouseEvent.MOUSE_MOVE,getElementMolnia);
			btnBomba.addEventListener(MouseEvent.MOUSE_MOVE,getElementBomba);
			btnYama.addEventListener(MouseEvent.MOUSE_MOVE,getElementYama);
			btnMagnit.addEventListener(MouseEvent.MOUSE_MOVE,getElementMagnit);
			btnEgg.addEventListener(MouseEvent.MOUSE_MOVE,getElementEgg);
		}

		function getElementYama(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Yama");
			
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementBanan(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Banan");
			
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementGotBlue(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_gotBlue");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementGotPink(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_gotPink");
			
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementYagodaPink(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_yagodaPink");
			
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementZaborGoriz(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_zaborGoriz");
			
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementZaborVert(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_zaborVert");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementYagodaBlue(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_yagodaBlue");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementEmpty(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Empty");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementTeleportPink(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_teleportPink");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementTeleportBlue(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_teleportBlue");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementSneg(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Sneg");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementMagnit(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Magnit");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementEgg(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Egg");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementBomba(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Bomba");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
		
		function getElementMolnia(event:MouseEvent):void{
			MovieClip(parent).gotoAndStop("fr_Molnia");
			var e:Event = new Event(EVT_SELECT_ELMENT,true);
			dispatchEvent(e);
		}
			}
			
		}
