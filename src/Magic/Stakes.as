package Magic 
{
	import Events.ShiftTrap;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Magic.Traps.Stakes_trap;
	/**
	 * ...
	 * @author i am
	 */
	public class Stakes extends Spell
	{
		public static const COOLDOWN_TIME:int = 210;
		private var stakesArray:Array = [];
		
		public function Stakes() 
		{
			firstUpFlag = false;
			index = 4;
			title = "Defence Ditch";
			label = "Stakes";
			castCost = Spell.CostsArray[index];
			_isTrap = true;
			_cooldownTime = COOLDOWN_TIME;
		}
			
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("trap_install");
				super.UseMagic(tmpGrid);
				var newStakesTrap:Stakes_trap = App.pools.getPoolObject(Stakes_trap.NAME);
				newStakesTrap.Init(tmpGrid, _currentLevel);
				stakesArray.push(newStakesTrap);
				newStakesTrap.addEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false, 0, true);
			}
		}
		
		private function onShiftIt(e:ShiftTrap):void 
		{
			var newStakesTrap:Stakes_trap = stakesArray.shift();
			newStakesTrap.removeEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false);
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}

}