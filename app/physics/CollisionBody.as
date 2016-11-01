package app.physics
{
	//import Box2D.Dynamics.*;
	//import Box2D.Collision.*;
	//import Box2D.Dynamics.Contacts.*;
	
	import Box2D.Collision.b2Manifold;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2ContactImpulse;
	import Box2D.Dynamics.b2ContactListener;
	import Box2D.Dynamics.b2Fixture;
	import Box2D.Dynamics.Contacts.b2Contact;
	
//	import app.InstSound;
	
	public class CollisionBody extends b2ContactListener
	{
	//	private var sound:InstSound;
		private var nameA,nameB:String;
		public var numTrubs:Array;
		public var bodyForDel:Array;
		public var flSoundPlay:Boolean;
		
		public function CollisionBody() {
			numTrubs = new Array();
			bodyForDel = new Array();
        }
		
		override public function BeginContact(contact:b2Contact):void
		{
			nameA = contact.GetFixtureA().GetBody().GetUserData().udName;
			nameB = contact.GetFixtureB().GetBody().GetUserData().udName;
			
			/*if(flSoundPlay){
				sound = new InstSound();
				sound.instCollision(nameA,nameB);
				sound = null;
			}*/
			
			if(nameA == "voronka"){
				ballInVoronka(contact.GetFixtureB().GetBody());
			}
			
			if(nameB == "voronka"){
				ballInVoronka(contact.GetFixtureA().GetBody());
			}
		}
		
		private function ballInVoronka(ball):void{
			ball.GetUserData().udTexture.visible = false;
			ball.GetUserData().udRemove = true;
			numTrubs.push(ball.GetUserData().udNumTruba);
			bodyForDel.push(ball);
		}
		
		override public function EndContact(contact:b2Contact):void
		{
			 
		}
		
		override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void
		{
			//trace('PostSolve');
		}
		
		override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void
		{
			//trace('PreSolve');
		}
		
		
	}
}