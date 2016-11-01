package app.base {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	
	public class ButtonMenu extends MovieClip {
		private var fltGlowIn, fltGlowOut:GlowFilter;
		
		public function ButtonMenu() {
			// constructor code
			addEventListener(MouseEvent.MOUSE_OVER, activate);
			addEventListener(MouseEvent.MOUSE_OUT, disable);
			
			fltGlowIn = new GlowFilter(0x774B08, 1, 3, 3, 1000, 1, false);			
			fltGlowOut = new GlowFilter(0xFFFF99, 1, 5, 5, 2, 1000, true);			

		}
		
		private function activate(e:MouseEvent) {
			
			this.filters = [fltGlowIn];
		}
		
		private function disable(e:MouseEvent) {
			this.filters = [];

		}
	}
	
}
