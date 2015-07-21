package com.virtuos.Managers
{
	import MyDispatcher.DispatchMananger;
	
	import MyEvent.EnemyEvents;
	import MyEvent.MyEvents;
	
	import com.virtuos.Characters.Farmer;
	import com.virtuos.BaseAI.PathFinder;
	import com.virtuos.animation.AutoMovieClip3D;
	import com.virtuos.display.MovieClip;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import starling.events.Event;
	
	/****
	 * 
	 * Farmer Ai
	 * 
	 * */
	public class FarmerManager
	{	
	
		//feed time
		private static var _myTimer:Timer=new Timer(1000);
		private static var _time:uint=0;	
		//被feed发出警告的x,y
		public static var _alertX:int=0-DataManager._alertRadius;
		public static var _alertY:int=0-DataManager._alertRadius;
		
			
		
		public static function enemyAI(_farm:Farmer,_remove:Boolean=false):void{
			if(_remove){
				//_farm._farmerStatus.gotoAndStop(1);
				_farm._altered=false;
				
				_farm.removeEventListener(Event.ENTER_FRAME,_onMove);			
				_farm.removeEventListener("refind",_onRefind);			
				_farm.removeEventListener("wait",_onWait);
				_farm.removeEventListener(Event.ENTER_FRAME,_onHit)
				return
			}	
			var _myX:uint=(_farm.y+25)/50;
			var _myY:uint=(_farm.x+25)/50;
			
			//alert ratio;
//			 var _alert_Distance:Number;
//			 var _alert_DistanceX:Number;
//			 var _alert_DistanceY:Number;
//			 var _alert_RatioX:Number;
//			 var _alert_RatioY:Number;
			//seek ratio;
			/* var _seek_Distance:Number;
			 var _seek_DistanceX:Number;
			 var _seek_DistanceY:Number;
			 var _seek_RatioX:Number;
			 var _seek_RatioY:Number;*/
			//alert ratio;
			var _to:String='R';
//			_alert_Distance:Number;
//			_alert_DistanceX:Number;
//			_alert_DistanceY:Number;
//			_alert_RatioX:Number;
//			_alert_RatioY:Number;
			//var _to_H:String="R";
			//var _to_V:String="U"
			_farm.visible=true;
			if(_farm._altered){
				//直接走向玩家
				_farm._alert_DistanceX=_myY-_farm.myDistinationY;
				_farm._alert_DistanceY=_myX-_farm.myDistinationX;
				_farm._alert_Distance=Math.sqrt(_farm._alert_DistanceX*_farm._alert_DistanceX+_farm._alert_DistanceY*_farm._alert_DistanceY);				
				_farm._alert_RatioX=_farm._alert_DistanceX/_farm._alert_Distance;
				_farm._alert_RatioY=_farm._alert_DistanceY/_farm._alert_Distance;	
				if(_farm._alert_RatioY>0){
					_farm._to_V="U";
				}else{
					_farm._to_V="D";
				}
				if(_farm._alert_RatioX>0){
					_farm._to_H="L";
					_farm._farmerStatus.scaleX=1;
				}else{
					_farm._to_H="R";
					_farm._farmerStatus.scaleX=-1;
				}
			}else if(_farm._seekedPlayer){
				_farm._seek_DistanceX=_myY-_farm.myDistinationY;
				_farm._seek_DistanceY=_myX-_farm.myDistinationX;
				_farm._seek_Distance=int(Math.sqrt(_farm._seek_DistanceX*_farm._seek_DistanceX+_farm._seek_DistanceY*_farm._seek_DistanceY));				
				_farm._seek_RatioX=_farm._seek_DistanceX/_farm._seek_Distance;
				_farm._seek_RatioY=_farm._seek_DistanceY/_farm._seek_Distance;	
//				trace(_myY,_myX,_farm._seek_DistanceY,_farm._seek_DistanceX,_farm.myDistinationY,_farm.myDistinationX);
				if(_farm._seek_RatioY>0){
					_farm._to_V="U";
				}else{
					_farm._to_V="D";
				}
				if(_farm._seek_RatioX>0){
					_farm._to_H="L";
					_farm._farmerStatus.scaleX=1;
				}else{
					_farm._to_H="R";
					_farm._farmerStatus.scaleX=-1;
				}
			}else{				
				//trace(_farm.myStartX,_farm.myStartY,(_farm.x+25)/50,(_farm.y+25)/50)
				try{
					_farm.myPath=PathFinder.findPath(DataManager._mapArray,_myX,_myY,_farm.myDistinationX,_farm.myDistinationY,_farm)
				}
				catch(e:Error){
					trace("_farm:",_farm._id)
					
				}
			}	
			_farm._farmerStatus.removeEventListener(Event.ENTER_FRAME,_onHit)
			if(!_farm.hasEventListener(Event.ENTER_FRAME)){				
				_farm.addEventListener(Event.ENTER_FRAME,_onMove);				
			}
			if(!_farm.hasEventListener("refind")){
				_farm.addEventListener("refind",_onRefind);
			}
			if(!_farm.hasEventListener("wait")){
				_farm.addEventListener("wait",_onWait);
			}		
			/***
			 * AI
			 * */
				function _onMove(e:Event):void
				{				
					if(_farm._altered){
						//如果敌人被警报了						
						if(OBJCollision.enemyCollisions(_farm.x,_farm.y,_farm._to_V,_farm,true))
						{
							/***					  
							 * 如果碰撞，则重新选择方向					 
							 * */
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._altered=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}
						else if(OBJCollision.enemyCollisions(_farm.x,_farm.y,_farm._to_H,_farm,true)){
							/***					  
							 * 如果碰撞，则重新选择方向					 
							 * */
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._altered=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}	
						else if(Math.abs(_farm.x-_farm.myDistinationY*50)<10&&Math.abs(_farm.y-_farm.myDistinationX*50)<10){
							//到达目的地；
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._seekedPlayer=false;
							_farm._altered=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}
					}else if(_farm._seekedPlayer){
						//如果敌人了	
						//trace(_farm.x,_farm.myDistinationY)						
							//
						if(OBJCollision.enemyCollisions(_farm.x,_farm.y,_farm._to_V,_farm,true))
						{
							/***					  
							 * 如果碰撞，则重新选择方向					 
							 * */
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._seekedPlayer=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}
						if(OBJCollision.enemyCollisions(_farm.x,_farm.y,_farm._to_H,_farm,true)){
							/***					  
							 * 如果碰撞，则重新选择方向					 
							 * */
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._seekedPlayer=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}	
						/*else if(Math.abs(_farm.x-_farm.myDistinationY*50)<10&&Math.abs(_farm.y-_farm.myDistinationX*50)<10){
							//到达目的地；
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._seekedPlayer=false;
							_farm._altered=false;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}*/
						//alert first
						if(Math.sqrt((_alertX-(_farm.x+25)/50)*(_alertX-(_farm.x+25)/50)+(_alertY-(_farm.y+25)/50)*(_alertY-(_farm.y+25)/50))<DataManager._alertRadius&&!_farm._altered){
							//trace("Alert!!!!!",_farm._id,Math.sqrt((_alertX-(_farm.y+25)/50)*(_alertX-(_farm.y+25)/50)+(_alertY-(_farm.x+25)/50)*(_alertY-(_farm.x+25)/50)))
							//重置enemy的位置到整数位
							//						_farm.x=_farm.myPath[0].j*50-25;
							//						_farm.y=_farm.myPath[0].i*50-25;
							//trace("farmer 被alert了：",_alertX,_alertY,_farm.myPath[0].j,_farm.myPath[0].i)
							if(!_farm._isFeed)
							{
								_farm._altered=true;
								_farm._seekedPlayer=false;
								//播放感叹号动画
								_farm._farmerStatus.gotoAndStop(4);
								_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
								_farm.myDistinationX=_alertY;
								_farm.myDistinationY=_alertX;
								
								var _countTimer1:int = GlobalValue.timer.addCallBack(
									function():void
									{
										GlobalValue.timer.removeCallBack(_countTimer1);
										_farm._farmerStatus.gotoAndStop(1);
										enemyAI(_farm);
									}, 800, true, false);
							}
							return;
						}
						//
					}else{	
						if(OBJCollision.enemyCollisions(_farm.x,_farm.y,_to,_farm))
						{
							/***
							 * 如果碰撞，则重新选择方向
							 * */
							_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
							_farm._altered=false;
							_farm.touchAI=true;
							_farm.dispatchEvent(new Event('wait'));
							return;
						}
						
						//判断是否为被alert的enemy；
	//					trace(_farm._id,_alertX,(_alertX-(_farm.x+25)/50)*(_alertX-(_farm.x+25)/50)+(_alertY-(_farm.y+25)/50)*(_alertY-(_farm.y+25)/50))
						if(Math.sqrt((_alertX-(_farm.x+25)/50)*(_alertX-(_farm.x+25)/50)+(_alertY-(_farm.y+25)/50)*(_alertY-(_farm.y+25)/50))<DataManager._alertRadius&&!_farm._altered){
							//trace("Alert!!!!!",_farm._id,Math.sqrt((_alertX-(_farm.y+25)/50)*(_alertX-(_farm.y+25)/50)+(_alertY-(_farm.x+25)/50)*(_alertY-(_farm.x+25)/50)))
							//重置enemy的位置到整数位
	//						_farm.x=_farm.myPath[0].j*50-25;
	//						_farm.y=_farm.myPath[0].i*50-25;
							//trace("farmer 被alert了：",_alertX,_alertY,_farm.myPath[0].j,_farm.myPath[0].i)
							if(!_farm._isFeed)
							{
								_farm._altered=true;
							//播放感叹号动画
								_farm._farmerStatus.gotoAndStop(4);
								_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
								_farm.myDistinationX=_alertY;
								_farm.myDistinationY=_alertX;
								
								_countTimer1 = GlobalValue.timer.addCallBack(
									function():void
									{
										GlobalValue.timer.removeCallBack(_countTimer1);
										_farm._farmerStatus.gotoAndStop(1);
										enemyAI(_farm);
									}, 800, true, false);
							}
							return;
						}
					}
					if(OBJCollision.hitPlayer(_farm)=='kill'){
						//_enemyReaction("kill",_farm);
						SpawnManager.removeFromLive(_farm._id);
						_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
						_farm.removeEventListener("refind",_onRefind);
						_farm.removeEventListener("wait",_onWait);
						farmerDeathAnimation();
						_farm._removeTorch();
						_farm.stopSeek();
//						trace(main3D.test);
						//_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
						//_farm.dispatchEvent(new EnemyEvents(EnemyEvents.ENEMY_DIE,'kill'));
					}else if(OBJCollision.hitPlayer(_farm)=='die'){
						//_enemyReaction("die",_farm);
						
						DispatchMananger._em3D.dispatchEvent(new MyEvents('die',_farm))
						
					}else if(OBJCollision.hitPlayer(_farm)=='feed'){
						SpawnManager.removeFromLive(_farm._id);
						//trace(_farm.myPath[0].j,_farm.myPath[0].i);
						_alertX=_farm.myPath[0].j;
						_alertY=_farm.myPath[0].i;
						trace("事发地点为:",_alertX,_alertY);
						DataManager._playerFeeding=true;
						_farm._removeTorch();
						_farm.stopSeek();
						_farm._isFeed=true;
						_myTimer.addEventListener("timer",_timerHandler);
						_myTimer.start();
						_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
						_farm.removeEventListener("refind",_onRefind);
						_farm.removeEventListener("wait",_onWait);
						
					}
					if(!_farm._altered&&!_farm._seekedPlayer){
						//非alert状态下的行走方式
						_farm._to_H=_farm._to_V=""
						if(_farm.myPath.length>0){
							if(_farm.myPath[0].j*50-25>_farm.x){
								_farm._to_H=_to="R";
							}else if(_farm.myPath[0].j*50-25<_farm.x){
								
								_farm._to_H=_to="L"
							}else  if(_farm.myPath[0].i*50-25>_farm.y){
								
								_farm._to_V=_to="D"
							}else  if(_farm.myPath[0].i*50-25<_farm.y){
								
								_farm._to_V=_to="U"
							}
							if(_to=='R'){
								_farm._farmerStatus.scaleX=-1;
								if(_farm.x+DataManager._enemySpeed>_farm.myPath[0].j*50-25){
									_farm.x=_farm.myPath[0].j*50-25;
									if(_farm.myPath.length>1){
										_farm.myPath.shift();
									}
								}else{
									_farm.x+=DataManager._enemySpeed;
								}
							}else if(_to=='L'){
								_farm._farmerStatus.scaleX=1;
								if(_farm.x-DataManager._enemySpeed<_farm.myPath[0].j*50-25){
									_farm.x=_farm.myPath[0].j*50-25;
									if(_farm.myPath.length>1){
										_farm.myPath.shift();
									}
								}else{
									_farm.x-=DataManager._enemySpeed;
								}
							}else if(_to=='U'){
								if(_farm.y-DataManager._enemySpeed<_farm.myPath[0].i*50-25){
									_farm.y=_farm.myPath[0].i*50-25;
									if(_farm.myPath.length>1){
										_farm.myPath.shift();
									}
								}else{
									_farm.y-=DataManager._enemySpeed;
								}
							}else if(_to=='D'){
								if(_farm.y+DataManager._enemySpeed>_farm.myPath[0].i*50-25){
									_farm.y=_farm.myPath[0].i*50-25;
									if(_farm.myPath.length>1){
										_farm.myPath.shift();
									}
								}else{
									_farm.y+=DataManager._enemySpeed;
								}
							}
						}
						if(_farm.myPath.length==1){
							_farm._altered=false;
							_farm.dispatchEvent(new Event('refind'));						
						}
					}else if(_farm._altered){
						//alert状态下的行走方式
						_farm.x-=DataManager._enemySpeed*_farm._alert_RatioX;
						_farm.y-=DataManager._enemySpeed*_farm._alert_RatioY;
					}else if(_farm._seekedPlayer){
						_farm.x-=DataManager._enemySpeed*_farm._seek_RatioX;
						_farm.y-=DataManager._enemySpeed*_farm._seek_RatioY;
					}
					DataManager._enemyArray[_farm._id]=new Point(_farm.x,_farm.y);	
					//trace(DataMananger._enemyArray[0])
				}
				
				//敌人碰敌人后谦让的
				function _onWait(e:Event):void{
					_farm.removeEventListener('wait',_onWait)
					_farm._farmerStatus.gotoAndStop(2);
					if(!_farm._farmerStatus.hasEventListener(Event.ENTER_FRAME)){
						_farm._farmerStatus.addEventListener(Event.ENTER_FRAME,_onHit)
					}
					/*if(_farm.myPath.length>0){
						_farm.x=_farm.myPath[0].j*50;
						_farm.y=_farm.myPath[0].i*50;
					}*/
					var _countTimer:int = GlobalValue.timer.addCallBack(
						function():void
						{
							
							GlobalValue.timer.removeCallBack(_countTimer);
							_farm._farmerStatus.gotoAndStop(1);
							if(_farm.touchAI){
								_GetNewWayPoint();
								_farm.touchAI=false;
							}else{
								if(_farm._waypointI==DataManager._wayPointArray.length-1){
									_farm._waypointI=0;
								}else{
									_farm._waypointI++
								}
								_farm.myDistinationX=DataManager._wayPointArray[_farm._waypointI].j;
								_farm.myDistinationY=DataManager._wayPointArray[_farm._waypointI].i;
							}							
							enemyAI(_farm)
							DataManager._mapArray[_farm._hitEnemyY][_farm._hitEnemyX]=DataManager._mapArrayCopy[_farm._hitEnemyY][_farm._hitEnemyX];
						}, 1000, true, false);
				}
				//wait 
				function _onHit(e:Event):void{
					if(OBJCollision.hitPlayer(_farm)=='kill'){
						_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
						_farm._farmerStatus.removeEventListener(Event.ENTER_FRAME,_onHit)
						_farm.removeEventListener("refind",_onRefind);
						_farm.removeEventListener("wait",_onWait);
						SpawnManager.removeFromLive(_farm._id);
						farmerDeathAnimation();
						//DispatchMananger._em3D.dispatchEvent(new EnemyEvents('removeenemy',_farm))
						//GlobalValue.timer.removeCallBack(1000);
					}else if(OBJCollision.hitPlayer(_farm)=='feed'){
						_alertX=_farm.myPath[0].j;
						_alertY=_farm.myPath[0].i;
						trace("事发地点为:",_alertX,_alertY);
						DataManager._playerFeeding=true;
						_farm._removeTorch();
						_farm._isFeed=true;
						_myTimer.addEventListener("timer",_timerHandler);
						_myTimer.start();
						_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
						_farm._farmerStatus.removeEventListener(Event.ENTER_FRAME,_onHit)
						SpawnManager.removeFromLive(_farm._id);
						_farm.removeEventListener("refind",_onRefind);
						_farm.removeEventListener("wait",_onWait);
						//GlobalValue.timer.removeCallBack(1000);
					}
				}
				function _GetNewWayPoint():void{
					var i:uint=0;
					if(_farm._to_H=="R"){
						/*for(i=0;i<DataMananger._wayPointArray.length;i++){
							if(DataMananger._wayPointArray[i].j*50-25<_farm.x){
								_farm._waypointI=i
								_farm.myDistinationX=DataMananger._wayPointArray[_farm._waypointI].j;
								_farm.myDistinationY=DataMananger._wayPointArray[_farm._waypointI].i;
								
								return
							}
						}*/
//						_farm._waypointI=0
//						_farm.myDistinationX=DataMananger._wayPointArray[0].j;
//						_farm.myDistinationY=DataMananger._wayPointArray[0].i;
						if(_farm._waypointI==0){
							_farm._waypointI=DataManager._wayPointArray.length-1;
						}else{
							_farm._waypointI--
						}				
					}
					if(_farm._to_H=="L"){
					/*	for(i=0;i<DataMananger._wayPointArray.length;i++){
							if(DataMananger._wayPointArray[i].j*50-25>_farm.x){
								_farm._waypointI=i
								_farm.myDistinationX=DataMananger._wayPointArray[_farm._waypointI].j;
								_farm.myDistinationY=DataMananger._wayPointArray[_farm._waypointI].i;
								return
							}
						}*/
						if(_farm._waypointI==DataManager._wayPointArray.length-1){
							_farm._waypointI=0;
						}else{
							_farm._waypointI++
						}
						
					}
					if(_farm._to_V=="U"){
						/*for(i=0;i<DataMananger._wayPointArray.length;i++){
							if(DataMananger._wayPointArray[i].i*50-25>_farm.y){
								_farm._waypointI=i
								_farm.myDistinationX=DataMananger._wayPointArray[_farm._waypointI].j;
								_farm.myDistinationY=DataMananger._wayPointArray[_farm._waypointI].i;
								return
							}
						}*/
					//	_farm.alpha=.5
						if(_farm._waypointI==DataManager._wayPointArray.length-1){
							_farm._waypointI=0;
						}else{
							_farm._waypointI++
						}				
					}
					if(_farm._to_V=="D"){
						/*for(i=0;i<DataMananger._wayPointArray.length;i++){
							if(DataMananger._wayPointArray[i].i*50-25<_farm.y){
								_farm._waypointI=i
								_farm.myDistinationX=DataMananger._wayPointArray[_farm._waypointI].j;
								_farm.myDistinationY=DataMananger._wayPointArray[_farm._waypointI].i;
								return
							}
						}*/
						if(_farm._waypointI==0){
							_farm._waypointI=DataManager._wayPointArray.length-1;
						}else{
							_farm._waypointI--
						}
						
					}
					_farm.myDistinationX=DataManager._wayPointArray[_farm._waypointI].j;
					_farm.myDistinationY=DataManager._wayPointArray[_farm._waypointI].i;
					
					/*if(_farm._waypointI==DataMananger._wayPointArray.length-1){
							_farm._waypointI=0;
					}else{
							_farm._waypointI++
					}
					_farm.myDistinationX=DataMananger._wayPointArray[_farm._waypointI].j;
					_farm.myDistinationY=DataMananger._wayPointArray[_farm._waypointI].i;*/
					
				}
				function _onRefind(e:Event):void{
					/*if(_farm.myPath.length>0){
						_farm.x=_farm.myPath[0].j*50;
						_farm.y=_farm.myPath[0].i*50;
					}*/
					_farm.removeEventListener('refind',_onRefind)
					var _countTimer1:int = GlobalValue.timer.addCallBack(
						function():void
						{
							GlobalValue.timer.removeCallBack(_countTimer1);
							_farm._farmerStatus.gotoAndStop(2);
							
						}, 800, true, false);
					
					var _countTimer:int = GlobalValue.timer.addCallBack(
						function():void
						{
							GlobalValue.timer.removeCallBack(_countTimer);
							_farm._farmerStatus.gotoAndStop(1);
							if(_farm._waypointI==DataManager._wayPointArray.length-1){
								_farm._waypointI=0;
							}else{
								_farm._waypointI++
							}
							_farm.myDistinationX=DataManager._wayPointArray[_farm._waypointI].j;
							_farm.myDistinationY=DataManager._wayPointArray[_farm._waypointI].i;
							enemyAI(_farm)
						}, 3300, true, false);
				}
				function _timerHandler(e:TimerEvent):void{
					_time++;
					if(_time==2){
						DataManager._playerFeeding=false;
						main3D._player._playStatus.gotoAndStop(1);
						if(!DataManager._playerDeath)
						{
							farmerDeathAnimation();
							//将警告点移除
							_alertX=0-DataManager._alertRadius
							_alertY=0-DataManager._alertRadius
						}
						
						_time=0;
						_myTimer.removeEventListener("timer",_timerHandler);
						_myTimer.stop();
					}
				}
				//every N secs nearest farmer seeking
				function findPlayer():void{
					var sX:uint=(uint(_farm.x))
					var sY:uint=(uint(_farm.y))
					//trace(sX,sY)
					_farm.x=sX;
					_farm.y=sY;
					var newPX:int=(int(DataManager._playerPoint.x)-int(DataManager._playerPoint.x)%50)/50
					var newPY:int=(int(DataManager._playerPoint.y)-int(DataManager._playerPoint.y)%50)/50
					
					//	trace(newPY,newPX)
					_farm.myDistinationX=newPY//DataManager._wayPointArray[0].j;
					_farm.myDistinationY=newPX//DataManager._wayPointArray[0].i;
					_farm.removeEventListener(Event.ENTER_FRAME, _onMove);
					enemyAI(_farm)
				}	
				function farmerDeathAnimation():void
				{
					var _amc:AutoMovieClip3D = new AutoMovieClip3D("ui.farmer.animation.FarmerDie", animationComplete);
					
					if(_farm._farmerStatus.scaleX == 1){
						_amc.x += 40;
						_amc.scaleX = 1;
					}else{
						_amc.scaleX = -1;
					}
					_farm.addChild(_amc);
					_farm._farmerStatus.visible = false;
					_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
				}
				function animationComplete():void
				{
					_farm._farmerStatus.visible = true;
					_farm._farmerStatus.gotoAndStop(1);
					SpawnManager.removeFromLive(_farm._id);
					DispatchMananger._em3D.dispatchEvent(new EnemyEvents('removeenemy',_farm))
					_farm.removeEventListener(Event.ENTER_FRAME,_onMove);
				}

		}
	}
}