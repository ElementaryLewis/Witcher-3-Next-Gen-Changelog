package gwint_game_fla
{
   import flash.display.MovieClip;
   
   public dynamic class mc_PlayerRenderer_Passed_40 extends MovieClip
   {
       
      
      public var txtPassed:txt_PlayerRenderer_Passed;
      
      public function mc_PlayerRenderer_Passed_40()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,38,this.frame39);
         this.__setProp_txtPassed_mc_PlayerRenderer_Passed_txtPassed_0();
      }
      
      internal function __setProp_txtPassed_mc_PlayerRenderer_Passed_txtPassed_0() : *
      {
         try
         {
            this.txtPassed["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.txtPassed.actAsButton = false;
         this.txtPassed.defaultText = "";
         this.txtPassed.displayAsPassword = false;
         this.txtPassed.editable = false;
         this.txtPassed.enabled = true;
         this.txtPassed.enableInitCallback = false;
         this.txtPassed.focusable = false;
         this.txtPassed.maxChars = 0;
         this.txtPassed.minThumbSize = 1;
         this.txtPassed.scrollBar = "";
         this.txtPassed.scrollSpeed = 40;
         this.txtPassed.text = "";
         this.txtPassed.thumbOffset = {
            "top":0,
            "bottom":0
         };
         this.txtPassed.visible = true;
         try
         {
            this.txtPassed["componentInspectorSetting"] = false;
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
      
      internal function frame39() : *
      {
         gotoAndPlay("passed");
      }
   }
}
