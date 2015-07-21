package com.virtuos.Managers
{
	import flash.geom.Point;

	public class DataManager
	{
		public static var _stageWidth:uint=1024;
		public static var _stageHeight:uint=768;
		public static var _versionDebug:Boolean=false;
		public static var _veriation:uint=1;
		public static var _brake:Boolean=false;
		//player
		//camera的跟随速度
		//public static var _cameraDuration:uint=2;
		//dash的长短；
		public static var _dashDuration:Number=2;
		//camera speed
		//public static var _cameraSpeed:uint=2;
		//dash speed
		public static var _dashSpeed:Number=2;
		
		public static var _killPoint:Number=2;
		public static var _feedPoint:Number=2;
		public static var _playerMoving:Boolean=false;
		public static var _playerFeeding:Boolean=false;
		public static var _playerDeath:Boolean=false;
		//level 相关
		public static var _mapArray:Array=new Array();
		public static var _mapArrayCopy:Array=new Array();
		//level collision数组；
		public static var _collisionMapArray:Array=new Array();
		public static var _wayPointArray:Vector.<Object>=new Vector.<Object>;
		public static var _startPointArray:Vector.<Object>=new Vector.<Object>;
		//enemy
		public static var _enemySpeed:Number=2;
		public static var _alertRadius:uint=100;
		//敌人的碰撞点小，大
		public static var _enemyCollision:Number=2;
		//每n秒，寻一次player
		public static var _enemySeekingTime:uint=4;
		public static var _torchCollision:uint=2;
		//障碍物的数量
		public static var MAX_OBS:uint=5;
		//map的位置转化为player的位置
		public static var _playerPoint:Point=new Point(50,50);
		//障碍物数组
		public static var _obstacleArray:Vector.<Point>=new Vector.<Point>();
		//enemy数组
		public static var _enemyArray:Vector.<Point>=new Vector.<Point>();
		public static var _max_Enemy:uint=30;
		public static var _seekPlayerNum:uint=2;
		public static var _seekRadius:uint=200;
		//敌人的数量
		public static var _birthSpace:Number;
		public static var MAX_FARM:int;
		public static var _killNum:int;
		//游戏难度
		public static var _enemyObj:Object = {};		
		private static var _currentLevel:uint;
		public static var _wholeLevel:uint=1;
		
		//hunter.
		public static var _hunterSpeed:Number;
		public static var _hunterTorchCollision:Number;
		
		public function DataManager()
		{
		}
		public  static function get currentLevel():uint
		{
			return _currentLevel;
		}
		
		public static function set currentLevel(_level:uint):void
		{
			_currentLevel = _level;
			if(_currentLevel<_wholeLevel){
				
				DataManager._birthSpace = getConfigLevel(_currentLevel).space;
				DataManager.MAX_FARM = getConfigLevel(_currentLevel).total;
				DataManager._killNum = getConfigLevel(_currentLevel).kill;
			}
		}
		
		private static function getConfigLevel(name:uint):Object
		{
			return _enemyObj[name];
		}
	}
}