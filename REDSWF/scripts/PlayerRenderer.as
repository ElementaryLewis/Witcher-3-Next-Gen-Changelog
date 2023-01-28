package
{
   import red.game.witcher3.menus.gwint.GwintPlayerRenderer;
   
   public dynamic class PlayerRenderer extends GwintPlayerRenderer
   {
       
      
      public function PlayerRenderer()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,5,this.frame6,12,this.frame13);
         this.__setProp_txtCardCount_PlayerRenderer_txtCardCount_0();
         this.__setProp_txtFactionName_PlayerRenderer_txtFactionName_0();
         this.__setProp_txtPlayerName_PlayerRenderer_txtPlayerName_0();
      }
      
      internal function __setProp_txtCardCount_PlayerRenderer_txtCardCount_0() : *
      {
         try
         {
            txtCardCount["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtCardCount.actAsButton = false;
         txtCardCount.defaultText = "";
         txtCardCount.displayAsPassword = false;
         txtCardCount.editable = false;
         txtCardCount.enabled = true;
         txtCardCount.enableInitCallback = false;
         txtCardCount.focusable = false;
         txtCardCount.maxChars = 0;
         txtCardCount.minThumbSize = 1;
         txtCardCount.scrollBar = "";
         txtCardCount.scrollSpeed = 40;
         txtCardCount.text = "";
         txtCardCount.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtCardCount.visible = true;
         try
         {
            txtCardCount["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtFactionName_PlayerRenderer_txtFactionName_0() : *
      {
         try
         {
            txtFactionName["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtFactionName.actAsButton = false;
         txtFactionName.defaultText = "";
         txtFactionName.displayAsPassword = false;
         txtFactionName.editable = false;
         txtFactionName.enabled = true;
         txtFactionName.enableInitCallback = false;
         txtFactionName.focusable = false;
         txtFactionName.maxChars = 0;
         txtFactionName.minThumbSize = 1;
         txtFactionName.scrollBar = "";
         txtFactionName.scrollSpeed = 40;
         txtFactionName.text = "";
         txtFactionName.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtFactionName.visible = true;
         try
         {
            txtFactionName["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_txtPlayerName_PlayerRenderer_txtPlayerName_0() : *
      {
         try
         {
            txtPlayerName["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtPlayerName.actAsButton = false;
         txtPlayerName.defaultText = "";
         txtPlayerName.displayAsPassword = false;
         txtPlayerName.editable = false;
         txtPlayerName.enabled = true;
         txtPlayerName.enableInitCallback = false;
         txtPlayerName.focusable = false;
         txtPlayerName.maxChars = 0;
         txtPlayerName.minThumbSize = 1;
         txtPlayerName.scrollBar = "";
         txtPlayerName.scrollSpeed = 40;
         txtPlayerName.text = "";
         txtPlayerName.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtPlayerName.visible = true;
         try
         {
            txtPlayerName["componentInspectorSetting"] = false;
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
      
      internal function frame6() : *
      {
         stop();
      }
      
      internal function frame13() : *
      {
         stop();
      }
   }
}
