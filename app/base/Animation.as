package app.base {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * Класс анимации
	 */
	public class Animation extends MovieClip{
		
		/* границы */
		public const BORDER_LEFT = 10;
		public const BORDER_RIGHT = 500;
		public const BORDER_UP_TOP = 100;
		public const BORDER_UP_BOTTOM = 200;
		public const BORDER_GROUND = 220;
		
		/* Углы движения */
		public const ANGLE_UP = 275;
		public const ANGLE_DOWN = 90;
		public const ANGLE_LEFT = 180;
		public const ANGLE_RIGHT = 0;
		
		/* управление движением */
		public var a = 1;
		public var speed;
		public var maxSpeed = 20;
		public var angle:int = 0;
		public var gravity = 0;
		
		/* управление удалением объектов */ 
		public var scaleSpeed = 1;
		public var alphaSpeed = 1;
		public var border_left:int;
		public var border_right:int;
		public var border_up:int;
		public var border_down:int;
		
		public var x0:int;
		public var y0:int;
		private var xs:int = 0;
		private var xf:int = 0;
		private var ys:int = 0;
		private var yf:int = 0;
		
		/* дискретные параметры */
		private var tx;
		private var ty;
		public  var vx = 0;
		public  var vy = 0;
		
		public var px,py:Number;
		
		public var forceAttractionX:Number = 0.3;
		public var forceAttractionY:Number = 0.3;
		
		public var flRemove:Boolean = false;
		public var flMove:Boolean = true;
				
		public function Animation():void {
			super();
			tx = Math.random()*10000;
			ty = Math.random()*10000;
			x0 = x; 
			y0 = y;
			addEventListener(Event.ENTER_FRAME, playEvent);
		}
		
		public function initCycleAnim(len:Number=0.5):void {
			xf = xs - width * len;
			ys = y;
		}
		
		// перемещение по X для цикличной анимации
		public function moveXcycle():void{
			moveX();
			var dx = xf - x; // вычисляем перебор
			if (dx > 0){
				x = xs - dx;// возвращаем в начальное положение
				y = ys;
			}
		}
		
		public function moveXsin(period = 0.3,amplitude = 15,x0 = 0):void{
			x = x0 + Math.sin(tx += period) * amplitude;
		}
		
		public function moveX():void{
			x = x + vx;
		}

		public function moveYsin(period = 0.4,amplitude = 25, y0 = 0):void{
			y = y0 + Math.sin(ty += period) * amplitude;
		}
		
		public function moveY():void{
			y = y + vy;
		}
		
		public function moveToPoint(cx,cy:Number,pstop:Number = 0.5):Boolean{
			changeSpringSpeed(cx,cy);
			moveX();
			moveY();
			
			if ((Math.abs(cx - x) <= pstop) && (Math.abs(cy - y) <= pstop)) {
				return true;
			} else {
				return false;
			}	
		}
		
		// Изменение скорости пружинным способом
		public function changeSpringSpeed(cx,cy:uint):Number {
			var dx = cx - x;
			vx = dx*forceAttractionX; //сила притяжения к курсору
			vx *= 0.8;//затухание
			vx = (vx > maxSpeed)? maxSpeed : (vx < -maxSpeed)? -maxSpeed : vx;
			
			var dy = cy - y;
			vy = dy*forceAttractionY; //сила притяжения к курсору
			vy *= 0.8;//затухание
			vy = (vy > maxSpeed)? maxSpeed : (vy < -maxSpeed)? -maxSpeed : vy;
		
			return dx;
		}
		
		// Изменение скорости линейным способом
		public function changeLineSpeed():void{
			vy = Math.sin(angle*Math.PI/180) * speed * a + gravity;
			vx = Math.cos(angle*Math.PI/180) * speed * a;
		}
		
		public function changeScale():void {
			scaleX = scaleY *= scaleSpeed;
		}
		
		public function changeAlpha():void {
			alpha *= alphaSpeed;
		}
		
		public function randScale(preScale:Number=1):void {
			var direct = Math.random();
			if (direct < 0.3) { direct = preScale; } else { direct = -preScale; }
			scaleX = scaleY = Math.random() * direct;
		}
		
		public function playEvent(event:Event) {
			playGo();
		}
		
		public function playGo():void{
	
		}
		
		public function removeEvent():void {
			removeEventListener(Event.ENTER_FRAME,playEvent);
		}
	}
}