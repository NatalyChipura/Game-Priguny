package app.base {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.net.SharedObject;
	
	import app.levels.LevelManager;
	import flash.text.TextField;
	import flash.ui.Mouse;
		
	public class Core extends MovieClip {

		public const EVT_SKIP_HINT = "skipHint";
		public const EVT_CANCEL = "onCancel";
		
		/* Клавиши */
		public const KEY_LEFT = 37;
		public const KEY_RIGHT = 39;
		public const KEY_UP = 38;
		public const KEY_DOWN = 40;
		
		public const KEY_A = 65;
		public const KEY_D = 68;
		public const KEY_W = 87;
		public const KEY_S = 83;
		
		public const KEY_M = 77; // отключение звука
		public const KEY_P = 80; // пауза
		public const KEY_H = 72; // помощь
		public const KEY_Z = 90; // отмена хода / действия
		public const KEY_R = 82; // рестарт
		
		public const KEY_CTRL = 17; // отмена хода / действия
		public const KEY_ESC = 27; // выход
		
		public const KEY_1 = 49;
		public const KEY_2 = 50;
		public const KEY_3 = 51;
		
		public const KEY_SPACE = 32;
		
		public var nameGame:String;
		public var saveData:SharedObject;
		
		public var navGame:Navigate;
				
		public static var sndManager:SoundManager;
		public static var scoreManager:ScoreManager;
		public var lvlManager:LevelManager;
		public var helpManager:HelpManager;
		public var lifeManager:LifeManager;
	
		public var flHelpWithSkip:Boolean = false;
		public var flGameOver:Boolean = false;
		public var flNextLevelOpen:Boolean = true;
		private var flKeyDown:Boolean;		
		
		public const EVT_GAME_OVER:String = 'gameOverEvent';
		public const EVT_LEVEL_COMPLETE:String = 'levelCompleteEvent';
		
		public static var mouseHint:MovieClip;
	
		public function Core() {
			navGame = new Navigate();
			addChild(navGame);
			
			sndManager = new SoundManager();	
			stage.addChild(sndManager);
			sndManager.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
			sndManager.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			
			helpManager = new HelpManager();
			addChild(helpManager);

			if (loadGame()) {
				lvlManager = new LevelManager(saveData.data.lev);
				lvlManager.curLevelNum = lvlManager.cntOpenLev = navGame.cntOpenLev = saveData.data.lev;

			} else {
				lvlManager = new LevelManager();
				lvlManager.curLevelNum = lvlManager.cntOpenLev = navGame.cntOpenLev = 1;
			}
			
			addEventListener(navGame.EVT_SELECT_LEVEL, gameStart);
			addEventListener(navGame.EVT_HISTORY_SKIP, gameStart);
			addEventListener(navGame.EVT_GO_GAME_PROCESS, gameStart); // addHistoryMenu
			addEventListener(navGame.EVT_YES_GO_MAIN_MENU, goMainMenu); 
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onCoreKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onCoreKeyUp);
			stage.focus = this;
			flKeyDown = false;
			
			mouseHint = new MouseHint();
			stage.addChild(mouseHint);
		}
		
		public static function setMouseHint(event:MouseEvent):void{
			
			switch(event.target.name){
				case "btnCancel":{
					mouseHint.hint.text = "Z";
				}break;
				case "btnMainMenu":{
					mouseHint.hint.text = "Esc";
				}break;
				case "btnRefresh":{
					mouseHint.hint.text = "R";
				}break;
				case "btnPause":{
					mouseHint.hint.text = "P";
				}break;
				case "btnHelp":{
					mouseHint.hint.text = "H";
				}break;
				case "btnSoundOn":{
					mouseHint.hint.text = "M";
				}break;
				case "btnSoundOff":{
					mouseHint.hint.text = "M";
				}break;
			}
			mouseHint.visible = true;
			
		}
		
		public static function resetMouseHint(event:MouseEvent):void{
			mouseHint.visible = false;
		}
		
		private function skipHint(event:MouseEvent):void {
			/*helpManager.curHint = lvlManager.curLevelNum+1;
			setChildIndex(helpManager, 1);
			helpManager.showHint();*/
			
			/*sndManager.menuMusicStop();
			sndManager.changeVolume(1);
			sndManager.fonMusicPlay();*/
			
			navGame.stateGame = navGame.STATE_GAME_RUN;
			
			var e:Event = new Event(EVT_SKIP_HINT,true);
			dispatchEvent(e);
		}
		
		
		
		/* очистка уровня */
		public function clearLevel():void {
			if(lvlManager.field!=null){
				removeChild(lvlManager.field);
				lvlManager.field = null;
				helpManager.hideHint();
			}
		}
		

		// start games
		public function gameStart(event:Event):void {
			
			removeEventListener(navGame.EVT_SELECT_LEVEL, gameStart);
			
			removeEventListener(navGame.EVT_HISTORY_SKIP, gameStart);
			navGame.delMainMenu();
			
			//removeChild(sndManager);
			navGame.addGameMenu();
			//navGame.gameMenu.addChild(sndManager);
			if (navGame.gameMenu.btnMainMenu != null) {
				navGame.gameMenu.btnMainMenu.addEventListener(MouseEvent.CLICK, navGame.addAlertGoMainMenu);
				navGame.gameMenu.btnMainMenu.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
				navGame.gameMenu.btnMainMenu.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			}
			
			if (navGame.gameMenu.btnRefresh != null) {
				navGame.gameMenu.btnRefresh.addEventListener(MouseEvent.CLICK, refreshLevel);
				navGame.gameMenu.btnRefresh.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
				navGame.gameMenu.btnRefresh.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			} 

			if (navGame.gameMenu.btnPause != null) {
				navGame.gameMenu.btnPause.addEventListener(MouseEvent.CLICK, pauseGame);
				navGame.gameMenu.btnPause.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
				navGame.gameMenu.btnPause.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			} 
			
			if (navGame.gameMenu.btnCancel != null) {
				navGame.gameMenu.btnCancel.addEventListener(MouseEvent.CLICK, backStep);
				navGame.gameMenu.btnCancel.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
				navGame.gameMenu.btnCancel.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			} 
			
			if (navGame.gameMenu.btnHelp != null) {
				navGame.gameMenu.btnHelp.addEventListener(MouseEvent.CLICK, helpGame);
				navGame.gameMenu.btnHelp.addEventListener(MouseEvent.MOUSE_OVER, setMouseHint);
				navGame.gameMenu.btnHelp.addEventListener(MouseEvent.MOUSE_OUT, resetMouseHint);
			} 
		
			scoreManager = new ScoreManager();
			navGame.gameMenu.addChild(scoreManager);
			
			lifeManager = new LifeManager();
			navGame.gameMenu.addChild(lifeManager);

			addEventListener(Event.ENTER_FRAME, onMainEnterFrame);
			initGameObj();
			
			//howToPlay(null);
		}
		
		public function backStep(event:Event):void {
			
		}
		
		public function helpGame(event:MouseEvent):void {
			if(helpManager!=null){
				helpManager.showHint(lvlManager.curLevelNum);
			}
		}

		public function pauseGame(event:MouseEvent):void {
			//setChildIndex(helpManager, 1);
			if(navGame.stateGame == navGame.STATE_GAME_RUN){
				navGame.addPauseMenu();
				navGame.pauseMenu.btnMainMenu.addEventListener(MouseEvent.CLICK, goMainMenu);
			}
		}
		
		// инициализация игровых объектов
		public function initGameObj():void {
			//scoreManager.cntScore = 0;
			
			
			navGame.gameMenu.addChild(lvlManager);
			lvlManager.field = new Field();
			addChild(lvlManager.field);
			
			loadLevel();
		}
		
		public function onMainEnterFrame(event:Event):void {
			
			if(!flGameOver){
				checkCollisions();
			}
			
			if(mouseHint.visible){
				mouseHint.x = mouseX;
				mouseHint.y = mouseY;
			}
			// загрузка выбранного уровня
			loadSelectLevel();
		
		}
		
		public function goMainMenu(event:MouseEvent):void {
			//sndManager.changeFonToMenu();
			
			clearLevel();
			
			//setChildIndex(helpManager, 1);

			if(navGame.gameMenu.btnMainMenu!=null) navGame.gameMenu.btnMainMenu.removeEventListener(MouseEvent.CLICK, goMainMenu);			
			navGame.delGameMenu();
			
			if (navGame.pauseMenu != null) {
				navGame.pauseMenu.btnMainMenu.removeEventListener(MouseEvent.CLICK, goMainMenu);
				navGame.delPauseMenu();
			}
			
		//	lvlManager = null;
			
			if(navGame.gameOverMenu!=null){
				navGame.gameOverMenu.btnMainMenu.removeEventListener(MouseEvent.CLICK, goMainMenu);
				navGame.delGameOverMenu();
				
			}
			
			if(navGame.levCompleteMenu!=null){
				navGame.levCompleteMenu.btnMainMenu.removeEventListener(MouseEvent.CLICK, goMainMenu);
				navGame.delLevCompleteMenu();
			}	
			
			navGame.addMainMenu();
			navGame.mainMenu.btnStart.addEventListener(MouseEvent.CLICK, gameStart); 
			//addChild(sndManager);
			addEventListener(navGame.EVT_SELECT_LEVEL, gameStart);
			
		}
					
		// проверка столкновений
		public function checkCollisions():void {

		}
		
		public function gameOver():void {
			
			if (navGame.stateGame != navGame.STATE_GAME_OVER) {

				navGame.addGameOverMenu();
				navGame.gameOverMenu.btnMainMenu.addEventListener(MouseEvent.CLICK, goMainMenu);
				navGame.gameOverMenu.strScore.text = scoreManager.cntScore.toString();
				
				clearLevel();
				
			/*	sndManager.fonMusicStop();
				sndManager.changeVolume(1);
				sndManager.menuMusicPlay();*/
				
				sndManager.gameOverPlay();
				
				//if(lvlManager.cntOpenLev<=lvlManager.cntLevels) saveGame(lvlManager.cntOpenLev);
			}	
		}
		
		private function tryAgane(event:MouseEvent):void {
			sndManager.changeMenuToFon();
			//sndManager.changeFonMenuMusic();
			navGame.levCompleteMenu.btnTryAgane.removeEventListener(MouseEvent.CLICK, tryAgane);
			navGame.selNumLev  = lvlManager.curLevelNum;
		}
		
		public function levelComplete():void {
			
			navGame.addLevCompleteMenu();
			navGame.levCompleteMenu.btnTryAgane.addEventListener(MouseEvent.CLICK,tryAgane);
			navGame.levCompleteMenu.btnNextLevel.addEventListener(MouseEvent.CLICK, nextLevel);
			navGame.levCompleteMenu.btnMainMenu.addEventListener(MouseEvent.CLICK, goMainMenu);
			navGame.levCompleteMenu.strScore.text = scoreManager.cntScore.toString();
			
			clearLevel();
			
			navGame.saveStar(lvlManager.curLevelNum);
			
			if(flNextLevelOpen){
				if (lvlManager.curLevelNum == lvlManager.cntOpenLev) {
					navGame.levCompleteMenu.bonus.visible = true;
					navGame.levCompleteMenu.bonus.gotoAndStop(navGame.cntOpenLev);
					//sndManager.ActionPlay(sndBonus);
					
					lvlManager.cntOpenLev++;
					navGame.cntOpenLev = lvlManager.cntOpenLev;
				} else {
					navGame.levCompleteMenu.bonus.visible = false;
				}
				
				if (lvlManager.cntOpenLev <= LevelManager.cntLevels) saveGame(lvlManager.cntOpenLev);
			} else {
				navGame.levCompleteMenu.btnNextLevel.alpha = 0.3;
				navGame.levCompleteMenu.btnNextLevel.mouseEnabled = false;
				navGame.levCompleteMenu.bonus.visible = false;
			}
			
			sndManager.levCompletePlay(flNextLevelOpen);
		}
		
		public function loadSelectLevel():void{
			//if(navGame.selectLevMenu!=null){
				
				 if(navGame.selNumLev!=0) {
					navGame.gameMenu.visible= true;
					clearLevel();
					
					lvlManager.curLevelNum = navGame.selNumLev;
					//lvlManager.goLevelNum(navGame.selNumLev);
					lvlManager.field = new Field();
					addChild(lvlManager.field);
				
					/*if (helpManager.curHint != 1) {
						helpManager.curHint = navGame.selNumLev + 1;
						setChildIndex(helpManager, 1);
					}*/

					this.loadLevel();
					
					navGame.selNumLev = 0;
					navGame.delSelectLevMenuPlay();
					navGame.delLevCompleteMenu();
				}
			//}
		}
		
		public function loadLevel():void {
			sndManager.changeMenuToFon();
			//sndManager.changeFonMenuMusic();
			
			lvlManager.goLevelNum(lvlManager.curLevelNum);
			flNextLevelOpen = true;
			
			//if(stateGame!=STATE_GAME_OVER) stateGame = STATE_LEV_RUN;
			setChildIndex(navGame, numChildren - 1);
			
			setChildIndex(helpManager,numChildren - 1);
			helpManager.cntShowHint = lvlManager.cntOpenLev;
			if (lvlManager.curLevelNum <= lvlManager.cntOpenLev) {
				navGame.saveLevData = SharedObject.getLocal("Lev" + lvlManager.curLevelNum.toString());
				
				if(navGame.saveLevData.data.helpSee != true){
					helpManager.showHint(lvlManager.curLevelNum);
				}
			}
			
			
			/*if(helpManager.curHint==1) setChildIndex(helpManager, numChildren - 1);
			helpManager.showHint();*/
		}
		
		public function loadGame():Boolean{
			saveData = SharedObject.getLocal(nameGame);
			if(saveData.data.lev!=null){
				return true;
			} else {
				return false;
			}
		}
		
		public function nextLevel(event:MouseEvent):void {
			/*sndManager.menuMusicStop();
			sndManager.changeVolume(1);
			sndManager.fonMusicPlay();*/
			sndManager.changeMenuToFon();
						
			navGame.levCompleteMenu.btnNextLevel.removeEventListener(MouseEvent.CLICK, nextLevel);
			if (lvlManager.curLevelNum + 1 <= LevelManager.cntLevels) {
				navGame.selNumLev = lvlManager.curLevelNum+1;
			} else {
				navGame.selNumLev = 1;
			}
		}
		
		public function saveGame(cntOpenLev:uint):Boolean{
			saveData.data.lev = cntOpenLev;
			var flushResult:Object = saveData.flush();
			return flushResult;
		}
		
		public function refreshLevel(event:MouseEvent):void {
			navGame.selNumLev = lvlManager.curLevelNum;
			//clearLevel();
		}
		
		public function onCoreKeyUp(event:KeyboardEvent):void {
			flKeyDown = false;
		}
		
		public function onCoreKeyDown(event:KeyboardEvent):void {
			flKeyDown = true;
			/*
			if(event.altKey){
				switch(event.keyCode){
					case KEY_Z:{
						trace(event.altKey);
						var e:Event = new Event(EVT_CANCEL,true);
						dispatchEvent(e);
						
					} break;
				}
			} else {*/
				switch(event.keyCode){
					case KEY_Z:{
					//	trace(event.altKey);
						
						
						var e:Event = new Event(EVT_CANCEL,true);
						dispatchEvent(e);
						
					} break;
					case KEY_M:{
						if( sndManager.flSoundPlay){
							sndManager.funcSoundOff(null);
						} else {
							sndManager.funcSoundOn(null);
						}
					} break;
					case KEY_P:{
						if(navGame.stateGame == navGame.STATE_GAME_RUN){
							pauseGame(null);
						} else if (navGame.stateGame == navGame.STATE_GAME_PAUSE){
							navGame.returnGame(null);
						}
					} break;
					case KEY_H:{
						if(helpManager.visible == false){
							helpGame(null);
						} else {
							helpManager.hideHint();
						}
					} break;
					case KEY_ESC:{
						if(navGame.alertGoMainMenu == null){
							navGame.addAlertGoMainMenu(null);
						}
					} break;
					
					case KEY_R:{
						refreshLevel(null);
					} break;
				}
		//	}
			
		}
	}
}