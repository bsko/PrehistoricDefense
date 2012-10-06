package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class Kaban extends Enemy
	{
		public static const NAME:String = "Kaban";
		private var _isVicious:Boolean = false;
		public var _HPtoStartAngrer:int = 35;
		
		public function Kaban() 
		{
			enemyTile = new KabanMovie();
			var rnd:Number = 0.65 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 2;
			//Init();
		}
		
		public function ViciousKaban():void
		{
			if (!_isVicious)
			{
				_isVicious = false;
				bonusResistBlunt = 20;
				bonusResistSword = 20;
				bonusResistPike = 20;
				bonusResistMagic = 20;
				SlowEnemy(250, 1000, Enemy.SLOW_TYPE_SPEEDUP);
			}
		}
		
		public function StopVicious():void
		{
			if (_isVicious)
			{
				_isVicious = false;
				bonusResistBlunt = 20;
				bonusResistSword = 20;
				bonusResistPike = 20;
				bonusResistMagic = 20;
				TakeEnemySpeedToNormal();
			}
		}
		
		override public function destroy():void 
		{
			StopVicious();
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function get isVicious():Boolean { return _isVicious; }
	}

}