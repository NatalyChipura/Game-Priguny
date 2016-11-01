package app.base {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class HelpManager extends MovieClip {
		public const EVT_SKIP_HELP = "onSkipHint";
		
		private var _cntHint:uint = 1;
		private var curHint:uint = 1;
		private var _cntShowHint:uint = 0;
		
		public function HelpManager() {
			// constructor code
			visible = false;
			curHint = 1;
		
			addEventListener(Event.ENTER_FRAME, counterSleep);
			if (this.hint.btnSkip != null) this.hint.btnSkip.addEventListener(MouseEvent.CLICK, skipHint);
			if(this.hint.btnMoreGame!=null) this.hint.btnMoreGame.addEventListener(MouseEvent.CLICK, MoreGames);
		}
		
		public function set cntHint(n:uint):void {
			_cntHint = n;
		}
		
		public function get cntHint():uint {
			return _cntHint;
		}
		
		public function set cntShowHint(n:uint):void {
			if (n <= _cntHint) {
				_cntShowHint = n;
			} else {
				_cntShowHint = _cntHint;
			}
		}
		
		public function get cntShowHint():uint {
			return _cntShowHint;
		}
		
		public function counterSleep(event:Event):void {

			if (this.hint.animHelp.currentFrameLabel == "fr_end") {
				gotoAndPlay("fr_end");
				removeEventListener(Event.ENTER_FRAME, counterSleep);
			}

		}
		
		public function showHint(cntStep:uint,flAnim:Boolean = true):void{
			
			if(cntStep<=cntHint){
				if(flAnim) {
					gotoAndPlay("fr_start");
				}
				
				hint.gotoAndStop(cntStep);
				this.curHint = cntStep;
				
				this.hint.animHelp.gotoAndPlay("fr_start");
				
				this.hint.numPage.text = curHint.toString();
				this.hint.numPage.mouseEnabled = false;
				
				if (curHint == cntShowHint) {
					this.hint.btnNextPage.alpha = 0.5;
					this.hint.btnNextPage.mouseEnabled = false;
				} else {
					this.hint.btnNextPage.alpha = 1;
					this.hint.btnNextPage.mouseEnabled = true;
					this.hint.btnNextPage.addEventListener(MouseEvent.CLICK,goNextPage);
				}
				if (curHint == 1) {
					this.hint.btnPrevPage.alpha = 0.5;
					this.hint.btnPrevPage.mouseEnabled = false;
				} else {
					this.hint.btnPrevPage.alpha = 1;
					this.hint.btnPrevPage.mouseEnabled = true;
					this.hint.btnPrevPage.addEventListener(MouseEvent.CLICK,goPrevPage);
				}
				addEventListener(Event.ENTER_FRAME, counterSleep);
				
				y = 0;
				x = 0;
				visible = true;
			}else{
				visible = false;
			}
		}
		
		private function goNextPage(event:MouseEvent):void {
			curHint++;
			showHint(curHint, false);
		}
		
		private function goPrevPage(event:MouseEvent):void {
			curHint--;
			showHint(curHint, false);
		}
		
		public function skipHint(event:MouseEvent):void {
			gotoAndPlay("fr_end");
			removeEventListener(Event.ENTER_FRAME, counterSleep);
		}
		
		public function hideHint():void {
			visible = false;
			removeEventListener(Event.ENTER_FRAME, counterSleep);
		}
		
		private function MoreGames(event:MouseEvent):void {
			var URL:URLRequest=new URLRequest("http://www.qupigra.com");
			navigateToURL(URL, "_blank");
		}
	}
	
}
