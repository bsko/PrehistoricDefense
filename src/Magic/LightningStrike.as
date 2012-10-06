package Magic 
{
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class LightningStrike extends Spell
	{
		public static const DAMAGE:int = 50;
		public static const NAME:String = "LightningStrike";
		private var _spell_movie:MovieClip = new buffingSpell();
		private var _currentEnemy:Enemy;
		private var _addedPower:int = 0;
		
		public function UseLightning(enemy:Enemy, addedDamage:int = 0):void 
		{
			if (!isCooldown)
			{
				_currentEnemy = enemy;
				_addedPower = addedDamage;
				_spell_movie.x = 0;// _currentCell.x;
				_spell_movie.y = 0;// _currentCell.y - App.HEIGHT_DELAY - _currentCell.gridHeight;
				_currentEnemy.addChild(_spell_movie);
				_spell_movie.gotoAndPlay(1);
				_spell_movie.addEventListener("lightningstrikes", onDamageDeal, false, 0, true);
				App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
				App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEventAlt, false, 0, true);
				App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEventAlt, false, 0, true);
			}
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
			_currentEnemy = null;
			_addedPower = 0;
			App.pools.returnPoolObject(NAME, this);
			_currentEnemy.removeChild(_spell_movie);
			_spell_movie.removeEventListener("lightningstrikes", onDamageDeal, false);
		}
		
		private function onDamageDeal(e:Event):void 
		{
			if ((_currentEnemy != null) && (!_currentEnemy.isDead))
			{
				_currentEnemy.enemyTakingDamage(null, false, DamageTypes.MAGIC, DAMAGE + _addedPower);
			}
			_spell_movie.removeEventListener("lightningstrikes", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
			_currentEnemy = null;
			_addedPower = 0;
			App.pools.returnPoolObject(NAME, this);
		}
	}
}