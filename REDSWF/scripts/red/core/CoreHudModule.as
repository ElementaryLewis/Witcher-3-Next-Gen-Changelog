package red.core
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import scaleform.gfx.Extensions;
   
   public class CoreHudModule extends CoreComponent
   {
       
      
      protected var dot:Sprite;
      
      public function CoreHudModule()
      {
         this.dot = new Sprite();
         super();
      }
      
      public function get moduleName() : String
      {
         throw new Error("Override this");
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override protected function onCoreInit() : void
      {
         this.registerModule();
         validateNow();
      }
      
      override protected function onCoreCleanup() : void
      {
         this.unregisterModule();
      }
      
      private function registerModule() : void
      {
         if(!this.moduleName)
         {
            throw new Error("No module name was set.");
         }
         var _loc1_:CoreHud = this.getHud();
         if(_loc1_)
         {
            _loc1_.registerChild(this,this.moduleName);
         }
         else if(Extensions.isScaleform && !Extensions.isGFxPlayer)
         {
            throw new Error("Can\'t find HUD");
         }
      }
      
      private function unregisterModule() : void
      {
         unregisterChild();
      }
      
      private function getHud() : CoreHud
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:DisplayObject = parent;
         while(_loc1_ != _loc2_ && _loc2_ && !(_loc2_ is CoreHud))
         {
            _loc1_ = _loc2_;
            _loc2_ = _loc2_.parent;
         }
         if(!(_loc2_ is CoreHud))
         {
            return null;
         }
         return CoreHud(_loc2_);
      }
      
      public function get stageWidth() : Number
      {
         return stage.stageWidth;
      }
      
      public function get stageHeight() : Number
      {
         return stage.stageHeight;
      }
   }
}
