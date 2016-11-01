package app.base {
	
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class GenericDuplicates extends MovieClip{

		public var massObj:Array; 	// массив для дубликатов
		public var lev0:int = 0;  	// счетчик кадров
		public var lev:int;  	// счетчик кадров
		public var step = 200; 		// на каком кадре вставлять новый объект
		public var score = 100;     // очки объекта
				
		public function GenericDuplicates(){
			super();
			massObj=new Array();
			lev = lev0;
			addEventListener(Event.ENTER_FRAME, onMyEnterFrame);
		}
		
		//функция добавляет элемент в массив
		public function addObj(obj) {
			massObj.push(obj);
		}
 
		//функция удаляет элемент из массива
		public function removeObj() {
			var i = massObj.length;
			
			while(i--) {
				if(massObj[i].flRemove) {
					removeChild(massObj[i]);//удалить со сцены
					massObj[i] = null;
					massObj.splice(i, 1);
				}
			}
		}
		
		//функция меняет скорость для объекта
		public function changeSpeedObj(dSpeed) {
			var i = massObj.length;
			while(i--) {
				massObj[i].speed += dSpeed;
				
			}
		}
		
		public function placeObj():void{
	
		}
		
		private function gameOver():void {
			var i = massObj.length;
			while(i--) {
				massObj[i].speed = 0;
			}
		}
		
		public function onMyEnterFrame(event:Event):void {
			try{
				var l = lev++ % step;
				
				if(l == 0 ){//каждый step-й кадр
					lev = lev0;
					placeObj();
				}	
			
				removeObj();
			} catch (e:Error) {
				
			}
		}
		
		public function removeEvent():void {
			removeEventListener(Event.ENTER_FRAME,onMyEnterFrame);
		}
	
		
	}
}