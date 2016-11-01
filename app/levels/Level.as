package app.levels {
	
	import flash.xml.XMLDocument;
	
	public class Level {
		public const VISIBLE_NO = 0;
		public const VISIBLE_ALPHA = 1;
		public const VISIBLE_YES = 2;
		
		//public var datas:XML;
		public var mxGotmoshki:Array; 
		public var cntPorog;
		public var enemyXML:XML;
		
		
		
		public var LevelNum:uint;
		
		public function Level() {
			cntPorog = 0;
			mxGotmoshki = new Array();			
		}
			
	}
}