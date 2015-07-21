package com.virtuos
{
	import MyDispatcher.DispatchMananger;
	
	import MyEvent.MyEvents;
	
	import com.virtuos.Characters.Farmer;
	import com.virtuos.Characters.Player;
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.OBJCollision;
	import com.virtuos.animation.AutoMovieClip3D;
	import com.virtuos.display.MovieClip;
	import com.virtuos.display.SWF;
	import com.virtuos.loader.Loader3D;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class MyLevel extends SpriteContainer3D
	{
		
		//player要达到的目标数组
		public static var _destinyArray:Vector.<Object>=new Vector.<Object>;
		//private static var OFFSET:Number = 0.3;
		
		//障碍物的实例
		private var _currentGrid:Grid;
		private static var _targetPoint:Point=new Point;
		[Embed(source="Assets/Ground.jpg")]
		private var GRID:Class;
		private var tempDracula:Image
		private var amc:AutoMovieClip3D;
		private static var _dashVector:Vector.<MovieClip> = new Vector.<MovieClip>;
		private static const _dashLen:uint =5;
		
		private var tempVec:Vector.<Number>=new Vector.<Number>;
		private var _len:uint=_destinyArray.length;
		private var dis:Number;
		public function MyLevel()
		{
			super();
		}
		override protected function init(e:Event):void{

			tempDracula=Image.fromBitmap(new GRID)
			addChild(tempDracula);
			tempDracula.x=-25
			tempDracula.dispose();		
			//触碰地图传坐标
			this.addEventListener(TouchEvent.TOUCH,onTouch);
			DispatchMananger._em3D.addEventListener("setpostion",_onSet);
		}
		
		public function addAllListener():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			//this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			DispatchMananger._em3D.addEventListener("setpostion",_onSet);
		}
		
		//移除所有listener
		public function _removeAllListener():void{
			this.removeEventListener(TouchEvent.TOUCH,onTouch);
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			DispatchMananger._em3D.removeEventListener("setpostion",_onSet);
		}
		/******
		 * 
		 * 碰撞后设定位置
		 * */
		private function _onSet(e:MyEvents):void
		{
			this.addEventListener(Event.ENTER_FRAME, removeShadow);
			this.x=e._tempObj[0]
			this.y=e._tempObj[1];			
			_dashDely=0;
			DataManager._playerPoint=new Point(_tempOrgX-this.x,_tempOrgY-this.y)
		}
		private const _tempOrgX:uint=497
		private const _tempOrgY:uint=359
		private var _countTimer:int;
		private function onTouch(e:TouchEvent):void
		{
			if(DataManager._playerDeath){
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				return;
			}
			var curTouch:Touch = e.getTouch(this);
			if (curTouch)
			{
				if (curTouch.phase == "began")
				{
					//if(_player.visible){
					if(!DataManager._playerFeeding){
						
						_targetPoint=new Point(curTouch.globalX-25,curTouch.globalY-25);	
						
						//trace(curTouch.globalX, curTouch.globalY)
						//
						/***确定player移动的位置坐标**/
						
						if(_len==0){
							tempVec[0]=_tempOrgX-_targetPoint.x;
							tempVec[1]=_tempOrgY-_targetPoint.y;
//							trace(_tempOrgX-_targetPoint.x)
//							_tempOrgX=_targetPoint.x;
//							_tempOrgY=_targetPoint.y;
							dis=Math.sqrt(tempVec[0]*tempVec[0]+tempVec[1]*tempVec[1])
							tempVec[2]=tempVec[0]/dis //* OFFSET//x/dis
							tempVec[3]=tempVec[1]/dis //* OFFSET//y/dis							
							/***
							 * fake
							 * */
//							Player.getInstance().x=_targetPoint.x-_tempOrgX
							amc = new AutoMovieClip3D("movie.ui.Circle");
							amc.x = curTouch.globalX - amc.width/2;
							amc.y = curTouch.globalY - amc.height/2;
							
							main3D.getInstance().addChild(amc);
							
							
							DataManager._playerMoving=true;
//							DataMananger._playerPoint=new Point(this.x-_tempOrgX,this.y-_tempOrgY)
							//if(OBJCollision.newPlayerCollision(DataMananger._playerPoint,_targetPoint)){
							DataManager._playerPoint=new Point(_tempOrgX-this.x,_tempOrgY-this.y)
						//	}
							_destinyArray[0]=tempVec
						}
						
					}
					if(!this.hasEventListener(Event.ENTER_FRAME)){
						this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
					}						
				}else if(curTouch.phase == "hover"){
					
				}
			}			
		}
		private function onRelayTime():void
		{
			
		}
		
		private var cumulateX:Number=0;
		private var cumulateY:Number=0;
		//dash模拟增量
		private var cumulateDashX:Number=0;
		private var cumulateDashY:Number=0;
		//private var _dashDely:uint=0;
		private var _dashSpeed:Number;
		//private var _cameraSpeed:Number;
		//private var _distance:Number;
		//=============
		private var _playerDisX:Number;
		private var _playerDisY:Number;
		//==============
		private var temp0:Number;
		private var temp1:Number;
		private var temp2:Number;
		private var temp3:Number;
		//x分量的速度
		private var _plusX:Number;
		//y分量的速度
		private var _plusY:Number;
		//x分量的dash速度
		private var _plusDashX:Number;
		//y分量的dash速度
		private var _plusDashY:Number;
		//dash delay
		private var _dashDely:uint=0;
		//距离
		private var _distance:Number;
		
		
//		private var _canMove:Boolean=true;
		private function onEnterFrame(e:Event):void{
			var _len:uint=_destinyArray.length;			
			//
			DataManager._playerPoint=new Point(_tempOrgX-this.x,_tempOrgY-this.y);
			if(_destinyArray.length==0){
				this.addEventListener(Event.ENTER_FRAME, this.removeShadow);
				return
			}
			//temp0:x偏量，temp1:y偏量；
			temp0=_destinyArray[0][0];
			temp1=_destinyArray[0][1];
			temp2=_destinyArray[0][2];
			temp3=_destinyArray[0][3];
			_distance=Math.sqrt(temp0*temp0+temp1*temp1);
			//_dashSpeed=DataMananger._dashSpeed;
			
			DataManager._dashSpeed=_dashSpeed=_distance/DataManager._dashDuration;
			
//			_cameraSpeed=_distance/DataMananger._dashDuration/6;			
			/***
			 * collision
			 ****/
			//collision
			
			if(OBJCollision.playerCollisions(temp2,temp3,_dashSpeed)){				
				this.removeEventListener(Event.ENTER_FRAME,removeShadow);
				_destinyArray.shift();
				cumulateX=0;	
				cumulateY=0;
				cumulateDashX=cumulateDashY=0;
				Player.getInstance().x=0;
				Player.getInstance().y=0;				
				DataManager._playerMoving=false;
//				DataMananger._brake=false;
				return
			}
			//x分量的速度
			_plusX=_dashSpeed*temp2;
			//y分量的速度
			_plusY=_dashSpeed*temp3;
			//x分量dash的速度
			_plusDashX=_dashSpeed*temp2;
			//y分量dash的速度
			_plusDashY=_dashSpeed*temp3;
			//trace(_plusX,_plusY,_plusDashY)
			///////////////////////=======================================
			//camera reach point			
			if(cumulateDashX>=Math.abs(temp0)-Math.abs(_plusDashX)||cumulateDashY>=Math.abs(temp1)-Math.abs(_plusDashY)){
				//trace(cumulateDashX,Math.abs(temp0)-Math.abs(_plusDashX),cumulateDashY,Math.abs(temp1)-Math.abs(_plusDashY),_dashDely)
				
				_plusDashX=_plusDashY=0;
//				cumulateDashX=cumulateDashY=0;
				//Player.getInstance().x+=_plusX;
				//Player.getInstance().y+=_plusY;
				DataManager._playerMoving=false;
			}			
			/*if(_targetPoint.x-_tempOrgX-Player.getInstance().x<=_plusX||_targetPoint.y-_tempOrgY-Player.getInstance().y<=_plusY){
				cumulateDashX=cumulateDashY=0;
				Player.getInstance().x=_targetPoint.x-_tempOrgX-_plusX;
				Player.getInstance().y=_targetPoint.y-_tempOrgY-_plusY;
				DataMananger._playerMoving=false;
			}*/
			if(cumulateX>=Math.abs(temp0)||cumulateY>=Math.abs(temp1)){
				cumulateX=0;
				cumulateY=0;
				cumulateDashX=cumulateDashY=0;
				_dashDely=0;
				Player.getInstance().x=0;
				Player.getInstance().y=0;
				_destinyArray.shift();
				return	
			}
			/****
			 * amortize,缓冲			  
			 * */			
			if(_dashDely<4){
				_dashDely++
					if(DataManager._playerMoving){
						cumulateDashX+=Math.abs(_plusDashX);
						cumulateDashY+=Math.abs(_plusDashY);
						
							Player.getInstance().x-=_plusDashX;
							Player.getInstance().y-=_plusDashY;
						
					}else{
						Player.getInstance().x+=_plusX;
						Player.getInstance().y+=_plusY;
					}
			}else{
				//if(_canMove){
					cumulateX+=Math.abs(_plusX);
					cumulateY+=Math.abs(_plusY);
			
					this.x+=_plusX;					
					this.y+=_plusY;
					amc.x += _plusX;
					amc.y += _plusY;	
				//}
				if(DataManager._playerMoving){					
					if(cumulateDashX>=Math.abs(temp0)-Math.abs(2*_plusDashX)||cumulateDashY>=Math.abs(temp1)-Math.abs(2*_plusDashY)){
						Player.getInstance().x-=_plusDashX;
						Player.getInstance().y-=_plusDashY;
					}else{						
						Player.getInstance().x-=_plusDashX/100;
						Player.getInstance().y-=_plusDashY/100;
					}
					cumulateDashX+=Math.abs(_plusDashX);
					cumulateDashY+=Math.abs(_plusDashY);
				}else if(!DataManager._playerMoving){
					Player.getInstance().x+=_plusX;
					Player.getInstance().y+=_plusY;
				}
			}
			
			//if(_dashDely>0){				
				/*cumulateX+=Math.abs(_plusX);
				cumulateY+=Math.abs(_plusY);
				this.x+=_plusX;					
				this.y+=_plusY;
			amc.x += _plusX-4;
			amc.y += _plusY-3;
					cumulateDashX+=Math.abs(_plusDashX);
					cumulateDashY+=Math.abs(_plusDashY);
					//					Player.getInstance().x-=_plusDashX;
					//					Player.getInstance().y-=_plusDashY;
				}else{
					Player.getInstance().x+=_plusDashX;
					Player.getInstance().y+=_plusDashY;
				}	*/
//				
			/*}else{
				if(DataMananger._playerMoving){
					cumulateDashX+=Math.abs(_plusDashX);
					cumulateDashY+=Math.abs(_plusDashY);
//					Player.getInstance().x-=_plusDashX;
//					Player.getInstance().y-=_plusDashY;
				}else{
					Player.getInstance().x+=_plusDashX;
					Player.getInstance().y+=_plusDashY;
				}				
			}	*/	
			DataManager._playerPoint=new Point(_tempOrgX-this.x+Player.getInstance().x,_tempOrgY-this.y+Player.getInstance().y)
			if(DataManager._playerMoving)
				shadowEffect();
		}
		
		private function shadowEffect():void
		{
			var _mc:MovieClip = Player.getInstance().getMC();
			this.addChild(_mc);
			//trace("mc:",this.numChildren)
			_mc.x = DataManager._playerPoint.x+25;
			_mc.y = DataManager._playerPoint.y+25;
			_mc.alpha = 0.5;
			if (_dashVector.length < _dashLen)
			{
				_dashVector.push(_mc);
				//_mc=null;
			}
			else
			{	
				this.removeChild(_dashVector[0], true);
				_dashVector[0]=null;
				_dashVector.shift();
				_dashVector.push(_mc);
			}
		}
		
		private function removeShadow(e:Event):void
		{
			if (_dashVector.length >= 1)
			{
				this.removeEventListener(TouchEvent.TOUCH, onTouch);
				
				this.removeChild(_dashVector[0], true);
				_dashVector[0]=null;
				_dashVector.shift();
			} 
			else if (_dashVector.length == 0)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.removeShadow);
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				this.addEventListener(TouchEvent.TOUCH, onTouch);
				_dashVector=new Vector.<MovieClip>;
			}
		}
		
		public function reset():void
		{
			this.x = 462;
			this.y = 334;
			_dashVector=new Vector.<MovieClip>;
			amc=null;
			//this.removeEventListener(Event.ENTER_FRAME, this.removeShadow);
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function destroy():void
		{
			if(null != _dashVector)
			{
				for(var i:* in _dashVector)
				{
					this.removeChild(_dashVector[i] , true);
				}
			}
			
		}
	}
}
import starling.display.Image;
import starling.display.Sprite;
internal class levelGridPool
{
	private static var MAX_VALUE:uint;
	
	
	
	private static var counter:uint;
	private static var pool:Vector.<Grid>;
	private static var currentSprite:Grid;
	public static function initialize(maxPoolSize:uint):void
	{
		MAX_VALUE=maxPoolSize;
		
		counter=maxPoolSize;
		
		var i:uint=maxPoolSize;
		pool=new Vector.<Grid>(MAX_VALUE);
		while(--i>-1)
			pool[i]=new Grid();
	}
	public static function getSprite():Grid
	{
		if(counter>0)
			return currentSprite=pool[--counter];
		//var i:uint=GROWTH_VALUE;
		//while(--i>-1)
		//pool.unshift(new Barrier());
		//counter=GROWTH_VALUE;
		return getSprite();
	}
	
	public static function disposeSprite(disposedSprite:Grid):void
	{
		pool[counter++]=disposedSprite;
	}
}

internal class Grid extends Sprite
{
	
	/*[Embed(source="Assets/Grid.jpg")]
	private var GRID:Class;*/
	private var tempDracula:Image//=Image.fromBitmap(new GRID);
	public function Grid():void{
		//tempDracula=Image.fromBitmap(new GRID)
		//addChild(tempDracula);
	}
}