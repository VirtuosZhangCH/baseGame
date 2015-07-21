package
{
	import com.virtuos.Managers.TimerManager;
	
	/**
	 * 存放一些全局常量变量和方法
	 * 
	 */
	public class GlobalValue
	{
		/** 计时器 */
		public static var timer:TimerManager;
	
		/** 根视图 */
		public static var root:E3Vampire;
		
		/** 主场景 */
		public static var main:main3D;
	
		/**
		 * 初始化游戏 
		 * @param $root 根视图
		 * 
		 */
		public static function init($root:E3Vampire):void
		{
			root=$root;
			timer=new TimerManager();
		}
		
	}
}