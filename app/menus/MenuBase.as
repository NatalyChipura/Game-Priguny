package app.menus {
	
	import flash.display.MovieClip;
	import app.base.Animation;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	
	public class MenuBase extends Animation {
		private var fltGlow:GlowFilter;
		private var fltBlur:BlurFilter;
		
		public function MenuBase() {
			// constructor code
			py = 480;
			
			speed = 150;
			maxSpeed = 200;
			
		//	forceAttractionX = 0.25;
			forceAttractionY = 1;
			
			angle =	ANGLE_DOWN;
			changeLineSpeed();
			
		//	flMove = false;
			fltGlow = new GlowFilter(0xFFFFFF, 1, 2, 5, 2, 100, true);
			fltBlur = new BlurFilter(0, 100, 1);
			
			this.filters = [fltGlow,fltBlur];
		}
		
		override public function playGo():void {
			if (flMove) {
				if (moveToPoint(0, py,1)) {

					this.filters = [];
					flMove = false;
				} else {
					flMove = y < 480;
				}
			}
		}
	}
	
}
