package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_PlayerRenderer_Score_opponent_31 extends MovieClip
   {
       
      
      public var txtScore:txt_PlayerRenderer_Score;
      
      public function mc_PlayerRenderer_Score_opponent_31()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,19,this.frame20,34,this.frame35);
         this.__setProp_txtScore_mc_PlayerRenderer_Score_opponent_txtScore_0();
      }
      
      internal function __setProp_txtScore_mc_PlayerRenderer_Score_opponent_txtScore_0() : *
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
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         gotoAndStop("Idle");
      }
      
      internal function frame35() : *
      {
         gotoAndPlay("Idle");
      }
   }
}
