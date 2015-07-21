package Configuration
{
	import MyDispatcher.DispatchMananger;
	
	import MyEvent.MyEvents;
	
	import com.virtuos.Managers.DataManager;
	import com.virtuos.Managers.OBJCollision;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class loadTXT{
		private var source:String = "map.txt";
		private var dataFormat:String = URLLoaderDataFormat.TEXT;
		public static var _mapData:Vector.<uint>;
		//障碍物数组
		private static var _barData:Vector.<Object>;
		//敌人数组
		private var sourceXML:String = "XML/configuration.xml";
//		private static var _eneData:Vector.<uint>;
		private var _isDebug:Boolean;
		//
		private var _wayPointArray:Vector.<Object>;
		//
		private var _startPointArray:Vector.<Object>;
		private var _enemyObj:Object = {};
		private var _currentLevel:String;
		
		//private var _collisionPointArray:Vector.<Object>;
		public function loadTXT():void {
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = dataFormat;
			configureListeners(loader);
			var request:URLRequest = new URLRequest(source);
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Error loading requested document: " + source);
			}
			//xml
			var loaderXML:URLLoader = new URLLoader();			
			loaderXML.addEventListener(Event.COMPLETE, completeHandlerXML);
			var requestXML:URLRequest = new URLRequest(sourceXML);
			loaderXML.load(requestXML);
		}
		private function completeHandlerXML(event:Event):void{
			var myXml:XML=XML(event.target.data);
			//player
			//DataMananger._cameraDuration=myXml.prop.player.cameraDuration;
			DataManager._dashDuration=myXml.prop.player.dashDuration;
			//DataMananger._cameraSpeed=myXml.prop.player.cameraSpeed;
//			DataMananger._dashSpeed=myXml.prop.player.dashSpeed;
			DataManager._killPoint=myXml.prop.player.killPoint;
			DataManager._feedPoint=myXml.prop.player.feedPoint;
			//enemy
			DataManager._enemySpeed=myXml.prop.enemy.speed;
			DataManager._enemyCollision=myXml.prop.enemy.collision;
			DataManager._torchCollision=myXml.prop.enemy.torchCollision;
			DataManager._alertRadius=myXml.prop.enemy.alertRadius;
			DataManager._enemySeekingTime=myXml.prop.enemy.seek;
			//hunter
			DataManager._hunterSpeed = myXml.prop.hunter.speed;
			DataManager._hunterTorchCollision = myXml.prop.hunter.torchCollision;
			
			DataManager._wholeLevel=myXml.prop.level.children().length();
			//veriation;
			DataManager._veriation=myXml.prop.version;
			//seeking player number
			DataManager._seekPlayerNum=myXml.prop.enemy.seekNum;
			//seeking player 
			DataManager._seekRadius=myXml.prop.enemy.seekRadius;
			trace(DataManager._seekPlayerNum)
			//trace(DataMananger._wholeLevel)
			for (var i:uint = 0; i < DataManager._wholeLevel; ++i)
			{
				DataManager._enemyObj[i] = myXml.prop.level.children()[i];
			}
			
			DataManager.currentLevel = 0;
			
			if(myXml.prop.debug == "false")
				_isDebug = false;
			else
				_isDebug = true;
			
			DataManager._versionDebug = _isDebug;
			
			DispatchMananger._em3D.dispatchEvent(new MyEvents('configCharacter',null));
		}
		private function configureListeners(dispatcher:URLLoader):void {
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);		
		}
		//private function configureListenerXML
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			//trace(event.target.data)
			switch(loader.dataFormat) {
				case URLLoaderDataFormat.TEXT :
//					trace("completeHandler (text): " + loader.data,loader.data.length);
					var tempStr:String=loader.data
//					trace(tempStr.charAt(26)=="\n")
//					for(var i:uint=1;i<=19;i++){
//						for(var j:uint=1;j<=27;j++){
//							var k:uint=i*j
//							if(tempStr.charAt(i*j)=="0"||tempStr.charAt(i*j)=="1"||tempStr.charAt(i*j)=="2")
////							_mapData.push(tempStr.charAt(i*j-1))
//							trace(i*j-1,tempStr.charAt(i*j-1))
//						}
//					}
					_mapData = new Vector.<uint>();
					_barData=new Vector.<Object>();
					_wayPointArray=new Vector.<Object>;
					_startPointArray=new Vector.<Object>;
					//_collisionPointArray=new Vector.<Object>;
					var tempObj:Object;
					var _tempVec:Array//=new Vector.<uint>();
					var _tempLen:uint=tempStr.length
					for(var i:uint=0;i<_tempLen;i++){
						if(tempStr.charAt(i)=="0"||tempStr.charAt(i)=="1"||tempStr.charAt(i)=="2"||tempStr.charAt(i)=="3"||tempStr.charAt(i)=="4"||tempStr.charAt(i)=="5"||tempStr.charAt(i)=="6"||tempStr.charAt(i)=="9"){
							_mapData.push(uint(tempStr.charAt(i)))
								if(uint(tempStr.charAt(i))>0){	
									_tempVec=new Array(_mapData.length,uint(tempStr.charAt(i)));
									//trace(_tempVec[1])
									_barData.push(_tempVec);
									tempObj={i:uint((_mapData.length-1)%41),j:uint((_mapData.length-1)/41)}
									//_collisionPointArray.push(tempObj);
									_tempVec=null;
									tempObj=null;
								}
						}else if(tempStr.charAt(i)=="7"){
							_mapData.push(uint(tempStr.charAt(i)))						
							tempObj={i:uint((_mapData.length-1)%41),j:uint((_mapData.length-1)/41)};
						//	trace(i,tempObj.i,tempObj.j)
							_wayPointArray.push(tempObj);
							tempObj=null;
						}else if(tempStr.charAt(i)=="8"){
							_mapData.push(uint(tempStr.charAt(i)))						
							tempObj={i:uint((_mapData.length-1)%41),j:uint((_mapData.length-1)/41)};
							//	trace(i,tempObj.i,tempObj.j)
							_startPointArray.push(tempObj);
							tempObj=null;
						}
					}
					//trace(_mapData[42])
					//将位置传给datamananger,地图数组为二维数组
					for(i=0;i<32;i++){
						DataManager._mapArray[i]=new Array()
						DataManager._mapArrayCopy[i]=new Array();
						for(var j:uint=0;j<41;j++){
							
							DataManager._mapArray[i].push(_mapData[i*41+j]);
							DataManager._mapArrayCopy[i].push(_mapData[i*41+j]);
						}						
					}					
//					for(i=0;i<_mapData.length;i++){
//						DataMananger._mapArray[uint(i/41)][uint(i%41)]=_mapData[i];
//					}
					DataManager._wayPointArray=_wayPointArray;
					DataManager._startPointArray=_startPointArray;
//					trace(DataMananger._collArray,DataMananger._wayPointArray)
					DispatchMananger._em3D.dispatchEvent(new MyEvents('configGame',_barData));
					_mapData=new Vector.<uint>;
					_mapData=null;
					_wayPointArray=null;
					break;				
			}
		}		
		
	}
}