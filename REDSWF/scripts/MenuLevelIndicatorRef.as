package
{
   import red.game.witcher3.menus.common_menu.MenuLevelIndicator;
   
   public dynamic class MenuLevelIndicatorRef extends MenuLevelIndicator
   {
       
      
      public function MenuLevelIndicatorRef()
      {
         super();
         this.__setProp_levelProgress_LevelIndicator_progressbar_0();
      }
      
      internal function __setProp_levelProgress_LevelIndicator_progressbar_0() : *
      {
         try
         {
            levelProgress["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         levelProgress.enabled = true;
         levelProgress.enableInitCallback = false;
         levelProgress.maximum = -1;
         levelProgress.minimum = -1;
         levelProgress.value = -1;
         levelProgress.visible = true;
         try
         {
            levelProgress["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
