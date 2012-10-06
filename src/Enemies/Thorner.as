package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author i am
	 */
	public class Thorner extends Enemy
	{
		public static const NAME:String = "Thorner";
		
		public function Thorner() 
		{
			enemyTile = new shaper_movie_full();
			var rnd:Number = 0.65 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 1;
			//Init();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}