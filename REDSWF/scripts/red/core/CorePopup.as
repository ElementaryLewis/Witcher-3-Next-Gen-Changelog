package red.core
{
   import flash.external.ExternalInterface;
   import scaleform.gfx.Extensions;
   
   public class CorePopup extends CoreComponent
   {
       
      
      public function CorePopup()
      {
         super();
      }
      
      override protected function onCoreInit() : void
      {
         this.registerPopup();
      }
      
      public function getPopupName() : String
      {
         return this.popupName;
      }
      
      protected function get popupName() : String
      {
         throw new Error("Override this");
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function toString() : String
      {
         return "CorePopup [ " + this.name + "; " + this.popupName + " ]";
      }
      
      private function registerPopup() : void
      {
         if(Extensions.isScaleform)
         {
            ExternalInterface.call("registerPopup",this.popupName,this);
         }
      }
      
      public function setGameLanguage(param1:String) : *
      {
         CoreComponent.gameLanguage = param1;
      }
   }
}
