package com.virtuos.Characters
{
	import com.virtuos.OBJ3D.PointUI;
	import com.virtuos.SpriteContainer3D;
	
	import flash.utils.Timer;
	
	import starling.events.Event;
	
	public class BaseEnemy extends SpriteContainer3D
	{
		public var _id:uint;
		public var _isFeed:Boolean=false;
		
		//farmer 的寻路数组
		public var myPath:Vector.<Object>
		//public var myStartX:uint;
		//public var myStartY:uint;
		public var myDistinationX:uint;
		public var myDistinationY:uint;
		//找到player的点
		//public var seekPlayerPosX:uint=0;
		//public var seekPlayerPosY:uint=0;
		//现在的waypoint点
		public var _waypointI:uint
		//farmer是否为alert状态；
		public var _altered:Boolean=false;
		//发现player
		public var _seekedPlayer:Boolean=false;
		//farm 接受到的事发地点
//		public var myAlertX:int=-150;
//		public var myAlertY:int=-150;
		//farm是否为碰撞AI
		public var touchAI:Boolean=false;
		//
		//纵向选择
		public var _to_V:String;
		//横向选择
		public var _to_H:String;
		//测试用文本框
		private var testText:PointUI=PointUI.getInstance();
		//player通过enemy的次数
		public var _through:uint=0;
		//seek
		public var  _seek_DistanceX:int;
		public var  _seek_DistanceY:int;
		public var _seek_Distance:int;
		public var _seek_RatioX:Number;
		public var _seek_RatioY:Number;
		
		protected var _seekTimer:Timer
		protected var xD:int;
		protected var yD:int;
		protected var newPX:int//=(int(DataManager._playerPoint.x)-int(DataManager._playerPoint.x)%50)/50
		protected var newPY:int//=(int(DataManager._playerPoint.y)-int(DataManager._playerPoint.y)%50)/50
		public function BaseEnemy()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}		
	}
}