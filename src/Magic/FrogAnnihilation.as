package Magic 
{
	import Enemies.Frog;
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class FrogAnnihilation extends Spell
	{
		public static const NAME:String = "FrogAnnihilation";
		private var _spell_movie:MovieClip = new frog_splash();
		private var _layer:Sprite;
		private var _poisonSplashRange:int = 130;
		private var _poisonSplashDamage:int = 12;
		
		public function FrogAnnihilation() 
		{
			_spell_movie.gotoAndStop(1);
		}
		
		public function UseSplash(layer:Sprite, xx:int, yy:int):void 
		{
			_layer = layer;
			_spell_movie.x = xx;
			_spell_movie.y = yy;
			
			_spell_movie.gotoAndPlay(1);
			_spell_movie.addEventListener("damageDeal", onDamageDeal, false, 0, true);
			_layer.addChild(_spell_movie);
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEventAlt, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEventAlt, false, 0, true);
		}
		
		private function onUnpauseEventAlt(e:PauseEvent):void 
		{
			_spell_movie.play();
		}
		
		private function onPauseEventAlt(e:PauseEvent):void 
		{
			_spell_movie.stop();
		}
		
		private function onDestroyMagic(e:UniverseDestroying):void 
		{
			App.pools.returnPoolObject(NAME, this);
			
			_layer.removeChild(_spell_movie);
			_spell_movie.removeEventListener("damageDeal", onDamageDeal, false);
			_spell_movie.gotoAndStop(1);
		}
		
		private function onDamageDeal(e:Event):void 
		{
			var tmpArray:Array = App.universe.towersArray;
			var length:int = tmpArray.length;
			var tmpTower:Tower;
			for (var i:int = 0; i < length; i++)
			{
				tmpTower = (tmpArray[i] == null) ? null : tmpArray[i];
				if (tmpTower == null) { continue; }
				
				var distance:int = (tmpTower.currentCell.x - _spell_movie.x) * (tmpTower.currentCell.x - _spell_movie.x) + ((tmpTower.currentCell.y - _spell_movie.y) * (tmpTower.currentCell.y - _spell_movie.y) / (App.YScale * App.YScale));
				
				if (distance < _poisonSplashRange * _poisonSplashRange)
				{
					tmpTower.TowerTakingDamage(_poisonSplashDamage);
				}
			}
			
			_spell_movie.removeEventListener("damageDeal", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
			App.pools.returnPoolObject(NAME, this);
		}
	}

}