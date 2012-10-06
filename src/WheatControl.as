package  
{
	import Events.PauseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author i am
	 */
	public class WheatControl extends Sprite
	{
		public static const NAME:String = "wheatcontrol";
		public static const WHEAT_COUNT:int = 5;
		public static const GROWING_SPEED:int = 1800; // y.e.
		
		private var _TimersArray:Array = [];
		private var _cellOwner:Grid;
		private var _tile:MovieClip = new wheatMovie();
		private var _wheatTimer:Timer = new Timer(int((_tile.totalFrames) * GROWING_SPEED / App.FRAMERATE));
		
		public function WheatControl()
		{
			_tile.stop();
		}
		
		public function Init(cell:Grid):void
		{
			_cellOwner = cell;
			_cellOwner.isWheatOwner = true;
			_tile.gotoAndPlay(1);
			_tile.x = - App.Half_Cell_W;;
			_tile.y = - App.Half_Cell_H - App.HEIGHT_DELAY - _cellOwner.gridHeight;
			addChild(_tile);
			_cellOwner.wheat = this;
			_cellOwner.addChild(this);
			_wheatTimer.addEventListener(TimerEvent.TIMER, onUpdateGrowingUp, false, 0, true);
			_wheatTimer.start();
			App.universe.wheatArray.push(this);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
		}
		
		private function onUnpauseEvent(e:PauseEvent):void 
		{
			var tmpTimer:Timer;
			while (_TimersArray.length != 0)
			{
				tmpTimer = _TimersArray.pop();
				tmpTimer.start();
			}
		}
		
		private function onPauseEvent(e:PauseEvent):void 
		{
			_TimersArray.length = 0;
			var tmpTimer:Timer;
			if (_wheatTimer.running)
			{
				tmpTimer = _wheatTimer;
				tmpTimer.stop();
				_TimersArray.push(tmpTimer);
			}
		}
		
		public function Destroy():void
		{
			_wheatTimer.removeEventListener(TimerEvent.TIMER, onUpdateGrowingUp, false);
			_tile.gotoAndStop(1);
			removeChild(_tile);
			_cellOwner.removeChild(this);
			_cellOwner.isWheatOwner = false;
			_cellOwner.wheat = null;
			_cellOwner = null;
			App.pools.returnPoolObject(NAME, this);
		}
		
		private function onUpdateGrowingUp(e:TimerEvent):void 
		{
			if (!App.isPauseOn)
			{
				if (_tile.currentFrame != _tile.totalFrames)
				{
					_tile.play();
				}
			}
		}
		
		public function get tile():MovieClip { return _tile; }
	}

}