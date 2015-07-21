package com.virtuos.BaseAI
{
	import com.virtuos.Characters.BaseEnemy;
	import com.virtuos.Characters.Farmer;
	import com.virtuos.Characters.VampireHunter;
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.HunterManager;
	
	//用于寻路的ai
	public class PathFinder{
		//
		public static var _startX:uint=7;
		public static var _startY:uint=1;
		//
		public static var _endX:uint=5;
		public static var _endY:uint=1;
		//地图数据
		public static var _map:Array ,_queue:Vector.<Object>;
		
		private static var _enemyDebug:BaseEnemy;
		public static function findPath(map:Array,sX:uint=7,sY:uint=1,eX:uint=5,eY:uint=1,$enemy:BaseEnemy=null):Vector.<Object>{
			var i:int;
			var $enemyType:String;
			_enemyDebug=$enemy
			_queue = new Vector.<Object>();
			_map = map;
			//first find the coordinate of finish which is a first object
			var finishObject:Object;
			var counter:int = 0;
			_startX=sX;
			_startY=sY;
			_endX=eX;
			_endY=eY;
			//trace(_startX,_startY,_endX,_endY)
			finishObject={i:_endX,j:_endY,counter:0}
			_queue.push(finishObject);		
			//trace(_queue)
			//run recursive function to find the shortest path
			if($enemy is Farmer){
				$enemyType="F"
			}else if($enemy is VampireHunter){
				if(DataManager._veriation==2){
					$enemyType="F"
				}else{
					$enemyType="VH"
				}
			}			
			checkQueue(0, 1,$enemyType);	
			
			//my function search Path;
			/**
			 * 寻最短路径
			 * */
			var newDisX:uint=_startX;
			var newDisY:uint=_startY;
			
			var pathArray:Vector.<Object>=new Vector.<Object>;
			var _counter:Number=_queue[_queue.length-1].counter;
//			var _len:uint=_queue.length-1;		
			i=_queue.length-1;
			if($enemyType=="F"){
				for(;i>=0;--i){
					//trace(_queue[i].i,_queue[i].j,_queue[i].counter)
					if(Math.abs(_queue[i].i-newDisX)==1&&Math.abs(_queue[i].j-newDisY)==0&&_queue[i].counter<=_counter){
						pathArray.push(_queue[i]);						
						newDisX=_queue[i].i;
						_counter=_queue[i].counter;
					}else if(Math.abs(_queue[i].i-newDisX)==0&&Math.abs(_queue[i].j-newDisY)==1&&_queue[i].counter<=_counter){
						pathArray.push(_queue[i]);
						newDisY=_queue[i].j;				
						_counter=_queue[i].counter;							
					}
				}		
			}else{
				//vampire hunter path
				//pathArray.push(_queue[_queue.length-1]);
				var _tempNewX:uint
				var _tempNewY:uint
				for(;i>=0;--i){						
					if(_queue[i].counter<=_counter&&(Math.abs(_queue[i].i-newDisX)==1&&Math.abs(_queue[i].j-newDisY)==0||Math.abs(_queue[i].i-newDisX)==0&&Math.abs(_queue[i].j-newDisY)==1||Math.abs(_queue[i].i-newDisX)==1&&Math.abs(_queue[i].j-newDisY)==1)){						
						if(_counter==_queue[i].counter+1){							
							//if((_endY-_queue[i].i)*(_queue[i].i-newDisX)>0&&(_endX-_queue[i].j)*(_queue[i].j-newDisY)>0||(_endX-_queue[i].j)*(_queue[i].j-newDisY)==0||(_endY-_queue[i].i)*(_queue[i].i-newDisX)==0){
								pathArray.push(_queue[i]);						
								newDisX=_queue[i].i;
								newDisY=_queue[i].j;
								_counter=_queue[i].counter;	
							//}
							//trace("+1:",_queue[i].i,_queue[i].j,_queue[i].counter,_counter)
						}else if(_counter==_queue[i].counter+.6){
							trace("new:",_queue[i].i,
								_queue[i].j,
								"y:",_endY-_queue[i].i,
								"x:",_endX-_queue[i].j)
							trace("new2:",_queue[i].i,
								_queue[i].j,
								"y:",_queue[i].i-newDisX,
								"x:",_queue[i].j-newDisY)
							//if((_endY-_queue[i].i)*(_queue[i].i-newDisX)>0&&(_endX-_queue[i].j)*(_queue[i].j-newDisY)>0||(_endX-_queue[i].j)*(_queue[i].j-newDisY)==0||(_endY-_queue[i].i)*(_queue[i].i-newDisX)==0){
								pathArray.push(_queue[i]);						
								newDisX=_queue[i].i;
								newDisY=_queue[i].j;
								_counter=_queue[i].counter;
							//}
							//trace("+.6:",_queue[i].i,_queue[i].j,_queue[i].counter,_counter)
						}else if(_counter==_queue[i].counter+1.4){
							
							//if()
							pathArray.push(_queue[i]);						
							newDisX=_queue[i].i;
							newDisY=_queue[i].j;
							_counter=_queue[i].counter;
							//trace("+1.4:",_queue[i].i,_queue[i].j,_queue[i].counter,_counter)
						}
					}
				}				
				
			}
			/**
			 * 是否全部打印寻路信息
			 * */
			var printAll:Boolean=true;
			if(printAll){
				main3D._test=_queue
			}else{
				main3D._test=pathArray;
			}
			return pathArray;
		}		
		private static function checkQueue(startIndex:int, counter:int, enemyType:String):void{
			var lastQueueLength:int = _queue.length;
			var i:int= startIndex;
			//trace(_startX,_startY,_endX,_endY)
			for (; i < lastQueueLength; i++)
			{
				var coordinate:Object;
				//check top
				if (_queue[i].j != 0 &&isPath(_map[_queue[i].i][_queue[i].j - 1]))
				{
					coordinate = {i: _queue[i].i, j: _queue[i].j - 1, counter:counter};
					//if this coordinate is the start finish algorothm as 
					//the shortest path was just found
					if (coordinate.i==_startX&&coordinate.j ==_startY)
						return;
					//if a coordinate already exists in the queue 
					//and has higher coordinate it won't be added
					//but if it has lower coordinate it will replace the one in the queue
					if (canBeAddedToQueue(coordinate))
						_queue.push(coordinate);
				}
				//check right			
				if (_queue[i].i != _map.length - 1 &&isPath(_map[_queue[i].i + 1][_queue[i].j])) 
					//(_map[_queue[i].i + 1][_queue[i].j] ==0||_map[_queue[i].i + 1][_queue[i].j] ==7||_map[_queue[i].i + 1][_queue[i].j] ==8))
				{
					coordinate = {i: _queue[i].i + 1, j: _queue[i].j, counter:counter};
					if (coordinate.i==_startX&&coordinate.j == _startY) 
						return;
					if (canBeAddedToQueue(coordinate)) 
						_queue.push(coordinate);
				}
				//check bottom
				if (_queue[i].j != _map[_queue[i].i].length - 1 &&isPath(_map[_queue[i].i][_queue[i].j + 1]))  
					//(_map[_queue[i].i][_queue[i].j + 1] ==0||_map[_queue[i].i][_queue[i].j + 1] ==7||_map[_queue[i].i][_queue[i].j + 1] ==8))
				{
					coordinate = {i: _queue[i].i, j: _queue[i].j + 1, counter:counter};
					if (coordinate.i==_startX&&coordinate.j == _startY) 
						return;
					if (canBeAddedToQueue(coordinate)) 
						_queue.push(coordinate);
				}
				//check left
				if (_queue[i].i != 0 &&isPath(_map[_queue[i].i-1][_queue[i].j])) 
					//(_map[_queue[i].i - 1][_queue[i].j] ==0||_map[_queue[i].i - 1][_queue[i].j] ==7||_map[_queue[i].i - 1][_queue[i].j] ==8))
				{
					coordinate = {i: _queue[i].i - 1, j: _queue[i].j, counter:counter};
					if (coordinate.i==_startX&&coordinate.j == _startY) 
						return;
					if (canBeAddedToQueue(coordinate)) 
						_queue.push(coordinate);
				}	
				//hunter 的AI策略
				if(enemyType=="VH"){
					//check left top
					if(_queue[i].i != 0&&_queue[i].j != 0&&isPath(_map[_queue[i].i-1][_queue[i].j-1])&&(isPath(_map[_queue[i].i][_queue[i].j-1])||isPath(_map[_queue[i].i-1][_queue[i].j]))){
						coordinate = {i: _queue[i].i - 1, j: _queue[i].j-1, counter:counter+.4};
						if (coordinate.i==_startX&&coordinate.j == _startY) 
							return;
						if (canBeAddedToQueue(coordinate)) 
							_queue.push(coordinate);
					}
					//check right top
					if(_queue[i].i != _map.length - 1&&_queue[i].j != 0&&isPath(_map[_queue[i].i+1][_queue[i].j-1])&&(isPath(_map[_queue[i].i][_queue[i].j-1])||isPath(_map[_queue[i].i+1][_queue[i].j]))){
						coordinate = {i: _queue[i].i + 1, j: _queue[i].j-1, counter:counter+.4};
						if (coordinate.i==_startX&&coordinate.j == _startY) 
							return;
						if (canBeAddedToQueue(coordinate)) 
							_queue.push(coordinate);
					}
					//check right bottom
					if(_queue[i].i != _map.length - 1 &&_queue[i].j != _map[_queue[i].i].length - 1 &&isPath(_map[_queue[i].i+1][_queue[i].j+1])&&(isPath(_map[_queue[i].i][_queue[i].j+1])||isPath(_map[_queue[i].i+1][_queue[i].j]))){
						coordinate = {i: _queue[i].i + 1, j: _queue[i].j+1, counter:counter+.4};
						if (coordinate.i==_startX&&coordinate.j == _startY) 
							return;
						if (canBeAddedToQueue(coordinate)) 
							_queue.push(coordinate);
					}
					//check left bottom
					if(_queue[i].i != 0 &&_queue[i].j != _map[_queue[i].i].length - 1 &&isPath(_map[_queue[i].i-1][_queue[i].j+1])&&(isPath(_map[_queue[i].i][_queue[i].j+1])||isPath(_map[_queue[i].i-1][_queue[i].j]))){
						coordinate = {i: _queue[i].i - 1, j: _queue[i].j+1, counter:counter+.4};
						if (coordinate.i==_startX&&coordinate.j == _startY) 
							return;
						if (canBeAddedToQueue(coordinate)) 
							_queue.push(coordinate);
					}
				}
			}
			//checkQueue(lastQueueLength, counter + 1,enemyType);
			try{
				checkQueue(lastQueueLength, counter + 1,enemyType);
			}catch(e:Error){
				return
				//trace(_enemyDebug,_enemyDebug._id,"can't find his way")
				//_enemyDebug.x--//myDistinationX=_enemyDebug.myDistinationY=5;
				//HunterManager.enemyAI(_enemyDebug as VampireHunter,false);	
			}
		}
		private static function canBeAddedToQueue(coordinate:Object):Boolean
		{
			var i:int=_queue.length - 1
			for (; i >= 0 ; i--)
			{
				if (coordinate.i == _queue[i].i && coordinate.j == _queue[i].j)
				{
					if (coordinate.counter >= _queue[i].counter)
					{
						return false;
					}
					else
					{
						_queue.splice(i, 1);
						return true;
					}
				}
			}
			return true;
		}
		private static function isPath($pathPoint:uint):Boolean{
			if($pathPoint==0||$pathPoint==7||$pathPoint==8){
				return true;
			}else{
				return false;
			}
		}		
	}
}