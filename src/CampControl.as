package  
{
	import Events.EndLevelEvent;
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author i am
	 */
	public class CampControl extends Sprite
	{
		public static const CAMP_PEOPLE_COUNT:int = 6;
		public static const BASE_CAMP_PEOPLE_COUNT:int = 10;
		public static const TIME_TO_NEW_HUMAN:int = 300; // время в фреймах
		public static const FRAMES_IN_ADDING_HUMAN_LINE:int = 8;
		
		private const _eatingSpeed:int = 30;
		
		private var _cellOwner:Grid;
		private var _campMovie:MovieClip = new CampMovie();
		private var _humansCount:int;
		private var _maxHumansCount:int;
		private var _humansDamage:Number = 1;
		private var _humansFullHP:int = 75;
		private var _humansHealth:int;
		private var _enemiesArray:Array = [];
		private var _currentEnemy:Object;
		private var _hasGrassEatingEnemy:Boolean;
		
		private var _humansHPs:MovieClip;
		private var _humansCounter:TextField;
		private var _monstersHPs:MovieClip;
		private var _monsterCounter:TextField;
		private var _changeRedFieldMovie:MovieClip;
		private var _changeBlueFieldMovie:MovieClip;
		private var _eatingCounter:int;
		
		private var _byClickMovie:MovieClip = new CampInfo();
		private var _isInfoOnScreen:Boolean = false;
		
		private var _timeForNewHuman:int = 0;
		private var _isInBattle:Boolean;
		private var _wasInBattle:Boolean;
		
		private var _EventListenersArray:Array = [];
		
		public function CampControl()
		{
			addChild(_campMovie);
			_campMovie.stop();
		}
		
		public function Init(grid:Grid):void
		{
			_wasInBattle = false;
			_cellOwner = grid;
			_timeForNewHuman = 0;
			_maxHumansCount = BASE_CAMP_PEOPLE_COUNT + int(App.economy / 5);
			_humansCount = _maxHumansCount;
			_humansDamage = int((1 + App.military / 50) * 100) / 100;
			_humansHealth = _humansFullHP;
			_enemiesArray.length = 0;
			_isInBattle = false;
			_hasGrassEatingEnemy = false;
			_campMovie.gotoAndStop("normal");
			visible = true;
			_cellOwner.addChild(this);
			this.x = 0;
			this.y = - App.Cell_H - App.HEIGHT_DELAY - grid.gridHeight;
			addEventListener(MouseEvent.MOUSE_OVER, onCampInfo, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, onCloseInfo, false, 0, true);
			addEventListener(Event.ENTER_FRAME, onUpdatePeopleCount, false, 0, true);
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
			if (!isInBattle)
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = onUpdatePeopleCount;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdatePeopleCount, false);
				}
			}
			else
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = onUpdateCampFight;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdateCampFight, false);
				}
				if (_hasGrassEatingEnemy)
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = onUpdateEating;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdateEating, false);
				}
			}
			if (isInfoOnScreen)
			{
				if (this.hasEventListener(Event.ENTER_FRAME))
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = findLinePosition;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, findLinePosition, false);
				}
			}
		}
		
		private function onUpdatePeopleCount(e:Event):void 
		{
			if (_humansCount < _maxHumansCount)
			{
				_timeForNewHuman++;
				if (_timeForNewHuman == TIME_TO_NEW_HUMAN)
				{
					_timeForNewHuman = 0;
					_humansCount++;
					visualPeopleUpdate();
				}
			}
		}
		
		private function onCampInfo(e:MouseEvent):void 
		{
			_campMovie.addChild(_byClickMovie);
			findLinePosition();
			_isInfoOnScreen = true;
			addEventListener(Event.ENTER_FRAME, findLinePosition, false, 0, true);
		}
		
		private function findLinePosition(e:Event = null):void 
		{
			_byClickMovie.peopleCount.text = String(_humansCount);
			_byClickMovie.gotoAndStop(int(FRAMES_IN_ADDING_HUMAN_LINE / TIME_TO_NEW_HUMAN * _timeForNewHuman));
		}
		
		private function onCloseInfo(e:MouseEvent = null):void 
		{
			if (_isInfoOnScreen)
			{
				removeEventListener(Event.ENTER_FRAME, findLinePosition, false);
				if (_campMovie.contains(_byClickMovie))
				{
					_campMovie.removeChild(_byClickMovie);
				}
				_isInfoOnScreen = false;
			}
		}
		
		public function addEnemy(fullHP:int, hp:int, dmg:int, isVolFlag:Boolean):void
		{
			var tmpObject:Object = new Object();
			tmpObject.health = hp;
			tmpObject.damage = dmg;
			tmpObject.fullHP = fullHP;
			tmpObject.isVol = isVolFlag;
			_enemiesArray.push(tmpObject);
			
			if (!_isInBattle)
			{
				App.soundControl.startFightingSound();
				
				_wasInBattle = true;
				_isInBattle = true;
				if (_isInfoOnScreen)
				{
					onCloseInfo();
				}
				removeEventListener(MouseEvent.MOUSE_OVER, onCampInfo, false);
				removeEventListener(MouseEvent.MOUSE_OUT, onCloseInfo, false);
				removeEventListener(Event.ENTER_FRAME, onUpdatePeopleCount, false);
				_campMovie.gotoAndStop("battle");
				var tmpMovie:MovieClip = _campMovie.fightingControl;
				_monstersHPs = tmpMovie.redProgressBar;
				_monsterCounter = tmpMovie.monsters;
				_humansHPs = tmpMovie.blueProgressBar;
				_humansCounter = tmpMovie.humans;
				_currentEnemy = tmpObject;
				_changeBlueFieldMovie = tmpMovie.changeBlueMovie;
				_changeRedFieldMovie = tmpMovie.changeRedMovie;
				
				_changeBlueFieldMovie.gotoAndPlay(0);
				addEventListener(Event.ENTER_FRAME, onUpdateCampFight, false, 0, true);
			}
			if (isVolFlag)
			{
				if (!_hasGrassEatingEnemy)
				{
					_hasGrassEatingEnemy = true;
					addEventListener(Event.ENTER_FRAME, onUpdateEating, false, 0, true);
				}
			}
			_changeRedFieldMovie.gotoAndPlay(0);
			_humansCounter.text = String(_humansCount);
			_monsterCounter.text = String(_enemiesArray.length);
		}
		
		private function onUpdateEating(e:Event):void 
		{
			_eatingCounter++;
			_humansHPs.gotoAndStop(_humansHPs.totalFrames - int(_humansHealth * _humansHPs.totalFrames / _humansFullHP));
			if (_eatingCounter >= _eatingSpeed)
			{
				var tmpArray:Array = App.universe.wheatArray;
				var length:int = tmpArray.length;
				var tmpInt:int = 0;
				var tmpWheat:WheatControl;
				var wheatToCut:WheatControl;
				for (var i:int = 0; i < length; i++)
				{
					tmpWheat = tmpArray[i];
					if (tmpInt < tmpWheat.tile.currentFrame)
					{
						tmpInt = tmpWheat.tile.currentFrame;
						wheatToCut = tmpWheat;
					}
				}
				if (wheatToCut != null)
				{
					wheatToCut.tile.gotoAndPlay(1);
				}
				_eatingCounter = 0;
			}
		}
		
		private function onUpdateCampFight(e:Event):void
		{
			if (!_currentEnemy.isVol)
			{
				_humansHealth -= _currentEnemy.damage;
				if (_humansHealth <= 0)
				{
					_humansCount--;
					_changeBlueFieldMovie.gotoAndPlay(0);
					if (_humansCount == 0)
					{
						dispatchEvent(new EndLevelEvent(EndLevelEvent.END_LEVEL, true, false, false));
					}
					_humansHealth = _humansFullHP;
					_humansCounter.text = String(_humansCount);
				}
				
				_humansHPs.gotoAndStop(_humansHPs.totalFrames - int(_humansHealth * _humansHPs.totalFrames / _humansFullHP));
			}
			
			_currentEnemy.health -= _humansDamage;
			if (_currentEnemy.health <= 0)
			{
				_enemiesArray.shift();
				_changeRedFieldMovie.gotoAndPlay(0);
				if (_enemiesArray.length != 0)
				{
					checkForMoreGrassEatingEnemies();
					_currentEnemy = _enemiesArray[0];
				}
				else
				{
					App.soundControl.stopFightingSound();
					
					if (_hasGrassEatingEnemy)
					{
						_hasGrassEatingEnemy = false;
						removeEventListener(Event.ENTER_FRAME, onUpdateEating, false);
					}
					_campMovie.gotoAndStop("normal");
					_isInBattle = false;
					addEventListener(MouseEvent.MOUSE_OVER, onCampInfo, false, 0, true);
					addEventListener(MouseEvent.MOUSE_OUT, onCloseInfo, false, 0, true);
					addEventListener(Event.ENTER_FRAME, onUpdatePeopleCount, false, 0, true);
					removeEventListener(Event.ENTER_FRAME, onUpdateCampFight, false);
					visualPeopleUpdate();
					return;
				}
				_monsterCounter.text = String(_enemiesArray.length);
			}
			var currentFrame:int = _monstersHPs.totalFrames - int(_currentEnemy.health * _monstersHPs.totalFrames / _currentEnemy.fullHP);
			_monstersHPs.gotoAndStop(currentFrame);
		}
		
		private function checkForMoreGrassEatingEnemies():void 
		{
			var length:int = _enemiesArray.length;
			var tmpObject:Object;
			for (var i:int = 0; i < length; i++)
			{
				tmpObject = _enemiesArray[i];
				if (tmpObject.isVol)
				{
					return;
				}
			}
			_hasGrassEatingEnemy = false;
			removeEventListener(Event.ENTER_FRAME, onUpdateEating, false);
		}
		
		private function visualPeopleUpdate():void
		{
			var tmpDiedPeopleCount:int = Math.ceil(CAMP_PEOPLE_COUNT / _maxHumansCount * _humansCount);
			var tmpMovie:MovieClip;
			for (var i:int = 0; i < CAMP_PEOPLE_COUNT; i++)
			{
				tmpMovie = _campMovie.getChildByName("man_" + String(i)) as MovieClip;
				if (i < tmpDiedPeopleCount)
				{
					tmpMovie.visible = true;
				}
				else
				{
					tmpMovie.visible = false;
				}
			}
		}
		
		public function makeAllPeopleVisible():void
		{
			var tmpMovie:MovieClip;
			if (isInBattle)
			{
				_campMovie.gotoAndStop("normal");
				_isInBattle = false;
			}
			for (var i:int = 0; i < CAMP_PEOPLE_COUNT; i++)
			{
				tmpMovie = _campMovie.getChildByName("man_" + String(i)) as MovieClip;
				if (tmpMovie != null)
				{
					tmpMovie.visible = true;
				}
			}
		}
		
		public function destroy():void
		{
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			makeAllPeopleVisible();
			_enemiesArray.length = 0;
			if (_hasGrassEatingEnemy)
			{
				removeEventListener(Event.ENTER_FRAME, onUpdateEating, false);
			}
			_cellOwner.removeChild(this);
			if (_isInBattle)
			{
				_campMovie.gotoAndStop("normal");
				_isInBattle = false;
				removeEventListener(Event.ENTER_FRAME, onUpdateCampFight, false);
			}
			else 
			{
				if (_isInfoOnScreen)
				{
					onCloseInfo();
				}
				removeEventListener(MouseEvent.MOUSE_OVER, onCampInfo, false);
				removeEventListener(MouseEvent.MOUSE_OUT, onCloseInfo, false);
				removeEventListener(Event.ENTER_FRAME, onUpdatePeopleCount, false);
			}
			_humansCount = 10;
			visualPeopleUpdate();
		}
		
		public function get isInBattle():Boolean { return _isInBattle; }
		
		public function get isInfoOnScreen():Boolean { return _isInfoOnScreen; }
		
		public function get wasInBattle():Boolean { return _wasInBattle; }
		
		public function set wasInBattle(value:Boolean):void 
		{
			_wasInBattle = value;
		}
	}

}