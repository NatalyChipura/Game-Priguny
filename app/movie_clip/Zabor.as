package app.movie_clip {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import app.Main;
	
	public class Zabor extends MovieClip {
		
		
		public function Zabor(n:uint=1) {
			// constructor code
			gotoAndStop(n);
			
			addEventListener(Event.ENTER_FRAME, checkCollision);
		}
		
		private function checkCollision(event:Event):void {
			if (Main.wave != null && this.name != "zabor.del") {
				if (this.hitTestObject(Main.wave)) {
					gotoAndPlay(3);
					this.name = "zabor.del";
					Main.massDelGotmosh.push(this);
				}
			}
			
			if (Main.banan != null && this.name != "zabor.del") {
				if (this.hitTestObject(Main.banan.hit)) {
					gotoAndPlay(3);
					this.name = "zabor.del";
					Main.massDelGotmosh.push(this);
					Main.mouseClip.pers.gotoAndPlay("fr_del");
					Main.mouseClip.name = "got.del" + Main.mouseClip.name;
					Main.amountGot--;
					switch(Main.direction) {
						case Main.DIR_MINUS_Y: { 
							Main.mouseClip.px = this.x;
							Main.mouseClip.py = this.y+Main.CELL_SIZE;
						} break;
						case Main.DIR_PLUS_Y: { 
							Main.mouseClip.px = this.x;
							Main.mouseClip.py = this.y-Main.CELL_SIZE;
						} break;
						case Main.DIR_MINUS_X: { 
							Main.mouseClip.px = this.x+Main.CELL_SIZE;
							Main.mouseClip.py = this.y;
						} break;
						case Main.DIR_PLUS_X: { 
							Main.mouseClip.px = this.x-Main.CELL_SIZE;
							Main.mouseClip.py = this.y;
						} break;
					}

										
					
				}
			}
		}
	}
	
}
