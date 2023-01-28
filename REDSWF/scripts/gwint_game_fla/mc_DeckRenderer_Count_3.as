package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_DeckRenderer_Count_3 extends MovieClip
   {
       
      
      public var txtCount:txt_DeckRenderer_Count;
      
      public function mc_DeckRenderer_Count_3()
      {
         super();
         this.__setProp_txtCount_mc_DeckRenderer_Count_txtCount_0();
      }
      
      internal function __setProp_txtCount_mc_DeckRenderer_Count_txtCount_0() : *
      {
         try
         {
            this.txtCount["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtCount.actAsButton = false;
         this.txtCount.defaultText = "0";
         this.txtCount.displayAsPassword = false;
         this.txtCount.editable = false;
         this.txtCount.enabled = true;
         this.txtCount.enableInitCallback = false;
         this.txtCount.focusable = false;
         this.txtCount.maxChars = 0;
         this.txtCount.minThumbSize = 1;
         this.txtCount.scrollBar = "";
         this.txtCount.scrollSpeed = 40;
         this.txtCount.text = "";
         this.txtCount.thumbOffset = {
            "top":0,
            "bottom":0
         };
         this.txtCount.visible = true;
         try
         {
            this.txtCount["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
