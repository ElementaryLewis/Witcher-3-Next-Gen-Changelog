package
{
   import red.game.witcher3.menus.overlay.QuantityMonsterBarganingPopup;
   
   public dynamic class QuantityMonsterBarganingPopupRef extends QuantityMonsterBarganingPopup
   {
       
      
      public function QuantityMonsterBarganingPopupRef()
      {
         super();
         this.__setProp_mcAngerBar_QuantityMonsterBarganingPopup_Layer2_0();
         this.__setProp_mcSlider_QuantityMonsterBarganingPopup_slider_0();
      }
      
      internal function __setProp_mcAngerBar_QuantityMonsterBarganingPopup_Layer2_0() : *
      {
         try
         {
            mcAngerBar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcAngerBar.enabled = true;
         mcAngerBar.enableInitCallback = false;
         mcAngerBar.maximum = 100;
         mcAngerBar.minimum = 0;
         mcAngerBar.value = 0;
         mcAngerBar.visible = true;
         try
         {
            mcAngerBar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcSlider_QuantityMonsterBarganingPopup_slider_0() : *
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
         mcSlider.offsetRight = 80;
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
