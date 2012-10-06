package Magic 
{
	import Events.ShiftTrap;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import Magic.Traps.Snare_trap;
	/**
	 * ...
	 * @author i am
	 */
	public class Snare extends Spell
	{	
		public static const COOLDOWN_TIME:int = 300;
		private var snareArray:Array = [];
		
		public function Snare() 
		{
			firstUpFlag = true;
			index = 3;
			title = "Hunting pit";
			label = "Snare";
			castCost = Spell.CostsArray[index];
			_isTrap = true;
			_cooldownTime = COOLDOWN_TIME - ((_currentLevel - 1) * 40);
		}
		
		override public function UseMagic(tmpGrid:Grid):void 
		{
			if (!isCooldown)
			{
				App.soundControl.playSound("trap_install");
				super.UseMagic(tmpGrid);
				var newSnareTrap:Snare_trap = App.pools.getPoolObject(Snare_trap.NAME);
				newSnareTrap.Init(tmpGrid);
				newSnareTrap.addEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false, 0, true);
				snareArray.push(newSnareTrap);
			}
		}
		
		private function onShiftIt(e:ShiftTrap):void 
		{
			var newSnareTrap:Snare_trap = snareArray.shift();
			newSnareTrap.removeEventListener(ShiftTrap.SHIFT_ME, onShiftIt, false);
		}
		
		override public function Destroy():void 
		{
			super.Destroy();
		}
	}
}