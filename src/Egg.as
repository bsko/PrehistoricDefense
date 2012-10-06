package  
{
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author i am
	 */
	public class Egg extends Sprite
	{
		
		public static const NAME:String = "Egg";
		private static const DAMAGE:int = 10;
		private static const FLYING_HEIGHT:int = 100;
		public static const DAMAGE_AREA:int = 50;
		public static var towers_array:Array;
		private var eggMovie:MovieClip;
		private var egg1:MovieClip = new egg_movie1();
		private var egg2:MovieClip = new egg_movie2();
		private var egg3:MovieClip = new egg_movie3();
		private var _dyingEgg:MovieClip = new eggBang_Movie();
		private var _startPoint:Point = new Point();
		//private var destination:Point = new Point();
		private var _gridOwner:Grid;
		private var _frames_counter:int = 0;
		private var _total_frames:int = 0;
		private var _endPosition:Point = new Point();
		private var _direct:int;
		private var _speedRotation:int;
		private var _EventListenersArray:Array = [];
		
		public function Egg()
		{
			_dyingEgg.stop();
			//eggMovie.stop();
		}
		
		public function Init(startingPoint:Point):void 
		{
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
			_direct = (Math.random() > 0.5) ? 1 : -1;
			_speedRotation = int(Math.random() * 10 + 5);
			if (startingPoint.y > 350)
			{
				if (parent != null)
				{
					parent.removeChild(this);
				}
				App.pools.returnPoolObject(NAME, this);
				return;
			}
			_startPoint.x = startingPoint.x;
			_startPoint.y = startingPoint.y + 5;
			switch(App.randomInt(0, 3))
			{
				case 0:
				eggMovie = egg1;
				eggMovie.scaleX = .5;
				eggMovie.scaleY = .5;
				break;
				case 1:
				eggMovie = egg2;
				eggMovie.scaleX = 0.8;
				eggMovie.scaleY = 0.8;
				break;
				case 2:
				eggMovie = egg3;
				eggMovie.scaleX = 1;
				eggMovie.scaleY = 1;
				break;
			}
			
			searchForGrid();
			addChild(eggMovie);
			if (_gridOwner != null)
			{
				searchForCoordinatesOnGrid();
				var tmpDelay:int = 0;
				if (_gridOwner.cellState != App.CELL_STATE_ROAD && _gridOwner.cellState != App.CELL_STATE_WATER)
				{
					tmpDelay = App.HEIGHT_DELAY;
				}
				_total_frames = Math.abs((_endPosition.y - _startPoint.y) / 5);
				_frames_counter = 0;
				eggMovie.x = _startPoint.x;
				eggMovie.y = _startPoint.y;
				addEventListener(Event.ENTER_FRAME, onUpdateEggPosition, false, 0, true);
			}
			else
			{
				Destroy();
			}
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
				tmpObject.handler = onUpdateEggPosition;
				_EventListenersArray.push(tmpObject);
				removeEventListener(Event.ENTER_FRAME, onUpdateEggPosition, false);
			}
		}
		
		private function searchForCoordinatesOnGrid():void 
		{
			_endPosition.x = _startPoint.x ;
			var tmpYPosition:int = _startPoint.y + FLYING_HEIGHT;
			if (_gridOwner.cellState != App.CELL_STATE_ROAD && _gridOwner.cellState != App.CELL_STATE_WATER)
			{
				tmpYPosition -= App.HEIGHT_DELAY;
			}
			tmpYPosition -= _gridOwner.gridHeight;
			_endPosition.y = tmpYPosition;
		}
		
		private function searchForGrid():void 
		{
			var tmpArray:Array = App.universe.mapMask;
			var tmpGrid:Grid;
			var distance:int;
			var minDistance:int = 999999;
			for (var i:int = 0; i < App.MAP_SIZE; i++)
			{
				for (var j:int = 0 ; j < App.MAP_SIZE; j++)
				{
					tmpGrid = tmpArray[i][j];
					distance = Point.distance(new Point(tmpGrid.x, tmpGrid.y), new Point(_startPoint.x, _startPoint.y + FLYING_HEIGHT));
					if (distance < minDistance)
					{
						minDistance = distance;
						_gridOwner = tmpGrid;
					}
				}
			}
			if (minDistance > 31)
			{
				_gridOwner = null;
			}
		}
		
		private function onUpdateEggPosition(e:Event):void 
		{
			if (_frames_counter < _total_frames)
			{
				eggMovie.y += 5;
				eggMovie.rotation += _direct * _speedRotation;
				_frames_counter++;
			}
			else if (_frames_counter >= _total_frames)
			{
				App.soundControl.playSound("egg_splash");
				
				if (Math.random() > 0.5)
				{
					_dyingEgg.gotoAndStop(1);
					_dyingEgg.egg1.gotoAndPlay(1);
				}
				else
				{
					_dyingEgg.gotoAndStop(2);
					_dyingEgg.egg2.gotoAndPlay(1);
				}
				_dyingEgg.x = eggMovie.x;
				_dyingEgg.y = eggMovie.y;
				App.universe.eggsLayer.addChild(_dyingEgg);
				//if (_gridOwner.tower != null)
				{
					searchForTowersInArea();
					//_gridOwner.tower.TowerTakingDamage(DAMAGE);
				}
				Destroy();
			}
		}
		
		private function searchForTowersInArea():void 
		{
			var tmpTower:Tower;
			for (var i:int = 0; i < towers_array.length; i++)
			{
				tmpTower = towers_array[i];
				var tmpDistance:int = Point.distance(new Point(tmpTower.currentCell.x, tmpTower.currentCell.y), new Point(_gridOwner.x, _gridOwner.y));
				if (tmpDistance <= DAMAGE_AREA)
				{
					tmpTower.TowerTakingDamage(DAMAGE);
				}
			}
		}
		
		public function Destroy():void 
		{
			removeChild(eggMovie);
			_gridOwner = null;
			removeEventListener(Event.ENTER_FRAME, onUpdateEggPosition, false);
			if (parent != null)
			{
				parent.removeChild(this);
			}
			eggMovie = null;
			_endPosition.x = 0;
			_endPosition.y = 0;
			_startPoint.x = 0;
			_startPoint.y = 0;
			App.pools.returnPoolObject(NAME, this);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
		}
		
	}

}