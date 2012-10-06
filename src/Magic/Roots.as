package Magic 
{
	import Events.ShiftTrap;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.events.Event;
	import Magic.Traps.Roots_trap;
	/**
	 * ...
	 * @author i am
	 */
	public class Roots extends Spell
	{
		public static const COOLDOWN_TIME:int = 210;
		private var rootsArray:Array = [];
		
		public function Roots() 
		{
			firstUpFlag = false;
			index = 5;
			title = "Poisonous Roots";
			label = "Roots";
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
				var newRootTrap:Roots_trap = App.pools.getPoolObject(Roots_trap.NAME);
				newRootTrap.Init(tmpGrid, _currentLevel);
				newRootTrap.addEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false, 0, true);
				rootsArray.push(newRootTrap);
			}
		}
		
		private function onShiftIt(e:ShiftTrap):void 
		{
			var newRootTrap:Roots_trap = rootsArray.shift();
			newRootTrap.removeEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false);
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}

}