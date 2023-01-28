package
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import red.game.witcher3.menus.mainmenu.GamepadMappingModule;
   
   public dynamic class MC_MODULE_GameMap extends GamepadMappingModule
   {
       
      
      public var __setPropDict:Dictionary;
      
      public var __lastFrameProp:int = -1;
      
      public function MC_MODULE_GameMap()
      {
         this.__setPropDict = new Dictionary(true);
         super();
         addFrameScript(0,this.frame1,4,this.frame5,5,this.frame6,8,this.frame9,9,this.frame10,12,this.frame13,13,this.frame14,18,this.frame19);
         this.__setProp_mcRightPCButton_MC_MODULE_GameMap_mcRightPCButton_0();
         this.__setProp_mcLeftPCButton_MC_MODULE_GameMap_mcLeftPCButton_0();
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
      }
      
      internal function __setProp_mcRightPCButton_MC_MODULE_GameMap_mcRightPCButton_0() : *
      {
         try
         {
            mcRightPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRightPCButton.autoRepeat = false;
         mcRightPCButton.autoSize = "none";
         mcRightPCButton.data = "";
         mcRightPCButton.enabled = true;
         mcRightPCButton.enableInitCallback = false;
         mcRightPCButton.focusable = false;
         mcRightPCButton.label = "";
         mcRightPCButton.selected = false;
         mcRightPCButton.showOnGamepad = true;
         mcRightPCButton.showOnMouseKeyboard = true;
         mcRightPCButton.toggle = false;
         mcRightPCButton.visible = true;
         try
         {
            mcRightPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_mcLeftPCButton_MC_MODULE_GameMap_mcLeftPCButton_0() : *
      {
         try
         {
            mcLeftPCButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcLeftPCButton.autoRepeat = false;
         mcLeftPCButton.autoSize = "none";
         mcLeftPCButton.data = "";
         mcLeftPCButton.enabled = true;
         mcLeftPCButton.enableInitCallback = false;
         mcLeftPCButton.focusable = false;
         mcLeftPCButton.label = "";
         mcLeftPCButton.selected = false;
         mcLeftPCButton.showOnGamepad = true;
         mcLeftPCButton.showOnMouseKeyboard = true;
         mcLeftPCButton.toggle = false;
         mcLeftPCButton.visible = true;
         try
         {
            mcLeftPCButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtAButton_MC_MODULE_GameMap_keybindtextareas_0(param1:int) : *
      {
         if(txtAButton != null && param1 >= 1 && param1 <= 5 && (this.__setPropDict[txtAButton] == undefined || !(int(this.__setPropDict[txtAButton]) >= 1 && int(this.__setPropDict[txtAButton]) <= 5)))
         {
            this.__setPropDict[txtAButton] = param1;
            try
            {
               txtAButton["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtAButton.actAsButton = false;
            txtAButton.alignArabicText = true;
            txtAButton.defaultText = "";
            txtAButton.displayAsPassword = false;
            txtAButton.editable = true;
            txtAButton.enabled = true;
            txtAButton.enableInitCallback = false;
            txtAButton.focusable = true;
            txtAButton.maxChars = 0;
            txtAButton.minThumbSize = 1;
            txtAButton.scrollBar = "";
            txtAButton.scrollSpeed = 40;
            txtAButton.text = "";
            txtAButton.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtAButton.visible = true;
            try
            {
               txtAButton["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtBButton_MC_MODULE_GameMap_keybindtextareas_0(param1:int) : *
      {
         if(txtBButton != null && param1 >= 1 && param1 <= 5 && (this.__setPropDict[txtBButton] == undefined || !(int(this.__setPropDict[txtBButton]) >= 1 && int(this.__setPropDict[txtBButton]) <= 5)))
         {
            this.__setPropDict[txtBButton] = param1;
            try
            {
               txtBButton["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtBButton.actAsButton = false;
            txtBButton.alignArabicText = true;
            txtBButton.defaultText = "";
            txtBButton.displayAsPassword = false;
            txtBButton.editable = true;
            txtBButton.enabled = true;
            txtBButton.enableInitCallback = false;
            txtBButton.focusable = true;
            txtBButton.maxChars = 0;
            txtBButton.minThumbSize = 1;
            txtBButton.scrollBar = "";
            txtBButton.scrollSpeed = 40;
            txtBButton.text = "";
            txtBButton.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtBButton.visible = true;
            try
            {
               txtBButton["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_0(param1:int) : *
      {
         if(txtRightBumper != null && param1 >= 1 && param1 <= 5 && (this.__setPropDict[txtRightBumper] == undefined || !(int(this.__setPropDict[txtRightBumper]) >= 1 && int(this.__setPropDict[txtRightBumper]) <= 5)))
         {
            this.__setPropDict[txtRightBumper] = param1;
            try
            {
               txtRightBumper["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtRightBumper.actAsButton = false;
            txtRightBumper.alignArabicText = true;
            txtRightBumper.defaultText = "";
            txtRightBumper.displayAsPassword = false;
            txtRightBumper.editable = true;
            txtRightBumper.enabled = true;
            txtRightBumper.enableInitCallback = false;
            txtRightBumper.focusable = true;
            txtRightBumper.maxChars = 0;
            txtRightBumper.minThumbSize = 1;
            txtRightBumper.scrollBar = "";
            txtRightBumper.scrollSpeed = 40;
            txtRightBumper.text = "";
            txtRightBumper.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtRightBumper.visible = true;
            try
            {
               txtRightBumper["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtAButton_MC_MODULE_GameMap_keybindtextareas_5(param1:int) : *
      {
         if(txtAButton != null && param1 >= 6 && param1 <= 19 && (this.__setPropDict[txtAButton] == undefined || !(int(this.__setPropDict[txtAButton]) >= 6 && int(this.__setPropDict[txtAButton]) <= 19)))
         {
            this.__setPropDict[txtAButton] = param1;
            try
            {
               txtAButton["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtAButton.actAsButton = false;
            txtAButton.alignArabicText = true;
            txtAButton.defaultText = "";
            txtAButton.displayAsPassword = false;
            txtAButton.editable = true;
            txtAButton.enabled = true;
            txtAButton.enableInitCallback = false;
            txtAButton.focusable = true;
            txtAButton.maxChars = 0;
            txtAButton.minThumbSize = 1;
            txtAButton.scrollBar = "";
            txtAButton.scrollSpeed = 40;
            txtAButton.text = "";
            txtAButton.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtAButton.visible = true;
            try
            {
               txtAButton["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtBButton_MC_MODULE_GameMap_keybindtextareas_5(param1:int) : *
      {
         if(txtBButton != null && param1 >= 6 && param1 <= 19 && (this.__setPropDict[txtBButton] == undefined || !(int(this.__setPropDict[txtBButton]) >= 6 && int(this.__setPropDict[txtBButton]) <= 19)))
         {
            this.__setPropDict[txtBButton] = param1;
            try
            {
               txtBButton["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtBButton.actAsButton = false;
            txtBButton.alignArabicText = true;
            txtBButton.defaultText = "";
            txtBButton.displayAsPassword = false;
            txtBButton.editable = true;
            txtBButton.enabled = true;
            txtBButton.enableInitCallback = false;
            txtBButton.focusable = true;
            txtBButton.maxChars = 0;
            txtBButton.minThumbSize = 1;
            txtBButton.scrollBar = "";
            txtBButton.scrollSpeed = 40;
            txtBButton.text = "";
            txtBButton.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtBButton.visible = true;
            try
            {
               txtBButton["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_5(param1:int) : *
      {
         if(txtRightBumper != null && param1 >= 6 && param1 <= 9 && (this.__setPropDict[txtRightBumper] == undefined || !(int(this.__setPropDict[txtRightBumper]) >= 6 && int(this.__setPropDict[txtRightBumper]) <= 9)))
         {
            this.__setPropDict[txtRightBumper] = param1;
            try
            {
               txtRightBumper["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtRightBumper.actAsButton = false;
            txtRightBumper.alignArabicText = true;
            txtRightBumper.defaultText = "";
            txtRightBumper.displayAsPassword = false;
            txtRightBumper.editable = true;
            txtRightBumper.enabled = true;
            txtRightBumper.enableInitCallback = false;
            txtRightBumper.focusable = true;
            txtRightBumper.maxChars = 0;
            txtRightBumper.minThumbSize = 1;
            txtRightBumper.scrollBar = "";
            txtRightBumper.scrollSpeed = 40;
            txtRightBumper.text = "";
            txtRightBumper.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtRightBumper.visible = true;
            try
            {
               txtRightBumper["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_9(param1:int) : *
      {
         if(txtRightBumper != null && param1 >= 10 && param1 <= 19 && (this.__setPropDict[txtRightBumper] == undefined || !(int(this.__setPropDict[txtRightBumper]) >= 10 && int(this.__setPropDict[txtRightBumper]) <= 19)))
         {
            this.__setPropDict[txtRightBumper] = param1;
            try
            {
               txtRightBumper["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            txtRightBumper.actAsButton = false;
            txtRightBumper.alignArabicText = false;
            txtRightBumper.defaultText = "";
            txtRightBumper.displayAsPassword = false;
            txtRightBumper.editable = true;
            txtRightBumper.enabled = true;
            txtRightBumper.enableInitCallback = false;
            txtRightBumper.focusable = true;
            txtRightBumper.maxChars = 0;
            txtRightBumper.minThumbSize = 1;
            txtRightBumper.scrollBar = "";
            txtRightBumper.scrollSpeed = 40;
            txtRightBumper.text = "";
            txtRightBumper.thumbOffset = {
               "top":0,
               "bottom":0
            };
            txtRightBumper.visible = true;
            try
            {
               txtRightBumper["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }
      
      internal function __setProp_handler(param1:Object) : *
      {
         var _loc2_:int = currentFrame;
         if(this.__lastFrameProp == _loc2_)
         {
            return;
         }
         this.__lastFrameProp = _loc2_;
         this.__setProp_txtAButton_MC_MODULE_GameMap_keybindtextareas_0(_loc2_);
         this.__setProp_txtBButton_MC_MODULE_GameMap_keybindtextareas_0(_loc2_);
         this.__setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_0(_loc2_);
         this.__setProp_txtAButton_MC_MODULE_GameMap_keybindtextareas_5(_loc2_);
         this.__setProp_txtBButton_MC_MODULE_GameMap_keybindtextareas_5(_loc2_);
         this.__setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_5(_loc2_);
         this.__setProp_txtRightBumper_MC_MODULE_GameMap_keybindtextareas_9(_loc2_);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame9() : *
      {
         stop();
      }
      
      internal function frame10() : *
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
   }
}
