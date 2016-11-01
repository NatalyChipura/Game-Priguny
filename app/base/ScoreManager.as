package app.base {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;

	public class ScoreManager extends MovieClip {
		
		public var cntScore:Number = 0;
		public var cntMoney:Number = 0;
		public var scoreFly:MovieClip;
		
		private var fltGlowE1, fltGlowE2, fltGlowE3:GlowFilter;
		private var fltGlowR1, fltGlowR2, fltGlowR3:GlowFilter;
		
		public function ScoreManager() {
			// constructor code
			cntScore = 0;
			cntMoney = 0;
			
			addEventListener(Event.ENTER_FRAME, onScoreEnterFrame);
			scoreFly = new ScoreFly();
			scoreFly.x = -50;
			addChild(scoreFly);
			
			fltGlowE1 = new GlowFilter(0xFF6600, 1, 5, 5, 2, 1, false);			
			fltGlowE2 = new GlowFilter(0xFFCC00, 1, 5, 5, 2, 1, false);			
			fltGlowE3 = new GlowFilter(0xFFFF00, 0.5, 15, 15, 2, 3, false);		
			
			fltGlowR1 = new GlowFilter(0x990000, 1, 5, 5, 2, 1, false);			
			fltGlowR2 = new GlowFilter(0xFF0000, 1, 5, 5, 2, 1, false);			
			fltGlowR3 = new GlowFilter(0xFF0000, 0.5, 15, 15, 2, 3, false);		
			
		}
		
		public function onScoreEnterFrame(event:Event):void {
			cntScore = (cntScore > 0?cntScore:0);
			strScore.text=" "+cntScore+" ";
			cntMoney = (cntMoney > 0?cntMoney:0);
			//strMoney.text=" "+cntMoney+" ";
		}
		
		public function scoreFlyGo(cx:Number, cy:Number, val:Number):void {
			scoreFly.x = cx;
			scoreFly.y = cy;
			
			if (val >= 0) {
				scoreFly.filters = [];
				scoreFly.filters = [ fltGlowE2, fltGlowE3];;
				scoreFly.score.value.text = "+ " + val.toString();
			} else {
				scoreFly.filters = [];
				scoreFly.filters = [ fltGlowR2, fltGlowR3];;
				scoreFly.score.value.text = val.toString();
			}
			scoreFly.gotoAndPlay(1);
		}
	}
	
}
