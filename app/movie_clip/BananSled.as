package app.movie_clip {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class BananSled extends MovieClip {
		private const POROG = 100;
		private var cnt:int;
		
		public function BananSled() {
			// constructor code
			var r = Math.ceil(Math.random()*3);
			gotoAndStop(r);
			
			addEventListener(Event.ENTER_FRAME, BananSledEnterFrame);
			
			cnt = 0;
		}
		
		private function BananSledEnterFrame(event:Event):void {
		/*	if (alpha > 0.1) {
				cnt++;
				if (cnt > POROG) {
					alpha -= 0.01;
				}
			} else {
				name = "bananSled.del";
			}*/
		}
	}
	
}
