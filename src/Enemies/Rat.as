package Enemies 
{
	import flash.display.MovieClip;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author author
	 */
	public class Rat extends Enemy
	{
		public static const NAME:String = "Rat";
		private var _isRegenerating:Boolean = false;
		private var _timer:Timer = new Timer(1000);
		
		public function Rat() 
		{
			enemyTile = new RatMovie();
			var rnd:Number = 0.75 + Math.random() * 0.25;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = true;
			speed = 1.6;
			//Init();
			_isRegenerating = false;
		}
		
		
		public function startRegeneration():void
		{
			if (!_isRegenerating)
			{
				_isRegenerating = true;
				
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, onUpdateRegenration, false, 0, true);
			}
		}
		
		
		private function onUpdateRegenration(e:TimerEvent):void 
		{
			if (health < fullHealth)
			{
				if (isDead)
				{
					trace("working!");
					stopRegenerating();
					return;
				}
				health += Math.ceil(fullHealth / 80);
				if (health > fullHealth) { health = fullHealth; }
				var flyingDmg:FlyingDamage = App.pools.getPoolObject(FlyingDamage.NAME);
				flyingDmg.Init(new Point(x, y), 1, 0, 0, false, true);
				enemyHP.gotoAndStop(int(health / fullHealth * enemyHP.totalFrames));
				trace("regenerating", health);
			}
		}
		
		
		public function stopRegenerating():void
		{
			if (_isRegenerating)
			{ 
				_timer.reset();
				removeEventListener(TimerEvent.TIMER, onUpdateRegenration, false);
				_isRegenerating = false; 
			}
		}
		
		override public function destroy():void 
		{
			stopRegenerating();
			
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function get isRegenerating():Boolean { return _isRegenerating; }
	}

}