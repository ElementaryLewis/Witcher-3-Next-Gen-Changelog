package
{
   import red.game.witcher3.menus.overlay.QuantityPopup;
   
   public dynamic class QuantityPopupRef extends QuantityPopup
   {
       
      
      public function QuantityPopupRef()
      {
         super();
         this.__setProp_mcSlider_QuantityPopup_slider_0();
      }
      
      internal function __setProp_mcSlider_QuantityPopup_slider_0() : *
      {
         try
         {
            mcSlider["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcSlider.enabled = true;
         mcSlider.enableInitCallback = false;
         mcSlider.enableSounds = false;
         mcSlider.focusable = true;
         mcSlider.liveDragging = true;
         mcSlider.maximum = 10;
         mcSlider.minimum = 0;
         mcSlider.offsetLeft = 15;
         mcSlider.offsetRight = 70;
         mcSlider.snapInterval = 1;
         mcSlider.snapping = true;
         mcSlider.value = 0;
         mcSlider.visible = true;
         try
         {
            mcSlider["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
