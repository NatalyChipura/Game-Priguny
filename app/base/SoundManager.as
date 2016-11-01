package  app.base {
	
	import flash.display.MovieClip;
	
	import flash.media.SoundChannel;
	import flash.media.Sound; 
	import flash.media.SoundTransform;
	
	import flash.events.Event;	
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class SoundManager extends MovieClip {

		private var SoundTrans:SoundTransform; 
		
	//	private var fonMusic:sndFonMusic = null;
	//	private var menuMusic:sndMenuMusic = null;
		private var fonMusic:Sound = null;
		private var menuMusic:Sound = null;
		
	//	private var soundLevComplete:sndLevComplete = null;
	//	private var soundGameOver:sndGameOver = null;
	
		private var soundLevComplete:Sound = null;
		private var soundGameOver:Sound = null;

		public var fonChannel:SoundChannel;
		public var menuChannel:SoundChannel;
		public var ActionChannel:SoundChannel;
		public var levCompleteChannel:SoundChannel;
		public var gameOverChannel:SoundChannel;
		
		public var flSoundPlay:Boolean = true;
		public var flFonMusicPlay:Boolean = false;
		
		private var volume:Number = 1;
		public var volumeMenu:Number = 1;
		public var volumeFon:Number = 1;
		private var posMusic:Number = 0;
		
		private var btnSoundOff:SoundOff;
		private var btnSoundOn:SoundOn;
		
		private var req:URLRequest;
		
		public function SoundManager() {
			btnSoundOff = new SoundOff();
			btnSoundOff.addEventListener(MouseEvent.CLICK, funcSoundOff);
			btnSoundOff.x = 0; 
			
			btnSoundOn = new SoundOn();
			btnSoundOn.addEventListener(MouseEvent.CLICK, funcSoundOn);
			btnSoundOn.x = 0; 
			
			addChild(btnSoundOn).name = "btnSoundOn";
			addChild(btnSoundOff).name = "btnSoundOff";
			
			flFonMusicPlay = false;
			   
			if(flSoundPlay){
			   btnSoundOn.visible = false;
			   menuMusicPlay();
			} else {
			   btnSoundOff.visible = false;
			}
		}
		
		public function funcSoundOff(event:Event):void{
			
			if( flSoundPlay){
				addEventListener(Event.ENTER_FRAME,onSndVolumeMin);
				//soundStop();
				btnSoundOn.visible = true;
				btnSoundOff.visible = false;
			}

		}
		
		public function funcSoundOn(event:Event):void{
			if(!flSoundPlay){
				soundPlay();
				addEventListener(Event.ENTER_FRAME,onSndVolumeMax);
				btnSoundOff.visible = true;
				btnSoundOn.visible = false;
			}
		}
		
		public function menuMusicPlay():void {
			if(flSoundPlay) {
				
				if (menuMusic == null) {
					if(menuChannel!=null){menuChannel.stop();}
					menuMusic = new sndMenuMusic(); 
					/*try{
						req = new URLRequest("sounds/MusicMenu.mp3"); 
						menuMusic = new Sound(req);
					} catch (e:Error) {
						
					}*/
				
					SoundTrans = new SoundTransform(volume, 0); 
					menuChannel = menuMusic.play(posMusic,1,SoundTrans);
					menuChannel.addEventListener(Event.SOUND_COMPLETE, menuMusicRepeat);
				}
			}
		}
		
		public function fonMusicPlay():void {
			
			if(flSoundPlay) {
				
				if (fonMusic == null) {
					if(fonChannel!=null){fonChannel.stop();}
					fonMusic = new sndFonMusic(); 
					/*try{
						req = new URLRequest("sounds/MusicGame.mp3"); 
						fonMusic = new Sound(req);
					} catch (e:Error) {
						
					}	*/
				
					SoundTrans = new SoundTransform(volume, 0); 
					fonChannel = fonMusic.play(posMusic,1,SoundTrans);
					fonChannel.addEventListener(Event.SOUND_COMPLETE, fonMusicRepeat);
				}
			}
		}
		
		public function changeVolume(v:Number):void {
			volume = v;
		}
		
		private function menuMusicRepeat(event:Event):void{
			menuMusic = null;
			menuMusicPlay();
		}
		
		private function fonMusicRepeat(event:Event):void{
			fonMusic = null;
			fonMusicPlay();
		}
		
		public function levCompletePlay(flSuccess:Boolean = true):void {
			if (flSoundPlay) {
				
				if(flSuccess){
					/*try{
						req = new URLRequest("sounds/LevelCompleteSuccess.mp3"); 
						fonMusic = new Sound(req);
					} catch (e:Error) {
						
					}*/
					soundLevComplete = new sndLevCompleteWin();
				} else {
					/*try{
						req = new URLRequest("sounds/LevelCompleteFail.mp3"); 
						fonMusic = new Sound(req);
					} catch (e:Error) {
						
					}*/
					soundLevComplete = new sndLevCompleteFail();
				}
				levCompleteChannel = soundLevComplete.play();
				soundLevComplete = null;
			}
		}
		
		public function gameOverPlay():void {
			if (flSoundPlay) {
				soundGameOver = new sndGameOver();
				gameOverChannel = soundGameOver.play();
				soundGameOver = null;
			}
		}
		
		public function ActionPlay(snd:Sound):void {
			if (flSoundPlay) {
				try {
					levCompleteChannel = snd.play();
				} catch (e:Error) {
					
				}
				
			}
		}
		
		public function menuMusicStop():void{ 
			if(menuChannel!=null){
				
				menuChannel.stop();
				menuMusic = null;
			}	
		}
		
		public function fonMusicStop():void{ 
			if (fonChannel != null) {
				
				fonChannel.stop();
				fonMusic = null;
			}
			
		}
		
		public function soundStop():void{ 
			fonMusicStop();
			menuMusicStop();
			flSoundPlay = false;
		}	
		
		public function soundPlay():void{ 
			flSoundPlay = true;
			if (flFonMusicPlay) { 
				fonMusicPlay(); 
			} else {
				menuMusicPlay();
			}
		}
		
		/*public function changeFonMenuMusic():void{
			if(fonMusic!=null){
				fonMusicStop();
				changeVolume(volumeMenu);
				posMusic = 0;
				menuMusicPlay();
			} else if (menuMusic!=null) {
				menuMusicStop();
				changeVolume(volumeFon);
				posMusic = 0;
				fonMusicPlay();
			}
		}*/
		
		public function changeFonToMenu():void{
			fonMusicStop();
			changeVolume(volumeMenu);
			posMusic = 0;
			menuMusicPlay();
		}
		
		public function changeMenuToFon():void{
			menuMusicStop();
			changeVolume(volumeFon);
			posMusic = 0;
			fonMusicPlay();
		}
		
		public function onSndVolumeMin(event:Event):void {
			if(volume>=0){
				volume-=0.03;
				SoundTrans = new SoundTransform(volume, 0); 
				
				if(menuMusic!=null){
					menuChannel.soundTransform = SoundTrans;
					posMusic = menuChannel.position;
				}
				if(fonMusic!=null){
					fonChannel.soundTransform = SoundTrans;
					posMusic = fonChannel.position;
				}
				
			} else {
				volume = 0;
				//flSoundPlay = false;
				soundStop();
				removeEventListener(Event.ENTER_FRAME, onSndVolumeMin);
			}
		}
		
		public function onSndVolumeMax(event:Event):void {
			if(volume<1){
				volume+=0.03;
				SoundTrans = new SoundTransform(volume, 0); 
				if(menuMusic!=null){
					menuChannel.soundTransform = SoundTrans;
				}
				if(fonMusic!=null){
					fonChannel.soundTransform = SoundTrans;
				}
				
			} else {
				volume = 1;
				removeEventListener(Event.ENTER_FRAME, onSndVolumeMax);
			}
		}

	}
	
}
