package Magic 
{
	import Enemies.Tiger;
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Firerain extends Spell
	{
		public static const DAMAGE:int = 20;
		public static const AREA:int = 100;
		public static const PERIODIC_DAMAGE:int = 3;
		public static const TIME_OF_PERIODIC_DAMAGE:int = 5;
		public static const PERIODIC_DAMAGE_DELAY:int = 200;
		public static const COOLDOWN_TIME:int = 600;
		
		private var _spell_movie:MovieClip = new FireRain();
		private var _currentCell:Grid;
		private var _periodicDamage:int = PERIODIC_DAMAGE;
		
		public function Firerain() 
		{
			index = 2;
			title = "Rain of Fire";
			label = "Meteorite";
			firstUpFlag = false;
			castCost = Spell.CostsArray[index];
			_cooldownTime = COOLDOWN_TIME;
			area = AREA;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("firerain");
				super.UseMagic(tmpGrid);
				_spell_movie.gotoAndPlay(1);
				_currentCell = tmpGrid;
				_spell_movie.x = _currentCell.x;
				_spell_movie.y = _currentCell.y - App.HEIGHT_DELAY - _currentCell.gridHeight;
				App.universe.addChild(_spell_movie);
				_spell_movie.addEventListener("firerainfall", onDamageDeal, false, 0, true);
				App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
			}
		}
		
		private function onDestroyMagic(e:UniverseDestroying):void 
		{
			App.universe.removeChild(_spell_movie);
			Destroy();
		}
		
		override protected function onPauseEvent(e:PauseEvent):void 
		{
			super.onPauseEvent(e);
			_spell_movie.stop();
		}
		
		override protected function onUnpauseEvent(e:PauseEvent):void 
		{
			super.onUnpauseEvent(e);
			_spell_movie.play();
		}
		
		private function onDamageDeal(e:Event):void 
		{
			var enemyArray:Array = App.universe.enemiesArray;
			var length:int = enemyArray.length;
			var tmpEnemy:Enemy;
			var distance:int;
			var spellArea:int = AREA * AREA;
			var maxDmg:int = DAMAGE * _currentLevel;
			var damage:int;
			var addedDamage:int = App.universe.increasedSpellsDamage;
			_periodicDamage = PERIODIC_DAMAGE * _currentLevel;
			
			for (var i:int = 0; i < length; i++)
			{
				tmpEnemy = enemyArray[i];
				if (tmpEnemy is Tiger) { continue; }
				distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + ((tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale * App.YScale));
				if (distance <= spellArea)
				{
					damage = (maxDmg / spellArea) * (spellArea - distance);
					if (addedDamage != 0)
					{
						damage += damage * addedDamage / 100;
					}
					tmpEnemy.enemyTakingDamage(null, false, DamageTypes.MAGIC, damage + addedDamage);
					if (tmpEnemy.isDead)
					{
						i--;
						length--;
					}
					else
					{
						tmpEnemy.DealDamageEveryXSecs(_periodicDamage, PERIODIC_DAMAGE_DELAY, TIME_OF_PERIODIC_DAMAGE);
					}
				}
			}
			Destroy();
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
			_spell_movie.removeEventListener("firerainfall", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
		}
	}

}