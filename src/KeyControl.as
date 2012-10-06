package  
{
	import Events.PauseEvent;
	import Events.UniverseDestroying;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	/**
	 * ...
	 * @author 
	 */
	public class KeyControl extends Sprite
	{
		public static const NAME:String = "KeyControl";
		public static const ROTATING_LENGTH:int = 20;
		public static const ROTATING_HEIGHT:int = 80;
		public static const FLYING_LENGTH:int = 15;
		public static const STATE_ROTATING:int = 101;
		public static const STATE_WAITING_FOR_EVENT:int = 102;
		public static const STATE_FLYING:int = 103;
		private var _key_movie:MovieClip = new key_full_movie();
		private var _startPoint:Point;
		private var _endPoint:Point = new Point;
		private var _state:int = 0;
		private var _scale_delay:Number;
		private var _height_delay:Number;
		private var _flying_delay:Number;
		private var _frame_counter:int;
		private var _flying_animation_length:int;
		private var _rotation_delay:Number;
		private var _EventListenersArray:Array = [];
		
		public function KeyControl()
		{
			_key_movie.stop();
		}
		
		public function Init(startingPoint:Point):void
		{
			App.soundControl.playSound("get_key");
			
			_startPoint = startingPoint;
			this.x = _startPoint.x;
			this.y = _startPoint.y;
			_endPoint.x = this.x;
			_endPoint.y = this.y - 50;
			App.universe.keysLayer.addChild(this);
			addChild(_key_movie);
			_key_movie.scaleX = _key_movie.scaleY = 0;
			_state = STATE_ROTATING;
			_scale_delay = 1 / ROTATING_LENGTH;
			_height_delay =  1 / ROTATING_LENGTH;
			_frame_counter = 0;
			addEventListener(Event.ENTER_FRAME, onUpdateRounding, false, 0, true);
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onQuickDestroy, false, 0, true);
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
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				switch(_state)
				{
					case STATE_ROTATING:
					tmpObject.handler = onUpdateRounding;
					removeEventListener(Event.ENTER_FRAME, onUpdateRounding, false);
					break;
					case STATE_FLYING:
					tmpObject.handler = onUpdateFlying;
					removeEventListener(Event.ENTER_FRAME, onUpdateFlying, false);
					break;
				}
				_EventListenersArray.push(tmpObject);
			}
		}
		
		private function onQuickDestroy(e:UniverseDestroying):void 
		{
			Destroy();
		}
		
		private function onUpdateRounding(e:Event):void 
		{
			_key_movie.scaleX += _scale_delay;
			_key_movie.scaleY += _scale_delay;
			var currentPoint:Point = Point.interpolate( _endPoint, _startPoint, _frame_counter * _height_delay);
			this.x = currentPoint.x;
			this.y = currentPoint.y;
			_frame_counter++;
			if (_frame_counter == ROTATING_LENGTH)
			{
				removeEventListener(Event.ENTER_FRAME, onUpdateRounding, false);
				_key_movie.gotoAndStop(2);
				_state = STATE_WAITING_FOR_EVENT;
				_key_movie.addEventListener("key_event", onChangeStatusToFlying, false, 0, true);
			}
		}
		
		private function onChangeStatusToFlying(e:Event):void 
		{
			_key_movie.removeEventListener("key_event", onChangeStatusToFlying, false);
			_state = STATE_FLYING;
			_endPoint.x = 590;
			_endPoint.y = 68.5;
			_startPoint.x = this.x;
			_startPoint.y = this.y;
			_flying_animation_length = Point.distance(_startPoint, _endPoint) / 40 + 5;
			_frame_counter = 0;
			_rotation_delay = 360 / _flying_animation_length;
			_flying_delay = 1 / _flying_animation_length;
			addEventListener(Event.ENTER_FRAME, onUpdateFlying, false, 0, true);
		}
		
		private function onUpdateFlying(e:Event):void 
		{
			var currentPoint:Point = Point.interpolate(_endPoint, _startPoint, _flying_delay * _frame_counter);
			this.x = currentPoint.x;
			this.y = currentPoint.y;
			this.rotation = _rotation_delay * _frame_counter;
			_frame_counter++;
			if (_frame_counter == _flying_animation_length)
			{
				removeEventListener(Event.ENTER_FRAME, onUpdateFlying, false);
				App.universe.keysCount++;
				Destroy();
			}
		}
		
		public function Destroy():void
		{
			switch(_state)
			{
				case STATE_FLYING:
				removeEventListener(Event.ENTER_FRAME, onUpdateFlying, false);
				break;
				case STATE_ROTATING:
				removeEventListener(Event.ENTER_FRAME, onUpdateRounding, false);
				break;
				case STATE_WAITING_FOR_EVENT:
				_key_movie.removeEventListener("key_event", onChangeStatusToFlying, false);
				break;
			}
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onQuickDestroy, false);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			App.universe.keysLayer.removeChild(this);
			removeChild(_key_movie);
		}
	}

}