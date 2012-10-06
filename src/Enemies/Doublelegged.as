package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author i am
	 */
	public class Doublelegged extends Enemy
	{
		public static const NAME:String = "Doublelegged";
		
		public function Doublelegged() 
		{
			enemyTile = new double_legged_full();
			var rnd:Number = 0.7 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
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