package app.Editor {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	
	
	public class EditElementAll extends MovieClip {
		private var tableElement:TableElements;
		
		public function EditElementAll() {
			// constructor code
			addEventListener(MouseEvent.CLICK, tableShow);	
			
		}

		function tableShow(event:MouseEvent):void{
			tableElement = new TableElements();
			tableElement.x = event.target.x;
			tableElement.y = event.target.y;
			parent.setChildIndex(this, parent.numChildren - 1);
		//	parent.mouseEnabled = false;
		//	parent.mouseChildren = false;
			
		//	this.mouseEnabled = true;
		//	this.mouseChildren = true;
			
			tableElement.addEventListener(TableElements.EVT_SELECT_ELMENT, tableHide);
			addChild(tableElement);
		}
		
		function tableHide(event:Event):void {
		/*	this.mouseEnabled = false;
			this.mouseChildren = false;*/
			tableElement.visible = false;
			tableElement.removeEventListener(TableElements.EVT_SELECT_ELMENT, tableHide);
			removeChild(tableElement);
			tableElement  = null;
		}
	}
	
}
