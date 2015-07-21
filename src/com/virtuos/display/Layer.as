package com.virtuos.display
{
	import com.virtuos.display.text.TextField;
	
	import starling.core.RenderSupport;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	internal class Layer extends Sprite
	{
		private static const MOVIE_CLIP:String = "movieclip";
		private static const BITMAP:String     = "bitmap";
		private static const TEXT_FIELD:String = "textfield";
		private static const INVALID_VALUE:String = "0";
		
		private static const TWEEN_PROPERTY:Array     = ["x","y","scaleX","scaleY","alpha","rotate"];
		private static const TWEEN_PROPERTY_MAP:Array = ["x","y","scaleX","scaleY","alpha","rotation"];
		
		private static const MC_PROPERTY:Array =     ["x","y","centerPointX","centerPointY","scaleX","scaleY","alpha","rotate"];
		private static const MC_PROPERTY_MAP:Array = ["x","y","pivotX",      "pivotY",      "scaleX","scaleY","alpha","rotation"];
		
				
		//-- not implemented effect
		private var _brightness:Number;
		private var _tint:Number;
		private var _red:int;
		private var _green:int;
		private var _blue:int;
		private var _skewHorizontal:Number;
		private var _skewVertial:Number;
		//--
		
		private var _xml:XML;
		private var _swf:SWF;
		private var _textureFactoryInstance:AltasTextureFactory;
		private var _instanceLibrary:Array = new Array();
		
		private var _totalFrames:int = 1;
		private var _prevFrame:int = 0;
		private var _currentFrame:int = 1;
		private var _prevDisplayList:Array;
		private var _curDisplayList:Array;
		
		private var _scripts:Array = new Array();
		private var _frameArray:Array = new Array();
		private var _frames:Array = new Array();
		
		private var _labelFrame:Object = {};
		
		private var _tweenStart:Array = new Array();
		private var _tweenEnd:Array = new Array();
		private var _tweenStartProperties:Array = new Array();
		private var _tweenEndProperties:Array = new Array();
		private var _tweenDisplayObject:DisplayObject; // Note: tween only support one object 
		
		public function Layer()
		{
			super();
		}
		
		public override function dispose():void
		{
			for each (var displayList:DisplayList in _frames)
			{
				displayList.distory();
				displayList = null;
			}
			super.dispose();
		}
		
		public function removeFromDisplayList(target:DisplayObject):void
		{
			for each (var displayList:DisplayList in _frames)
			{
				displayList.remove(target);
			}
		}
		
		public function setData(swf:SWF, movieClip:XML, factoryInstance:AltasTextureFactory):int
		{
			_xml = movieClip;
			_swf = swf;
			_textureFactoryInstance = factoryInstance;
			var frameList:XMLList = movieClip.children();
			for (var i:int = 0; i < frameList.length(); ++i)
			{
				var currentFrame:XML = frameList[i];
				var frame:Number = currentFrame.attribute("number");
				var label:String = currentFrame.attribute("label");
				var script:String = currentFrame.attribute("script");
				_frameArray.push(frame);
				if (label != "")
					(parent as MovieClip).setLabelFrame(label, frame);
				var displayListInstance:DisplayList = new DisplayList();
				_frames[frame] = displayListInstance;
				if (script != null && script != "")
					_scripts[frame] = script;
				soluveFrame(currentFrame, displayListInstance);
				_totalFrames = frame > _totalFrames ? frame : _totalFrames;
				currentFrame = null;
			}
			runFrameScript();
			updateMember();
			updateState();
			_xml = null;
			return _totalFrames;
		}
		
		private function runFrameScript():void
		{
			if (_scripts[_currentFrame])
			{
				var script:String = _scripts[_currentFrame];
				var scripts:Array = script.split(";");
				var scriptLength:int = scripts.length;
				for (var i:int = 0; i < scriptLength; ++i)
				{  
					runStatement(scripts[i]);
				}
			}
		}
		
		private function runStatement(script:String):void
		{
			script = trimFront(script, " ");
			script = trimBack(script, " ");
			if (script == "stop()")
			{
				(parent as MovieClip).stop();
			}
			else if (script == "play()")
			{
				(parent as MovieClip).play();
			}
			else if (script.indexOf("gotoAndStop") != -1)
			{
				var tarFrame:String = script.substr(script.indexOf("(") + 1, script.indexOf(")") - script.indexOf("(") - 1);
				var tarFrameNum:Number;
				if (tarFrame.indexOf("\'") != -1)
				{
					tarFrame = tarFrame.substr(tarFrame.indexOf("'") + 1, tarFrame.length - 2);
					(parent as MovieClip).gotoAndStop(tarFrame);
				}
				else
				{
					tarFrameNum = Number(tarFrame);
					(parent as MovieClip).gotoAndStop(tarFrameNum);
				}
				
			}
			else if (script.indexOf("gotoAndPlay") != -1)
			{
				tarFrame = script.substr(script.indexOf("(") + 1, script.indexOf(")") - script.indexOf("(") - 1);
				if (tarFrame.indexOf("\'") != -1)
				{
					tarFrame = tarFrame.substr(tarFrame.indexOf("\'") + 1, tarFrame.length - 2);
					(parent as MovieClip).gotoAndPlay(tarFrame);
				}
				else
				{
					tarFrameNum = Number(tarFrame);
					(parent as MovieClip).gotoAndPlay(tarFrameNum);
				}
			}
		}
		
		private function trimFront(str:String, char:String):String 
		{
			char = stringToCharacter(char);
			if (str.charAt(0) == char) {
				str = trimFront(str.substring(1), char);
			}
			return str;
		}
		
		private function trimBack(str:String, char:String):String 
		{
			char = stringToCharacter(char);
			if (str.charAt(str.length - 1) == char) {
				str = trimBack(str.substring(0, str.length - 1), char);
			}
			return str;
		}
		
		private function stringToCharacter(str:String):String {
			if (str.length == 1) {
				return str;
			}
			return str.slice(0, 1);
		}
		
		// Note: This function could be optimized
		private function soluveFrame(frame:XML, displayList:DisplayList):void
		{
			for (var i:int = 0; i < frame.children().length(); ++i)
			{
				var targetDisplayInstance:DisplayObject = null;
				var mc:XML = frame.children()[i];
				if (null != _instanceLibrary[mc.attribute("instanceName")] && _instanceLibrary[mc.attribute("instanceName")] != 0 && mc.attribute("type") == MOVIE_CLIP)
					targetDisplayInstance = _instanceLibrary[mc.attribute("instanceName")];
				else
				{
					if (mc.attribute("type") == MOVIE_CLIP)
					{
						var mcPrototype:*;
						var linkage:String = mc.attribute("linkage");
						if (linkage == INVALID_VALUE || linkage == "")
							mcPrototype = _swf.getMCInstance(mc.attribute("prototypeName"));
						else
						{
							linkage = linkage.substr(0, linkage.indexOf(".xml"));
							var refSwf:SWF = SWFInventory.getInstance().getSWF(linkage);
							mcPrototype = refSwf.getMCInstance(mc.attribute("prototypeName"));
						}
						if (mcPrototype is MovieClip)
							targetDisplayInstance = mcPrototype;
					}
					else if (mc.attribute("type") == BITMAP)
					{
						var texture:Texture = _textureFactoryInstance.getTexture(mc.attribute("instanceName"));
						var image:Image = new Image(texture);
						targetDisplayInstance = image;
					}
					else if (mc.attribute("type") == TEXT_FIELD)
					{
						var tWidth:Number = mc.attribute("width");
						var tHeight:Number = mc.attribute("height");
						var text:String = mc.attribute("text");
						var fontName:String = mc.attribute("fontName");
						var fontSize:Number = mc.attribute("fontSize");
						var color:int = mc.attribute("color");
						var bold:Boolean = Boolean(Number(mc.attribute("bold")));
						targetDisplayInstance = new TextField(tWidth, tHeight, text, fontName, fontSize, color, bold);
					}
					else
					{
						throw new Error("It's can't be here.");
					}
					if (targetDisplayInstance)
					{
						_instanceLibrary[mc.attribute("instanceName")] = targetDisplayInstance;
						targetDisplayInstance.name = mc.attribute("instanceName");
					}
				}
				if (targetDisplayInstance)
				{
					var x:Number = mc.attribute("x");
					var y:Number = mc.attribute("y");
					var pivotX:Number = mc.attribute("centerPointX");
					var pivotY:Number = mc.attribute("centerPointY");
					var scaleX:Number = mc.attribute("scaleX");
					var scaleY:Number = mc.attribute("scaleY");
					var alpha:Number = mc.attribute("alpha");
					var rotation:Number = mc.attribute("rotate");
					var depth:Number = mc.attribute("depth");
					displayList.push(targetDisplayInstance, {x:x,y:y,pivotX:pivotX,pivotY:pivotY,scaleX:scaleX,scaleY:scaleY,alpha:alpha,rotation:rotation,depth:depth});
					if (mc.attribute("tweenStart") == 1)
					{
						_tweenDisplayObject = targetDisplayInstance;
						_tweenStart.push(frame.attribute("number"));
						_tweenStartProperties.push(mc);
					}
					if (mc.attribute("tweenEnd") == 1)
					{
						_tweenEnd.push(frame.attribute("number"));
						_tweenEndProperties.push(mc);
					}
				}
				mc = null;
			}
		}
		
		private function updateMember():void
		{
			var isKeyFrame:Boolean = false;
			if (_currentFrame > _totalFrames)
			{
				_curDisplayList = new Array();
			}
			else if (_frames[_currentFrame])
			{
				isKeyFrame = true;
				_curDisplayList = _frames[_currentFrame].elements;
				var properties:Array = _frames[_currentFrame].properties;
			}
			else
			{
				var targetFrame:int = 0;
				if (!(parent as MovieClip).isReversePlay)
				{
					for (var possibleFrame:int = _currentFrame; possibleFrame >= 1; --possibleFrame)
					{
						if (_frames[possibleFrame])
						{
							targetFrame = possibleFrame;
							break;
						}
					}
				}
				else
				{
					for (possibleFrame = _currentFrame; possibleFrame <= _totalFrames; ++possibleFrame)
					{
						if (_frames[possibleFrame])
						{
							targetFrame = possibleFrame;
							break;
						}
					}
				}
				_curDisplayList = _frames[targetFrame].elements;
			}
			if (_curDisplayList)
			{
				if (_prevDisplayList)
				{
					for (var i:int = 0; i < _prevDisplayList.length; ++i)
					{
						var exist:Boolean = false;
						for (var j:int = 0; j < _curDisplayList.length; ++j)
						{
							if (_prevDisplayList[i] == _curDisplayList[j])
							{
								exist = true;
								break;
							}
						}
						if (!exist)
						{
							removeChild(_prevDisplayList[i]);
							var index:int = (parent as MovieClip).children.indexOf(_prevDisplayList[i]);
							(parent as MovieClip).children.splice(index, 1);
							delete parent[_prevDisplayList[i].name];
						}
						else
						{
							if (isKeyFrame)
								setProperty(_curDisplayList[j],  properties[j]);
						}
					}
				}
				for (i = 0; i < _curDisplayList.length; ++i)
				{
					if (!this.contains(_curDisplayList[i]))
					{
						addChild(_curDisplayList[i]);
						(parent as MovieClip).children.push(_curDisplayList[i]);
						parent[_curDisplayList[i].name] = _curDisplayList[i];
						if (isKeyFrame)
							setProperty(_curDisplayList[i], properties[i]);
					}
				}
				_prevFrame = _currentFrame;
				_prevDisplayList = _curDisplayList;
			}
		}
		
		public override function render(support:RenderSupport, alpha:Number):void
		{
			super.render(support, alpha);
			if (_currentFrame != _prevFrame)
			{
				runFrameScript();
				updateMember(); 
				updateState(); 
			}
		}
				
		private function updateState():void
		{
			// tween effect
			for (var tweenIndex:int = 0; tweenIndex < _tweenStart.length; ++tweenIndex)
			{
				if (_currentFrame > _tweenStart[tweenIndex] && _currentFrame < _tweenEnd[tweenIndex])
				{
					var delta:int = _tweenEnd[tweenIndex] - _tweenStart[tweenIndex];
					var tweenStartXML:XML = _tweenStartProperties[tweenIndex];
					var tweenEndXML:XML = _tweenEndProperties[tweenIndex];
					
					for (var tweenPropertyIndex:int = 0; tweenPropertyIndex < TWEEN_PROPERTY.length; ++tweenPropertyIndex)
					{		
						if (!(parent as MovieClip).isReversePlay)
							_tweenDisplayObject[TWEEN_PROPERTY_MAP[tweenPropertyIndex]] += (tweenEndXML.attribute(TWEEN_PROPERTY[tweenPropertyIndex]) - tweenStartXML.attribute(TWEEN_PROPERTY[tweenPropertyIndex])) / delta;
						else
							_tweenDisplayObject[TWEEN_PROPERTY_MAP[tweenPropertyIndex]] += (tweenStartXML.attribute(TWEEN_PROPERTY[tweenPropertyIndex]) - tweenEndXML.attribute(TWEEN_PROPERTY[tweenPropertyIndex])) / delta;
					}
					tweenStartXML = null;
					tweenEndXML = null;
				}
			}
		}

		
		private function setProperty(displayObject:DisplayObject, property:Object):void
		{
			setChildIndex(displayObject, property["depth"]);

			for (var propertyIndex:int = 0; propertyIndex < MC_PROPERTY.length; ++propertyIndex)
			{
				displayObject[MC_PROPERTY_MAP[propertyIndex]] = property[MC_PROPERTY_MAP[propertyIndex]];
			}
		}
		
		public function gotoAndStop(frame:*):void
		{
			_currentFrame = frame;
		}
				
	}
}

import com.virtuos.display.MovieClip;

import starling.display.DisplayObject;
import starling.display.Image;

class DisplayList
{
	public var elements:Array = new Array();
	public var properties:Array = new Array();
	
	public function push(displayObject:DisplayObject, property:Object):void
	{
		elements.push(displayObject);
		properties.push(property);
	}
	
	public function remove(displayObject:DisplayObject):void
	{
		for (var i:int = 0; i < elements.length; ++i)
		{
			if (elements[i] == displayObject)
			{
				elements.splice(i, 1);
				properties.splice(i, 1);
				break;
			}
		}
	}
	
	public function distory():void
	{
		if (elements)
		{
			var elementLength:int = elements.length;
			for (var i:int = 0; i < elementLength; ++i)
				elements[i].dispose();
			elements.splice(0, elements.length);
			elements = null;
		}
		if (properties)
		{
			properties.splice(0, properties.length);
			properties = null;
		}
	}
}
