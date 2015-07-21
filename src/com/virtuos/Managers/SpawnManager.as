// ActionScript file
package com.virtuos.Managers{
	import com.virtuos.Characters.Farmer;
	import com.virtuos.Characters.VampireHunter;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;

	public class SpawnManager{
		//spawn time		
		private static var _spawnTimer:Timer
		
		//舞台上现存的玩家数量
		public static var count_Enemy:uint = 0;
		public static var kill_Enemy:uint = 0;
		//存活的enemy
		public static var live_Enemy:Vector.<Farmer>=new Vector.<Farmer>();
		public static var die_Enemy:Vector.<Farmer>=new Vector.<Farmer>();
		//private static var dieCounter:uint=0;
		private static var liveLen:uint

		private static var nearLen:uint=5000;
		private static var nearFam:Vector.<Farmer>=new Vector.<Farmer>();
		
		public static function setSpawnEnemy():void{
			
			if(_spawnTimer){
				_spawnTimer.removeEventListener("timer",spawnHandler)
				_spawnTimer.stop();
				_spawnTimer=null;
			}
			/*if(_seekTimer){
				_seekTimer.removeEventListener("timer",spawnHandler)
				_seekTimer.stop();
				_seekTimer=null;
			}*/
			_spawnTimer = new Timer(DataManager._birthSpace);			
			_spawnTimer.addEventListener("timer",spawnHandler)
			_spawnTimer.start();
			/*if(DataManager._veriation==3||DataManager._veriation==31){
				_seekTimer = new Timer(DataManager._enemySeekingTime);			
				_seekTimer.addEventListener("timer",seekHandler)
				_seekTimer.start();
			}*/
		}
		public static function stopSpawnEnemy():void{
			if(_spawnTimer){
				_spawnTimer.removeEventListener("timer",spawnHandler)
				_spawnTimer.stop();
			}
		}
		/**
		 * 等级加强
		 * */
		public static function levelUp():void{
			if(DataManager.currentLevel<DataManager._wholeLevel){
				DataManager.currentLevel++
			}			
			setSpawnEnemy();
		}
		//only vampire AI
		public static function setHunterAI(_hun:VampireHunter):void{
			HunterManager.enemyAI(_hun);
			//_hun.startSeek();
		}		
		//remove liveenemy to die
		public static function removeFromLive(_farmID:uint):void{
			
			liveLen=live_Enemy.length;
			//trace(live_Enemy.length)
			for( var i:uint=0;i<liveLen;i++){
				//trace(live_Enemy[i]._id, _farmID)
				if(live_Enemy[i]._id== _farmID){
					live_Enemy.splice(i,1) 
					break;
				}
			}
			//trace(live_Enemy.length)
		}
		//出enemy
		private static function spawnHandler(e:TimerEvent):void
		{	
			if(count_Enemy-die_Enemy.length<DataManager.MAX_FARM)
			{
				if(count_Enemy<DataManager._max_Enemy){
//					trace("shengcheng:",count_Enemy)
					live_Enemy.push(main3D.enemyVect[count_Enemy]);
					if(DataManager._veriation==3||DataManager._veriation==31){
						main3D.enemyVect[count_Enemy].startSeek();
					}
					FarmerManager.enemyAI(main3D.enemyVect[count_Enemy++]);		
					
					
				}else{
					//从die数组里面复活					
					var startPoint:uint=0;
					if(DataManager._max_Enemy>die_Enemy.length-1&&die_Enemy.length>0){
						//die_Enemy[0].visible=true;
						main3D._levelMap.addChild(die_Enemy[0]);
						startPoint=die_Enemy[0]._id%DataManager._startPointArray.length;
						die_Enemy[0].tempTorch.visible=true;
						FarmerManager.enemyAI(die_Enemy[0])
						if(DataManager._veriation==3||DataManager._veriation==31){
							die_Enemy[0].startSeek();
						}
						die_Enemy[0].setPosition(DataManager._startPointArray[startPoint].i*50,DataManager._startPointArray[startPoint].j*50);
						live_Enemy.push(die_Enemy[0]);
						die_Enemy.shift();
					}else{
						//dieCounter=0;
						//FarmerMananger.enemyAI(die_Enemy[0])
					}
				}
			}
			else
			{				
				_spawnTimer.removeEventListener("timer",spawnHandler)
				_spawnTimer.stop();				
			}
		}
	}
}