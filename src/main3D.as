package
{
	import Configuration.loadTXT;
	
	import MyDispatcher.DispatchMananger;
	
	import MyEvent.EnemyEvents;
	import MyEvent.MyEvents;
	
	import com.virtuos.BaseAI.HunterPathFinder;
	import com.virtuos.Characters.BaseEnemy;
	import com.virtuos.Characters.Farmer;
	import com.virtuos.Characters.Player;
	import com.virtuos.Characters.VampireHunter;
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.FarmerManager;
	import com.virtuos.Managers.HunterManager;
	import com.virtuos.Managers.SpawnManager;
	import com.virtuos.MyLevel;
	import com.virtuos.OBJ3D.Barrier;
	import com.virtuos.OBJ3D.PointUI;
	import com.virtuos.OBJ3D.ResetUI;
	import com.virtuos.animation.AutoMovieClip3D;
	import com.virtuos.display.MovieClip;
	import com.virtuos.loader.Loader3D;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.Timer;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;

	public class main3D extends Sprite
	{
		//加载地图
		public static var _loadMap:loadTXT;
		public static var _levelMap:MyLevel=new MyLevel();
		private static var _instance:main3D;;
		//获取寻路路径的数组
		public static var _test:Vector.<Object>;		
		//障碍物的实例
		private var _currentBarrier:Barrier;
		//enemy的实例
		private var _currentEnemy:Farmer;
		//hunter的实例
		private var _vampireHunter:VampireHunter;
		
		public static var enemyVect:Vector.<Farmer> = new Vector.<Farmer>();
		public static var test:Vector.<VampireHunter>=new Vector.<VampireHunter>();
		
		//玩家实例
		public static var _player:Player;
		
		private var _reset:ResetUI = new ResetUI();
		
		//==================================================
		private var _loader3D:Loader3D;
		//enemy max
		private var _MAX:uint;
		public function main3D()
		{
			_loader3D = new Loader3D();
			_loader3D.addEventListener(Event.COMPLETE, loadComplete);
			_loader3D.load();
			_instance = this;
		}
		
		public static function getInstance():main3D
		{
			if(!_instance)
				_instance=new main3D();
			return _instance;
		}
		
		
		private function loadComplete(event:flash.events.Event):void
		{
			_loader3D.removeEventListener(Event.COMPLETE, loadComplete);
			init();
		}
		
		private function init():void 
		{
			//trace(768%50);
			_loadMap=new loadTXT();			
			addChild(_levelMap);	
			//暂时写死
			_levelMap.x = 462;
			_levelMap.y = 334;
			
			DispatchMananger._em3D.addEventListener('configCharacter',addCharacter);
			DispatchMananger._em3D.addEventListener('configGame',_configBarrier);
			//侦听enemy移除情况
			DispatchMananger._em3D.addEventListener('removeenemy',_removeEnemy);
			//侦听player死亡情况
			DispatchMananger._em3D.addEventListener(MyEvents.DIE,_playerReact);
			//侦听player feed
			DispatchMananger._em3D.addEventListener(MyEvents.FEED,_playerReact);
		}
		
		//player 反应
		private function _playerReact(e:MyEvents):void{
			switch(e.type){
				case "die":
					removeAllListner();
					addPlayerAnimation();					
					_levelMap._removeAllListener();		
					SpawnManager.stopSpawnEnemy();
					for(var i:* in enemyVect)
					{
						trace(i,enemyVect[i]);
						enemyVect[i].stopSeek();
						FarmerManager.enemyAI(enemyVect[i],true);
					}
					
				break;
				case "feed":
					addEnemyAnimation(e._tempObj);
				break;
			
			}
		}
		
		//移除enemy
		private function _removeEnemy(e:EnemyEvents):void
		{
			//farmer
			if(e._tempObj as Farmer)
			{
				DataManager._enemyArray[(e._tempObj as Farmer)._id] = new Point(-200, -200);
				SpawnManager.die_Enemy.push(e._tempObj as Farmer);
				SpawnManager.kill_Enemy++;
				hideEnemy(e._tempObj as Farmer);
			}
			
			//hunter
			if(e._tempObj as VampireHunter)
			{
				var _countTimer:int = GlobalValue.timer.addCallBack(
					function():void
					{
						GlobalValue.timer.removeCallBack(_countTimer);
						_levelMap.removeChild(e._tempObj as VampireHunter,true);
					}, 1000, true, false);
				(e._tempObj as VampireHunter)._removeTorch();
			}
			_player._playStatus.gotoAndStop(1);
			
		}
		
		private function addCharacter(e:MyEvents):void{
			DispatchMananger._em3D.removeEventListener('configCharacter',addCharacter);
			_player=Player.getInstance();
			addChild(_player);			
			_reset = new ResetUI();
			_reset.visible = false;			
			_reset.addEventListener(TouchEvent.TOUCH,onResetTouch);
			addChild(_reset);
			
			initEnemyPool();
			initVampireHunter();
		}
		
		private function initEnemyPool():void
		{
			_MAX=DataManager._max_Enemy
			EnemyPool.initialize(_MAX);			
			var startPoint:uint=0;
			var i:uint=0;
			for(;i<_MAX;i++){
				_currentEnemy=EnemyPool.getSprite();
				_levelMap.addChild(_currentEnemy);
				startPoint=i%DataManager._startPointArray.length;
				_currentEnemy.setPosition(DataManager._startPointArray[startPoint].i*50,DataManager._startPointArray[startPoint].j*50)
				_currentEnemy._id=i;				
				_currentEnemy._farmerStatus.visible=true;
				enemyVect[_currentEnemy._id] =_currentEnemy;
				if(!DataManager._versionDebug){
					var randPoint:uint=Math.random()*(DataManager._wayPointArray.length-1);
					_currentEnemy.myDistinationX=DataManager._wayPointArray[randPoint].j;
					_currentEnemy.myDistinationY=DataManager._wayPointArray[randPoint].i;
					_currentEnemy._waypointI=randPoint;
				}else{
					_currentEnemy.myDistinationX=DataManager._wayPointArray[i].j;
					_currentEnemy.myDistinationY=DataManager._wayPointArray[i].i;
					_currentEnemy._waypointI=i;
				}
				_currentEnemy.visible=false;
				_currentEnemy._farmerStatus.gotoAndStop(1);
				DataManager._enemyArray.push(new Point(0,0));
				_currentEnemy=null;
			}			
			SpawnManager.setSpawnEnemy();
			
			/***
			 * 寻路测试
			 * */
//			EnemyPool.initialize(1);
//			_currentEnemy=EnemyPool.getSprite();
//			_levelMap.addChild(_currentEnemy);
//			trace(DataMananger._startPointArray[0].i,DataMananger._startPointArray[0].j)
//			_currentEnemy.setPosition(DataMananger._startPointArray[0].i*50,DataMananger._startPointArray[0].j*50);
//			_currentEnemy._id=0;
//			enemyVect[_currentEnemy._id] =_currentEnemy;
//			
//			_currentEnemy.myStartX=DataMananger._startPointArray[0].j;
//			//trace(DataMananger._startPointArray[0].j)
//			_currentEnemy.myStartY=DataMananger._startPointArray[0].i;
//			_currentEnemy.myDistinationX=DataMananger._wayPointArray[6].j;
//			_currentEnemy.myDistinationY=DataMananger._wayPointArray[6].i;
//			FarmerMananger.enemyAI(_currentEnemy)
//			//trace(DataMananger._startPointArray[0].i)
//			/*show path*/
//			for(i=0;i<_test.length;i++){
////				trace(i,_test.length,_test[i].i,_test[i].j,_test[i].counter)
//				var mTextField:TextField=new TextField(50, 50,
//					_test[i].i.toString()+":"+_test[i].j.toString()+"\n"+_test[i].counter.toString(), BitmapFont.MINI,14, 0xff0000);
//				_levelMap.addChild(mTextField);
//				mTextField.x=_test[i].j*50-25;
//				mTextField.y=_test[i].i*50-25;
//			}
//			_test=null;
//			DataMananger._enemyArray.push(new Point(FarmerMananger.startPoint1[0],FarmerMananger.startPoint1[1]))
				/**test*/
		}		
		private function initVampireHunter():void{
			if(DataManager._veriation==0||DataManager._veriation==31){
				return;
			}
			//vampHunter 初始化
			if(_vampireHunter==null){
				_vampireHunter=new VampireHunter();
				_levelMap.addChild(_vampireHunter);
				_vampireHunter.setPosition(DataManager._wayPointArray[DataManager._wayPointArray.length-3].i*50,DataManager._wayPointArray[DataManager._wayPointArray.length-3].j*50)
				_vampireHunter.myDistinationX=10//DataManager._wayPointArray[32].j;
				_vampireHunter.myDistinationY=2//DataManager._wayPointArray[32].i;
					
				SpawnManager.setHunterAI(_vampireHunter);				
			}			
			//draw path			
			/*for(var i:uint=0;i<_test.length;i++){
				var mTextField:TextField=new TextField(50, 50,
				_test[i].x.toString()+":"+_test[i].y.toString()+"\n"+_test[i].g.toString(), BitmapFont.MINI,14, 0xff0000);
				_levelMap.addChild(mTextField);
				mTextField.x=_test[i].x*50-25;
				mTextField.y=_test[i].y*50-25;
			}*/
			_test=null;
			
		}
		private function _configBarrier(e:MyEvents):void
		{
			DispatchMananger._em3D.removeEventListener('configGame',_configBarrier);
			//记录障碍物总数
			var _tempMax:uint=DataManager.MAX_OBS=e._tempObj.length;
			var i:uint=0;
			if(DataManager._versionDebug){
				//levelmap
				BarrierPool.initialize(_tempMax);
				for(;i<_tempMax;i++){
					_currentBarrier=BarrierPool.getSprite();
					_levelMap.addChild(_currentBarrier);
					//trace(e._tempObj[i])
					//BarrierPool.poolStyle.push(e._tempObj[i][1])
					_currentBarrier.randPosition(e._tempObj[i][0])
					_currentBarrier._id=i;				
					_currentBarrier=null;	
					//trace(e._tempObj.length)
					//_currentBarrier=null;
					//disposeSprite(_currentBarrier);
				}
			}else{
				BarrierPool.poolStyle=new Vector.<uint>;
				for(i=0;i<_tempMax;i++){
					BarrierPool.poolStyle.push(e._tempObj[i][1])
				}
				BarrierPool.initialize(_tempMax);
				for(i=0;i<_tempMax;i++){
					_currentBarrier=BarrierPool.getSprite();
					if(e._tempObj[i][1]!=1){						
						_levelMap.addChild(_currentBarrier);
						_currentBarrier.randFullVersionPosition(e._tempObj[i][0]);					
						_currentBarrier._id=i;						
					}else{
						Barrier.configFullVersionPosition(e._tempObj[i][0]);
					}
					_currentBarrier=null;									
				}				
			}	
			BarrierPool.nullBarrier()
		}
		
		private function addPlayerAnimation():void
		{
			_player._playStatus.gotoAndStop(2);
			var _countTimer:int = GlobalValue.timer.addCallBack(
				function():void
				{
					GlobalValue.timer.removeCallBack(_countTimer);
					hideMovieClip();
				}, 1300, true, false);
			
			function hideMovieClip():void
			{
				_player.visible=false;
				_reset.visible = true;				
				_levelMap.destroy();
			}
		}		
		private function addEnemyAnimation($enemy:BaseEnemy):void
		{
			//farmer
			if($enemy as Farmer)
			{
				enemyVect[$enemy._id].tempTorch.visible = false;
				enemyVect[$enemy._id]._farmerStatus.gotoAndStop(3);
			}
			//hunter
			if($enemy as VampireHunter)
			{
				var _countTimer:int = GlobalValue.timer.addCallBack(
					function():void
					{
						GlobalValue.timer.removeCallBack(_countTimer);
						_levelMap.removeChild($enemy, true);
					}, 1300, true, false);
				
			}
			
			_player._playStatus.gotoAndStop(3);
		}
		
		private function hideEnemy($farmer:Farmer):void
		{
			FarmerManager.enemyAI($farmer,true);
			$farmer.removeAllChildren();
			DataManager._enemyArray[$farmer._id] = new Point(-200, -200);
			$farmer.stopSeek();
			_levelMap.removeChild($farmer);
			//$farmer.tempTorch.visible = true;			
			if(SpawnManager.kill_Enemy >= DataManager._killNum)
			{
				SpawnManager.levelUp();
				SpawnManager.kill_Enemy = 0;
			}else{
				//SpawnMananger.setSpawnEnemy();
			}
		}		
		private function onResetTouch(e:TouchEvent):void
		{
			var curTouch:Touch = e.getTouch(this);
			if (curTouch)
			{
				if (curTouch.phase == "began")
				{
					_reset.removeEventListener(TouchEvent.TOUCH,onResetTouch);
					removeAllListner();
					resetGame();
					System.gc();
				}
			}
		}
		
		public function resetGame():void
		{
			
			_player.visible = true;
			
			_reset.visible = false;
			DataManager._playerDeath=DataManager._playerFeeding=false			
			_levelMap.reset();
			_levelMap.addAllListener();
			removeAllChildren();
			enemyVect=new Vector.<Farmer>
			SpawnManager.die_Enemy=new Vector.<Farmer>
			SpawnManager.live_Enemy=new Vector.<Farmer>
			SpawnManager.kill_Enemy=0;
			SpawnManager.count_Enemy=0;
			
			DataManager.currentLevel = 0;
			DataManager._enemyArray=new Vector.<Point>;
			DataManager._playerPoint=new Point(50,50);
			//HunterPathFinder.reset();
			
			
			FarmerManager._alertX=FarmerManager._alertY=-15
			initEnemyPool();
			initVampireHunter();
			//侦听player死亡情况
			DispatchMananger._em3D.removeEventListener(MyEvents.DIE,_playerReact);
			//侦听player feed
			DispatchMananger._em3D.removeEventListener(MyEvents.FEED,_playerReact);
			_reset.removeEventListener(TouchEvent.TOUCH,onResetTouch);
			addAllListner();
			
			_player._playStatus.gotoAndStop(1);
			_player.reset();
			_player.x=_player.y=0;
			
			
			System.gc();
		}
		
		public function addAllListner():void
		{
			DispatchMananger._em3D.addEventListener(MyEvents.DIE,_playerReact);
			DispatchMananger._em3D.addEventListener(MyEvents.FEED,_playerReact);
			_reset.addEventListener(TouchEvent.TOUCH,onResetTouch);
		}
		
		public function removeAllListner():void
		{
			DispatchMananger._em3D.removeEventListener(MyEvents.DIE,_playerReact);			
			DispatchMananger._em3D.removeEventListener(MyEvents.FEED,_playerReact);
			_player.reset();
		}
		
		public function removeAllChildren():void
		{
			for(var i:* in enemyVect)
			{
				FarmerManager.enemyAI(enemyVect[i],true);
				enemyVect[i].removeAllChildren();
				_levelMap.removeChild(enemyVect[i], true);
				EnemyPool.disposeSprite(enemyVect[i]);
				enemyVect[i] = null;
			}
			EnemyPool.nullBarrier();
			
			EnemyPool.pool=new Vector.<Farmer>;
			//if(DataManager._veriation!=3){
				HunterManager.enemyAI(_vampireHunter,true);
				_levelMap.removeChild(_vampireHunter,true);
				
				_vampireHunter=null
			//}
		}
		
	}
}
//Barrier 对象池；

