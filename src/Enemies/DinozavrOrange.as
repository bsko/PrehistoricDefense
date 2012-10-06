package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class DinozavrOrange extends Enemy
	{
		public static const NAME:String = "DinozavrOrange";
		public function DinozavrOrange() 
		{
			enemyTile = new DinozavrOrMovie();
			var rnd:Number = 0.65 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = false;
			speed = 1.2;
			//Init();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}