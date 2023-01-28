package panel_alchemy_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mcCraftedItem_5 extends MovieClip
   {
       
      
      public var mcItem:IconLoader;
      
      public function mcCraftedItem_5()
      {
         super();
         addFrameScript(0,this.frame1,7,this.frame8,8,this.frame9,15,this.frame16);
         this.__setProp_mcItem_mcCraftedItem_mcItem_0();
      }
      
      internal function __setProp_mcItem_mcCraftedItem_mcItem_0() : *
      {
         try
         {
            this.mcItem["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcItem.autoSize = false;
         this.mcItem.enableInitCallback = false;
         this.mcItem.maintainAspectRatio = false;
         this.mcItem.source = "";
         this.mcItem.visible = true;
         try
         {
            this.mcItem["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         stop();
      }
   }
}
