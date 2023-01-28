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
      
      protected function get popupName() : String
      {
         throw new Error("Override this");
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      private function registerPopup() : void
      {
         if(Extensions.isScaleform)
         {
            ExternalInterface.call("registerPopup",this.popupName,this);
         }
      }
   }
}
