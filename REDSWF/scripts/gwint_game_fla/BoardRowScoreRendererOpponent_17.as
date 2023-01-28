package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class BoardRowScoreRendererOpponent_17 extends MovieClip
   {
       
      
      public var txtScore:txt_BoardRowScoreRenderer;
      
      public function BoardRowScoreRendererOpponent_17()
      {
         super();
         this.__setProp_txtScore_BoardRowScoreRendererOpponent_txtScore_0();
      }
      
      internal function __setProp_txtScore_BoardRowScoreRendererOpponent_txtScore_0() : *
      {
         try
         {
            this.txtScore["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtScore.actAsButton = false;
         this.txtScore.defaultText = "";
         this.txtScore.displayAsPassword = false;
         this.txtScore.editable = false;
         this.txtScore.enabled = true;
         this.txtScore.enableInitCallback = false;
         this.txtScore.focusable = false;
         this.txtScore.maxChars = 0;
         this.txtScore.minThumbSize = 1;
         this.txtScore.scrollBar = "";
         this.txtScore.scrollSpeed = 40;
         this.txtScore.text = "";
         this.txtScore.thumbOffset = {
            "top":0,
            "bottom":0
         };
         this.txtScore.visible = true;
         try
         {
            this.txtScore["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
