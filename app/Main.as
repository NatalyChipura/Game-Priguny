package app {

	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import app.base.Core;
	import app.base.TimeManager;
	import app.grid.GridManager;
	import app.movie_clip.Teleport;
	import app.movie_clip.GotmoshkiAll;
	import app.movie_clip.Zabor;
	import app.movie_clip.Yagoda;
	import app.movie_clip.BananSled;
	import app.Editor.EditElementAll;
	import app.levels.LevelManager;
	import app.base.Navigate;

	
	public class Main extends Core {
		
		public const WIDTH = 640;
		public const HEIGHT = 480;
		
		public static const CELL_SIZE = 23;
		
		public const EL_EMPTY = "0";
		public const EL_WALL = "1";
		public const EL_GOTMOSH = "got";
		public const EL_GOTMOSH_BLUE = "2";
		public const EL_GOTMOSH_PINK = "6";
		public const EL_YAMA = "3";
		public const EL_BOMBA = "4";
		public const EL_TELEPORT = "teleport";
		public const EL_TELEPORT_1 = "t1";
		public const EL_TELEPORT_2 = "t2";
		public const EL_MOLNIA = "5";
		public const EL_EGG = "7";
		public const EL_BANAN = "8";
		public const EL_ZABOR_VERT = "zv";
		public const EL_ZABOR_GORIZ = "zg"
		public const EL_ZABOR = "zabor"
		public const EL_MAGNIT = "9";
		public const EL_YAGODA_BLUE = "yb";
		public const EL_YAGODA_PINK = "yp";
		public const EL_YAGODA = "yagoda";
		public const EL_SNEG = "10";
		
		public static const DIR_MINUS_Y = "1";
		public static const DIR_PLUS_X = "2";
		public static const DIR_PLUS_Y = "3";
		public static const DIR_MINUS_X = "4";
		
		public const CNT_FRAME_SNEG = 500;
		
		private const SCORE_DEFAULT = 100;
				
		private var i:Number;
		private var j:Number;
		
		private var counterSneg:Number;
		private var cntGotOst:Number;
		public static var direction:String;
								
		private var flTimer:Boolean;
		
		private var fieldEdit:MovieClip;
	
	/*	private var sndMedal:SndMedal = null;
		private var sndJump:SndJump = null;
		private var sndBanan:SndBanan = null;*/
		private var sndMedal:Sound = null;
		private var sndJump:Sound = null;
		private var sndBanan:Sound = null;
		private var sndBomba:Sound = null;
		private var sndYama:Sound = null;
		private var sndMolnia :Sound = null;
		private var sndTeleport :Sound = null;
		private var sndIce:Sound = null;
		private var sndMagnit:Sound = null;
		private var sndEgg:Sound = null;
		private var sndYagoda:Sound = null;
		private var sndNea:Sound = null;
		private var sndBonus:Sound = null;
		private var sndUdar:Sound = null;
		private var sndUra:Sound = null;

		public static var mouseClip:MovieClip;
		private var elCheckCell:MovieClip;
		
		private var medals:MovieClip;
		private var grid:GridManager;
		private var krug:Krug;
		public static var wave:MovieClip;
		public static var banan:MovieClip;
		private var telEnter1:Object;
		private var telExit1:Object;
		private var telEnter2:Object;
		private var telExit2:Object;
		
		private var massKrugs:Array;
		private var massMolnia:Array;
		private var massNewGotmosh:Array;
		private var massEmptyCell:Array;
		private var massGotmoshPull:Array;
		public static var massGotmoshSneg:Array;
		public static var massDelGotmosh:Array;
		
		public static var flChangeColor:Boolean;
		public var flNoCheckMove:Boolean;
		private var flSneg:Boolean;
		private var flBomba:Boolean;
		
		private var timeoutYama:uint;
		private var timeoutTeleport:uint;
		private var timeoutMolnia:uint;
		private var timeoutPauseBeforCheck:uint;
		private var timeoutLevelComplete:uint;
		private var timeoutUndel:uint;
		
		public static var koeffJump:uint;
		public static var scoreBonus:uint = 0;
		
		public static var amountGot:uint = 0;

		public function Main() {
			
			nameGame = "Priguni";
			
			super();
			
			sndManager.x = 600;
			sndManager.y = 435;
			
		//	sndManager.volumeFon = 0;
		//	sndManager.volumeMenu = 0;
			
		//	sndManager.soundStop();
			
		//	sndManager.funcSoundOn(null);
		
			helpManager.x = 0;
			helpManager.y = 0;
			
			//addEventListener(navGame.EVT_OPEN_SELLEV_MENU, loadStar);
			
			//addEventListener(navGame.EVT_SELECT_LEVEL, changeMusic);
			
			addEventListener(navGame.EVT_RETURN_GAME, returnChild);
			addEventListener(navGame.EVT_PAUSE, pauseChild);
			addEventListener(EVT_SKIP_HINT, toGame);
			addEventListener(EVT_CANCEL, backStep);
		
			
		//	addEventListener(GotmoshkiAll.EVT_OTHER_COLOR, changeColor);
		
			
			
			LevelManager.cntLevels = Navigate.cntLevels = 14;
			Navigate.cntBtnLevOnPage = 8;
			Navigate.cntBtnLevColMap = 4;
		//	navGame.sx = 215;
			navGame.sx = 170;
			navGame.sy = -370;
			Navigate.pages = Math.ceil(Navigate.cntLevels/Navigate.cntBtnLevOnPage);
			
			grid = new GridManager(20, 27, CELL_SIZE, CELL_SIZE, 40, 40);

			btnEditLevel.addEventListener(MouseEvent.CLICK, EditLevel);
			
			navGame.saveHelpSee(7);
			
		}
		
		private function EditLevel(event:MouseEvent):void{
			
			navGame.delMainMenu();
			addChild(grid);
			addGotmochEdit();
			
		}
		
		
		private function addGotmochEdit():void{
			fieldEdit = new MovieClip();
			addChild(fieldEdit);
			i = grid.cntCol*grid.cntRow;
			while (i--) {
				var cub = new EditElementAll();
				grid.getCoords(i);
				cub.x = grid.colX;
				cub.y = grid.rowY;
				
				fieldEdit.addChild(cub).name = "el."+grid.col+"."+grid.row ;
				
				
				cub = null;
			}
			
			btnPrint.addEventListener(MouseEvent.CLICK, printMX);
			
		}
		
		private function addGotmoch():void{
			i = 0;
			var mc:MovieClip;
			var n = grid.cntCol * grid.cntRow;
			while ( i < n ) {
				grid.getCoords(i);
				switch(lvlManager.level.mxGotmoshki[grid.row][grid.col].toString()) {
					case EL_GOTMOSH_BLUE: {
						mc = new GotmoshkiAll("fr_blue");
						
						mc.x = mc.px = grid.colX;
						mc.y = mc.py = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "got."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
						amountGot++;
					} break;
					case EL_GOTMOSH_PINK: {
						mc = new GotmoshkiAll("fr_pink");
						
						mc.x = mc.px = grid.colX;
						mc.y = mc.py = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "got."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
						amountGot++;
					} break;					
					case EL_YAMA: {
						mc = new Yama();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "yama."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_BOMBA: {
						mc = new Bomba();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "bomba."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_TELEPORT_1: {
						mc = new Teleport(1);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "teleport."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_TELEPORT_2: {
						mc = new Teleport(2);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "teleport."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_MOLNIA: {
						mc = new Molnia();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "molnia."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_EGG: {
						mc = new Egg();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "egg."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_BANAN: {
						mc = new Banan();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "banan."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_ZABOR_VERT: {
						mc = new Zabor(2);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "zabor."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_ZABOR_GORIZ: {
						mc = new Zabor(1);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "zabor."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_MAGNIT: {
						mc = new Magnit();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "magnit."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_YAGODA_BLUE: {
						mc = new Yagoda(1);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "yagoda."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_YAGODA_PINK: {
						mc = new Yagoda(2);
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "yagoda."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
					case EL_SNEG: {
						mc = new Sneg();
						mc.x = grid.colX;
						mc.y = grid.rowY;
					
						lvlManager.field.addChild(mc).name = "sneg."+grid.colX.toString()+"."+grid.rowY;
						mc = null;
					} break;
				}
				i++;
			}
		}
		
		
		
		private function printMX(event:MouseEvent):void{
			var n = grid.cntCol* grid.cntRow;
			var i = 0;
			var str="";
			
			while(i < n){
				grid.getCoords(i);
				
				if(grid.col<grid.cntCol-1){
					
					switch(MovieClip(fieldEdit.getChildByName("el."+grid.col+"."+grid.row)).currentFrameLabel.toString()) {
						case "fr_Empty": {
							str = str + EL_EMPTY;
						}break;
						case "fr_gotBlue": {
							str = str + EL_GOTMOSH_BLUE;
						}break;
						case "fr_gotPink": {
							str = str + EL_GOTMOSH_PINK;
						}break;
						case "fr_Bomba": {
							str = str + EL_BOMBA;
						}break;
						case "fr_Banan": {
							str = str + EL_BANAN;
						}break;
						case "fr_Yama": {
							str = str + EL_YAMA;
						}break;
						case "fr_yagodaBlue": {
							str = str + EL_YAGODA_BLUE;
						}break;
						case "fr_yagodaPink": {
							str = str + EL_YAGODA_PINK;
						}break;
						case "fr_Magnit": {
							str = str + EL_MAGNIT;
						}break;
						case "fr_Egg": {
							str = str + EL_EGG;
						}break;
						case "fr_Molnia": {
							str = str + EL_MOLNIA;
						}break;
						case "fr_Sneg": {
							str = str + EL_SNEG;
						}break;
						case "fr_zaborGoriz": {
							str = str + EL_ZABOR_GORIZ;
						}break;
						case "fr_zaborVert": {
							str = str + EL_ZABOR_VERT;
						}break;
						case "fr_teleportPink": {
							str = str + EL_TELEPORT_1;
						}break;
						case "fr_teleportBlue": {
							str = str + EL_TELEPORT_2;
						}break;
						case "fr_wall": {
							str = str + EL_WALL;
						}break;

					}
					
					//str = str +MovieClip(fieldEdit.getChildAt(i+1)).currentFrame.toString()+ ", ";
					str = str + ", ";
				} else{
					//str = "mxGotmoshki[" + (grid.cntRow - grid.row - 1).toString() +"] = [" + str;
					str = "mxGotmoshki[" + (grid.row).toString() +"] = [" + str;
				//	switch(MovieClip(fieldEdit.getChildAt(i + 1)).currentFrameLabel.toString()) {
					switch(MovieClip(fieldEdit.getChildByName("el."+grid.col+"."+grid.row)).currentFrameLabel.toString()) {
						case "fr_Empty": {
							str = str + EL_EMPTY;
						}break;
						case "fr_gotBlue": {
							str = str + EL_GOTMOSH_BLUE;
						}break;
						case "fr_gotPink": {
							str = str + EL_GOTMOSH_PINK;
						}break;
						case "fr_Bomba": {
							str = str + EL_BOMBA;
						}break;
						case "fr_Banan": {
							str = str + EL_BANAN;
						}break;
						case "fr_Yama": {
							str = str + EL_YAMA;
						}break;
						case "fr_yagodaBlue": {
							str = str + EL_YAGODA_BLUE;
						}break;
						case "fr_yagodaPink": {
							str = str + EL_YAGODA_PINK;
						}break;
						case "fr_Magnit": {
							str = str + EL_MAGNIT;
						}break;
						case "fr_Egg": {
							str = str + EL_EGG;
						}break;
						case "fr_Molnia": {
							str = str + EL_MOLNIA;
						}break;
						case "fr_Sneg": {
							str = str + EL_SNEG;
						}break;
						case "fr_zaborGoriz": {
							str = str + EL_ZABOR_GORIZ;
						}break;
						case "fr_zaborVert": {
							str = str + EL_ZABOR_VERT;
						}break;
						case "fr_teleportPink": {
							str = str + EL_TELEPORT_1;
						}break;
						case "fr_teleportBlue": {
							str = str + EL_TELEPORT_2;
						}break;
						case "fr_wall": {
							str = str + EL_WALL;
						}break;

					}
					str = str + "];";
					trace(str);
					str = "";
					
				}
				i++;
			}
		}
		
		private function toGame(e:Event):void {
		//	wave.gotoAndPlay(1);
			
		}

		private function cnvPause(massChild:Array):void {
			var j = massChild.length;
			while (j--) {
				massChild[j].flPause = true;
			}
		}
		
		private function cnvReturnGame(massChild:Array):void {
			var j = massChild.length;
			while (j--) {
				massChild[j].flPause = false;
			}
		}
		
		private function pauseChild(event:Event):void {
			sndManager.fonMusicStop();
			sndManager.changeVolume(1);
			sndManager.menuMusicPlay();			
		}
		
		private function returnChild(event:Event):void {
			
			if (navGame.stateGame != navGame.STATE_GAME_HELP ) {
				sndManager.menuMusicStop();
				sndManager.changeVolume(1);
				sndManager.fonMusicPlay();
			}
			
		}
		
		
		
		override public function initGameObj():void {
			
			navGame.cntMedals = 8;
			
			medals = new Medals();
			
			
			helpManager.cntHint = 10;// lvlManager.cntLevels + 1;
			
			sndMedal = new SndMedal();
			sndJump = new SndJump();
			sndBanan = new SndBanan();
			
			//var req:URLRequest = new URLRequest("sounds/Jump.mp3"); 
			//sndJump = new Sound(req);
			
			//req = new URLRequest("sounds/Banan.mp3"); 
				
			//req = new URLRequest("sounds/Medal.mp3"); 
						
			//req = new URLRequest("sounds/Bomba.mp3"); 
			sndBomba = new SndBomba();
			
			//req = new URLRequest("sounds/Hole.mp3"); 
			sndYama = new SndYama();
			
			//req = new URLRequest("sounds/Electric.mp3"); 
			sndMolnia = new SndMolnia();
			
			//req = new URLRequest("sounds/Teleportation.mp3"); 
			sndTeleport = new SndTeleport();
			
			//req = new URLRequest("sounds/Ice.mp3"); 
			sndIce = new SndIce();
			
			//req = new URLRequest("sounds/Magnet.mp3"); 
			sndMagnit = new SndMagnit();
			
			//req = new URLRequest("sounds/Egg.mp3"); 
			sndEgg = new SndEgg();
			
			//req = new URLRequest("sounds/Berry.mp3"); 
			sndYagoda = new SndBerry();
			
			//req = new URLRequest("sounds/Nea.mp3"); 
			sndNea = new SndNea();
			
			//req = new URLRequest("sounds/Bonus.mp3"); 
			sndBonus = new SndBonus();
			
			//req = new URLRequest("sounds/Udar.mp3"); 
			sndUdar = new SndUdar();
			
			//sndUra = new SndUra();
			addEventListener(GotmoshkiAll.EVT_GOTMOSH_STOP, mouseClipStop);	
			
			
			super.initGameObj();
					
			
		}
		
	
		override public function clearLevel():void {
			clearTimeout(timeoutYama);
			clearTimeout(timeoutTeleport);
			clearTimeout(timeoutMolnia);
			clearTimeout(timeoutPauseBeforCheck);
			
		//	
		//	removeEventListener(GotmoshkiAll.EVT_GOTMOSH_STOP, mouseClipStop);
		//	removeEventListener(GotmoshkiAll.EVT_OTHER_COLOR, changeColor);
			
			
		//	lvlManager.field.removeEventListener(MouseEvent.CLICK,doAction);
			super.clearLevel();
			telEnter1 = null;
			telExit1 = null;
			telEnter2 = null;
			telExit2 = null;
			mouseClip = null;
			banan = null;
			elCheckCell = null;
			massKrugs = new Array();
			massMolnia = null;
			massNewGotmosh = null;
			massEmptyCell = null;
			massGotmoshPull = null;
			massGotmoshSneg = null;
			massDelGotmosh = null;
			
		//	lvlManager.level = null;
			
		}
		
		private function doBonusAction(el_key:String , trg:Object):void{
			var gotStart:Object;
			var mc:MovieClip;
			var evt:Event;
			
			switch(el_key){
					case EL_YAMA: {
						scoreBonus = 150;
						
						delKrugs();
						sndManager.ActionPlay(sndYama);
						mouseClip.pers.gotoAndPlay("fr_small");
						MovieClip(lvlManager.field.getChildByName("yama." + mouseClip.px .toString() + "." + mouseClip.py.toString())).gotoAndPlay("fr_del");
					//	mouseClip.name = "got.del";
						mouseClip.name = "got.del." + mouseClip.name;
						amountGot--;
						
						timeoutYama = setTimeout(function() { /*mouseClip = null; */  clearTimeout(timeoutYama); }, 100);	
						
					}break;
					case EL_BOMBA: {
						scoreBonus = 200;
						flBomba = true;
						delKrugs();
						sndManager.ActionPlay(sndBomba);
						var bomba = MovieClip(lvlManager.field.getChildByName("bomba." + mouseClip.px .toString() + "." + mouseClip.py.toString()));
						
						wave = MovieClip(bomba.wave);
						
						bomba.gotoAndPlay("fr_boom");
						mouseClip.pers.gotoAndPlay("fr_del");
						mouseClip.name = "got.del" + mouseClip.name;
						amountGot--;
						
						//bomba.name = "bomba.del";
						grid.getNumCellXY(mouseClip.px, mouseClip.py);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_YAMA;
						mc = new Yama();
						mc.x = mouseClip.px;
						mc.y = mouseClip.py;
					
						lvlManager.field.addChild(mc).name = "yama." + mc.x.toString() + "." + mc.y;
						massDelGotmosh.push(mc);
						mc = null;
						
						lvlManager.field.setChildIndex(bomba, lvlManager.field.numChildren - 1);
						
					} break;
					case EL_TELEPORT_1: {
						scoreBonus = 300;
						delKrugs();
						sndManager.ActionPlay(sndTeleport);
						
						telEnter1 = new Object();
						telEnter1.x = mouseClip.px;
						telEnter1.y = mouseClip.py;
					
						var teleport1 = MovieClip(lvlManager.field.getChildByName("teleport." + telEnter1.x .toString() + "." + telEnter1.y.toString()));
				
						mouseClip.pers.gotoAndPlay("fr_teleport");
						teleport1.name += ".close";
						teleport1.tel.stop();
						
						var flStop1:Boolean = false;
						i = 0;
						while (i < grid.cntRow && !flStop1) {
							j = 0;
							while ( j < grid.cntCol && !flStop1) {
								if (lvlManager.level.mxGotmoshki[i][j] == EL_TELEPORT_1) {
									grid.getCoordsColRow(i, j);
									if (grid.colX != mouseClip.px && grid.rowY != mouseClip.py) {
										flStop1 = true;
									}
								}
								j++;
							}
							i++;
						}	
							
						timeoutTeleport = setTimeout(Teleportation, 100);
					
					} break;
					case EL_TELEPORT_2: {
						scoreBonus = 300;
						delKrugs();
						sndManager.ActionPlay(sndTeleport);
						
						telEnter2 = new Object();
						telEnter2.x = mouseClip.px;
						telEnter2.y = mouseClip.py;
					
						var teleport2 = MovieClip(lvlManager.field.getChildByName("teleport." + telEnter2.x .toString() + "." + telEnter2.y.toString()));
				
						mouseClip.pers.gotoAndPlay("fr_teleport");
						teleport2.name += ".close";
						teleport2.tel.stop();
						
						var flStop2:Boolean = false;
						i = 0;
						while (i < grid.cntRow && !flStop2) {
							j = 0;
							while ( j < grid.cntCol && !flStop2) {
								
								if (lvlManager.level.mxGotmoshki[i][j] == EL_TELEPORT_2) {
									grid.getCoordsColRow(i, j);
									if (grid.colX != mouseClip.px && grid.rowY != mouseClip.py) {
										flStop2 = true;
									}
								}
								j++;
							}
							i++;
						}	
							
						timeoutTeleport = setTimeout(Teleportation, 100);
					
					} break;
					case EL_MOLNIA: {
						scoreBonus = 250;
						delKrugs();
						sndManager.ActionPlay(sndMolnia);
						mouseClip.pers.gotoAndPlay("fr_molnia");
						
						massMolnia = new Array();
						gotStart = new Object();
					
						gotStart.dir = -CELL_SIZE;
						gotStart.orient = "Y";
						gotStart.x = mouseClip.px;
						gotStart.y = mouseClip.py;
						gotStart.cnt = 1; // количество проверяемых готмошек в ряду
						gotStart.num = 1;
						
						
						getMolnia(gotStart);
						
						
						for (i = 0; i < massMolnia.length; i++) {
							if (massMolnia[i] != "") {
								if (MovieClip(lvlManager.field.getChildByName(massMolnia[i])) != null) {
									MovieClip(lvlManager.field.getChildByName(massMolnia[i])).pers.gotoAndPlay("fr_molnia");
									
									massDelGotmosh.push(MovieClip(lvlManager.field.getChildByName(massMolnia[i])));
									MovieClip(lvlManager.field.getChildByName(massMolnia[i])).name = "got.del." + MovieClip(lvlManager.field.getChildByName(massMolnia[i])).name;
									amountGot--;
								}
							}
						}
						
						massMolnia = null;
						
						
						mouseClip.name = "got.del" + mouseClip.name;
					//	timeoutMolnia = setTimeout(function() { mouseClip = null; delKrugs(); clearTimeout(timeoutMolnia); }, 20);
						mouseClip = null; 
						amountGot--;
						
						
					} break;
					case EL_EGG: {
						scoreBonus = 500;
						sndManager.ActionPlay(sndEgg);
						massNewGotmosh = new Array();
						gotStart = new Object();
						
						gotStart.dir = -CELL_SIZE;
						gotStart.orient = "Y";
						gotStart.x = mouseClip.px;
						gotStart.y = mouseClip.py;
						gotStart.cnt = 3; // количество проверяемых готмошек в ряду
						gotStart.num = 1;
						
						getEmptyCell(gotStart);
						
						for (i = 0; i < massNewGotmosh.length; i++) {
							
							mc = new GotmoshkiAll("fr_pink");
					
							mc.x = mouseClip.px;
							mc.y = mouseClip.py;
							
							var coord = massNewGotmosh[i].split(".");
							
							mc.px = Number(coord[1]);
							mc.py = Number(coord[2]);
						
							lvlManager.field.addChild(mc).name = massNewGotmosh[i];
							massDelGotmosh.push(mc);
							mc = null;
							
						}
					
						massNewGotmosh = null;
						
						grid.getNumCellXY(mouseClip.px, mouseClip.py);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
					//	lvlManager.field.removeChild(lvlManager.field.getChildByName("egg." + mouseClip.px + "." + mouseClip.py));
						MovieClip(lvlManager.field.getChildByName("egg." + mouseClip.px + "." + mouseClip.py)).gotoAndStop("fr_del");
						massDelGotmosh.push(lvlManager.field.getChildByName("egg." + mouseClip.px + "." + mouseClip.py));
						
					} break;
					case EL_MAGNIT: {
						scoreBonus = 350;
						sndManager.ActionPlay(sndMagnit);
						massEmptyCell = new Array();
						gotStart = new Object();
						
						gotStart.dir = -CELL_SIZE;
						gotStart.orient = "Y";
						gotStart.x = mouseClip.px;
						gotStart.y = mouseClip.py;
						gotStart.cnt = 3; // количество проверяемых готмошек в ряду
						gotStart.num = 1;
						
						Attraction(gotStart);
						
					} break;
					case EL_BANAN: {
						scoreBonus = 400;
						sndManager.ActionPlay(sndBanan);
						var razX = mouseClip.x - mouseClip.px;
						var razY = mouseClip.y - mouseClip.py;
						if (Math.abs(razX) > Math.abs(razY)) {
							if(razX > 0){
								mouseClip.px -= 4 * CELL_SIZE;
								mouseClip.pers.gotoAndPlay("fr_banan_x");
								
								if (mouseClip.px < grid.grid_x) {
									mouseClip.px = grid.grid_x
								}
								
								direction = DIR_MINUS_X;
								
							} else if (razX < 0) {
								mouseClip.px += 4 * CELL_SIZE;
								mouseClip.pers.gotoAndPlay("fr_banan_x");
								
								if (mouseClip.px >= grid.grid_x + grid.cntCol*CELL_SIZE) {
									mouseClip.px = grid.grid_x + grid.cntCol*CELL_SIZE;
								}
								
								direction = DIR_PLUS_X;
							}
						} else {
							
							if(razY < 0){
								mouseClip.py += 4 * CELL_SIZE;
								mouseClip.pers.gotoAndPlay("fr_banan_y");
							
								if (mouseClip.py >= grid.grid_y + grid.cntRow*CELL_SIZE) {
									mouseClip.py = grid.grid_y + (grid.cntRow)*CELL_SIZE;
								}
								
								direction = DIR_PLUS_Y;
							} else if (razY > 0) {
								mouseClip.py -= 4 * CELL_SIZE;
								mouseClip.pers.gotoAndPlay("fr_banan_y");
								
								if (mouseClip.py < grid.grid_y) {
									mouseClip.py = grid.grid_y;
								}
								
								direction = DIR_MINUS_Y;
							}
						}
						
						banan = MovieClip(lvlManager.field.getChildByName("banan." + trg.x + "." + trg.y));
						
						grid.getNumCellXY(trg.x, trg.y);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
							
						grid.curMoveCol = grid.col;
						grid.curMoveRow = grid.row;
						
						var saveBanan = new Banan();
						saveBanan.x = banan.x;
						saveBanan.y = banan.y;
						saveBanan.name = "bananSave." + banan.x + "." + banan.y;
						massDelGotmosh.push(saveBanan);
						
						
						
						/*	mouseClip.name = "got." + mouseClip.px + "." + mouseClip.py;
						
						grid.getNumCellXY(mouseClip.px, mouseClip.py);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_BANAN;
						
						
						banan.name = "banan." + mouseClip.px + "." + mouseClip.py;*/
						
					} break;
					case EL_YAGODA_PINK: {
						scoreBonus = 450;
						sndManager.ActionPlay(sndYagoda);
						yagodaUdar(new Point(mouseClip.px,mouseClip.py - CELL_SIZE), "fr_pink");
						massDelGotmosh.push(lvlManager.field.getChildByName("yagoda." + mouseClip.px + "." + mouseClip.py));
						MovieClip(lvlManager.field.getChildByName("yagoda." + mouseClip.px + "." + mouseClip.py)).yagoda.gotoAndStop("fr_del");
						grid.getNumCellXY(mouseClip.px, mouseClip.py);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
						evt = new Event(GotmoshkiAll.EVT_GOTMOSH_STOP,true);
						dispatchEvent(evt);
					}break;
					case EL_YAGODA_BLUE: {
						scoreBonus = 450;
						sndManager.ActionPlay(sndYagoda);
						
						yagodaUdar(new Point(mouseClip.px,mouseClip.py - CELL_SIZE), "fr_blue");
						massDelGotmosh.push(lvlManager.field.getChildByName("yagoda." + mouseClip.px + "." + mouseClip.py));
						MovieClip(lvlManager.field.getChildByName("yagoda." + mouseClip.px + "." + mouseClip.py)).yagoda.gotoAndStop("fr_del");
						grid.getNumCellXY(mouseClip.px, mouseClip.py);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
						evt = new Event(GotmoshkiAll.EVT_GOTMOSH_STOP,true);
						dispatchEvent(evt);
					}break;
					case EL_SNEG: {
						scoreBonus = 100;
						
						if(flSneg == false){
							scoreManager.cntScore += scoreBonus;
							scoreManager.combo.mc.nameCombo.text = "bonus +"+scoreBonus.toString();
							scoreManager.combo.gotoAndPlay("fr_start");
						}
						sndManager.ActionPlay(sndIce);
						
						scoreBonus = 0;
						flSneg = true;
						
						massGotmoshSneg.push(mouseClip);
						if (mouseClip.currentFrameLabel == "fr_gold_blue") {
							mouseClip.gotoAndStop("fr_gold_snegB");
						} else if(mouseClip.currentFrameLabel == "fr_gold_pink"){ 
							mouseClip.gotoAndStop("fr_gold_snegP");
						}
						setSnegGotmosh(new Point(mouseClip.px, mouseClip.py - CELL_SIZE));
						
						counterSneg = CNT_FRAME_SNEG;
					//	MovieClip(lvlManager.field.getChildByName("sneg." + mouseClip.px + "." + mouseClip.py)).yagoda.gotoAndStop("fr_del");
					//	grid.getNumCellXY(mouseClip.px, mouseClip.py);
					//	lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
					}break;
				}
		}
		
		private function doAction(event:Event):void{
			flChangeColor = false; 
			if(event.target.name == "krug"){
				sndManager.ActionPlay(sndJump);
				if(koeffJump>1){
					scoreManager.combo.mc.nameCombo.text = "combo x"+koeffJump.toString();
					scoreManager.combo.gotoAndPlay("fr_start");
				}
				scoreManager.cntScore += SCORE_DEFAULT*koeffJump;
				
				koeffJump++;
				
				
				// перемещение готмошек
				lvlManager.field.setChildIndex(mouseClip,lvlManager.field.numChildren - 1);
				
				
				
				mouseClip.px = event.target.x;
				mouseClip.py = event.target.y;
				mouseClip.name = "got."+mouseClip.px+"."+mouseClip.py;
				try{
					mouseClip.pers.gotoAndPlay("fr_rjump");
				} catch (e:Error){
					
				}
				if(mouseClip.x>mouseClip.px){
					mouseClip.scaleX = -1;
				} else {
					mouseClip.scaleX = 1;
				}
				
				grid.getNumCellXY(mouseClip.px, mouseClip.py);
				//var col;
				//var row;
				
				
			//	var el_key = checkCellEmpty(mouseClip.px, mouseClip.py);
				
				var el_key = lvlManager.level.mxGotmoshki[grid.row][grid.col].toString();
				flNoCheckMove = el_key == EL_BOMBA || el_key == EL_MOLNIA || el_key == EL_TELEPORT_1 || el_key == EL_TELEPORT_2 || el_key == EL_WALL || el_key == EL_YAMA || el_key == EL_ZABOR_GORIZ || el_key == EL_ZABOR_VERT; 
				
				doBonusAction(el_key,event.target);
				if(scoreBonus>0 ){
					
					scoreManager.cntScore += scoreBonus;
					scoreManager.combo.mc.nameCombo.text = "bonus +"+scoreBonus.toString();
					scoreManager.combo.gotoAndPlay("fr_start");
					scoreBonus = 0;
				}
				
			
			} else if (event.target.name.substr(0,3) == "got"){
				getGotmosh(MovieClip(event.target));
			}
			
			
		}
		
		private function Attraction(got:Object):void {
			
			if(got.cnt!=5){
				
				massGotmoshPull = new Array();
					
				switch(got.orient) {
					case "Y": {
						got.y = got.y + got.dir;
					} break;
					case "X": {
						got.x = got.x + got.dir;
					} break;
				}
				
				for (i = 0; i < got.cnt; i++) {
					var gx;
					var gy;
					switch(got.orient) {
						case "Y": {
							gx = got.x - Math.floor(got.cnt / 2)*CELL_SIZE + i*CELL_SIZE;
							gy = got.y;
						}break;	
						case "X": {
							gx = got.x;
							gy = got.y - Math.floor(got.cnt / 2)*CELL_SIZE + i*CELL_SIZE;;
						} break;
					}	
					
					if (checkCellEmpty(gx, gy) == EL_EMPTY) {
						massEmptyCell.push(new Point(gx,gy));
					}
				//	 && massNewGotmosh.indexOf("got." + gx.toString() + "." + (gy+got.dir).toString())==-1
					if (checkCellEmpty(gx, gy + got.dir) == EL_GOTMOSH) {
						massGotmoshPull.push("got." + gx.toString() + "." + (gy+got.dir).toString());
					}
				}
				if (massEmptyCell.length < massGotmoshPull.length) {
					i = massEmptyCell.length;
				} else {
					i = massGotmoshPull.length;
				}
				while (i > 0) {
					var n = massGotmoshPull.pop();
					var gotPull = lvlManager.field.getChildByName(n);
					var coord:Point = massEmptyCell.shift();
					gotPull.px = coord.x;
					gotPull.py = coord.y;
					gotPull.name = "got." + coord.x + "." + coord.y;
					
					var gotMagnit = new MovieClip();
					gotMagnit.px = gotPull.x;
					gotMagnit.py = gotPull.y;
					gotMagnit.name = "magnit." + coord.x + "." + coord.y;
					
					massDelGotmosh.push(gotMagnit);
					
					i--;
				}
				
				got.cnt ++;
				Attraction(got);
			} else {
				if(got.num<4){
					switch(got.num) {
						case 1: {
							got.dir = CELL_SIZE;
						} break;
						case 2: {
							got.dir = -CELL_SIZE;
							got.orient = "X";
						} break;
						case 3: {
							got.dir = CELL_SIZE;
						} break;
					}
					
					got.num++;
					got.cnt = 3;
					got.x = mouseClip.px;
					got.y = mouseClip.py;
					massEmptyCell = new Array();
					Attraction(got);
				}	
			}
		}
		
		private function getEmptyCell(got:Object):void {
			
			if(got.cnt!=5){
				switch(got.orient) {
					case "Y": {
						got.y = got.y + got.dir;
					} break;
					case "X": {
						got.x = got.x + got.dir;
					} break;
				}
				
				for (i = 0; i < got.cnt; i++) {
					var gx = got.x - Math.floor(got.cnt / 2)*CELL_SIZE + i*CELL_SIZE;
					var gy = got.y;
					
					var cell = checkCellEmpty(gx, gy);
					if ( cell == EL_EMPTY && massNewGotmosh.indexOf("gotegg." + gx.toString() + "." + gy.toString())==-1) {
						massNewGotmosh.push("gotegg."+gx.toString()+"."+gy.toString());
					}
					
				}
				
				got.cnt ++;
				getEmptyCell(got);
			} else {
				if(got.num<4){
					switch(got.num) {
						case 1: {
							got.dir = CELL_SIZE;
						} break;
						case 2: {
							got.dir = -CELL_SIZE;
							got.orient = "X";
						} break;
						case 3: {
							got.dir = CELL_SIZE;
						} break;
					}
					
					got.num++;
					got.cnt = 3;
					got.x = mouseClip.px;
					got.y = mouseClip.py;
					getEmptyCell(got);
				}	
			}
		}
		
		private function getMolnia(got:Object):void {
			
			if(got.cnt!=5){
				switch(got.orient) {
					case "Y": {
						got.y = got.y + got.dir;
					} break;
					case "X": {
						got.x = got.x + got.dir;
					} break;
				}
				massMolnia.push(getGotmoshUdar(got));
				got.cnt += 2;
				getMolnia(got);
			} else {
				if(got.num<4){
					switch(got.num) {
						case 1: {
							got.dir = CELL_SIZE;
						} break;
						case 2: {
							got.dir = -CELL_SIZE;
							got.orient = "X";
						} break;
						case 3: {
							got.dir = CELL_SIZE;
						} break;
					}
					
					got.num++;
					got.cnt = 1;
					got.x = mouseClip.px;
					got.y = mouseClip.py;
					getMolnia(got);
				}	
			}
		}
		
		private function yagodaUdar(coord:Point,fr:String="fr_blue",n:uint = 3,cnt:uint=3):void {
			
			for (i = 0; i < cnt; i++) {
				var gx = coord.x - Math.floor(cnt / 2)*CELL_SIZE + i*CELL_SIZE;
				var gy = coord.y;
				
				if (checkCellEmpty(gx, gy) == EL_GOTMOSH) {
					//if(mouseClip.name!="got." + gx.toString() + "." + gy.toString()){
						var got:MovieClip = MovieClip(lvlManager.field.getChildByName("got." + gx.toString() + "." + gy.toString()));
						var newGot = new GotmoshkiAll(got.currentFrameLabel);
							newGot.x = got.x;
							newGot.y = got.y;
							newGot.name = "yagoda."+got.name;
							massDelGotmosh.push(newGot);
						newGot = null;	
						if(got.currentFrameLabel!=fr){
							got.gotoAndStop(fr);
							got.pers.gotoAndPlay("fr_yagoda");
						} 
					//}	
				}
			}
			
			n--;
			if (n > 0) {
				yagodaUdar(new Point(coord.x,coord.y+CELL_SIZE),fr,n,cnt);
			}
			
		}
		
		private function setSnegGotmosh(coord:Point,n:uint = 3,cnt:uint=3):void {
			
			for (i = 0; i < cnt; i++) {
				var gx = coord.x - Math.floor(cnt / 2)*CELL_SIZE + i*CELL_SIZE;
				var gy = coord.y;
				
				if (checkCellEmpty(gx, gy) == EL_GOTMOSH) {
					if(mouseClip.name!="got." + gx.toString() + "." + gy.toString()){
						var got:MovieClip = MovieClip(lvlManager.field.getChildByName("got." + gx.toString() + "." + gy.toString()));
						
						got.pers.gotoAndStop("fr_sneg");
						massGotmoshSneg.push(got);
						massDelGotmosh.push(got);
						
						
					} 
				}
			}
			
			n--;
			if(n==2){
				cnt +=2;
			} else {
				cnt -=2;
			}
			if (n > 0) {
				setSnegGotmosh(new Point(coord.x,coord.y+CELL_SIZE),n,cnt);
			}
			
		}
		
		private function getGotmoshUdar(got:Object):String {
			
			var str:String = "";
			var mass = new Array();
			for (i = 0; i < got.cnt; i++) {
				var gx = got.x - Math.floor(got.cnt / 2)*CELL_SIZE + i*CELL_SIZE;
				var gy = got.y;
				
				if (checkCellEmpty(gx, gy) == EL_GOTMOSH) {
					mass.push("got."+gx.toString()+"."+gy.toString());
				}
			}
			
			if (mass.length > 0) {
				var r = Math.ceil(Math.random() * (mass.length - 1));
				str = mass[r];
			}
			return str;
		}
		
		private function Teleportation():void{
			clearTimeout(timeoutTeleport);
			mouseClip.x = mouseClip.px = grid.colX;
			mouseClip.y = mouseClip.py = grid.rowY;
			mouseClip.name = "got." + mouseClip.x.toString() + "." + mouseClip.y.toString();
			
			grid.getNumCellXY(mouseClip.px, mouseClip.py);
			var el_key = lvlManager.level.mxGotmoshki[grid.row][grid.col].toString();
			switch(el_key){
				case EL_TELEPORT_1: {
					telExit1 = new Object();
					telExit1.x = mouseClip.px;
					telExit1.y = mouseClip.py;
				} break;
				case EL_TELEPORT_2: {
					telExit2 = new Object();
					telExit2.x = mouseClip.px;
					telExit2.y = mouseClip.py;
				} break;
			}	
			
			checkMove();
		}	
		
		private function pauseBeforCheck():void {
			clearTimeout(timeoutPauseBeforCheck);
			if(checkLevelComplete()){
					
				i = 0;
				
					
				
				while(i<lvlManager.field.numChildren){
					if(lvlManager.field.getChildAt(i).name.search("got.del")==-1 && lvlManager.field.getChildAt(i).name.substr(0,3) == "got"){
						MovieClip(lvlManager.field.getChildAt(i)).pers.gotoAndPlay("fr_nea");
						MovieClip(lvlManager.field.getChildAt(i)).name = "got.del"
						cntGotOst++;
					}
					i++;
				}
				trace(lvlManager.field.numChildren+" cntGotOst "+cntGotOst);
				timeoutLevelComplete = setTimeout(levelComplete,1000);	
			}
		}
		
		private function mouseClipStop(event:Event):void {
			
		    var ch = checkCellEmpty(mouseClip.px,mouseClip.py + CELL_SIZE);
			if(ch!=EL_EMPTY && ch!=EL_WALL && ch!=EL_GOTMOSH){
				lvlManager.field.setChildIndex(mouseClip, lvlManager.field.getChildIndex(elCheckCell));
			}	
					
			if(!flNoCheckMove) {
				checkMove();
			}
			
				cntGotOst = 0;
				timeoutPauseBeforCheck = setTimeout(pauseBeforCheck, 500);
			
		}
		
		override public function levelComplete():void {
			clearTimeout(timeoutLevelComplete);
			
			if (cntGotOst > lvlManager.level.cntPorog) {
				flNextLevelOpen = false;
			} else {
				flNextLevelOpen = true;
			}
			
			if (cntGotOst <= Math.ceil(lvlManager.level.cntPorog / 3)) {
				navGame.cntStars = 3;
			} else if (cntGotOst<=Math.ceil(2*lvlManager.level.cntPorog / 3)){
				navGame.cntStars = 2;
			} else if (cntGotOst<=lvlManager.level.cntPorog){
				navGame.cntStars = 1;
			} else {
				navGame.cntStars = 0;
			}
			
			super.levelComplete();
			
			
			
			navGame.levCompleteMenu.got.gotoAndStop("fr_front");
			
			navGame.levCompleteMenu.cntGotOstatok.text = cntGotOst.toString();
			navGame.levCompleteMenu.cntGotPorog.text = lvlManager.level.cntPorog.toString();
			
			switch(navGame.cntStars){
				case 0:{
					navGame.levCompleteMenu.got.gotoAndPlay("fr_nea");
					sndManager.ActionPlay(sndNea);
				} break;
				case 1:{
					navGame.levCompleteMenu.stars.gotoAndPlay("fr_star1");
					navGame.levCompleteMenu.got.gotoAndPlay("fr_jump");
				}break;
				case 2:{
					navGame.levCompleteMenu.stars.gotoAndPlay("fr_star2");
					navGame.levCompleteMenu.got.gotoAndPlay("fr_jump");
				}break;
				case 3:{
					navGame.levCompleteMenu.stars.gotoAndPlay("fr_star3");
					navGame.levCompleteMenu.got.gotoAndPlay("fr_jump");
				}break;
			}	
			
		}
		
		private function resetMouseClip():void {
			
			if (mouseClip != null && mouseClip.name.search("got.del.")==-1) {
				
				if (mouseClip.currentFrameLabel == "fr_gold_blue") {
					mouseClip.gotoAndStop("fr_blue");
				} else if (mouseClip.currentFrameLabel == "fr_gold_pink") {
					mouseClip.gotoAndStop("fr_pink");
				} else if (mouseClip.currentFrameLabel.search("fr_gold_sneg")!=-1) {
					if (mouseClip.currentFrameLabel.replace("fr_gold_sneg", "") == "B") {
						mouseClip.gotoAndStop("fr_blue");	
						mouseClip.pers.gotoAndStop("fr_sneg");
					} else {
						mouseClip.gotoAndStop("fr_pink");
						mouseClip.pers.gotoAndStop("fr_sneg");
					}
					
				}
				
				mouseClip = null;
				delKrugs();
			}
			
			
		}
				
		private function getGotmosh(mc:MovieClip):void{
			
			koeffJump = 1;
			scoreBonus = 0;
			resetMouseClip();
				
			mouseClip = mc;
			
		
				while (massDelGotmosh.length > 1) {
					var mcdel:MovieClip = massDelGotmosh.pop();
					if (mcdel.name.search("egg.") != -1) {
						mcdel.name = mcdel.name.replace("egg","");
						
					} else if (mcdel.name.search("got.") != -1) {
						
						if(lvlManager.field.getChildByName(mcdel.name)!=null){
													
							if(mcdel.pers.currentFrameLabel =="fr_del"){
								
								mcdel.name = "got.del";
								mcdel.removeChild(mcdel.hit);
								mcdel.visible = false;
								lvlManager.field.removeChild(mcdel);
							}	
						}
						mcdel = null;
						
					}
				}
			 
			
			flSneg = false;
			flBomba = false;
			massDelGotmosh = new Array();
			var oldMouseClip:MovieClip = new GotmoshkiAll(mc.currentFrameLabel);			
			oldMouseClip.name = "got." + mc.x + "." + mc.y;
			oldMouseClip.x = oldMouseClip.px = mc.x;
			oldMouseClip.y = oldMouseClip.py = mc.y;
			massDelGotmosh.push(oldMouseClip);
			
			
			
			lvlManager.field.setChildIndex(mouseClip,lvlManager.field.numChildren - 1);
			
			if (mc.currentFrameLabel == "fr_blue") {
				if (mc.pers.currentFrameLabel == "fr_sneg") {
					mouseClip.gotoAndStop("fr_gold_snegB");
				} else {
					mouseClip.gotoAndStop("fr_gold_blue");
				}
			} else if (mc.currentFrameLabel == "fr_pink") {
				if (mc.pers.currentFrameLabel == "fr_sneg") {
					mouseClip.gotoAndStop("fr_gold_snegP");
				} else {
					mouseClip.gotoAndStop("fr_gold_pink");
				}	
			}
			
			if(!checkMove()){
				mouseClip.pers.gotoAndPlay("fr_nea");
				sndManager.ActionPlay(sndNea);
			}
			mc = null;
		}
		
		private function checkCellEmpty(cx:Number,cy:Number):String{
			
			if(cx>grid.grid_x && cx<(grid.grid_x+grid.grid_width*grid.cntCol) && cy>grid.grid_y && cy<(grid.grid_y+grid.grid_width*grid.cntRow)){
				grid.getNumCellXY(cx,cy);
				var str:String = "";
				
				if (lvlManager.level.mxGotmoshki[grid.row][grid.col] == EL_WALL || lvlManager.field.getChildByName("teleport." + cx.toString() + "." + cy.toString()+".close") != null) {
					str = EL_WALL;
					elCheckCell = null;
				} else if (lvlManager.field.getChildByName("got." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_GOTMOSH;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("got." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("yama." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_YAMA;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("yama." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("bomba." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_BOMBA;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("bomba." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("teleport." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_TELEPORT;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("teleport." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("molnia." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_MOLNIA;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("molnia." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("egg." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_EGG;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("egg." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("banan." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_BANAN;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("banan." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("zabor." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_ZABOR;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("zabor." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("yagoda." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_YAGODA;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("yagoda." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("sneg." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_SNEG;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("sneg." + cx.toString() + "." + cy.toString()));
				} else if (lvlManager.field.getChildByName("magnit." + cx.toString() + "." + cy.toString()) != null) {
					str = EL_MAGNIT;
					elCheckCell = MovieClip(lvlManager.field.getChildByName("magnit." + cx.toString() + "." + cy.toString()));
				}  else {
					str = EL_EMPTY;
					elCheckCell = null;
				}
			} else {
				str = EL_WALL;
				elCheckCell = null;
			}
			
			return str;
		}
		
		private function checkLevelComplete():Boolean{
			i = lvlManager.field.numChildren - 1;
			var flStop = true;
			while (i > 0 && flStop) {
				
				
				if(lvlManager.field.getChildAt(i).name.search("got.del") == -1 && lvlManager.field.getChildAt(i).name.substr(0,3) == "got"){
					if(checkPossibleMove(MovieClip(lvlManager.field.getChildAt(i)))){
						flStop = false;
					}
				}
				i--;
			}
			return flStop && navGame.levCompleteMenu == null;
		}
		
		private function checkPossibleMove(mc:MovieClip):Boolean{
			var flPathExist = false;
			var cell = "";
			var cell2 = "";
			if ((mc.py + CELL_SIZE * 2) <= (grid.grid_y + grid.grid_height*grid.cntRow)) {
				cell = checkCellEmpty(mc.px,mc.py+CELL_SIZE);
				cell2 = checkCellEmpty(mc.px, mc.py + CELL_SIZE * 2);
				//|| cell==EL_YAMA || cell==EL_BOMBA 
			
				if((cell==EL_GOTMOSH && (cell2==EL_EMPTY || cell2 == EL_BANAN || cell2 == EL_EGG  || cell2 == EL_MAGNIT  || cell2 == EL_SNEG || cell2 == EL_YAGODA_BLUE || cell2 == EL_YAGODA_PINK))){
					flPathExist = true;
				}
			}
			if ((mc.py-CELL_SIZE*2) >= grid.grid_y){
				cell = checkCellEmpty(mc.px,mc.py-CELL_SIZE);
				cell2 = checkCellEmpty(mc.px, mc.py - CELL_SIZE * 2);
				//|| cell==EL_YAMA || cell==EL_BOMBA
				if((cell==EL_GOTMOSH && (cell2==EL_EMPTY || cell2 == EL_BANAN || cell2 == EL_EGG  || cell2 == EL_MAGNIT  || cell2 == EL_SNEG || cell2 == EL_YAGODA_BLUE || cell2 == EL_YAGODA_PINK))){
					flPathExist = true;
				}
			}
			if ((mc.px+CELL_SIZE*2) <= (grid.grid_x+grid.grid_width*grid.cntCol)){
				cell = checkCellEmpty(mc.px+CELL_SIZE,mc.py);
				cell2 = checkCellEmpty(mc.px + CELL_SIZE * 2, mc.py);
				//|| cell==EL_YAMA || cell==EL_BOMBA
				if((cell==EL_GOTMOSH && (cell2==EL_EMPTY || cell2 == EL_BANAN || cell2 == EL_EGG  || cell2 == EL_MAGNIT  || cell2 == EL_SNEG || cell2 == EL_YAGODA_BLUE || cell2 == EL_YAGODA_PINK))){
					flPathExist = true;
				}
			}	
			if ((mc.px-CELL_SIZE*2) >= grid.grid_x){			
				cell = checkCellEmpty(mc.px-CELL_SIZE,mc.py);
				cell2 = checkCellEmpty(mc.px - CELL_SIZE * 2, mc.py);
				//|| cell==EL_YAMA || cell==EL_BOMBA
				if((cell==EL_GOTMOSH && (cell2==EL_EMPTY || cell2 == EL_BANAN || cell2 == EL_EGG  || cell2 == EL_MAGNIT  || cell2 == EL_SNEG || cell2 == EL_YAGODA_BLUE || cell2 == EL_YAGODA_PINK))){
					flPathExist = true;
				}
			}	
			return flPathExist;
		}
		
		private function checkMove():Boolean{
			delKrugs();
			var flPathExist = false;
			var cell = "";
			var cell2 = "";
			if(mouseClip!=null){
				if ((mouseClip.py + CELL_SIZE * 2) <= (grid.grid_y + grid.grid_height*grid.cntRow)) {
					cell = checkCellEmpty(mouseClip.px, mouseClip.py + CELL_SIZE);
					cell2 = checkCellEmpty(mouseClip.px, mouseClip.py + CELL_SIZE * 2);
					krug = new Krug();
					krug.x = mouseClip.px;

				/*	if(cell==EL_YAMA || cell==EL_BOMBA  || cell==EL_TELEPORT){
						krug.y = mouseClip.py+CELL_SIZE;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					} else*/
					//(cell2==EL_EMPTY || cell2==EL_YAMA || cell2==EL_BOMBA || cell2==EL_TELEPORT)
					if(cell==EL_GOTMOSH && (cell2!=EL_WALL && cell2!=EL_GOTMOSH && cell2!=EL_ZABOR)){
						krug.y = mouseClip.py+CELL_SIZE*2;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					}
					krug = null;
				}
				
				if ((mouseClip.py-CELL_SIZE*2) >= grid.grid_y){
					cell = checkCellEmpty(mouseClip.px, mouseClip.py - CELL_SIZE);
					cell2 = checkCellEmpty(mouseClip.px, mouseClip.py - CELL_SIZE * 2);
					krug = new Krug();
					krug.x = mouseClip.px;
					/*if(cell==EL_YAMA || cell==EL_BOMBA  || cell==EL_TELEPORT){
						krug.y = mouseClip.py-CELL_SIZE;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					} else */
					//(cell2==EL_EMPTY || cell2==EL_YAMA || cell2==EL_BOMBA || cell2==EL_TELEPORT)
					if(cell==EL_GOTMOSH && (cell2!=EL_WALL && cell2!=EL_GOTMOSH && cell2!=EL_ZABOR)){
						krug.y = mouseClip.py-CELL_SIZE*2;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					}
					krug = null;
				}
				
				if ((mouseClip.px+CELL_SIZE*2) <= (grid.grid_x+grid.grid_width*grid.cntCol)){
					cell = checkCellEmpty(mouseClip.px + CELL_SIZE, mouseClip.py);
					cell2 = checkCellEmpty(mouseClip.px + CELL_SIZE * 2, mouseClip.py);
					krug = new Krug();
					krug.y = mouseClip.py;
				
					
					/*if(cell==EL_YAMA || cell==EL_BOMBA  || cell==EL_TELEPORT){
						krug.x = mouseClip.px+CELL_SIZE;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					} else*/
					//(cell2==EL_EMPTY || cell2==EL_YAMA || cell2==EL_BOMBA || cell2==EL_TELEPORT)
					if(cell==EL_GOTMOSH && (cell2!=EL_WALL && cell2!=EL_GOTMOSH && cell2!=EL_ZABOR)){
						krug.x = mouseClip.px+CELL_SIZE*2;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					}
					krug = null;
				}
				
				if ((mouseClip.px-CELL_SIZE*2) >= grid.grid_x){
					cell = checkCellEmpty(mouseClip.px - CELL_SIZE, mouseClip.py);
					cell2 = checkCellEmpty(mouseClip.px - CELL_SIZE * 2, mouseClip.py);
					krug = new Krug();
					krug.y = mouseClip.py;
					/*if(cell==EL_YAMA || cell==EL_BOMBA  || cell==EL_TELEPORT){
						krug.x = mouseClip.px-CELL_SIZE;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					} else */
					//(cell2==EL_EMPTY || cell2==EL_YAMA || cell2==EL_BOMBA || cell2==EL_TELEPORT)
					if(cell==EL_GOTMOSH && (cell2!=EL_WALL && cell2!=EL_GOTMOSH && cell2!=EL_ZABOR)){
						krug.x = mouseClip.px-CELL_SIZE*2;
						lvlManager.field.addChild(krug).name = "krug";
						massKrugs.push(krug);
						flPathExist = true;
					}
					krug = null;
				}	
			}
			return flPathExist;
		}
		
		private function delKrugs():void{
			while(massKrugs.length>0){
				lvlManager.field.removeChild(massKrugs.pop());
			}
		}	
		
				
		/** Загрузка уровня **/
		override public function loadLevel():void {
		//	addEventListener(GotmoshkiAll.EVT_GOTMOSH_STOP, mouseClipStop);
		//	addEventListener(GotmoshkiAll.EVT_OTHER_COLOR, changeColor);
			
			//lvlManager.goLevelNum(lvlManager.curLevelNum);
			super.loadLevel();
			
			lvlManager.field.addEventListener(MouseEvent.CLICK,doAction);
			
			if(lvlManager.curLevelNum<5){
				lvlManager.field.scaleX = lvlManager.field.scaleY = 2;
			} else if (lvlManager.curLevelNum < 9) {
				lvlManager.field.scaleX = lvlManager.field.scaleY = 1.4;
			}
			switch (lvlManager.curLevelNum) {
				case 1: {
					lvlManager.field.addChild(new FonLev1());
				} break;
				case 2: {
					lvlManager.field.addChild(new FonLev2());
				} break;
				case 3: {
					lvlManager.field.addChild(new FonLev3());
				} break;
				case 4: {
					lvlManager.field.addChild(new FonLev4());
				} break;
				case 5: {
					lvlManager.field.addChild(new FonLev5());
				} break;
				case 6: {
					lvlManager.field.addChild(new FonLev6());
				} break;
				case 7: {
					lvlManager.field.addChild(new FonLev7());
				} break;
				case 8: {
					lvlManager.field.addChild(new FonLev8());
				} break;
				case 9: {
					lvlManager.field.addChild(new FonLev9());
				} break;
				case 10: {
					lvlManager.field.addChild(new FonLev10());
				} break;
				case 11: {
					lvlManager.field.addChild(new FonLev11());
				} break;
				case 12: {
					lvlManager.field.addChild(new FonLev12());
				} break;
				case 13: {
					lvlManager.field.addChild(new FonLev13());
				} break;
				case 14: {
					lvlManager.field.addChild(new FonLev14());
				} break;
			}
			scoreBonus = 0;
			koeffJump = 1;
			
			counterSneg = -1;
			flChangeColor = false;
			flSneg = false;
			flBomba = false;
			
			telEnter1 = null;
			telExit1 = null;
			telEnter2 = null;
			telExit2 = null;
			mouseClip = null;
			banan = null;
			elCheckCell = null;
			
			massKrugs = new Array();
			massGotmoshSneg = new Array();
			massDelGotmosh = new Array();
			massMolnia = null;
			

			
		/*	if (tm != null) {
				tm.timerStop();
				tm = null;
			}
			
			tm = new TimeManager();*/
			

		//	lvlManager.field.mouseEnabled = false;
						
			medals.x = 325;
			medals.y = 235;
			lvlManager.field.addChild(medals);
			
			
			amountGot = 0;
			
			addGotmoch();
			
			navGame.gameMenu.amount.gotoAndStop(2);
			navGame.gameMenu.amount.strAmount.text = lvlManager.level.cntPorog+" ("+amountGot.toString()+")";
			
		/*	lvlManager.field.scaleX = lvlManager.field.scaleY = 2;
			lvlManager.field.x = -100;
			lvlManager.field.y = -100;*/
		}	
		
		private function addSledBanan():void {
			
			grid.getCoordsXY(banan.x, banan.y);
			if (lvlManager.field.getChildByName("bananSled." + grid.colX + "." + grid.rowY) == null && !(grid.colX==mouseClip.px && grid.rowY==mouseClip.py )) {
				var mc = new BananSled();
				mc.x = grid.colX;
				
				if (direction == DIR_MINUS_X) {
					mc.rotation = -90;
					mc.y = grid.rowY - Math.round(CELL_SIZE/3);
				} else if (direction == DIR_PLUS_X) {
					mc.rotation = 90;
					mc.y = grid.rowY - Math.round(CELL_SIZE/3);
				}else if(direction == DIR_MINUS_Y){
					mc.y = grid.rowY;
				} else if (direction == DIR_PLUS_Y) {
					mc.rotation = 180;
					mc.y = grid.rowY;
				}
				lvlManager.field.addChild(mc).name = "bananSled." + grid.colX + "." + grid.rowY;
				lvlManager.field.setChildIndex(mc, 1);
				mc = null;
			}
		}
		
		private function undelGotmosh():void {
			clearTimeout(timeoutUndel);
			var mc:MovieClip;
			while (massDelGotmosh.length > 0) {
				mc = massDelGotmosh.shift();
				
				if (mc.name.search("egg.") != -1) {
					
					if(mc.name.search("got.") != -1){
						try{
							lvlManager.field.removeChild(mc);
						} catch(e:Error){
							
						}
					} else {
						mc.gotoAndStop("fr_start");
						grid.getNumCellXY(mc.x, mc.y);
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EGG;
					}
				} else if (mc.name.search("got.") != -1) {
					mc.name = mc.name.replace("got.del.", "");
					amountGot++;
					
					
					if(Main.flChangeColor){
						if(mc.currentFrameLabel=="fr_blue"){
							mc.gotoAndStop("fr_pink");
						} else {
							mc.gotoAndStop("fr_blue");
						}
					}
					
					if (mc.name.search("yagoda") != -1){
						
						mc.name = mc.name.replace("yagoda.","")
						
						if(lvlManager.field.getChildByName(mc.name)!=null){
							
							MovieClip(lvlManager.field.getChildByName(mc.name.replace("yagoda.",""))).gotoAndStop(mc.currentFrameLabel);
						}
					}
					
					if (flSneg) {
						mc.pers.gotoAndStop("fr_right");
						massGotmoshSneg = new Array();
						counterSneg = -1;	
					} else if(mc.pers.currentFrameLabel != "fr_sneg") {
						mc.pers.gotoAndStop("fr_right");	
					}
					
				} else if (mc.name.search("magnit.") != -1) {
					//mc.name = "got."+mc.x+"."+mc.y;
					mc.name = mc.name.replace("magnit.", "got.");
					var mcNew = lvlManager.field.getChildByName(mc.name);
					if (mcNew != null) {
						mcNew.px = mc.px;
						mcNew.py = mc.py;
						mcNew.name = "got." + mc.px + "." + mc.py;
					}
					
				} else if(mc.name.search("yama.") != -1 && flBomba) {
					
					grid.getNumCellXY(mc.x, mc.y);
					
					if (lvlManager.level.mxGotmoshki[grid.row][grid.col] == EL_YAMA) {
						
						lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_BOMBA;
						
						var newMC = new Bomba();
						newMC.x = mc.x;
						newMC.y = mc.y;
						lvlManager.field.addChild(newMC).name = "bomba." + mc.x.toString() + "." + mc.y;
						
						newMC = null;
						lvlManager.field.removeChild(lvlManager.field.getChildByName("yama." + mc.x .toString() + "." + mc.y.toString()));
						
					}
				} else if (mc.name.search("bananSave.") != -1){
					mc.name = mc.name.replace("Save" ,"");
					lvlManager.field.addChild(mc);
					grid.getNumCellXY(mc.x, mc.y);
					lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_BANAN;
				} else if (mc.name.search("banan.") != -1){
					lvlManager.field.removeChild(mc);
					
					grid.getNumCellXY(mc.x, mc.y);
					lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_EMPTY;
				} else if (mc.name.search("zabor") != -1){
					
					grid.getNumCellXY(mc.x, mc.y);
					var n = lvlManager.level.mxGotmoshki[grid.row][grid.col]=="zg"?1:2;
					mc.gotoAndStop(n);
					mc.name = "zabor."+mc.x+"."+mc.y;
				} else if(mc.name.search("yagoda") != -1){
					mc.yagoda.gotoAndStop(1);
					grid.getNumCellXY(mc.x, mc.y);
					lvlManager.level.mxGotmoshki[grid.row][grid.col] = mc.currentFrame == 1?EL_YAGODA_BLUE:EL_YAGODA_PINK;
				}
			}
			flSneg = false;
			flBomba = false;
			flNoCheckMove = true;
			resetMouseClip();
		}
		
		override public function backStep(event:Event):void{
			scoreManager.cntScore -= SCORE_DEFAULT*Main.koeffJump;
			scoreManager.cntScore -= scoreBonus;
			Main.koeffJump = 1;
			if(massDelGotmosh.length > 1){
				var mc:MovieClip = massDelGotmosh.shift();
				if (mouseClip != null) {
					
					
					mouseClip.px = mc.x;
					mouseClip.py = mc.y;
					
					if (flSneg) {
						if (mouseClip.currentFrameLabel.replace("fr_gold_sneg", "") == "B") {
							mouseClip.gotoAndStop("fr_gold_blue");	
						} else if (mouseClip.currentFrameLabel.replace("fr_gold_sneg", "") == "P") {
							mouseClip.gotoAndStop("fr_gold_pink");
						}
						
						mouseClip.pers.gotoAndStop("fr_right");
						
					}	
					trace(mouseClip.name);
					if(mouseClip.name.search("del")!=-1){
						
						amountGot++;
					}
					mouseClip.gotoAndStop(mc.currentFrameLabel);
					mouseClip.name = "got." + mc.x + "." + mc.y;
					
					
				} 
				
				
				timeoutUndel = setTimeout(undelGotmosh, 150);
			}	
		}
	
		
		override public function checkCollisions():void {
			try {
			
			} catch (e:Error) {
				
			}
		}
		
		
		
		
		override public function onMainEnterFrame(event:Event):void{ 
			super.onMainEnterFrame(event);
			
			
			
			//if(!(navGame.stateGame == navGame.STATE_GAME_MAIN_MENU || navGame.stateGame == navGame.STATE_GAME_PAUSE || navGame.stateGame == navGame.STATE_GAME_HELP || navGame.stateGame == navGame.STATE_GAME_CLEAR ||  navGame.stateGame == navGame.STATE_GAME_LEV_COMPL ||  stateGame == STATE_GAME_OVER)){
			if(navGame.stateGame == navGame.STATE_GAME_RUN){
				/*if(lvlManager.field.getChildByName("got.del")!=null){
					lvlManager.field.removeChild(lvlManager.field.getChildByName("got.del"));
				}*/
				
				/*if(amountGot <= lvlManager.level.cntPorog){
					navGame.gameMenu.amount.gotoAndStop(2);
				}
				navGame.gameMenu.amount.strAmount.text = amountGot.toString();
				*/
				if (wave != null) {
					
					wave.scaleX += 0.1;
					wave.scaleY += 0.1;
					if (wave.scaleX > 2.5) {
						wave = null;
						lvlManager.field.removeChild(lvlManager.field.getChildByName("bomba." + mouseClip.px .toString() + "." + mouseClip.py.toString()));
					//	lvlManager.field.removeChild(mouseClip);
					//	mouseClip = null;
					}
				}
				
				if (counterSneg > 0) {
					counterSneg--;
				} else if (counterSneg == 0) {
					counterSneg = -1;
					
					while (massGotmoshSneg.length) {
						var mc:MovieClip = massGotmoshSneg.pop();
						if(mc!=mouseClip && mc.name.search("got.del")==-1){
							MovieClip(mc).pers.gotoAndPlay("fr_melt");
						} else if(mouseClip!=null) {
							if (mouseClip.currentFrameLabel.replace("fr_gold_sneg", "") == "B") {
								mouseClip.gotoAndStop("fr_gold_blue");	
							} else if (mouseClip.currentFrameLabel.replace("fr_gold_sneg", "") == "P") {
								mouseClip.gotoAndStop("fr_gold_pink");
							}
							try{
								//mouseClip.pers.gotoAndPlay("fr_melt");
							} catch(e:Error){
								
							}
						}
						mc = null;
					}
					
					//massGotmoshSneg = null;
					
				}
				
				if (telExit1 != null) {
					
					if (lvlManager.field.getChildByName("got." + telExit1.x .toString() + "." + telExit1.y.toString()) == null) {
						var teleport1 = MovieClip(lvlManager.field.getChildByName("teleport." + telEnter1.x .toString() + "." + telEnter1.y.toString() + ".close"));
						teleport1.name = "teleport." + telEnter1.x.toString() + "." + telEnter1.y.toString();
						teleport1.tel.play();
						telExit1 = null;
						telEnter1 = null;
					}
				}
				
				if (telExit2 != null) {
					if (lvlManager.field.getChildByName("got." + telExit2.x .toString() + "." + telExit2.y.toString()) == null) {
						var teleport2 = MovieClip(lvlManager.field.getChildByName("teleport." + telEnter2.x .toString() + "." + telEnter2.y.toString() + ".close"));
						teleport2.name = "teleport." + telEnter2.x.toString() + "." + telEnter2.y.toString();
						teleport2.tel.play();
						telExit2 = null;
						telEnter2 = null;
					}
				}
				
				if (mouseClip != null) { 
					var flMCStop = (Math.abs(mouseClip.x - mouseClip.px) <= 1 && Math.abs(mouseClip.y - mouseClip.py) <= 1);
				/*	if (flChangeColor && flMCStop) {
						flChangeColor = false;
					}*/
					if (banan != null) {
						if(!flMCStop) {
					
					/*	grid.getNumCellXY(mouseClip.x, mouseClip.y);
							if (lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_WALL) {
							trace("stop");	
							}*/
							banan.x = mouseClip.x;
							banan.y = mouseClip.y;
							addSledBanan();
							
						} else {
							
							banan.name = "banan." + mouseClip.px + "." + mouseClip.py;
							
							grid.getNumCellXY(mouseClip.px, mouseClip.py);
							
							var el:String = lvlManager.level.mxGotmoshki[grid.row][grid.col];
							if ( el == EL_EMPTY || el == EL_GOTMOSH_BLUE || el == EL_GOTMOSH_PINK || el == EL_ZABOR ||el == EL_WALL) {
								lvlManager.level.mxGotmoshki[grid.row][grid.col] = EL_BANAN;
							} else {
								if(banan!=null){
									lvlManager.field.removeChild(banan);
								}
								doBonusAction(lvlManager.level.mxGotmoshki[grid.row][grid.col].toString(),mouseClip);
							}
							massDelGotmosh.push(banan);
							banan = null;
							
							if(mouseClip!=null){
								if (mouseClip.name.search("got.del")!=-1) {
									lvlManager.field.removeChild(mouseClip);
									mouseClip = null;
									delKrugs();
									sndManager.ActionPlay(sndUdar);
								} else {
									mouseClip.name = "got." + mouseClip.px + "." + mouseClip.py;
								}
							}
	
						}
					}	
				}
				
				if (lvlManager.field.getChildByName("bananSled.del") != null) {
					lvlManager.field.removeChild(lvlManager.field.getChildByName("bananSled.del"));
				}
				
			}
			
			sndManager.flFonMusicPlay = navGame.stateGame == navGame.STATE_GAME_RUN;
			//	tm.flSndPlay = sndManager.flSoundPlay;
			
			
			
		/*	if (tm != null ){
				
				if (navGame.stateGame == navGame.STATE_GAME_PAUSE || navGame.stateGame == navGame.STATE_GAME_HELP ||navGame.stateGame == navGame.STATE_GAME_CLEAR ||  navGame.stateGame == navGame.STATE_GAME_LEV_COMPL  ) { 
					tm.timerStop(); flTimer = false; 
				} else {
					if (!flTimer) { 
						tm.timerStart(); 
						flTimer = true; 
					}
				}
				navGame.gameMenu.timeScore.text = tm.getStrHour() + " : " + tm.getStrMin() + " : " + tm.getStrSec();
				
			}*/
		}
		
	
		
	}
}