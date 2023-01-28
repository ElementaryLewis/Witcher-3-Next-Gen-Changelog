package
{
   import red.game.witcher3.popups.SystemMessageModule;
   
   public dynamic class SystemMessageModuleRef extends SystemMessageModule
   {
       
      
      public function SystemMessageModuleRef()
      {
         super();
         this.__setProp_tfMessage_SystemMessageModule_tfMessage_0();
      }
      
      internal function __setProp_tfMessage_SystemMessageModule_tfMessage_0() : *
      {
         try
         {
            tfMessage["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         tfMessage.actAsButton = false;
         tfMessage.alignArabicText = false;
         tfMessage.defaultText = "";
         tfMessage.displayAsPassword = false;
         tfMessage.editable = false;
         tfMessage.enabled = true;
         tfMessage.enableInitCallback = false;
         tfMessage.focusable = true;
         tfMessage.maxChars = 0;
         tfMessage.minThumbSize = 1;
         tfMessage.scrollBar = "messageScrollbar";
         tfMessage.scrollSpeed = 40;
         tfMessage.text = "";
         tfMessage.thumbOffset = {
            "top":0,
            "bottom":0
         };
         tfMessage.visible = true;
         try
         {
            tfMessage["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
