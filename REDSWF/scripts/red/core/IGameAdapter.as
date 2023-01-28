package red.core
{
   import flash.display.DisplayObject;
   
   public interface IGameAdapter
   {
       
      
      function registerDataBinding(param1:String, param2:Object, param3:Object = null, param4:Boolean = false) : void;
      
      function unregisterDataBinding(param1:String, param2:Object, param3:Object = null) : void;
      
      function registerChild(param1:DisplayObject, param2:String) : void;
      
      function unregisterChild() : void;
      
      function callGameEvent(param1:String, param2:Array) : void;
      
      function registerRenderTarget(param1:String, param2:uint, param3:uint) : void;
      
      function unregisterRenderTarget(param1:String) : void;
   }
}
