package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class BlueDino extends Enemy
	{
		public static const NAME:String = "BlueDino";
		public var fearChance:int = 10;
		
		public function BlueDino() 
		{
			enemyTile = new NeckShieldDinoBlue();
			var rnd:Number = 0.65 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 1.5;
			//Init();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}