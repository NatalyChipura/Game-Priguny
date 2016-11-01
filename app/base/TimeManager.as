package app.base 
{
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	
	import flash.media.SoundChannel;
	import flash.media.Sound; 
	
	public class TimeManager 
	{
		public var tmTimer : Timer;
		public var timeAll:Number;
		private var timeStart: Number;
		private var timeEnd: Number;
		private var mHour: String;
		private var mMin: String;
		private var mSec: String;
		
		private var mDelay:Number;
		
		public var milisec:Number = 0;
		public var seconds:Number = 0;
		public	var minutes:Number = 0;
		public	var hours:Number = 0;
		
		public var milisecStop:Number = 0;
		private var secStop:Number = 0;
		private	var minStop:Number = 0;
		private	var hourStop:Number = 0;
		private var timeSub:Number = 0;
		
		private	var howStop:Number = 0;
		private var howStart:Number = 0; 
		
		private var periodMillisec:Number = 0;
		
		//private var sndTik:SoundTik = null;

		public var tikChannel:SoundChannel;
		public var flSndPlay:Boolean;
		public var flTimerStop:Boolean;
		
		// period - в минутах (обратный отсчет)
		public function TimeManager(v_delay:Number = 1000,period:Number = 0) {
			mHour="00";
			mMin="00";
			mSec = "00";
			
			mDelay  = v_delay;
			
			periodMillisec = period*60*1000;
			timerStart();
			
			
			
			//sndTik = new SoundTik();
		}	
		
		public function timerStop():void {
		
			if (tmTimer!=null) {
				
				tmTimer.stop();
				
				tmTimer.removeEventListener(TimerEvent.TIMER, timerListener);
				tmTimer = null;
				
				this.milisecStop = this.timeSub;
			}
		}
		
		public function timerStart():void {
			flTimerStop = false;
			timeStart = (new Date()).getTime();
			//--стартуем счётчик
			tmTimer = new Timer(mDelay);
			tmTimer.addEventListener(TimerEvent.TIMER, timerListener);
			tmTimer.start();
			
		}
		
		//--расчитываем часы минуты сек
		public function timerListener(event:TimerEvent):void {
			
			//if(flSndPlay) tikChannel = sndTik.play();
			
			timeEnd = (new Date()).getTime();	
			this.timeSub = (timeEnd - timeStart) + this.milisecStop;
			
			if(periodMillisec==0){
				milisec = this.timeSub;
			} else {
				milisec = periodMillisec - this.timeSub;
				if (milisec<0) {
					timerStop();
					flTimerStop = true;
				}
			}
			seconds = Math.floor(milisec / 1000);
			minutes = Math.floor(seconds / 60);
			hours = Math.floor(minutes / 60);
			//var days:Number = Math.floor(hours / 24);
			
			seconds %= 60;
			minutes %= 60;
			hours %= 24;
			timeAll = milisec;
			
			var sec:String = seconds.toString();
			var min:String = minutes.toString();
			var hrs:String = hours.toString();
			//var d:String = days.toString();
			
			if (sec.length < 2) {
				sec = "0" + sec;
			}
			if (min.length < 2) {
				min = "0" + min;
			}
			if (hrs.length < 2) {
				hrs = "0" + hrs;
			}
			
			mHour = hrs;
			mMin = min;
			mSec = sec;			
		}
		
		public function getStrHour():String {
			return mHour;
		}
		
		public function getStrMin():String {
			return mMin;
		}
		
		public function getStrSec():String {
			return mSec;
		}		
		
		public function getHour():Number {
			return hours;
		}
		
		public function getMin():Number {
			return minutes;
		}
		
		public function getSec():Number {
			return seconds;
		}	
		
		public function timerBackSec(sec:Number):void {
			
			timerStop();
			this.milisecStop -= sec*1000;
			if ( this.milisecStop <= 0 ) {
				this.milisecStop = 0;
				}
			timerStart();
		}
	}

}