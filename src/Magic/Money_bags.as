package Magic 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * ...
	 * @author i am
	 */
	public class Money_bags extends Spell
	{
		private static const USING_RANGE:int = 150;
		public static const COOLDOWN_TIME:int = 450;
		private var _spell_counter:int;
		private var _currentCell:Grid;
		
		public function Money_bags() 
		{
			firstUpFlag = false;
			index = 10;
			title = "Black Spot";
			label = "Money_bags";
			castCost = Spell.CostsArray[index];
			_isBuffMagic = true;
			_area = USING_RANGE;
			_cooldownTime = COOLDOWN_TIME;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("money_bags");
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
					distance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + (tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) /(App.YScale * App.YScale);
					if (distance <= spellArea)
					{
						if (!tmpEnemy.isDead)
						{
							tmpEnemy.UseAdditionalMoneySpell(currentLevel);
						}
					}
				}
			}
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}

}