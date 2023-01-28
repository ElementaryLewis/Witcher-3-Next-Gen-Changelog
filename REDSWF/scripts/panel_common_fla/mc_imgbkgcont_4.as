package panel_common_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_imgbkgcont_4 extends MovieClip
   {
       
      
      public var mcImageLoader:IconLoader;
      
      public function mc_imgbkgcont_4()
      {
         super();
         this.__setProp_mcImageLoader_mc_imgbkgcont_imgloader_0();
      }
      
      internal function __setProp_mcImageLoader_mc_imgbkgcont_imgloader_0() : *
      {
         try
         {
            this.mcImageLoader["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcImageLoader.autoSize = false;
         this.mcImageLoader.enableInitCallback = false;
         this.mcImageLoader.maintainAspectRatio = false;
         this.mcImageLoader.source = "";
         this.mcImageLoader.visible = true;
         try
         {
            this.mcImageLoader["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
