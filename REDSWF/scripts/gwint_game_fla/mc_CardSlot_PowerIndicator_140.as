package gwint_game_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.utils.Dictionary;
   
   public dynamic class mc_CardSlot_PowerIndicator_140 extends MovieClip
   {
       
      
      public var txtPower:txt_CardSlot_Power;
      
      public var __setPropDict:Dictionary;
      
      public var __lastFrameProp:int = -1;
      
      public function mc_CardSlot_PowerIndicator_140()
      {
         this.__setPropDict = new Dictionary(true);
         super();
         addFrameScript(0,this.frame1,6,this.frame7,7,this.frame8,12,this.frame13,13,this.frame14,18,this.frame19,26,this.frame27,32,this.frame33,37,this.frame38,42,this.frame43,49,this.frame50,54,this.frame55,55,this.frame56,60,this.frame61,61,this.frame62,66,this.frame67);
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
      }
      
      internal function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(curFrame:int) : *
      {
         if(this.txtPower != null && curFrame >= 1 && curFrame <= 13 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 1 && int(this.__setPropDict[this.txtPower]) <= 13)))
         {
            this.__setPropDict[this.txtPower] = curFrame;
            try
            {
               this.txtPower["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.txtPower.actAsButton = false;
            this.txtPower.defaultText = "";
            this.txtPower.displayAsPassword = false;
            this.txtPower.editable = false;
            this.txtPower.enabled = true;
            this.txtPower.enableInitCallback = false;
            this.txtPower.focusable = false;
            this.txtPower.maxChars = 0;
            this.txtPower.minThumbSize = 1;
            this.txtPower.scrollBar = "";
            this.txtPower.scrollSpeed = 40;
            this.txtPower.text = "";
            this.txtPower.thumbOffset = {
               "top":0,
               "bottom":0
            };
            this.txtPower.visible = true;
            try
            {
               this.txtPower["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(curFrame:int) : *
      {
         if(this.txtPower != null && curFrame >= 14 && curFrame <= 67 && (this.__setPropDict[this.txtPower] == undefined || !(int(this.__setPropDict[this.txtPower]) >= 14 && int(this.__setPropDict[this.txtPower]) <= 67)))
         {
            this.__setPropDict[this.txtPower] = curFrame;
            try
            {
               this.txtPower["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.txtPower.actAsButton = false;
            this.txtPower.defaultText = "";
            this.txtPower.displayAsPassword = false;
            this.txtPower.editable = false;
            this.txtPower.enabled = true;
            this.txtPower.enableInitCallback = false;
            this.txtPower.focusable = false;
            this.txtPower.maxChars = 0;
            this.txtPower.minThumbSize = 1;
            this.txtPower.scrollBar = "";
            this.txtPower.scrollSpeed = 40;
            this.txtPower.text = "";
            this.txtPower.thumbOffset = {
               "top":0,
               "bottom":0
            };
            this.txtPower.visible = false;
            try
            {
               this.txtPower["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_handler(e:Object) : *
      {
         var curFrame:int = currentFrame;
         if(this.__lastFrameProp == curFrame)
         {
            return;
         }
         this.__lastFrameProp = curFrame;
         this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_0(curFrame);
         this.__setProp_txtPower_mc_CardSlot_PowerIndicator_txtPower_13(curFrame);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame7() : *
      {
         stop();
      }
      
      internal function frame8() : *
      {
         stop();
      }
      
      internal function frame13() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         stop();
      }
      
      internal function frame19() : *
      {
         stop();
      }
      
      internal function frame27() : *
      {
         stop();
      }
      
      internal function frame33() : *
      {
         stop();
      }
      
      internal function frame38() : *
      {
         stop();
      }
      
      internal function frame43() : *
      {
         stop();
      }
      
      internal function frame50() : *
      {
         stop();
      }
      
      internal function frame55() : *
      {
         stop();
      }
      
      internal function frame56() : *
      {
         stop();
      }
      
      internal function frame61() : *
      {
         stop();
      }
      
      internal function frame62() : *
      {
         stop();
      }
      
      internal function frame67() : *
      {
         stop();
      }
   }
}
