package Textures
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class mapGrid extends Sprite
	{
		public function mapGrid():void{
			//drawMap()
		}
		//
		private function drawMap():void{
			for(var xx:int = 0; xx < 62; xx++) {
				for(var yy:int = 0; yy < 46; yy++) {
					fillRect(graphics, xx * 50, yy * 50,0xaaaaaa);
				}
			}
		}
		private function fillRect(target:Graphics, cellX:int, cellY:int, color:int):void {			
			target.lineStyle(2, color);
			target.moveTo(cellX , cellY );
			target.beginFill(color, 0);			
			target.drawRect(cellX + 2, cellY + 2, 40 , 40 );
			//target.drawCircle(cellX * cellSize, cellY * cellSize, 10);
			target.endFill();
		}
	}
}