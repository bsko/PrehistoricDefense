package Magic 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author i am
	 */
	public class Money extends Spell
	{
		private static const USING_RANGE:int = 100;
		private static const USING_TIME:int = 15000;
		public static const COOLDOWN_TIME:int = 450;
		private var _spell_counter:int;
		private var _currentCell:Grid;
		
		public function Money() 
		{
			firstUpFlag = true;
			index = 9;
			title = "Reward";
			label = "Money";
			castCost = Spell.CostsArray[index];
			_isBuffMagic = true;
			_area = USING_RANGE;
			_cooldownTime = COOLDOWN_TIME;
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("money");
				super.UseMagic(tmpGrid);
				var towersArray:Array = App.universe.towersArray;
				var length:int = towersArray.length;
				var tmpTower:Tower;
				var distance:int;
				var spellArea:int = USING_RANGE * USING_RANGE;
				_currentCell = tmpGrid;
				for (var i:int = 0; i < length; i++)
				{
					tmpTower = towersArray[i];
					distance = (tmpTower.currentCell.x - _currentCell.x) * (tmpTower.currentCell.x - _currentCell.x) + (tmpTower.currentCell.y - _currentCell.y) * (tmpTower.currentCell.y - _currentCell.y) / (App.YScale * App.YScale);
					trace(distance, spellArea, USING_RANGE);
					if (distance <= spellArea)
					{
						tmpTower.AdditionalMoneyMagic(currentLevel, USING_TIME);
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