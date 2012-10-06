package Magic 
{
	import Enemies.Tiger;
	import Events.PauseEvent;
	import Events.SpellCastingEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Fireball extends Spell
	{
		public static const DAMAGE:int = 25;
		public static const AREA:int = 70;
		public static const COOLDOWN_TIME:int = 120;
		
		private var _spell_movie:MovieClip = new FireBall();
		private var _currentCell:Grid;
		
		public function Fireball() 
		{
			index = 0;
			title = "Fireball";
			label = "Fireball";
			firstUpFlag = true;
			castCost = Spell.CostsArray[index];
			_cooldownTime = COOLDOWN_TIME;
			area = AREA;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				super.UseMagic(tmpGrid);
				_spell_movie.gotoAndPlay(1);
				_currentCell = tmpGrid;
				_spell_movie.x = _currentCell.x;
				_spell_movie.y = _currentCell.y - App.HEIGHT_DELAY - _currentCell.gridHeight;
				App.universe.addChild(_spell_movie);
				_spell_movie.addEventListener("fireballfall", onDamageDeal, false, 0, true);
				App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
				
				App.soundControl.playSound("fireball");
			}
		}
		
		private function onDestroyMagic(e:UniverseDestroying):void 
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
				if (tmpEnemy is Tiger) { continue; }
				distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + ((tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale *  App.YScale));
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
			_spell_movie.removeEventListener("fireballfall", onDamageDeal, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
		}
	}

}