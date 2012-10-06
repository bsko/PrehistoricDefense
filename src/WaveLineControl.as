package  
{
	import Events.AddNewWave;
	import Events.MenuToWavesControl;
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author i am
	 */
	public class WaveLineControl extends Sprite
	{
		private static const STATE_GETTING_CLOSE:int = 101;
		private static const STATE_ROUNDING:int = 102;
		
		private static const _timerDelay:int = 1000;
		private static const _AnimationLength:int = 10;
		private var _timer:Timer = new Timer(_timerDelay);
		private var _wavesSprite:Sprite = new Sprite();
		private var _repeatsNumber:int = App.WAVES_DELAY / _timerDelay;
		private var _currentIconToAnimate:MovieClip;
		private var _enterFrameCounter:int = 0;
		private var _isAnimating:Boolean = false;
		private var _isAddingStoped:Boolean = false;
		private var _waveArray:Array;
		private var _EventListenersArray:Array = [];
		private var _TimersArray:Array = [];
		private var _waveDescriptionsArray:Array = [];
		private var _animationState:int;
		
		public function Init(wavesArray:Array):void 
		{
			_waveArray = wavesArray;
			_isAddingStoped = false;
			addChild(_wavesSprite);
			_wavesSprite.visible = true;
			_wavesSprite.x = 580 - _repeatsNumber * App.WAVE_MENU_X_DELAY;
			_wavesSprite.y = 18;
			var length:int = wavesArray.length;
			for (var i:int = 0; i < length; i++)
			{
				var tmpWaveMovie:MovieClip = new WaveMobsMovie();
				var tmpWave:Wave = wavesArray[i];
				tmpWaveMovie.gotoAndStop(tmpWave.type);
				if (!tmpWave.isBossWave) {
					tmpWaveMovie.crown.visible = false;
				} else {
					tmpWaveMovie.crown.visible = true;
				}
				tmpWaveMovie.name = "wave_" + i.toString();
				_wavesSprite.addChild(tmpWaveMovie);
				tmpWaveMovie.x = ( -1) * i * _repeatsNumber * App.WAVE_MENU_X_DELAY;
				tmpWaveMovie.y = 0;
				tmpWaveMovie.addEventListener(MouseEvent.CLICK, onNextWave, false, 0, true);
				tmpWaveMovie.addEventListener(MouseEvent.MOUSE_OVER, onWaveDescr, false, 0, true);
				tmpWaveMovie.addEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false, 0, true);
			}
			_timer.start();
			_timer.addEventListener(TimerEvent.TIMER, onUpdatePositionByTimer, false, 0, true);
			App.universe.addEventListener(AddNewWave.READY_FOR_NEXT_WAVE, onReadyForNextWave, false, 0, true);
			App.universe.addEventListener(AddNewWave.NOT_READY, onStopWaveAdding, false, 0, true);
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
			var tmpTimer:Timer;
			while (_TimersArray.length != 0)
			{
				tmpTimer = _TimersArray.pop();
				tmpTimer.start();
			}
			
			_wavesSprite.visible = true;
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			var tmpObject:Object;
			_EventListenersArray.length = 0;
			if (_isAnimating)
			{
				if (hasEventListener(Event.ENTER_FRAME))
				{
					tmpObject = new Object();
					tmpObject.object = this;
					tmpObject.type = Event.ENTER_FRAME;
					tmpObject.handler = onUpdateIcon;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdateIcon, false);
				}
			}
			_TimersArray.length = 0;
			var tmpTimer:Timer;
			if (_timer.running)
			{
				tmpTimer = _timer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
			
			_wavesSprite.visible = false;
		}
		
		private function onCloseDescr(e:MouseEvent):void 
		{
			//App.appearingWindow.Hide();
			App.aboutWavesWindow.CloseWindow();
		}
		
		private function onWaveDescr(e:MouseEvent):void 
		{
			if (e.currentTarget is WaveMobsMovie)
			{
				var tmpWaveBtn:WaveMobsMovie = e.currentTarget as WaveMobsMovie;
				var tmpIndex:int = int(tmpWaveBtn.name.split("_")[1]);
				var tmpWave:Wave = _waveDescriptionsArray[tmpIndex];
				var tmpText:String = tmpWave.type + "\ncount: " + tmpWave.numberOfType + "\nhealth: " + tmpWave.enemyHP + "\narmor: " + tmpWave.enemyArmor + "\ncosts: " + tmpWave.cost + "\nresist to swords: " + tmpWave.resistToSword + "\nresist to pikes: " + tmpWave.resistToPike + "\nresist to blunts: " + tmpWave.resistToBlunt + "\nmagic resist: " + tmpWave.resistToMagic;
				var tmpPoint:Point = tmpWaveBtn.parent.localToGlobal(new Point(tmpWaveBtn.x, tmpWaveBtn.y));
				App.aboutWavesWindow.Init(tmpPoint.x, tmpPoint.y, tmpWave);
				//App.appearingWindow.NewText2(tmpText, tmpPoint, 120, - 50, 20);
			}
		}
		
		private function onStopWaveAdding(e:AddNewWave):void 
		{
			_isAddingStoped = true;
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER, onUpdatePositionByTimer, false);
			if (_isAnimating)
			{
				removeEventListener(Event.ENTER_FRAME, onUpdateIcon, false);
			}
		}
		
		private function onReadyForNextWave(e:AddNewWave):void 
		{
			if (_isAddingStoped)
			{
				_isAddingStoped = false;
				_timer.start();
				_timer.addEventListener(TimerEvent.TIMER, onUpdatePositionByTimer, false, 0, true);
				if (_isAnimating)
				{
					addEventListener(Event.ENTER_FRAME, onUpdateIcon, false, 0, true);
				}
				dispatchEvent(new AddNewWave(AddNewWave.ADD_NEW_WAVE, true, false));
			}
		}
		
		public function removeEventListenersFromWaves():void
		{
			for (var i:int = 0; i < _wavesSprite.numChildren; i++)
			{
				(_wavesSprite.getChildAt(i) as MovieClip).removeEventListener(MouseEvent.CLICK, onNextWave, false);
			}
		}
		
		public function addEventListenersToWaves():void
		{
			for (var i:int = 0; i < _wavesSprite.numChildren; i++)
			{
				(_wavesSprite.getChildAt(i) as MovieClip).addEventListener(MouseEvent.CLICK, onNextWave, false, 0, true);
			}
		}
		
		private function onNextWave(e:MouseEvent):void 
		{
			removeEventListenersFromWaves();
			_wavesSprite.x += 580 - (_wavesSprite.localToGlobal(new Point(_wavesSprite.getChildAt(0).x, _wavesSprite.getChildAt(0).y))).x - (_wavesSprite.getChildAt(0) as MovieClip).width / 2;
			dispatchEvent(new AddNewWave(AddNewWave.ADD_NEW_WAVE, true, false));
			startAnimation();
			_timer.reset();
			_timer.start();
		}
		
		private function onUpdatePositionByTimer(e:TimerEvent):void 
		{
			if (_timer.currentCount == _repeatsNumber)
			{
				if (_wavesSprite.numChildren > 0)
				{
					startAnimation();
					_timer.reset();
					_timer.start();
					removeEventListenersFromWaves();
					dispatchEvent(new AddNewWave(AddNewWave.ADD_NEW_WAVE, true, false));
				}
				else
				{
					destroy();
				}
			}
			_wavesSprite.x += App.WAVE_MENU_X_DELAY;
		}
		
		private function startAnimation():void 
		{
			_isAnimating = true;
			_animationState = STATE_GETTING_CLOSE;
			_currentIconToAnimate = _wavesSprite.getChildAt(0) as MovieClip;
			addEventListener(Event.ENTER_FRAME, onUpdateIcon, false, 0, true);	
		}
		
		private function onUpdateIcon(e:Event):void 
		{
			_enterFrameCounter++;
			if (_animationState == STATE_GETTING_CLOSE)
			{
				_currentIconToAnimate.x += (70 / _AnimationLength);
				if (_enterFrameCounter == int(_AnimationLength / 2))
				{
					_animationState = STATE_ROUNDING;
				}
			}
			if (_animationState == STATE_ROUNDING)
			{
				_currentIconToAnimate.scaleX -= ( 1 / _AnimationLength);
				_currentIconToAnimate.scaleY -= ( 1 / _AnimationLength);
				_currentIconToAnimate.rotation += 10;
				_currentIconToAnimate.x += (10 / _AnimationLength);
				
				if (_enterFrameCounter == _AnimationLength)
				{
					_wavesSprite.removeChildAt(0);
					removeEventListener(Event.ENTER_FRAME, onUpdateIcon, false);
					_enterFrameCounter = 0;
					_isAnimating = false;
				}
			}
		}
		
		private function removeListenersFromAnimatingIcon():void 
		{
			var tmpMovie:MovieClip = _wavesSprite.getChildAt(0) as MovieClip;
			tmpMovie.removeEventListener(MouseEvent.MOUSE_OVER, onWaveDescr, false);
			tmpMovie.removeEventListener(MouseEvent.MOUSE_OUT, onCloseDescr, false);
			App.appearingWindow.Hide();
		}
		
		public function destroy():void
		{
			_waveDescriptionsArray.length = 0;
			if (_isAnimating)
			{
				removeEventListener(Event.ENTER_FRAME, onUpdateIcon, false);
				_isAnimating = false;
				_currentIconToAnimate = null;
			}
			_timer.stop();
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, onUpdatePositionByTimer, false);
			
			App.universe.removeEventListener(AddNewWave.READY_FOR_NEXT_WAVE, onReadyForNextWave, false);
			App.universe.removeEventListener(AddNewWave.NOT_READY, onStopWaveAdding, false);
			while (_wavesSprite.numChildren > 0)
			{
				var tmpMovie:MovieClip = _wavesSprite.getChildAt(0) as MovieClip;
				tmpMovie.removeEventListener(MouseEvent.CLICK, onNextWave, false);
				_wavesSprite.removeChild(tmpMovie);
			}
			if (contains(_wavesSprite))
			{
				removeChild(_wavesSprite);
			}
			MonsterNames.ReInit();
		}
		
		public function initAboutWavesArray(wavesArray:Array):void 
		{
			var length:int = wavesArray.length;
			for (var i:int = 0; i < length; i++)
			{
				_waveDescriptionsArray.push(wavesArray[i]);
			}
		}
	}

}