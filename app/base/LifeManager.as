package app.base {
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class LifeManager extends MovieClip {
		
		public var cntLife:Number;
		private var fillLife:Number;
		
		public function LifeManager(n:uint = 3) {
			// constructor code
			//setFullHeart();
			cntLife = n;
			setCntLife(cntLife);
		}
		
		public function setCntLife(n:Number):void {
			gotoAndStop(n+1);
		}
		
		public function setFullHeart():void{
			setFillLife(100);
			gotoAndStop(cntLife);
		}
		
		public function minusLife():void{
			cntLife--;
			setFullHeart();
		}
		
		public function setFillLife(per:uint):void{
			if(per!=0){
				fillLife = per;
				this.heartBig.fill.scaleY = fillLife/100;
			} else {
				minusLife();
			}
		}
		
		public function setMinusFillLife(per:uint):void{
			fillLife -=per;
			if(fillLife<=0){
				cntLife--;
				heartBig.fill.scaleY = 0;
				if(cntLife>0) setFullHeart();
			} else {
				heartBig.fill.scaleY = fillLife/100;
			}
			
		}
	}
	
}
