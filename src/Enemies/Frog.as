package Enemies 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import Magic.FrogAnnihilation;
	/**
	 * ...
	 * @author author
	 */
	public class Frog extends Enemy
	{
		public static const NAME:String = "Frog";
		
		public function Frog() 
		{
			enemyTile = new FrogMovie();
			var rnd:Number = 0.6 + Math.random() * 0.2;
			enemyTile.scaleX = rnd;
			enemyTile.scaleY = rnd;
			addChild(enemyTile);
			enemyTile.stop();
			(enemyTile.getChildAt(0) as MovieClip).stop();
			//характеристики
			isVoluptuous = true;
			speed = 3;
			//Init();
		}
		
		public function UsePoisonSplash():void
		{
			App.soundControl.playSound("frog");
			var splash:FrogAnnihilation = App.pools.getPoolObject(FrogAnnihilation.NAME);
			splash.UseSplash(App.universe.mainLayer, x, y);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			App.pools.returnPoolObject(NAME, this);
		}
	}

}