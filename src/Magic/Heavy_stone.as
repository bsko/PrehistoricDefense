package Magic 
{
	import Enemies.DinozavrOrange;
	import Enemies.WhiteTiger;
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Heavy_stone extends Spell
	{
		public static const DAMAGE:int = 10;
		public static const COOLDOWN_TIME:int = 450;
		public static const STOP_TIME:int = 4000; 	// время в милисекундах
		
		private var _enemiesList:Array;
		private var _stop_time:int = STOP_TIME;
		
		public function Heavy_stone() 
		{
			firstUpFlag = false;
			index = 7;
			title = "Earthquake";
			label = "Heavy_stone";
			castCost = Spell.CostsArray[index];
			_isInstantCastSpell = true;
			_cooldownTime = COOLDOWN_TIME;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				super.UseMagic(tmpGrid);
				_stop_time = STOP_TIME * _currentLevel;
				_enemiesList = App.universe.enemiesArray;
				var tmpArray:Array = [];
				for (var i:int = 0; i < _enemiesList.length; i++)
				{
					var tmpEnemy:Enemy = _enemiesList[i];
					if ((tmpEnemy is WhiteTiger) || (tmpEnemy is DinozavrOrange)) { continue; }
					tmpArray.push(tmpEnemy);
				}
				for (i = 0; i < tmpArray.length; i++)
				{
					tmpEnemy = tmpArray[i];
					tmpEnemy.StopEnemy(_stop_time);
					tmpEnemy.enemyTakingDamage(null, false, DamageTypes.BLUNT, (DAMAGE * _currentLevel));
				}
				App.universe.startShaking();
				
				App.soundControl.playSound("earthquake");
			}
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}

}