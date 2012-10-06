package Magic 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author i am
	 */
	public class Chest extends Spell
	{
		private static const USING_RANGE:int = 150;
		public static const COOLDOWN_TIME:int = 450;
		public static const BASE_BONUS:int = 5;
		public static const PEL_LEVEL_BONUS:int = 1;
		private var _spell_movie:MovieClip;
		private var _spell_counter:int;
		private var _currentCell:Grid;
		
		public function Chest() 
		{
			firstUpFlag = false;
			index = 11;
			title = "Avidity";
			label = "Chest";
			castCost = Spell.CostsArray[index];
			_isBuffMagic = true;
			_area = USING_RANGE;
			_cooldownTime = COOLDOWN_TIME;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("crystal");
				super.UseMagic(tmpGrid);
				var enemyArray:Array = App.universe.enemiesArray;
				var length:int = enemyArray.length;
				var tmpEnemy:Enemy;
				var distance:int;
				var spellArea:int = USING_RANGE * USING_RANGE;
				_currentCell = tmpGrid;
				
				for (var i:int = 0; i < length; i++)
				{
					tmpEnemy = enemyArray[i];
					distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + ((tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale * App.YScale));
					if (distance <= spellArea)
					{
						if (!tmpEnemy.isDead)
						{
							tmpEnemy.UseAdditionalDiamondsSpell(currentLevel);
						}
					}
				}
			}
			
			Destroy();
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}

}