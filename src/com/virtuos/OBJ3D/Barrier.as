package com.virtuos.OBJ3D
{
	import com.virtuos.Managers.DataManager;
	import com.virtuos.SpriteContainer3D;
	
	import flash.geom.Point;
	
	import starling.display.Image;

//	import starling.display.Sprite;
	
	public class Barrier extends SpriteContainer3D
	{
		[Embed(source="Assets/Barrier.jpg")]
		private var dracula:Class;
		//big table
		[Embed(source="Assets/2.png")]
		private var bigTable:Class;
		//coffin
		[Embed(source="Assets/3.png")]
		private var coffin:Class;
		//pillar
		[Embed(source="Assets/4.png")]
		private var pillar:Class;
		//table
		[Embed(source="Assets/5.png")]		
		private var table:Class;
		//barrier id
		[Embed(source="Assets/6-1.png")]		
		private var wall_1:Class;
		[Embed(source="Assets/6-2.png")]		
		private var wall_2:Class;
		public var _id:uint;
		
	//	public var _style:uint;
		//private function _tempFun:Function
		public function Barrier(_style:uint)
		{
			super();	
			
			var tempDracula:Image
			if(DataManager._versionDebug){
				
				tempDracula=Image.fromBitmap(new dracula)
				addChild(tempDracula);
				tempDracula.dispose();
			}else{
				switch(_style){
					case 6:						
						
						tempDracula=Image.fromBitmap(new wall_2);
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					case 9:	
						tempDracula=Image.fromBitmap(new wall_1);
						tempDracula.y=-50						
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					case 2:
						tempDracula=Image.fromBitmap(new bigTable);
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					case 3:
						tempDracula=Image.fromBitmap(new coffin);
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					case 4:
						tempDracula=Image.fromBitmap(new pillar);
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					case 5:
						tempDracula=Image.fromBitmap(new table);
						addChild(tempDracula);
						tempDracula.dispose();
						break;
					
				}
			}
			//tempDracula.x=tempDracula.y=-25
		}		
		//debug 模式放collision
		public function randPosition(_pos:uint):void{
			
			var _tempY:uint=uint((_pos-1)/41);
			var _tempX:uint=(_pos-1)%41;	
//			trace("_pos:",_pos,_tempY,_tempX)	
			this.width=this.height=50;
			this.x=_tempX*50-25;
			this.y=_tempY*50-25;
			DataManager._obstacleArray.push(new Point(this.x,this.y))			
		}	
		//完整模式放collision
		public function randFullVersionPosition(_pos:uint):void{
			
			var _tempY:uint=uint((_pos-1)/41);
			var _tempX:uint=(_pos-1)%41;
			//this.width=this.height=50;
			this.x=_tempX*50-25;
			this.y=_tempY*50-25;
			//trace(_tempY,_tempX)
			DataManager._obstacleArray.push(new Point(this.x,this.y))			
		}
		public static function configFullVersionPosition(_pos:uint):void{
			var _tempY:uint=uint((_pos-1)/41)*50-25;
			var _tempX:uint=(_pos-1)%41*50-25;			
			//trace(_tempY,_tempX)
			DataManager._obstacleArray.push(new Point(_tempX,_tempY))	
		}
	}
}