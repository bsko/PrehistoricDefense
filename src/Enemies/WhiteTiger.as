package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author i am
	 */
	public class WhiteTiger extends Enemy
	{
		public static const NAME:String = "WhiteTiger";
		
		public function WhiteTiger() 
		{
			enemyTile = new tiger_white_full();
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