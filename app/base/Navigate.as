package app.base  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.filters.GlowFilter;
	
	import app.menus.ShopMenu;
	import app.menus.LevCompleteMenu;
	import app.menus.SelectLevMenu;
	import app.menus.HistoryMenu;
	import app.menus.PauseMenu;
	import app.levels.LevelManager;
	import app.menus.AlertGoMainMenu;
	import flash.net.URLVariables;
	
	public class Navigate extends MovieClip {

		/* Состояния игры */
		public const STATE_GAME_RUN = "run";
		public const STATE_GAME_CLEAR = "clear";
		public const STATE_GAME_PAUSE = "pause";
		public const STATE_GAME_HELP = "help";
		public const STATE_GAME_LEV_COMPL = "levCompl";
		public const STATE_GAME_MAIN_MENU = "main";		
		public const STATE_GAME_OVER = "gameOver"
		
		public const EVT_OPEN_SELLEV_MENU = "OpenSelectLevelMenu";
		public const EVT_SELECT_LEVEL = "SelectLevel";
		public const EVT_PAUSE = "onPause";
		public const EVT_RETURN_GAME = "onReturn";
		public const EVT_HISTORY_SKIP = "onHistorySkip";
		public const EVT_GO_GAME_PROCESS = "onGoGameProcess";
		public const EVT_YES_GO_MAIN_MENU = "onGoMainMenu";

		public var sx:Number = 0;
		public var sy:Number = 0;
		
		/* Менюшки */
		public var levCompleteMenu:LevCompleteMenu;
		public var gameOverMenu:GameOverMenu;
		public var subScoreMenu:SubScoreMenu;
		public var selectLevMenu:SelectLevMenu;
		public var mainMenu:MainMenu;
		public var pauseMenu:PauseMenu;
		public var gameMenu:GameMenu;
		public var medalMenu:MedalMenu;
		public var shopMenu:ShopMenu;
		public var historyMenu:HistoryMenu;
		public var alertGoMainMenu:AlertGoMainMenu;
		
		public static var pages:uint = 1;
		public static var page:uint = 1;
		public static var cntBtnLevOnPage:uint = 15;
		public static var cntBtnLevColMap = 5;
		public static var cntLevels = 15;
		public var selNumLev:uint;
		public var cntOpenLev:uint = 1;	
		public var cntMedals:uint = 8;
		public var cntTovar:uint = 9;
		public var cntStars:uint = 0;
		
		private var btnLevelNum:BtnLevelNum;
		
		public var stateGame:String;
		
		public var saveMedalData:SharedObject;
		public var saveShopData:SharedObject;
		public var saveLevData:SharedObject;
		
		public var massMedal:Array;
		public var massTovar:Array;
		
		private var fltGlow:GlowFilter;
		
		private var i:uint;
		private var n0:uint;
		private var n:uint;
		
		
		
		
		public function Navigate() {
			// constructor code
			addMainMenu();
			
			massMedal = new Array();
			saveMedalData = SharedObject.getLocal("Medals");
			if(saveMedalData.data.medal!=null){
				massMedal = saveMedalData.data.medal;
			}else {
				for (i = 1; i <= cntMedals; i++) {
					massMedal[i] = false;
				}
			}
			
			massTovar = new Array();
			saveShopData = SharedObject.getLocal("Shop");
			if(saveShopData.data.tovar!=null){
				massTovar = saveShopData.data.tovar;
			}else {
				for (i = 1; i <= cntTovar; i++) {
					massTovar[i] = false;
				}
			}
			
			fltGlow = new GlowFilter(0xFFFF99, 1, 3, 3, 100, 3, false);
			
			
		}
		
		public function addAlertGoMainMenu(event:MouseEvent):void{
			Core.sndManager.changeFonToMenu();
			alertGoMainMenu = new AlertGoMainMenu();
			addChild(alertGoMainMenu);
			alertGoMainMenu.btnYes.addEventListener(MouseEvent.CLICK, goMainMenuYes); 
			alertGoMainMenu.btnNo.addEventListener(MouseEvent.CLICK, returnGame);
			alertGoMainMenu.btnSelectLevel.addEventListener(MouseEvent.CLICK,openSelectLevMenu);
			alertGoMainMenu.btnMoreGames.addEventListener(MouseEvent.CLICK, MoreGames);
		}
		
		private function goMainMenuYes(event:MouseEvent):void{
			delAlertMenu();
			var e:MouseEvent = new MouseEvent(EVT_YES_GO_MAIN_MENU,true);
			dispatchEvent(e);
		}
		
		public function delAlertMenu():void{
			if (alertGoMainMenu != null) {
				removeChild(alertGoMainMenu);
				alertGoMainMenu.btnYes.removeEventListener(MouseEvent.CLICK, goMainMenuYes); 
				alertGoMainMenu.btnNo.removeEventListener(MouseEvent.CLICK, returnGame);
				alertGoMainMenu.btnMoreGames.removeEventListener(MouseEvent.CLICK, MoreGames);
				alertGoMainMenu.btnSelectLevel.removeEventListener(MouseEvent.CLICK,openSelectLevMenu);
				alertGoMainMenu = null;
			}
		}
		
		public function addMainMenu():void{
			mainMenu = new MainMenu();
			addChild(mainMenu);
			mainMenu.btnStart.addEventListener(MouseEvent.CLICK, startGameProcess);  // addHistoryMenu
			mainMenu.btnMedals.addEventListener(MouseEvent.CLICK, addMedalsMenu);
			mainMenu.btnSelLev.addEventListener(MouseEvent.CLICK, openSelectLevMenu);
			mainMenu.btnMoreGames.addEventListener(MouseEvent.CLICK, MoreGames);
			stateGame = STATE_GAME_MAIN_MENU;
			if(Core.sndManager!=null){
				Core.sndManager.changeFonToMenu();
			}
		}
		
		private function startGameProcess(event:MouseEvent):void {
			var e:Event = new Event(EVT_GO_GAME_PROCESS,true);
			dispatchEvent(e);
		}
		
		public function saveMedal(i:uint):void {
			saveMedalData = SharedObject.getLocal("Medals");
			massMedal[i] = true;
			saveMedalData.data.medal  = massMedal;
			saveMedalData.flush();
		}
	
		public function isMedal(i:uint):Boolean {
			saveMedalData = SharedObject.getLocal("Medals");
			if(saveMedalData.data.medal!=null){
				if(saveMedalData.data.medal[i]==true){
					return true;
				} 
			}
			return false;
		}
		
		private function addMedalsMenu(event:MouseEvent):void {
			medalMenu = new MedalMenu();
			addChild(medalMenu);
			medalMenu.btnReturn.addEventListener(MouseEvent.CLICK,returnMainMenu);
			
			saveMedalData = SharedObject.getLocal("Medals");
			if(saveMedalData.data.medal!=null){
				for (var i = 1; i <= cntMedals; i++) {
					if(saveMedalData.data.medal[i]==true){
						MovieClip(medalMenu.getChildByName("m"+i.toString())).gotoAndStop(2); 
					}
				}	
			}
		}
		
		public function growBtnOn(event:MouseEvent):void {
			event.target.filters = [fltGlow];
		}
		
		public function growBtnOff(event:MouseEvent):void {
			event.target.filters = [];
		}
		
		public function buyTovar(event:MouseEvent):void {
			
			var s:String = event.target.name;
			var i = uint(s.substr(1, s.length));
			
			//sndManager.ActionPlay(sndShop);
			
			saveTovar(i);
			Core.scoreManager.cntMoney-= uint(event.target.price.text);
			shopMenu.strScore.text = Core.scoreManager.cntMoney.toString();
			
			MovieClip(shopMenu.getChildByName("t" + i.toString())).gotoAndStop(3);
			for (i = 1; i <= cntTovar; i++) {
			
				if (saveShopData.data.tovar[i] != true && uint(MovieClip(shopMenu.getChildByName("t" + i.toString())).price.text) > Core.scoreManager.cntMoney) {
					MovieClip(shopMenu.getChildByName("t" + i.toString())).gotoAndStop(1); 
					MovieClip(shopMenu.getChildByName("t" + i.toString())).mouseEnabled = false;
					MovieClip(shopMenu.getChildByName("t" + i.toString())).mouseChildren = false;
					MovieClip(shopMenu.getChildByName("t" + i.toString())).removeEventListener(MouseEvent.CLICK, buyTovar);
					MovieClip(shopMenu.getChildByName("t" + i.toString())).removeEventListener(MouseEvent.MOUSE_OVER, growBtnOn);
					MovieClip(shopMenu.getChildByName("t" + i.toString())).removeEventListener(MouseEvent.MOUSE_OUT, growBtnOff);
				}
			}	
			
		}
		
		public function saveTovar(i:uint,fl:Boolean = true):void {
			saveShopData = SharedObject.getLocal("Shop");
			massTovar[i] = fl;
			saveShopData.data.tovar  = massTovar;
			saveShopData.flush();
		}
		
		public function addShopMenu():void {
			setPause();
			
			shopMenu = new ShopMenu();
			addChild(shopMenu);
			shopMenu.btnReturn.addEventListener(MouseEvent.CLICK, returnGame);
			shopMenu.strScore.text = Core.scoreManager.cntMoney.toString();
			
			saveShopData = SharedObject.getLocal("Shop");
			
			for (var i = 1; i <= cntTovar; i++) {
			
				if (saveShopData.data.tovar != null && saveShopData.data.tovar[i] == true) {
					
					MovieClip(shopMenu.getChildByName("t"+i.toString())).gotoAndStop(3); 
				} else if (uint(MovieClip(shopMenu.getChildByName("t" + i.toString())).price.text) <= Core.scoreManager.cntScore) {
					MovieClip(shopMenu.getChildByName("t" + i.toString())).gotoAndStop(2); 
					MovieClip(shopMenu.getChildByName("t" + i.toString())).mouseEnabled = true;
					MovieClip(shopMenu.getChildByName("t" + i.toString())).mouseChildren = false;
					MovieClip(shopMenu.getChildByName("t" + i.toString())).addEventListener(MouseEvent.CLICK, buyTovar);
					MovieClip(shopMenu.getChildByName("t" + i.toString())).addEventListener(MouseEvent.MOUSE_OVER, growBtnOn);
					MovieClip(shopMenu.getChildByName("t" + i.toString())).addEventListener(MouseEvent.MOUSE_OUT, growBtnOff);
				}
			}	
			
		}
		
		public function addHistoryMenu(event:MouseEvent):void {
			delMainMenu();
					
			historyMenu = new HistoryMenu();
			addChild(historyMenu);
			historyMenu.btnSkip.addEventListener(MouseEvent.CLICK, delHistoryMenu);
			
			Core.sndManager.changeFonToMenu();
		}
		
		private function delHistoryMenu(event:MouseEvent):void {
			historyMenu.btnSkip.removeEventListener(MouseEvent.CLICK, delHistoryMenu);
			removeChild(historyMenu);
			historyMenu = null;

			var e:Event = new Event(EVT_HISTORY_SKIP,true);
			dispatchEvent(e);
		}
		
		private function returnMainMenu(event:MouseEvent):void {
			medalMenu.btnReturn.removeEventListener(MouseEvent.CLICK, returnLevComplete);
			
			removeChild(medalMenu);
			medalMenu = null;
		}
		
		public function addGameMenu():void{
			stateGame = STATE_GAME_RUN;
			gameMenu = new GameMenu();
			addChild(gameMenu);
		}
		
		public function addLevCompleteMenu():void {
			Core.sndManager.changeFonToMenu();
			levCompleteMenu = new LevCompleteMenu();
			addChild(levCompleteMenu);
			levCompleteMenu.btnSelectLevel.addEventListener(MouseEvent.CLICK,openSelectLevMenu);
			levCompleteMenu.btnMoreGames.addEventListener(MouseEvent.CLICK, MoreGames);
			//levCompleteMenu.btnSubScore.addEventListener(MouseEvent.CLICK, addSubScoreMenu);
			stateGame = STATE_GAME_LEV_COMPL;
		}
		
		public function addGameOverMenu():void{
			gameOverMenu = new GameOverMenu();
			addChild(gameOverMenu);
			gameOverMenu.btnMoreGames.addEventListener(MouseEvent.CLICK, MoreGames);
			gameOverMenu.btnSubScore.addEventListener(MouseEvent.CLICK, addSubScoreMenu);
			
			stateGame = STATE_GAME_OVER; 			
		}
		
		private function addSubScoreMenu(event:MouseEvent):void {
			var myurl:String = "index.php?act=Arcade&do=newscore";
			var req:* = new URLRequest(myurl);
			var mydata:* = new URLVariables();
			mydata.gname = "Priguny";
			mydata.gscore = Core.scoreManager.cntScore;
			trace("Score:", Core.scoreManager.cntScore);
			req.data = mydata;
			req.method = URLRequestMethod.POST;
			navigateToURL(req, "_self");
			
			/*subScoreMenu = new SubScoreMenu();
			addChild(subScoreMenu);
			if(levCompleteMenu!=null) {
				subScoreMenu.boxScore.scoreText.text = levCompleteMenu.strScore.text;
			} else if(gameOverMenu!=null) {
				subScoreMenu.boxScore.scoreText.text = gameOverMenu.strScore.text;
			}
			subScoreMenu.nameUser.text = "";
			
			/*subScoreMenu.logo.buttonMode = true;
			subScoreMenu.logo.useHandCursor = true;
			subScoreMenu.logo.addEventListener(MouseEvent.CLICK, MoreGamesSubScoreLogo);
			*/
		/*	subScoreMenu.btnSubScore.addEventListener(MouseEvent.CLICK, submitScore);
			subScoreMenu.btnReturn.addEventListener(MouseEvent.CLICK,returnLevComplete);
			*/
			/*if (TremorGames.IsLoggedIn()) {
				
				subScoreMenu.nameUser.text = TremorGames.GetPlayerName(); 
			} */
			
		}
		
		private function returnLevComplete(event:MouseEvent):void {
			subScoreMenu.btnSubScore.removeEventListener(MouseEvent.CLICK, submitScore);
			subScoreMenu.btnReturn.removeEventListener(MouseEvent.CLICK, returnLevComplete);
			//subScoreMenu.logo.removeEventListener(MouseEvent.CLICK, MoreGamesSubScoreLogo);
			removeChild(subScoreMenu);
			subScoreMenu = null;
		}
		
		private function submitScore(event:MouseEvent):void {
			
			var PlayerName:String = subScoreMenu.nameUser.text.toString();
			
			if (PlayerName != "\n" && PlayerName != "\r" && PlayerName != "") {
				
				returnLevComplete(event);
			} else {
				subScoreMenu.edText.gotoAndPlay(2);
			}
			
		}
		
		private function setPause():void {
			stateGame = STATE_GAME_PAUSE;
			//gameMenu.visible = false;
			
			var e:Event = new Event(EVT_PAUSE,true);
			dispatchEvent(e);
		}
		
		public function addPauseMenu():void {
			setPause();
			
			pauseMenu = new PauseMenu();
			addChild(pauseMenu);
			pauseMenu.btnSelectLevel.addEventListener(MouseEvent.CLICK,openSelectLevMenu);
			pauseMenu.btnReturn.addEventListener(MouseEvent.CLICK,returnGame);
			pauseMenu.btnMoreGames.addEventListener(MouseEvent.CLICK, MoreGames);
		//	pauseMenu.btnMainMenu.addEventListener(MouseEvent.CLICK,goMainMenu);
		
			
		}
		
		private function addBtnNumLevel():void{
			selectLevMenu.numPage.text = page.toString();
			
			if (page == 1) {
				selectLevMenu.btnPrevPage.alpha = 0.5;
				selectLevMenu.btnPrevPage.mouseEnabled = false;
			} else {
				selectLevMenu.btnPrevPage.alpha = 1;
				selectLevMenu.btnPrevPage.mouseEnabled = true;
				selectLevMenu.btnPrevPage.addEventListener(MouseEvent.CLICK,goPrevPage);
			}
			if (page == pages) {
				selectLevMenu.btnNextPage.alpha = 0.5;
				selectLevMenu.btnNextPage.mouseEnabled = false;
			} else {
				selectLevMenu.btnNextPage.alpha = 1;
				selectLevMenu.btnNextPage.mouseEnabled = true;
				selectLevMenu.btnNextPage.addEventListener(MouseEvent.CLICK,goNextPage);
			}
			
			var j = 0;
			getNumberSelectMenu();
			
			for (var i = n0; i <= n ; i++) {
				btnLevelNum = new BtnLevelNum();
				
				btnLevelNum.y = sy + (btnLevelNum.height) * (Math.ceil(((i-n0)+1) / cntBtnLevColMap) - 1);
				btnLevelNum.x = sx + (btnLevelNum.width)* j;
				if ((i % cntBtnLevColMap) == 0 ) {
					j = 0;
				} else { j++; }

				btnLevelNum.numLev.text = i.toString();
				
				btnLevelNum.mouseChildren = false;
			//	if (i <= cntOpenLev) {
				if (i <= (cntOpenLev<10?10:cntOpenLev)) {
			//	if (i <= 14) {
					btnLevelNum.gotoAndStop(1);
					
					btnLevelNum.addEventListener(MouseEvent.MOUSE_OVER, onLightBtn);
					btnLevelNum.addEventListener(MouseEvent.MOUSE_OUT, offLightBtn);
					
					btnLevelNum.mouseEnabled = true;
				
				} else {
					btnLevelNum.gotoAndStop(3);
					btnLevelNum.mouseEnabled = false;
					
				}
				
				btnLevelNum.buttonMode = true;
				btnLevelNum.useHandCursor = true;
				
				
				btnLevelNum.addEventListener(MouseEvent.CLICK, selectLevel);
				selectLevMenu.addChild(btnLevelNum).name = i.toString();
				btnLevelNum = null;
			}
			
			loadStar(null);
		}
		
		private function getNumberSelectMenu():void{
			n = 0;
			if(cntBtnLevOnPage*page >= cntLevels){
				n = cntLevels;
			} else {
				n = cntBtnLevOnPage*page;
			}
			n0 = (cntBtnLevOnPage*(page-1))+1;
			
		}
		
		private function removeBtnNumLevel():void{
			getNumberSelectMenu();
			
			for (var i = n0; i <= n ; i++) {
				selectLevMenu.getChildByName(i.toString()).removeEventListener(MouseEvent.CLICK, selectLevel);
				selectLevMenu.removeChild(selectLevMenu.getChildByName(i.toString()));
			}
		}
		
		public function addSelectLevMenu():void{
			//Core.sndManager.changeFonToMenu();
			selectLevMenu = new SelectLevMenu();
			addChild(selectLevMenu);
			
			selNumLev = 0;
			
			addBtnNumLevel();
			
			selectLevMenu.btnBack.addEventListener(MouseEvent.CLICK,backToPrevMenu);
			selectLevMenu.btnMoreGame.addEventListener(MouseEvent.CLICK,MoreGames);

		}
		
		private function goPrevPage(event:MouseEvent):void {
			removeBtnNumLevel();
			page--;
			addBtnNumLevel();
		}
		
		private function goNextPage(event:MouseEvent):void {
			removeBtnNumLevel();
			page++;
			addBtnNumLevel();
		}
		
		
		
		public function saveHelpSee(numLev:uint):void{
			saveLevData = SharedObject.getLocal("Lev"+numLev.toString());
			saveLevData.data.helpSee = true;
			saveLevData.flush();
		}
		
		public function saveStar(numLev:uint):void{
			saveLevData = SharedObject.getLocal("Lev"+numLev.toString());
			if(saveLevData.data.cntStar==null){
				saveLevData.data.cntStar = cntStars;
			} else {
				if(saveLevData.data.cntStar<cntStars){
					saveLevData.data.cntStar = cntStars;
				}
			}
			
			saveLevData.data.helpSee = true;
			saveLevData.flush();
		}
		
		private function loadStar(event:Event):void {
			getNumberSelectMenu();
			
			for (var i = n0; i <= n ; i++) {
			//for (i = 1; i <= LevelManager.cntLevels; i++) {
				saveLevData = SharedObject.getLocal("Lev" + i.toString());
				if(saveLevData.data.cntStar!=null){
					MovieClip(selectLevMenu.getChildByName(i.toString())).stars.gotoAndStop(saveLevData.data.cntStar + 1); 
				}
			}
			
		}
		
		public function onLightBtn(event:MouseEvent):void {
			MovieClip(event.target).gotoAndStop(2);
		}
		
		public function offLightBtn(event:MouseEvent):void {
			MovieClip(event.target).gotoAndStop(1);
		}
		
		private function backToPrevMenu(event:MouseEvent):void {
			if(stateGame == STATE_GAME_MAIN_MENU){
				delSelectLevMenuBack();
			} else {
				delSelectLevMenuPlay();
			}
		}
		
		public function delSelectLevMenuBack():void{
			if(selectLevMenu != null){
				removeBtnNumLevel();
				removeChild(selectLevMenu);
				selectLevMenu = null;
			}
		}
	
		public function delSelectLevMenuPlay():void{
			Core.sndManager.changeMenuToFon();
			if(selectLevMenu != null){
				/*getNumberSelectMenu();
				for (var i = n0; i <= n; i++) {
					selectLevMenu.getChildByName(i.toString()).removeEventListener(MouseEvent.CLICK, selectLevel);
				}*/
				removeBtnNumLevel();
				removeChild(selectLevMenu);
				selectLevMenu = null;
			}
			stateGame = STATE_GAME_RUN;
		}
		
		public function delLevCompleteMenu():void{
			if (levCompleteMenu != null) {
				levCompleteMenu.btnSelectLevel.removeEventListener(MouseEvent.CLICK,openSelectLevMenu);
				levCompleteMenu.btnMoreGames.removeEventListener(MouseEvent.CLICK, MoreGames);
				//levCompleteMenu.btnSubScore.removeEventListener(MouseEvent.CLICK, addSubScoreMenu);
				removeChild(levCompleteMenu);
				levCompleteMenu = null;
			}
		}
		
		public function delGameOverMenu():void{
			if (gameOverMenu != null) {
				gameOverMenu.btnMoreGames.removeEventListener(MouseEvent.CLICK, MoreGames);
				gameOverMenu.btnSubScore.removeEventListener(MouseEvent.CLICK, addSubScoreMenu);
				
				removeChild(gameOverMenu);
				gameOverMenu = null;
			}
		}
		
		public function delMainMenu():void{
			if (mainMenu != null) {
				removeChild(mainMenu);
				mainMenu.btnMedals.removeEventListener(MouseEvent.CLICK, addMedalsMenu);
				mainMenu.btnSelLev.removeEventListener(MouseEvent.CLICK, openSelectLevMenu);
				mainMenu.btnMoreGames.removeEventListener(MouseEvent.CLICK, MoreGames);
				mainMenu.btnStart.removeEventListener(MouseEvent.CLICK, addHistoryMenu);
				mainMenu = null;
			}
		}
		
		public function delGameMenu():void{
			if (gameMenu != null) {
				removeChild(gameMenu);
				gameMenu = null;
			}
		}
		
		public function delPauseMenu():void{
			if (pauseMenu != null) {
				removeChild(pauseMenu);
				pauseMenu.btnMoreGames.removeEventListener(MouseEvent.CLICK, MoreGames);
				pauseMenu.btnReturn.removeEventListener(MouseEvent.CLICK, returnGame);
				pauseMenu = null;
			}
			
			if (shopMenu != null) {
				removeChild(shopMenu);
				shopMenu.btnReturn.removeEventListener(MouseEvent.CLICK, returnGame);
				shopMenu = null;
			}
			
			if (historyMenu != null) {
				removeChild(historyMenu);
				historyMenu.btnSkip.removeEventListener(MouseEvent.CLICK, returnGame);
				historyMenu = null;
				
			}			
		
		}
		
		private function MoreGames(event:MouseEvent):void {
			var URL:URLRequest=new URLRequest("http://sogood.com");
			navigateToURL(URL,"_blank");
		}
		
		private function openSelectLevMenu(event:MouseEvent):void{
			delLevCompleteMenu();
			delAlertMenu();
			
			if (pauseMenu != null) {
				delPauseMenu();
				stateGame = STATE_GAME_CLEAR;
			}
			
			addSelectLevMenu();
			
			var e:Event = new Event(EVT_OPEN_SELLEV_MENU,true);
			dispatchEvent(e);
		}
		
		public function returnGame(event:MouseEvent):void {
			Core.sndManager.changeMenuToFon();
			stage.focus = stage;
			
			var e:Event = new Event(EVT_RETURN_GAME,true);
			dispatchEvent(e);
			
			stateGame = STATE_GAME_RUN;
			gameMenu.visible = true;
			delPauseMenu();
			delAlertMenu();
		}
		
		private function selectLevel(event:MouseEvent):void {
			
			selNumLev = event.currentTarget.name;
			
			var e:Event = new Event(EVT_SELECT_LEVEL,true);
			dispatchEvent(e);
		}
		

	}
	
}
