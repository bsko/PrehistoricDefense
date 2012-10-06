package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class Spider extends Enemy
	{
		public static const NAME:String = "Spider";
		public var chanceToCreateWeb:int = 20;
		
		public function Spider() 
		{
			enemyTile = new SpiderMovie();
			var rnd:Number = 0.5 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 1.4;
			//Init();
		}
		
		public function createWeb(tower:Tower):void
		{
			var tmpWeb:Enemy = App.universe.addEnemy(Web.NAME, Web.BASE_HP, Web.BASE_HP, 0, 0, 0, 0, 0, false, 0);
			(tmpWeb as Web).SetTower(tower);
			tower.AddWeb();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}