package
{
   import red.game.witcher3.menus.preparation_menu.TrackedMonsterInfo;
   
   public dynamic class mcMonsterInfo extends TrackedMonsterInfo
   {
       
      
      public function mcMonsterInfo()
      {
         super();
         this.__setProp_txtDescription_mcMonsterInfo_txtDescription_0();
      }
      
      internal function __setProp_txtDescription_mcMonsterInfo_txtDescription_0() : *
      {
         try
         {
            txtDescription["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         txtDescription.actAsButton = false;
         txtDescription.defaultText = "";
         txtDescription.displayAsPassword = false;
         txtDescription.editable = false;
         txtDescription.enabled = true;
         txtDescription.enableInitCallback = false;
         txtDescription.focusable = true;
         txtDescription.maxChars = 0;
         txtDescription.minThumbSize = 1;
         txtDescription.scrollBar = "mcScrollbar";
         txtDescription.text = "";
         txtDescription.thumbOffset = {
            "top":0,
            "bottom":0
         };
         txtDescription.visible = true;
         try
         {
            txtDescription["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
