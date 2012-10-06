package Magic.Traps 
{
	import Enemies.ZlobniyGlist;
	import Events.PauseEvent;
	import Events.ShiftTrap;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class Snare_trap extends Sprite
	{
		public static const AREA:int = 10;
		public static const IN_USE_TIME:int = 900; // время в фреймах
		public static const NAME:String = "Snare_trap";
		private var _spell_movie:Sprite  = new SnareMovie();
		private var _spell_counter:int;
		private var _enemiesList:Array = [];
		private var _distance:int = AREA * AREA;
		private var _currentCell:Grid;
		
		private var _EventListenersArray:Array = [];
		
		public function Init(grid:Grid):void
		{
			_currentCell = grid;
			_spell_movie.x = _currentCell.x;
			_spell_movie.y = _currentCell.y;
			App.universe.ground.addChild(_spell_movie);
			_spell_counter = 0;
			addEventListener(Event.ENTER_FRAME, onSearchingForTarget, false, 0, true);
			_enemiesList = App.universe.enemiesArray;
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			while (_EventListenersArray.length != 0)
			{
				tmpObject = _EventListenersArray.pop();
				tmpObject.object.addEventListener(tmpObject.type, tmpObject.handler, false, 0, true);
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			_EventListenersArray.length = 0;
			var tmpObject:Object;
			if (hasEventListener(Event.ENTER_FRAME))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				tmpObject.handler = onSearchingForTarget;
				_EventListenersArray.push(tmpObject);
				removeEventListener(Event.ENTER_FRAME, onSearchingForTarget, false);
			}
		}
		
		private function onDestroyMagic(e:Event):void 
		{
			Destroy();
		}
		
		private function onSearchingForTarget(e:Event):void 
		{
			var tmpDistance:int;
			var tmpEnemy:Enemy;
			for (var i:int = 0; i < _enemiesList.length; i++)
			{
				tmpEnemy = _enemiesList[i];
				if (tmpEnemy.isBoss || (tmpEnemy is ZlobniyGlist))
				{
					continue;
				}
				tmpDistance = (tmpEnemy.x - _currentCell.x) * (tmpEnemy.x - _currentCell.x) + (tmpEnemy.y - _currentCell.y) * (tmpEnemy.y - _currentCell.y) / (App.YScale * App.YScale);
				if (tmpDistance <= _distance)
				{
					App.soundControl.playSound("fall_down");
					tmpEnemy.enemyTakingDamage(null, false, DamageTypes.MAGIC, 100000);
					Destroy();
					return;
				}
			}
			_spell_counter++;
			if (_spell_counter == IN_USE_TIME)
			{
				Destroy();
			}
		}
		
		private function Destroy():void 
		{
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyMagic, false);
			_spell_counter = 0;
			App.universe.ground.removeChild(_spell_movie);
			_currentCell = null;
			removeEventListener(Event.ENTER_FRAME, onSearchingForTarget, false);
			dispatchEvent(new ShiftTrap(ShiftTrap.SHIFT_ME, true, false));
			App.pools.returnPoolObject(NAME, this);
		}
		
	}

}