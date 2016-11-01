package app.levels {
	
	import flash.display.MovieClip;

	import app.levels.datas.Level_1;
	import app.levels.datas.Level_2;
	import app.levels.datas.Level_3;
	import app.levels.datas.Level_4;
	import app.levels.datas.Level_5;
	import app.levels.datas.Level_6;
	import app.levels.datas.Level_7;
	import app.levels.datas.Level_8;
	import app.levels.datas.Level_9;
	import app.levels.datas.Level_10;
	import app.levels.datas.Level_11;
	import app.levels.datas.Level_12;
	import app.levels.datas.Level_13;
	import app.levels.datas.Level_14;
	
	public class LevelManager extends MovieClip {
		
		public var level:Level; // данные об уровне
		//public  var countEl:uint = 0; // количество игровых предметов
		//public  var Trubs:XMLList;
		public  var field:Field;
		
		public  var curLevelNum:uint=1;
		public  var cntOpenLev:uint = 1;
		public static var cntLevels:uint = 1;
		
		public function LevelManager(n:uint = 1) {
			goLevelNum(n);
		}	
		
		private function getLevelData(level:Level):void {
			
			curLevelNum = level.LevelNum;
			
			//Trubs = level.datas.elements("Truba");
		}
		
		public function goLevelNum(n:uint):void {
			strLevel.text = " "+n+" ";
			level = null;		
			if (n > cntLevels) { n = cntLevels; }
			switch(n){
				case 1: level = new Level_1(); break;
				case 2: level = new Level_2(); break;
				case 3: level = new Level_3(); break;
				case 4: level = new Level_4(); break;
				case 5: level = new Level_5(); break;
				case 6: level = new Level_6(); break;
				case 7: level = new Level_7(); break;
				case 8: level = new Level_8(); break;
				case 9: level = new Level_9(); break;
				case 10: level = new Level_10(); break;
				case 11: level = new Level_11(); break;
				case 12: level = new Level_12(); break;
				case 13: level = new Level_13(); break;
				case 14: level = new Level_14(); break;
			}
			
			getLevelData(level);
		}
		
		public function goLevelNext():void {
			curLevelNum = curLevelNum+1;
			goLevelNum(curLevelNum);
		}
		
		/*public function isLevelComplete():Boolean {
			if (countEl <= 0) {
				return true;
			} else {
				return false;
			}
		}*/
	}
}