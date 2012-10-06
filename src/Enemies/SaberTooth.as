package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class SaberTooth extends Enemy
	{
		public static const NAME:String = "SaberTooth";
		public var speedUpChance:int = 100;
		
		public function SaberTooth() 
		{
			enemyTile = new Sabertooth();
			var rnd:Number = 0.65 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 1.3;
			//Init();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}