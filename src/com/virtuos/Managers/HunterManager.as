package com.virtuos.Managers
{
	
	import MyDispatcher.DispatchMananger;
	
	import MyEvent.EnemyEvents;
	import MyEvent.MyEvents;
	
	import com.virtuos.BaseAI.HunterPathFinder;
	import com.virtuos.BaseAI.PathFinder;
	import com.virtuos.Characters.VampireHunter;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import starling.events.Event;

	/***
	 *vampireHunter AI
	 ***/
	public class HunterManager
	{
		//private static var _myTimer:Timer=new Timer(1000);
		private static var _speed:Number=2;	
		private static var _to:String;	
		//private static var _chaseTimer:Timer=new Timer(4000);
		private static var _chaseTime:uint=20;
		private static var _duration:uint
		private static var _count:uint = 0;
		//new AI
		private static var _map:HunterPathFinder//=new HunterPathFinder(41,32);;
		public static function enemyAI(_vam:VampireHunter,_remove:Boolean=false):void
		{	if(_map==null){
				_map=new HunterPathFinder(41,32);;
			}
			if(_remove){
				if(_vam.hasEventListener(Event.ENTER_FRAME)){
					_vam.removeEventListener(Event.ENTER_FRAME,_onMove);
					_map.reset();
					_map.clearMap();
				}			
				return
			}
			
			var _myX:uint=(_vam.x+25)/50;
			var _myY:uint=(_vam.y+25)/50;
			_chaseTime=0;
			//trace(_vam.myDistinationX,_vam.myDistinationY)
			
			if(!_vam.hasEventListener(Event.ENTER_FRAME)){
				_vam.addEventListener(Event.ENTER_FRAME, _onMove);
			}	
				/*for(var i:uint=0;i<32;i++){					
					for(var j:uint=0;j<41;j++){
						if(DataManager._mapArray[i][j]!=7&&DataManager._mapArray[i][j]!=8&&DataManager._mapArray[i][j]!=0){
							_map.setCell(j, i, _map.CELL_FILLED);
							//trace(_map.mapArray[j][i].x,_map.mapArray[j][i].y,_map.mapArray[j][i].cellType)
						}						
					}
				}*/
				//test
				/*var tempStr:String
				for(i=0;i<32;i++){	
					tempStr=""
					for(j=0;j<41;j++){
						//if(DataManager._mapArray[i][j]!=7&&DataManager._mapArray[i][j]!=8&&DataManager._mapArray[i][j]!=0){
							//_map.setCell(j, i, _map.CELL_FILLED);
							tempStr+=_map.mapArray[j][i].cellType
							//trace(_map.mapArray[j][i].x,_map.mapArray[j][i].y,_map.mapArray[j][i].cellType)
						//}
						//DataManager._mapArray[i].push(_mapData[i*41+j]);
						//DataManager._mapArrayCopy[i].push(_mapData[i*41+j]);
					}
					trace(tempStr)
				}*/
				
				_map.setEndPoints(_myX,_myY,_vam.myDistinationX,_vam.myDistinationY);
				//_map.setEndPoints(_myY,_myX,5,10);
				_vam.myPath=_map.solve();
				//trace(_vam.myPath)
				//_vam.myPath=PathFinder.findPath(DataManager._mapArray,_myX,_myY,_vam.myDistinationX,_vam.myDistinationY,_vam)
			
			//_chaseTimer.addEventListener("timer",_timerHandler);
			//_chaseTimer.start();
			if(DataManager._veriation==1 || DataManager._veriation==4||DataManager._veriation==3){
				if(DataManager._hunterSpeed<10){
					_duration=23+DataManager._hunterSpeed
				}else{
					_duration=25
				}
			}else{
				if(DataManager._hunterSpeed<10){
					_duration=12+DataManager._hunterSpeed
				}else{
					_duration=15
				}
			}
			function _onMove(e:Event):void{
				_chaseTime++;
				if(_chaseTime>=_duration){
					if(Math.abs(_vam.x-_vam.myPath[0].x*50)>=DataManager._hunterSpeed||Math.abs(_vam.y-_vam.myPath[0].y*50)>=DataManager._hunterSpeed){
						_chaseTime--						
					}else{
						_chaseTime=0;
						//trace('distance:',_vam.x-_vam.myPath[0].j*50,_vam.y-_vam.myPath[0].i*50)
						if(_vam.myPath.length>0&&(DataManager._veriation==1 || DataManager._veriation==4|| DataManager._veriation==3)){
							_vam.x=_vam.myPath[0].x*50;
							_vam.y=_vam.myPath[0].y*50;
						}
						findPlayer();
					return;
					}
				}
				/*if(OBJCollision.killPlay(_vam)=='kill'&&DataManager._veriation!=3)
				{
					_vam.removeEventListener(Event.ENTER_FRAME,_onMove);
					_vam.removeEventListener("refind",_onRefind);
					//DispatchMananger._em3D.dispatchEvent(new EnemyEvents('removeenemy',_vam))
				}*/
				if(OBJCollision.killPlay(_vam)=='die')
				{
					DispatchMananger._em3D.dispatchEvent(new MyEvents('die',_vam))
				}	
				/*else if(OBJCollision.killPlay(_vam)=='feed'&&DataManager._veriation!=3)
				{
					DataManager._playerFeeding=true;
					_vam._removeTorch();
					_vam._isFeed=true;
					//_myTimer.addEventListener("timer",_timerHandler);
					_myTimer.start();
					_vam.removeEventListener(Event.ENTER_FRAME,_onMove);
					_vam.removeEventListener("refind",_onRefind);
				}	*/			
					if(_vam.myPath.length>0){
						if(_vam.myPath[0].x*50>_vam.x){
							_vam._to_H="R";
						}else if(_vam.myPath[0].x*50<_vam.x){						
							_vam._to_H="L"
						}else{
							_vam._to_H=""
						}
						if(_vam.myPath[0].y*50>_vam.y){						
							_vam._to_V="D"
						}else if(_vam.myPath[0].y*50<_vam.y){						
							_vam._to_V="U"
						}else{
							_vam._to_V=""
						}
						//_speed=DataManager._hunterSpeed;
						if(_vam._to_H==""){
							_to=_vam._to_V
							_speed=DataManager._hunterSpeed;
						}
						if(_vam._to_V==""){
							_to=_vam._to_H
							_speed=DataManager._hunterSpeed;
						}
						if(DataManager._veriation==1 || DataManager._veriation==4|| DataManager._veriation==3){
							if(_vam._to_V!=""&&_vam._to_H!=""){
								_to=_vam._to_V+_vam._to_H
								_speed=DataManager._hunterSpeed*Math.sqrt(2);
							}
						}
						//trace(_vam._to_H,_vam._to_V,_to)
						//========================================================
						if(_to=="U"){
							if(_vam.y-_speed<_vam.myPath[0].y*50){
								//trace("up")
								_vam.y=_vam.myPath[0].y*50//+_speed/2;
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.y-=_speed;
								
							}
						}else if(_to=='D'){
							if(_vam.y+_speed>_vam.myPath[0].y*50){
								//trace("down")
								_vam.y=_vam.myPath[0].y*50//-_speed/2;;
								if(_vam.myPath.length>1){							
									_vam.myPath.shift();
								}
							}else{
								_vam.y+=_speed;
								
							}
						}
						//=============================================================
						if(_to=='R'){
							if(_vam.x+_speed>_vam.myPath[0].x*50){
								//trace("right")
								_vam.x=_vam.myPath[0].x*50//-_speed/2;
								if(_vam.myPath.length>1){							
									_vam.myPath.shift();
								}
							}else{
								_vam.x+=_speed;
								
							}
						}else if(_to=='L'){
							if(_vam.x-_speed<_vam.myPath[0].x*50){
								//trace("left")
								_vam.x=_vam.myPath[0].x*50//+_speed/2;
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.x-=_speed;
								
							}
						}						
						//==============================================================
						if(_to=='UL'){
							if(_vam.x-_speed<_vam.myPath[0].x*50){
								_vam.x=_vam.myPath[0].x*50;
								_vam.y=_vam.myPath[0].y*50;						
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.x-=_speed;
								_vam.y-=_speed;						
							}
						}else if(_to=='UR'){
							if(_vam.x+_speed>=_vam.myPath[0].x*50){
								_vam.x=_vam.myPath[0].x*50//-_speed/2;
								_vam.y=_vam.myPath[0].y*50//-_speed/2;						
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.x+=_speed;
								_vam.y-=_speed;
								
							}
						}else if(_to=='DR'){
							if(_vam.x+_speed>_vam.myPath[0].x*50){
								_vam.x=_vam.myPath[0].x*50;
								_vam.y=_vam.myPath[0].y*50;						
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.x+=_speed;
								_vam.y+=_speed;
							}
						}else if(_to=='DL'){
							if(_vam.x-_speed<_vam.myPath[0].x*50){
								_vam.x=_vam.myPath[0].x*50;
								_vam.y=_vam.myPath[0].y*50;						
								if(_vam.myPath.length>1){
									_vam.myPath.shift();
								}
							}else{
								_vam.x-=_speed;
								_vam.y+=_speed;
								
							}				
						}
						//trace(_to,_vam.myPath[0].x,_vam.myPath[0].y,_vam.myPath.length)
					}else{
						findPlayer();
					}					
					if(_vam.myPath.length==1){					
						_vam.dispatchEvent(new Event('refind'));						
					}
				
			}
			/*function _onRefind(e:Event):void{
				_vam.removeEventListener('refind',_onRefind)
				findPlayer();				
			}	*/		
			function findPlayer():void{
				var sX:uint=(uint(_vam.x))
				var sY:uint=(uint(_vam.y))
				//trace(sX,sY)
				_vam.x=sX;
				_vam.y=sY;
				var newPX:int=(int(DataManager._playerPoint.x)-int(DataManager._playerPoint.x)%50)/50
				var newPY:int=(int(DataManager._playerPoint.y)-int(DataManager._playerPoint.y)%50)/50
				/*if(inCollition(newPX,newPY)){
						
				}*/
			//	trace(newPY,newPX)
				_vam.myDistinationX=newPX//DataManager._wayPointArray[0].j;
				_vam.myDistinationY=newPY//DataManager._wayPointArray[0].i;
				_vam.removeEventListener(Event.ENTER_FRAME, _onMove);
				//trace("founddd")
				enemyAI(_vam)
			}
			/*
			function _timerHandler(e:TimerEvent):void{
				_count++;
				if(_count==2){
					DataManager._playerFeeding=false;
					main3D._player._playStatus.gotoAndStop(1);
					_count=0;
					_myTimer.removeEventListener("timer",_timerHandler);
					_myTimer.stop();
				}
			}*/
		}
		
	}
}