import com.virtuos.OBJ3D.Barrier;


internal class BarrierPool
{
	private static var MAX_VALUE:uint;
	private static var GROWTH_VALUE:uint=5;
	private static var counter:uint;
	public static var pool:Vector.<Barrier>;
	public static var poolStyle:Vector.<uint>;
	public static var currentSprite:Barrier;
	public static function initialize(maxPoolSize:uint):void
	{
		MAX_VALUE=maxPoolSize;
	
		counter=maxPoolSize;
		
		var i:uint=maxPoolSize;
		pool=new Vector.<Barrier>(MAX_VALUE);
		//poolStyle=new Vector.<uint>;
		
		while(--i>-1){
			try{
				pool[i]=new Barrier(poolStyle[MAX_VALUE-1-i]);
			}catch(e:Error){
				pool[i]=new Barrier(2);
			}
		}
	}
	/*public static function publishStyle():void{
		var i:uint=0//MAX_VALUE;
		while(++i<MAX_VALUE){			
			pool[i]._style=poolStyle[i];
		}
		//trace(pool[MAX_VALUE-1]._style)
	}*/
	public static function nullBarrier():void{
		//trace(pool)
		var i:uint=0;
		for(;i<MAX_VALUE;i++){
			pool[i]=null;
		}
		//trace(pool)
		pool=null;
	}
	public static function getSprite():Barrier
	{
		//if(counter>0)
			return currentSprite=pool[--counter];
		//var i:uint=GROWTH_VALUE;
		//while(--i>-1)
			//pool.unshift(new Barrier());
		//counter=GROWTH_VALUE;
		//return getSprite();
	}
	
	public static function disposeSprite(disposedSprite:Barrier):void
	{
		pool[counter++]=disposedSprite;
	}
}
/***
 * enemy 对象池 * 
 * */
import com.virtuos.Characters.Farmer;
internal class EnemyPool
{
	private static var MAX_VALUE:uint;	
	public static var counter:uint;
	public static var pool:Vector.<Farmer>;
	private static var currentSprite:Farmer;
	public static function initialize(maxPoolSize:uint):void
	{
		MAX_VALUE=maxPoolSize;
		
		counter=maxPoolSize;
		
		var i:uint=maxPoolSize;
		pool=new Vector.<Farmer>(MAX_VALUE);
		while(--i>-1)
			pool[i]=new Farmer();
		//trace(pool.length)
	}
	public static function getSprite():Farmer
	{
		//if(counter>0)
			return currentSprite=pool[--counter];		
		//return getSprite();
	}
	public static function nullBarrier():void{
		//trace(pool)
		var i:uint=0;
		for(;i<MAX_VALUE;i++){
			pool[i]=null;
		}
		//trace(pool)
		pool=null;
	}
	public static function disposeSprite(disposedSprite:Farmer):void
	{
		pool[counter++]=disposedSprite;
	}
}