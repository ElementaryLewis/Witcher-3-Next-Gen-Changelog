package red.core
{
   import flash.external.ExternalInterface;
   import scaleform.gfx.Extensions;
   
   public class CoreHud extends CoreComponent
   {
       
      
      public function CoreHud()
      {
         super();
         _enableHoldEmulation = false;
         _enableInputDeviceCheck = false;
      }
      
      public function get hudName() : String
      {
         throw new Error("Override this");
      }
      
      override protected function onCoreInit() : void
      {
         this.registerHud();
      }
      
      override public function toString() : String
      {
         return "CoreHud [ " + this.name + "; " + this.hudName + " ]";
      }
      
      private function registerHud() : void
      {
         if(Extensions.isScaleform)
         {
            ExternalInterface.call("registerHud",this.hudName,this);
         }
      }
      
      protected function loadModule(param1:String, param2:int) : void
      {
      }
      
      protected function unloadModule(param1:String, param2:int) : void
      {
      }
      
      public function _HOOK_loadModule(param1:String, param2:int = -1) : void
      {
         this.loadModule(param1,param2);
      }
      
      public function _HOOK_unloadModule(param1:String, param2:int = -1) : void
      {
         this.unloadModule(param1,param2);
      }
   }
}
