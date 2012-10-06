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
	 * @author i am
	 */
	public class Bullet extends Sprite
	{
		public static const NAME:String = "Bullet";
		public static const ARROW:int = 101;
		public static const SPEAR:int = 102;
		public static const BIG_STONE:int = 103;
		public static const SMALL_STONE:int = 104;
		public static const EYE:int = 105;
		public static const MOVING_ROUND:int = 201;
		public static const MOVING_LINE:int = 202;
		public static const ANGLE_1:int = 15;
		public static const ANGLE_2:int = 165;
		public static const ANGLE_3:int = 195;
		public static const ANGLE_4:int = 345;
		public static const FULL_ROUND_ANGLE:int = 180;
		public static const ANIMATION_LENGTH:int = 9;
		public static const TOWER_HEIGHT:int = 80;
		public static const RIGHT_THROWING_DELAY:int = 15;
		
		public static var layer:Sprite;
		
		private var _bullet_movie:MovieClip;
		private var _type:int;
		private var _angle:int;
		private var _movingType:int;
		private var _X_delay:Number;
		private var _Y_delay:Number;
		private var _frames_counter:int;
		private var _enemy:Enemy;
		private var _tower:Tower;
		private var _meleeAttackFlag:Boolean;
		private var _centerPoint:Point;
		private var _radius:int;
		private var _angleDelay:Number;
		private var _currentAngle:Number;
		private var _direction:int;
		
		private var _EventListenersArray:Array = [];
		
		public function Init(type:int, tower:Tower, enemy:Enemy, meleeAttack:Boolean = false):void
		{
			_enemy = enemy;
			_tower = tower;
			_type = type;
			_meleeAttackFlag = meleeAttack;
			var firstPoint:Point;
			//var tmpMovie:MovieClip = _tower.towerMovie.getChildAt(0) as MovieClip;
			var tmpPointMovie:MovieClip = _tower.towerMovie.getChildByName("point") as MovieClip;
			if (tmpPointMovie != null)
			{
				firstPoint = new Point(_tower.currentCell.x + tmpPointMovie.x, _tower.currentCell.y - _tower.currentCell.gridHeight + tmpPointMovie.y);
			}
			else
			{
				firstPoint = new Point(_tower.currentCell.x, _tower.currentCell.y - TOWER_HEIGHT);
			}
			var lastPoint:Point = new Point(_enemy.x, _enemy.y);
			
			switch(type)
			{
				case SPEAR:
				_bullet_movie = new spearMovie();
				break;
				case ARROW:
				_bullet_movie = new arrowMovie();
				break;
				case BIG_STONE:
				_bullet_movie = new stoneMovie();
				_bullet_movie.gotoAndStop(1);
				break;
				case SMALL_STONE:
				_bullet_movie = new smallStoneMovie();
				break;
				case EYE:
				_bullet_movie = new EyeMovie();
				break;
			}
			layer.addChild(this);
			addChild(_bullet_movie);
			App.universe.addEventListener(UniverseDestroying.DESTROYING, onDestroyThis, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.PAUSE, onPauseEvent, false, 0, true);
			App.ingameInterface.addEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false, 0, true);
			
			_angle = (App.angleFinding(firstPoint, lastPoint) + 180) % 360;
			if ((_angle > ANGLE_1 && _angle < ANGLE_2) && (_type != EYE) && (_type != BIG_STONE))
			{
				_direction = 1;
				_movingType = MOVING_ROUND;
				_frames_counter = 0;
				this.x = firstPoint.x;
				this.y = firstPoint.y;
				_centerPoint = Point.interpolate(firstPoint, lastPoint, .5);
				_radius = Point.distance(firstPoint, _centerPoint);
				_angleDelay = FULL_ROUND_ANGLE / ANIMATION_LENGTH;
				_currentAngle = int(ANIMATION_LENGTH) * _angleDelay;
				rotation = _currentAngle / 5 + 90;
				addEventListener(Event.ENTER_FRAME, onUpdateRoundMoving, false, 0, true);
			}
			else if ((_angle > ANGLE_3 && _angle < ANGLE_4) && (_type != EYE) && (_type != BIG_STONE))
			{
				_direction = -1;
				_movingType = MOVING_ROUND;
				_frames_counter = 0;
				firstPoint.x += RIGHT_THROWING_DELAY;
				this.x = firstPoint.x;
				this.y = firstPoint.y;
				_centerPoint = Point.interpolate(firstPoint, lastPoint, .5);
				_radius = Point.distance(firstPoint, _centerPoint);
				_angleDelay = FULL_ROUND_ANGLE / ANIMATION_LENGTH;
				_currentAngle = 0;
				rotation = _currentAngle / 5 - 90;
				addEventListener(Event.ENTER_FRAME, onUpdateRoundMoving, false, 0, true);
			}
			else
			{
				_bullet_movie.rotation = (_angle + 180) % 360;
				_movingType = MOVING_LINE;
				_X_delay = (lastPoint.x - firstPoint.x) / ANIMATION_LENGTH;
				_Y_delay = (lastPoint.y - firstPoint.y) / ANIMATION_LENGTH;
				this.x = firstPoint.x + _X_delay * 3;
				this.y = firstPoint.y + _Y_delay * 3;
				_frames_counter = 3;
				addEventListener(Event.ENTER_FRAME, onUpdateLineMoving, false, 0, true);
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
			if (this.hasEventListener(Event.ENTER_FRAME))
			{
				tmpObject = new Object();
				tmpObject.object = this;
				tmpObject.type = Event.ENTER_FRAME;
				switch(_movingType)
				{
					case MOVING_ROUND:
					tmpObject.handler = onUpdateRoundMoving;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdateRoundMoving, false);
					break;
					case MOVING_LINE:
					tmpObject.handler = onUpdateLineMoving;
					_EventListenersArray.push(tmpObject);
					removeEventListener(Event.ENTER_FRAME, onUpdateLineMoving, false);
					break;
				}
			}
		}
		
		private function onUpdateRoundMoving(e:Event):void 
		{
			if(_direction == -1)
			{
				_frames_counter++;
				var tmpPoint:Point = Point.polar(_radius, (_currentAngle + _angle)/180*Math.PI);
				this.x = _centerPoint.x + tmpPoint.x;
				this.y = _centerPoint.y + tmpPoint.y / 3;
				_currentAngle += _angleDelay;
				this.rotation = _currentAngle/5 + 90;
				if (_frames_counter > ANIMATION_LENGTH / 2)
				{
					if (!_enemy.isDead)
					{
						_enemy.enemyTakingDamage(_tower, _meleeAttackFlag, _tower.damageType);
					}
					if (_type == ARROW || _type == SPEAR) {
						App.soundControl.playSound("hit_flesh");
					} else {
						App.soundControl.playSound("hit_stone");
					}
					Destroy();
				}
			}
			else
			{
				_frames_counter++;
				tmpPoint = Point.polar(_radius, (_currentAngle + _angle)/180*Math.PI);
				this.x = _centerPoint.x + tmpPoint.x;
				this.y = _centerPoint.y + tmpPoint.y / 3;
				_currentAngle -= _angleDelay;
				this.rotation = _currentAngle/5 - 90;
				if (_frames_counter > ANIMATION_LENGTH / 2)
				{
					if (!_enemy.isDead)
					{
						_enemy.enemyTakingDamage(_tower, _meleeAttackFlag, _tower.damageType);
					}
					if (_type == ARROW || _type == SPEAR) {
						App.soundControl.playSound("hit_flesh");
					} else {
						App.soundControl.playSound("hit_stone");
					}
					Destroy();
				}
			}
		}
		
		private function onUpdateLineMoving(e:Event):void 
		{
			_frames_counter++;
			this.x += _X_delay;
			this.y += _Y_delay;
			if (_type == BIG_STONE && _frames_counter == ANIMATION_LENGTH - 4)
			{
				_bullet_movie.play();
			}
			if (_frames_counter == ANIMATION_LENGTH)
			{
				if (!_enemy.isDead)
				{
					_enemy.enemyTakingDamage(_tower, _meleeAttackFlag, _tower.damageType);
				}
				if (_type == BIG_STONE)
				{
					App.soundControl.playSound("hit_big_stone");
					PreDestroy();
					_bullet_movie.gotoAndPlay(2);
				}
				else
				{
					Destroy();
				}
			}
		}
		
		private function PreDestroy():void 
		{
			removeEventListener(Event.ENTER_FRAME, onUpdateLineMoving, false);
			_bullet_movie.addEventListener("razvalilsia", onCompleteDestroy, false, 0, true);
		}
		
		private function onCompleteDestroy(e:Event):void 
		{
			_bullet_movie.removeEventListener("razvalilsia", onCompleteDestroy, false);
			removeChild(_bullet_movie);
			layer.removeChild(this);
			_bullet_movie.gotoAndStop(1);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyThis, false);
			App.pools.returnPoolObject(NAME, this);
		}
		
		private function onDestroyThis(e:UniverseDestroying):void 
		{
			Destroy();
		}
		
		public function Destroy():void
		{
			switch(_movingType)
			{
				case MOVING_LINE:
				removeEventListener(Event.ENTER_FRAME, onUpdateLineMoving, false);
				break;
				case MOVING_ROUND:
				removeEventListener(Event.ENTER_FRAME, onUpdateRoundMoving, false);
				break;
			}
			removeChild(_bullet_movie);
			layer.removeChild(this);
			_bullet_movie.gotoAndStop(1);
			App.ingameInterface.removeEventListener(PauseEvent.PAUSE, onPauseEvent, false);
			App.ingameInterface.removeEventListener(PauseEvent.UNPAUSE, onUnpauseEvent, false);
			App.universe.removeEventListener(UniverseDestroying.DESTROYING, onDestroyThis, false);
			App.pools.returnPoolObject(NAME, this);
		}
	}

}