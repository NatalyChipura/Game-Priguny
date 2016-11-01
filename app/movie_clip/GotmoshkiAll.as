package app.movie_clip {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import app.Main;
	import app.base.Core;
	import app.base.Animation;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	public class GotmoshkiAll extends Animation {
		
		public static const EVT_GOTMOSH_CLICK = "GotmoshClick";
		public static const EVT_GOTMOSH_STOP = "GotmoshStop";
		public static const EVT_OTHER_COLOR = "GotmoshOtherColor";
		private var e:Event;
		private var tmCheck:Timer;
		
		public function GotmoshkiAll(n:String) {
			// constructor code
			
			gotoAndStop(n);
			mouseChildren = false;
			
			tmCheck = new Timer(1);
			tmCheck.addEventListener(TimerEvent.TIMER, timerListener);
			tmCheck.start();
			
			
			//addEventListener(Event.ADDED_TO_STAGE, initProperty);
			//addEventListener(MouseEvent.MOUSE_OVER, alphaSet);
			//addEventListener(MouseEvent.MOUSE_OUT, alphaReset);
			
			//	addEventListener(MouseEvent.CLICK,setNext);
			//addEventListener(MouseEvent.CLICK,setGold);
			
		}
		
		/*private function initProperty(event:Event):void {
			px = x;
			py = y;
		}*/
		
		public function timerListener(event:TimerEvent):void {
			checkCollision();
		}
		
		private function alphaSet(event:MouseEvent):void{
			alpha = 0.5;
			
		}
		
		private function alphaReset(event:MouseEvent):void{
			alpha = 1;
		}
		
		private function setGold(event:MouseEvent):void{
			var e:Event = new Event(EVT_GOTMOSH_CLICK,true);
			dispatchEvent(e);
		}
		
		private function setNext(event:MouseEvent):void{
			if(currentFrame<2) {
				nextFrame();
			} else {
				gotoAndStop(1);
			}
		}
		
		private function checkCollision():void{
			try{
				if (Main.wave != null) {
					
					if (this.hit.hitTestObject(Main.wave)) {
					//	this.name = "got.del";
						if(this.pers.currentFrameLabel!="fr_del"){
							//this.removeChild(this.hit)
							this.name = "got.del." + this.name;
							Main.amountGot--;
							Main.massDelGotmosh.push(this);
							e = new Event(EVT_GOTMOSH_STOP,true);
							dispatchEvent(e);
						}
						this.pers.gotoAndStop("fr_del"); 
					}
				}
				
				if(Main.mouseClip!=null && !Main.flChangeColor ){
					if (this.currentFrameLabel != Main.mouseClip.currentFrameLabel.replace("_gold","") && (this.pers.currentFrameLabel != "fr_sneg" && Main.mouseClip.currentFrameLabel.search("fr_gold_sneg")==-1) && Main.banan==null){
						if (this.hitTestPoint(Main.mouseClip.x,Main.mouseClip.y,true) && (this.name!=Main.mouseClip.name)) {
							Main.koeffJump = 1;
							Main.flChangeColor = true;
							
							Main.massDelGotmosh.push(this);
							this.gotoAndStop(Main.mouseClip.currentFrameLabel.replace("_gold","").toString());
							
							e = new Event(EVT_GOTMOSH_STOP,true);
							dispatchEvent(e);
						}
					} else if (this.hit.hitTestObject(Main.mouseClip.hitGold)) {
						
						//if(Main.mouseClip.currentFrameLabel.search("fr_gold_sneg")==-1){
						 	if(this.pers.currentFrameLabel!="fr_sneg"){
								
								
								
								
								if (this.pers.currentFrameLabel != "fr_del") {
									this.name = "got.del." + this.name;
									Main.amountGot--;
									Main.massDelGotmosh.push(this);
								//	this.removeChild(this.hit);
								//	this.hit.x = -100;
									e = new Event(EVT_GOTMOSH_STOP,true);
									dispatchEvent(e);
								}
								this.pers.gotoAndStop("fr_del"); 
								
							} else {
								Main.koeffJump = 1;
								
								
								if (Main.massDelGotmosh[Main.massDelGotmosh.length-1].name != this.name) {
								
									//	this.name = "got.del." + this.name;
									Main.massDelGotmosh.push(this);
								}
								
								e = new Event(EVT_GOTMOSH_STOP,true);
								dispatchEvent(e);
							}
						/*} else {
							trace("sneg");
							this.pers.gotoAndStop("fr_seng");
							Main.massGotmoshSneg.push(this);
							e = new Event(EVT_GOTMOSH_STOP,true);
							dispatchEvent(e);
							
						}*/
						
					}
				}	

					
			} catch(e:Error){
				
			}
		}
		
		override public function playGo():void {
		//	if (flMove) {
			//	checkCollision();
				if(moveToPoint(px, py,1)){
					x = px;
					y = py;
					scaleX = 1;
					
				}
		//	}	
		}
	}
	
}
