package Enemies 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author i am
	 */
	public class Flying extends Enemy
	{
		private var _spawnsArray:Array = [];
		private var _flewed:Boolean = false;
		
		override protected function checkPointChange():void 
		{
			if (!_flewed)
			{
				var tmpObject:Object = spawnsArray[App.randomInt(0, 4)];
				var tmpPoint1:Point = Point.interpolate(tmpObject.Point1, tmpObject.Point2, Math.random());
				var tmpPoint2:Point = Point.interpolate(tmpObject.Destination1, tmpObject.Destination2, Math.random());
				var tmpX1:int = x = tmpPoint1.x;
				var tmpY1:int = y = tmpPoint1.y;
				var tmpX2:int = tmpPoint2.x;
				var tmpY2:int = tmpPoint2.y
				
				_moving_pts_delay = 0;
				_startPt = tmpPoint1;
				_destinationPt = tmpPoint2;
				
				if (tmpX1 > tmpX2)
				{
					if (tmpY1 > tmpY2)
					{
						_direction = "UP_LEFT";
						enemyTile.gotoAndStop(_direction);
					}
					else
					{
						_direction = "DOWN_LEFT";
						enemyTile.gotoAndStop(_direction);
					}
				}
				else if (tmpX1 < tmpX2)
				{
					if (tmpY1 > tmpY2)
					{
						_direction = "UP_RIGHT";
						enemyTile.gotoAndStop(_direction);
					}
					else
					{
						_direction = "DOWN_RIGHT";
						enemyTile.gotoAndStop(_direction);
					}
				}
				_flewed = true;
			}
			else
			{
				destroy();
			}
		}
		
		protected function InitSpawns():void 
		{
			var tmpObject:Object = new Object();
			tmpObject.Point1 = new Point( -150, 50);
			tmpObject.Point2 = new Point(50, -150);
			tmpObject.Destination1 = new Point( 490, 630);
			tmpObject.Destination2 = new Point( 790, 430);
			spawnsArray.push(tmpObject);
			var tmpObject2:Object = new Object();
			tmpObject2.Point1 = new Point( 590, -150);
			tmpObject2.Point2 = new Point( 790, 50);
			tmpObject2.Destination1 = new Point( -150, 430);
			tmpObject2.Destination2 = new Point(50, 630);
			spawnsArray.push(tmpObject2);
			var tmpObject3:Object = new Object();
			tmpObject3.Point1 = new Point( -150, 430);
			tmpObject3.Point2 = new Point(50, 630);
			tmpObject3.Destination1 = new Point( 590, -150);
			tmpObject3.Destination2 = new Point( 790, 50);
			spawnsArray.push(tmpObject3);
			var tmpObject4:Object = new Object();
			tmpObject4.Point1 = new Point( 590, 630);
			tmpObject4.Point2 = new Point( 790, 430);
			tmpObject4.Destination1 = new Point( -150, 50);
			tmpObject4.Destination2 = new Point(50, -150);
			spawnsArray.push(tmpObject4);
		}
		
		override public function destroy():void 
		{
			super.destroy();
			_flewed = false;
		}
		
		public function get spawnsArray():Array { return _spawnsArray; }
		
		public function set spawnsArray(value:Array):void 
		{
			_spawnsArray = value;
		}
	}

}