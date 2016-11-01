package app.physics
{
	import Box2D.Collision.b2AABB;
	import Box2D.Collision.Shapes.b2Shape;

	import Box2D.Collision.Shapes.b2Shape;
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	
	import Box2D.Common.Math.b2Vec2;
	
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	//import Box2D.Dynamics.Joints.b2MouseJoint;
	//import Box2D.Dynamics.Joints.b2MouseJointDef;
	import Box2D.Dynamics.Joints.*;
	import Box2D.Dynamics.Controllers.b2ConstantAccelController;
	
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	
	import flash.utils.Timer;
	import flash.utils.Dictionary;

	public class PhysicsWithBox2D
	{
		public  var flBodyActive:Boolean = false;
		public  var flSpellTelekinez:Boolean = false;
		
		// stage
		private var _stage:Stage;
		
		private var refBody = new Dictionary();
		private var refTexture = new Dictionary();
		
		//--MOUSE
		private var mouseJoint:b2MouseJoint; //вспомогательная переменная (соединение тела с мышью)
		private var mousePosVec:b2Vec2 = new b2Vec2();
		private var _mouseXWorldPhys: Number;//координата мышки по оси X в метрах
		private var _mouseYWorldPhys: Number;//координата мышки по оси Y в метрах
		private var _mouseXWorld:Number; //координата мышки по оси X в пикселях
		private var _mouseYWorld:Number; //координата мышки по оси Y в пикселях
		private var _mouseDown:Boolean = false; //флаг определяющий что кнопка мыши нажата
		private var _mouseReleased:Boolean = false;
		private var _mousePressed:Boolean = false;
		
		private var _wall_bottom:b2Body;
		//--
		
		private var currentBody:b2Body;
		private var currentTexture:MovieClip;		
			
		private var world:b2World;
		//--скорость обновления мира 30 раз в секунду 30Hz
		private var timestep:Number;
		/*
		Итерация определяет сколько раз за временной шаг рассчитать 
		положение (positionIterations) и скорость тела (velocityIterations) 
		прежде, чем перейти к следующему в списке очередности, 
		компромисс между производительностью и точностью.
		*/
		private var velocityIterations:uint;
		private var positionIterations:uint;
		private var SCALE:Number = 30.0;
		private var sideWallWidth:int = 20;
		private var bottomWallHeight:int = 25;
		private var bodyCount:int = 0;
		
		private var mDdebugDraw:Boolean = false;
		
		private const DIV_180_PI:Number = 180 / Math.PI;
		private const DIV_PI_180:Number = Math.PI / 180;
		//private const DIV_SCALE_2:Number = 2*SCALE;
		
		private var windcontroler:b2ConstantAccelController;
		
		public var collision:CollisionBody;
		
		//======================
		// mousePress listener
		//======================
		public function mousePress(e:MouseEvent):void{
			_mousePressed = true;
			_mouseDown = true;
			//mouseDragX = 0;
			//mouseDragY = 0;
		}		
		//======================
		// mousePress listener
		//======================
		public function mouseRelease(e:MouseEvent):void{
			_mouseDown = false;
			_mouseReleased = true;
		}
		//======================
		// mousePress listener
		//======================
		public function mouseLeave(e:Event):void{
			_mouseReleased = _mouseDown;
			_mouseDown = false;
		}
		
		public function PhysicsWithBox2D( v_stage:Stage, v_debug:Sprite = null )
		{	
			_stage = v_stage;
			this.initWorld();
			//this.createWalls();
			//this.createStaticBodies();
			if(v_debug){
				setupDebugDraw(v_debug);			
			}
			//this.genBodyTimer = new Timer(500);
			//this.genBodyTimer.addEventListener(TimerEvent.TIMER, this.genRandomBody);
 			
			//--цикл отрисовки
			//if (_stage) init();
			//else _stage.addEventListener(Event.ADDED_TO_STAGE, init);
			
			// mouse listeners
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mousePress, false, 0, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseRelease, false, 0, true);
			_stage.addEventListener(MouseEvent.CLICK, mouseRelease, false, 0, true);
			//_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove, false, 0, true);
			_stage.addEventListener(Event.MOUSE_LEAVE, mouseLeave, false, 0, true);
		}
		/*
		private function init(e:Event = null):void
		{
			_stage.removeEventListener(Event.ADDED_TO_STAGE, init);
			_stage.addEventListener(Event.ENTER_FRAME, update);
			_stage.genBodyTimer.start();
		}
		*/
		
		//---------------------------------------------------------------------------
		
		private function initWorld():void
		{
			var gravity:b2Vec2 = new b2Vec2(0.0, 9.8);
			var doSleep:Boolean = true;
			
			// Construct world
			world = new b2World(gravity, doSleep);
			world.SetWarmStarting(true);			
			timestep = 1.0 / 30.0;
			velocityIterations = 6;
			positionIterations = 2;
			
			collision = new CollisionBody();
			world.SetContactListener( collision );
			
			windcontroler = new b2ConstantAccelController();
			windcontroler.A = new b2Vec2(15, 0);
			world.AddController(windcontroler);
		}
 
		private function setupDebugDraw( debugSprite:Sprite ):void{
			var debugDraw:b2DebugDraw = new b2DebugDraw(); //создаем объект отвечающий за настройки отрисовки debug тел
			debugDraw.SetSprite( debugSprite );//устанавливаем спрайт
			debugDraw.SetDrawScale( SCALE ); //масштаб
			debugDraw.SetFillAlpha( 0.5 ); //прозрачность
			debugDraw.SetLineThickness( 1.0 ); //толщину линий
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit); //флаги
			world.SetDebugDraw(debugDraw); //добавляем в мир debug
			mDdebugDraw = true;
		}
		
		//--цикл отрисовки и инициализации-------------------------------------------
		public function update(e:Event = null):void
		{	
			//UpdateMouseWorld();
			//MouseDestroy();
			MouseDrag();
			
			//--mouseJoint
			/*if (mouseJoint)
			{	
				
				var currentMousePos:b2Vec2 = new b2Vec2( currentTexture.mouseX / SCALE, currentTexture.mouseY / SCALE );
				mouseJoint.SetTarget(currentMousePos);
			}*/
			//--
			
			world.Step(timestep, velocityIterations, positionIterations);
			
			Render();
			
			world.ClearForces();
			
			if( mDdebugDraw ){
				world.DrawDebugData();
			}
			
		}
		
		//--вывод изображений
		private function Render():void {
			

			//--удаляем тела от колизий collision.bodyForDel
			/*for (var i:* in bodyForDel) {
				var body:b2Body = i as b2Body;
				delByBody( body );
				collision.bodyForDel[body] = null;
				delete collision.bodyForDel[body];
			}*/
			
			//--удаляем тела от колизий collision.bodyForDel
			while (collision.bodyForDel.length > 0){
				var bodyToDestroy:b2Body = collision.bodyForDel.shift();
				if (bodyToDestroy){
					delByBody( bodyToDestroy );
				}
			}
			
			//flBodyActive = false;			
			for (var i:b2Body = world.GetBodyList(); i; i = i.GetNext()){
				var gud:Object = i.GetUserData();
				if (gud != null && gud.udTexture != null){
					
					//flBodyActive = flBodyActive || gud.udTexture.flActive;
					
					switch(gud.udPolygonShape){
						case 'circle':					
							gud.udTexture.x = i.GetPosition().x * SCALE;
							gud.udTexture.y = i.GetPosition().y * SCALE;
							gud.udTexture.rotation = i.GetAngle() * DIV_180_PI;
							break;
						case 'rectangle':					
							gud.udTexture.x = i.GetPosition().x * SCALE;
							gud.udTexture.y = i.GetPosition().y * SCALE;
							gud.udTexture.rotation = i.GetAngle() * DIV_180_PI;
							break;
						case 'polygon':					
							gud.udTexture.x = i.GetPosition().x * SCALE;
							gud.udTexture.y = i.GetPosition().y * SCALE;
							gud.udTexture.rotation = i.GetAngle() * DIV_180_PI;
							break;	
					}
				}
			}
		}
		
		/*private function createWalls():void
		{
			var wallShape:b2PolygonShape = new b2PolygonShape();
			var wallBd:b2BodyDef = new b2BodyDef();
			var wallB:b2Body;
			
			wallShape.SetAsBox(sideWallWidth / SCALE / 2, _stage.stageHeight / SCALE / 2);
 
 			//Left wall
			wallBd.position.Set((sideWallWidth / 2) / SCALE, _stage.stageHeight / 2 / SCALE);
			wallB = world.CreateBody(wallBd);
			wallB.CreateFixture2(wallShape);
			
			//Right wall
			wallBd.position.Set(( _stage.stageWidth - (sideWallWidth / 2)) / SCALE, _stage.stageHeight / 2 / SCALE);
			wallB = world.CreateBody(wallBd);
			wallB.CreateFixture2(wallShape);
			
			//Bottom wall
			wallShape.SetAsBox(_stage.stageWidth / SCALE / 2, bottomWallHeight / SCALE / 2);
			wallBd.position.Set(_stage.stageWidth / 2 / SCALE, (_stage.stageHeight - (bottomWallHeight / 2)) / SCALE);
			wallB = world.CreateBody(wallBd);
			wallB.CreateFixture2(wallShape);

		}*/
		
		public function addBody( userData:Object ):Object{
			var vBody: b2Body;
			var vFixDef: b2FixtureDef = new b2FixtureDef(); //(внешний вид глазами box2d)
			var vBodyDef: b2BodyDef = new b2BodyDef(); //(этот класс отвечает за размеры, тип, угол..)
			var vBodyShape; //(этот класс отвечает за форму тела)
			var arrShape:Array = new Array();
			
			//userData.udTexture.flActive=false;
			
			switch(userData.udPolygonShape)
			{
				case 'circle':					
					//--переводим радиус из пикселей в систему СИ т.е метры принятой в физ движке
					var ciRadius:Number = userData.udRadius / SCALE;
					//--создаём круг
					vBodyShape = new b2CircleShape( ciRadius );
					vBodyDef.position.Set( userData.udX / SCALE , userData.udY / SCALE );
	       			break;
				
				case 'rectangle':
					//--создаём прямоугольник
					vBodyShape = new b2PolygonShape();
					vBodyShape.SetAsBox( userData.udW / SCALE / 2  , userData.udH / SCALE / 2 );
					vBodyDef.position.Set( userData.udX / SCALE + userData.udW / SCALE / 2 , userData.udY / SCALE + userData.udH / SCALE / 2 );
        			break;
				case 'polygon':
					//vBodyShape = new b2PolygonShape(); //создаем шейп
					var len:uint = userData.udVertex.length;
					var arr:Array = new Array()
					//for (var i:int = 0; i < len; ++i){ 
    				//	arr[i] = b2Vec2.Make( userData.udVertex[i][0] / SCALE, userData.udVertex[i][1] / SCALE );
					//}
					var arrPoints:Array = new Array()
					for (var i:int = 0; i < len; i++){ 
						arrPoints[i] = new Array();
						for(var j:int = 0; j < userData.udVertex[i].length; j=j+2){ 
    						arrPoints[i].push( b2Vec2.Make( userData.udVertex[i][j] / SCALE, userData.udVertex[i][j+1] / SCALE ) );
						}
						arrShape[i] = b2PolygonShape.AsArray( arrPoints[i], arrPoints[i].length );
					}
					vBodyDef.position.Set( userData.udX / SCALE , userData.udY / SCALE );
					break;
			}

			if(userData.udDensity == 0){
				vBodyDef.type = b2Body.b2_staticBody;//--статическое тело
			}else{
				vBodyDef.type = b2Body.b2_dynamicBody;//--динамическое тело
			}

			if(userData.udAngle){
				vBodyDef.angle = userData.udAngle * DIV_PI_180;//--угол поворота
			}
			
			vBodyDef.userData = userData; //--данные пользователя						
			vBody = world.CreateBody(vBodyDef);
			
			vFixDef.density = userData.udDensity; //вес тела 0--, 0=статичное тело
			vFixDef.friction = userData.udFriction; //сила трения[0-1]
			vFixDef.restitution = userData.udRestitution; // упругость прыгучесть(отскок)[0-1]
			
			if (userData.udPolygonShape == 'polygon'){
				for (var i:int = 0; i < arrShape.length; ++i){ 
					vFixDef.shape = arrShape[i];
					vBody.CreateFixture( vFixDef );
				}
			}else{
				vFixDef.shape = vBodyShape;
				vBody.CreateFixture(vFixDef);
			}
			
			refBody[ vBody ] = userData.udTexture;
			refTexture[ userData.udTexture ] = vBody;
			
			if( userData.udName == 'wall_bottom'){
				_wall_bottom = vBody;
			}

			//userData.udTexture.addEventListener(MouseEvent.MOUSE_DOWN, pMouseDown);
			
			//windcontroler.AddBody( vBody ); //добавляем тела к контроллеру
			return vBody as Object;
		}
		
		public function delBody( mc:MovieClip ):void{
			//удалям физ-объект
			world.DestroyBody( refTexture[ mc ] );
			//зачищаем словари
			refBody[ refTexture[ mc ] ] = null;
			delete refBody[ refTexture[ mc ] ];
			refTexture[ mc ] = null;
			delete refTexture[ mc ];
		}
		
		public function delByBody( body:b2Body ):void{
			//удалям физ-объект
			world.DestroyBody( body );
			//зачищаем словари
			refTexture[ refBody[ body ] ] = null;
			delete refTexture[ refBody[ body ] ];
			refBody[ body ] = null;
			delete refBody[ body ];
		}
		
		public function destroyAllBody():void{
			//--удаляем все соединения
			var jj:b2Joint;
			for( jj=world.GetJointList(); jj; jj=jj.GetNext()){
				world.DestroyJoint( jj );
			}			
			//--удаляем все тела
			var b:b2Body;
			for( b=world.GetBodyList(); b; b=b.GetNext()){
				delByBody( b );
			}
		}
		
		public function setImpulse(mc:MovieClip, v_impulse:Array ):void{ 
			var body:b2Body = refTexture[ mc ] as b2Body;
			var impulse = new b2Vec2( v_impulse[0], v_impulse[1] );
			body.ApplyImpulse( impulse, body.GetWorldCenter() );
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		public function setRevoluteJoint(v_bodyA:Object, v_bodyB:Object):void{
			
			var bodyA:b2Body = v_bodyA as b2Body;
			var bodyB:b2Body = v_bodyB as b2Body;
			
			var revoluteJointDef:b2RevoluteJointDef = new  b2RevoluteJointDef();  
			revoluteJointDef.Initialize(bodyA, bodyB, bodyA.GetWorldCenter());  

			revoluteJointDef.maxMotorTorque = 1.0;
			revoluteJointDef.enableMotor = true;			
			revoluteJointDef.enableLimit = true; //включаем пределы
			revoluteJointDef.lowerAngle = -45 * Math.PI / 180; //нижний предел
			revoluteJointDef.upperAngle = 45 * Math.PI / 180; //верхний предел
			
			world.CreateJoint(revoluteJointDef);
			
			/*
			
			var _jointDef:b2RevoluteJointDef;
			var _joint:b2RevoluteJoint;
			_jointDef = new b2RevoluteJointDef(); //создаем определение соединения
			_jointDef.bodyA = _bodyA; //первое тело соединения
			_jointDef.bodyB = _bodyB; //второе тело соединения
			_jointDef.collideConnected = false; //тела не сталкиваются
			_jointDef.localAnchorA = new b2Vec2(0, -0.5); //якорная точка первого тела
			_jointDef.localAnchorB = new b2Vec2(0, 4.5); //якорная точка второго тела
			_jointDef.enableLimit = true; //включаем пределы
			_jointDef.lowerAngle = -45 * Math.PI / 180; //нижний предел
			_jointDef.upperAngle = 45 * Math.PI / 180; //верхний предел
			_jointDef.referenceAngle = 0; //начальный угол соединения
			_jointDef.motorSpeed = 10.0; //желаемая скорость вращения в радианах в секунду
			_jointDef.maxMotorTorque = 350; //максимальный крутящий момент мотора
			_jointDef.enableMotor = true; //включаем мотор
			_jointMotor = Box2DHelpers.world.CreateJoint(_jointDef) as b2RevoluteJoint; //добавляем соединение в мир
			
			*/
		}
		/*public function pMouseDown(e:MouseEvent):void
		{
			trace('pMouseDown');
			currentTexture = e.currentTarget as MovieClip;
			currentTexture.removeEventListener(MouseEvent.MOUSE_DOWN, pMouseDown);
			currentTexture.addEventListener(MouseEvent.MOUSE_UP, pMouseUp)
			currentBody = refTexture[ currentTexture ];
			if( currentBody )
			{
				var mouseDef:b2MouseJointDef = new b2MouseJointDef();
				mouseDef.bodyA = world.GetGroundBody();
				mouseDef.bodyB = currentBody;
				var bodyPos:b2Vec2 = currentBody.GetWorldCenter();
				mouseDef.target.Set(bodyPos.x, bodyPos.y);
				mouseDef.collideConnected = true;
				mouseDef.maxForce = 300 * currentBody.GetMass();
				mouseJoint = world.CreateJoint(mouseDef) as b2MouseJoint;
			}
		}
		
		private function pMouseUp(e:MouseEvent):void 
		{
			trace('pMouseUp');
			currentTexture.addEventListener(MouseEvent.MOUSE_DOWN, pMouseDown)
			if (mouseJoint)
			{
				world.DestroyJoint(mouseJoint);
				mouseJoint = null;
				
			}
		}
		
		private function MouseDestroy():void
		{
			//--кнопка D=68 && Input.isKeyPressed(68)
			/*if (!_mouseDown )
			{
				var body:b2Body = GetBodyAtMouse(true);

				if (body)
				{
					world.DestroyBody(body);
					return;
				}
			}
		}*/
private function GetBodyAtMouse(includeStatic:Boolean = false):b2Body {//определяет тело находящееся под курсором мыши
			mousePosVec.Set(_mouseXWorldPhys, _mouseYWorldPhys);//записываем текущие координаты курсора
			var aabb:b2AABB = new b2AABB();//создаем прямоугольную область вокруг курсора мыши
			aabb.lowerBound.Set( _mouseXWorldPhys - 0.001, _mouseYWorldPhys - 0.001);
			aabb.upperBound.Set( _mouseXWorldPhys + 0.001, _mouseYWorldPhys + 0.001);
			var body:b2Body = null;
			var fixture:b2Fixture;

			// Query the world for overlapping shapes.
			function GetBodyCallback(fixture:b2Fixture):Boolean{
				var shape:b2Shape = fixture.GetShape();//получаем шейп который находится под курсором
				if (fixture.GetBody().GetType() != b2Body.b2_staticBody || includeStatic) {//если тело не статическое
					var inside:Boolean = shape.TestPoint(fixture.GetBody().GetTransform(), mousePosVec);//проверяем находится ли точка-позиция курсора в рамках тела
					if (inside){//если да
						body = fixture.GetBody();//получаем ссылку на тело
						return false;
					}
				}
				return true;
			}
			world.QueryAABB(GetBodyCallback, aabb); //проверяем на попадание любых тел в область aabb
			return body; //возвращаем тело
		}
		
		private function MouseDrag():void{
			UpdateMouseWorld();
			var body:b2Body;
			var md:b2MouseJointDef;
			if (_mouseDown && !mouseJoint){ //если кнопка мыши нажата и соединения MouseJoint не существует 
				body = GetBodyAtMouse(); //получаем ссылку на тело которое находится под курсором мыши
				
				if (body){ //если есть тело под курсором мыши 
					md = new b2MouseJointDef(); //создаем настройки соединения
					md.bodyA = world.GetGroundBody(); //один конец крепим к миру
					md.bodyB = body; //другой к телу
					md.target.Set(_mouseXWorldPhys, _mouseYWorldPhys); //соединение создается от курсора мыши
					md.collideConnected = true;
					md.maxForce = 300.0 * body.GetMass(); //макс. сила которая может быть приложена к телу
					mouseJoint = world.CreateJoint(md) as b2MouseJoint; //создаем соединение
					body.SetAwake(true); //будим тело
					currentBody = body;
					//currentBody.GetUserData().udTexture.flActive = true;
				}
				
			}
			
			if (!_mouseDown){ //если кнопка мыши отпущена
			
				if (mouseJoint){ //а соединение еще существует
					//currentBody.GetUserData().udTexture.flActive = false;
					world.DestroyJoint(mouseJoint);//удаляем его
					mouseJoint = null;
					currentBody = null;
				}
				
			}

			if (mouseJoint){ //если кнопка мыши нажата и соединение уже существует
				var p2:b2Vec2 = new b2Vec2(_mouseXWorldPhys, _mouseYWorldPhys);
				mouseJoint.SetTarget(p2); //перемещаем соединение за курсором мыши
				//currentBody.GetUserData().udTexture.flActive = true;
			}
		}
		
		private function UpdateMouseWorld():void{
			_mouseXWorldPhys = _stage.mouseX / SCALE;
			_mouseYWorldPhys = _stage.mouseY / SCALE;
		}
		
	}	
}