package hud_wolfstatbars_fla
{
   import flash.display.MovieClip;
   
   public dynamic class MC_IMG_AdrenalinePoints_29 extends MovieClip
   {
       
      
      public var mcFocusPoint3:MovieClip;
      
      public var mcFocusPoint2:MovieClip;
      
      public var mcFocusPoint1:MovieClip;
      
      public var mcblink:MovieClip;
      
      public var mcFocusProgressbar:FocusStatusIndicator;
      
      public function MC_IMG_AdrenalinePoints_29()
      {
         super();
         this.__setProp_mcFocusProgressbar_MC_IMG_AdrenalinePoints_adrenalinebar_0();
      }
      
      internal function __setProp_mcFocusProgressbar_MC_IMG_AdrenalinePoints_adrenalinebar_0() : *
      {
         try
         {
            this.mcFocusProgressbar["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcFocusProgressbar.enabled = true;
         this.mcFocusProgressbar.enableInitCallback = false;
         this.mcFocusProgressbar.maximum = 100;
         this.mcFocusProgressbar.minimum = 0;
         this.mcFocusProgressbar.value = 0;
         this.mcFocusProgressbar.visible = true;
         try
         {
            this.mcFocusProgressbar["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
