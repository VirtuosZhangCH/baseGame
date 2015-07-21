package com.virtuos.animation
{
	public interface IDestroy
	{
		function destroy(isDel:Boolean=true):void;
		/** 移除所有child */
		function removeAllChildren():void;
		/** 移除所有事件监听 */
		function removeAllListener():void;
		/** 将所有引用变量置空 */
		function nullAllReference():void;
	}
}