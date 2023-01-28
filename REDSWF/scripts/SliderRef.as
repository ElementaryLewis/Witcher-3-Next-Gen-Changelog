package
{
   import red.game.witcher3.controls.W3QuantitySlider;
   
   public dynamic class SliderRef extends W3QuantitySlider
   {
       
      
      public function SliderRef()
      {
         super();
         addFrameScript(9,this.frame10,19,this.frame20,29,this.frame30);
         this.__setProp_btnLeft_Slider_buttons_0();
         this.__setProp_btnRight_Slider_buttons_0();
      }
      
      internal function __setProp_btnLeft_Slider_buttons_0() : *
      {
         try
         {
            btnLeft["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         btnLeft.autoRepeat = false;
         btnLeft.autoSize = "none";
         btnLeft.data = "";
         btnLeft.enabled = true;
         btnLeft.enableInitCallback = false;
         btnLeft.focusable = false;
         btnLeft.label = "";
         btnLeft.selected = false;
         btnLeft.toggle = false;
         btnLeft.visible = true;
         try
         {
            btnLeft["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnRight_Slider_buttons_0() : *
      {
         try
         {
            btnRight["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         btnRight.autoRepeat = false;
         btnRight.autoSize = "none";
         btnRight.data = "";
         btnRight.enabled = true;
         btnRight.enableInitCallback = false;
         btnRight.focusable = false;
         btnRight.label = "";
         btnRight.selected = false;
         btnRight.toggle = false;
         btnRight.visible = true;
         try
         {
            btnRight["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame10() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         stop();
      }
   }
}
