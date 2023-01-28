package
{
   import red.game.witcher3.hud.modules.radialmenu.RadialMenuFieldsContainer;
   
   public dynamic class RadialMenuFields extends RadialMenuFieldsContainer
   {
       
      
      public function RadialMenuFields()
      {
         super();
         this.__setProp_mcRadialMenuItem4_RadialMenuFields_mcRadialMenuItem4_0();
      }
      
      internal function __setProp_mcRadialMenuItem4_RadialMenuFields_mcRadialMenuItem4_0() : *
      {
         try
         {
            mcRadialMenuItem4["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         mcRadialMenuItem4.enabled = true;
         mcRadialMenuItem4.enableInitCallback = false;
         mcRadialMenuItem4.visible = false;
         try
         {
            mcRadialMenuItem4["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
