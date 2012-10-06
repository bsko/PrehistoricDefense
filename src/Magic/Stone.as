package Magic 
{
	import Enemies.DinozavrOrange;
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Stone extends Spell
	{
		public static const COOLDOWN_TIME:int = 90;
		public static const AREA:int = 60;
		public static const DAMAGE:int = 30;
		
		private var _spell_movie:MovieClip = new stone_from_earth();
		private var _currentCell:Grid;
		
		public function Stone() 
		{
			firstUpFlag = true;
			index = 6;
			title = "Highlands Revenge";
			label = "Stone";
			castCost = Spell.CostsArray[index];
			_cooldownTime = COOLDOWN_TIME;
			area = AREA;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("stone_appear");
				_spell_movie.gotoAndPlay(1);
				_currentCell = tmpGrid;
				_spell_movie.x = _currentCell.x;
				_spell_movie.y = _currentCell.y - App.HEIGHT_DELAY - _currentCell.gridHeight;
				App.universe.addChild(_spell_movie);
				_spell_movie.addEventListener("stonerised", onDamageDeal, false, 0, true);
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
			
			for (var i:int = 0; i < length; i++)
			{
				tmpEnemy = enemyArray[i];
				if (tmpEnemy is DinozavrOrange) { continue; }
				distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + ((tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale * App.YScale));
				if (distance <= spellArea)
				{
					damage = (maxDmg / spellArea) * (spellArea - distance);
					if (addedDamage != 0)
					{
						damage += damage * addedDamage / 100;
					}
					tmpEnemy.enemyTakingDamage(null, false, DamageTypes.BLUNT, damage + addedDamage);
					if (tmpEnemy.isDead)
					{
						i--;
						length--;
					}
				}
			}
			Destroy();
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
			_spell_movie.removeEventListener("stonerised", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
		}
	}

}