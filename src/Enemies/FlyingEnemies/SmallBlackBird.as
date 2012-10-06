package Enemies.FlyingEnemies 
{
	import Enemies.Flying;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author 
	 */
	public class SmallBlackBird extends Flying
	{
		
		public static const NAME:String = "SmallBlackBird";
		
		public function SmallBlackBird() 
		{
			InitSpawns();
			
			enemyTile = new flying3_full_movie();
			enemyTile.scaleX = .75;
			enemyTile.scaleY = .75;
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