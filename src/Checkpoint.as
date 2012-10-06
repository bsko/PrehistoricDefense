package  
{
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author author
	 */
	public class Checkpoint 
	{
		public static var NAME:String = "Checkpoint";
		public var currentPoint:Point;
		public var nextPointArray:Array = [];
		public var nextPointLinesArray:Array = [];
		
		public function Init(curPoint:Point):void 
		{
			currentPoint = curPoint;
		}
		
		public function destroy():void 
		{
			currentPoint = null;
			for (var i:int = 0; i < nextPointArray.length; i++)
			{
				nextPointArray[i].destroy();
			}
			nextPointArray.length = 0;
			nextPointLinesArray.length = 0;
			App.pools.returnPoolObject(NAME, this);
		}
		
		public function addCheckpoint(nextCheck:Checkpoint):Boolean
		{
			for (var i:int = 0; i < nextPointArray.length; i++)
			{
				if (nextCheck == nextPointArray[i])
				{
					return false;
				}
			}
			if (currentPoint.x != nextCheck.currentPoint.x && currentPoint.y != nextCheck.currentPoint.y)
			{
				return false;
			}
			nextPointArray.push(nextCheck);
			var tmpSprite:Sprite = new Sprite();
			var tmpY:int = - App.Cell_H * 5 + App.Half_Cell_H + currentPoint.y * App.Half_Cell_H + App.Half_Cell_H * currentPoint.x;
			var tmpX:int = App.Half_W_DIV + currentPoint.x * App.Half_Cell_W - App.Half_Cell_W * currentPoint.y;
			tmpSprite.graphics.moveTo(tmpX, tmpY);
			var tmpX2:int = App.Half_W_DIV + nextCheck.currentPoint.x * App.Half_Cell_W - App.Half_Cell_W * nextCheck.currentPoint.y;
			var tmpY2:int = - App.Cell_H * 5 + App.Half_Cell_H + nextCheck.currentPoint.y * App.Half_Cell_H + App.Half_Cell_H * nextCheck.currentPoint.x;
			tmpSprite.graphics.lineStyle(4, 0xFF0000);
			tmpSprite.graphics.lineTo(tmpX2, tmpY2);
			nextPointLinesArray.push(tmpSprite);
			return true;
		}
	}

}