package Enemies 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author author
	 */
	public class ZlobniyGlist extends Enemy
	{
		public static const NAME:String = "ZlobniyGlist";
		public function ZlobniyGlist() 
		{
			enemyTile = new ZlobniyGlistMovie();
			var rnd:Number = 0.6 + Math.random() * 0.4;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = true;
			speed = 0.8;
			//Init();
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}