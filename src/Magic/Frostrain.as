package Magic 
{
	import Enemies.WhiteTiger;
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Frostrain extends Spell
	{
		public static const DAMAGE:int = 45;
		public static const AREA:int = 100;
		public static const FROST_TIME:int = 150;
		public static const FROST_PERCENTAGE:int = 50;
		public static const COOLDOWN_TIME:int = 600;
		
		private var _spell_movie:MovieClip = new FrostRain();
		private var _currentCell:Grid;
		
		public function Frostrain() 
		{
			index = 1;
			title = "Rain of Ice";
			label = "Frostball";
			firstUpFlag = false;
			castCost = Spell.CostsArray[index];
			_cooldownTime = COOLDOWN_TIME;
			area = AREA;
		}
		
		override public function UseMagic(tmpGrid:Grid):void  
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("frostrain");
				super.UseMagic(tmpGrid);
				_spell_movie.gotoAndPlay(1);
				_currentCell = tmpGrid;
				_spell_movie.x = _currentCell.x;
				_spell_movie.y = _currentCell.y - App.HEIGHT_DELAY - _currentCell.gridHeight;
				App.universe.addChild(_spell_movie);
				_spell_movie.addEventListener("frostrainfall", onDamageDeal, false, 0, true);
				App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
			}
		}
		
		private function onDestroyMagic(e:Event):void 
		{
			App.universe.removeChild(_spell_movie);
			Destroy();
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
			
			for (var i:int = 0; i < length; i++)
			{
				tmpEnemy = enemyArray[i];
				if (tmpEnemy is WhiteTiger) { continue; }
				distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + (tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale * App.YScale);
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
						tmpEnemy.SlowEnemy(FROST_PERCENTAGE, FROST_TIME, Enemy.SLOW_TYPE_COLD);
					}
				}
			}
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
		
		override public function Destroy():void 
		{
			super.Destroy();
			_spell_movie.removeEventListener("frostrainfall", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
		}
	}

}