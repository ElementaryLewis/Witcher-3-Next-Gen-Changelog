package red.game.witcher3.menus.glossary
{
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.menus.common.JournalRewardModule;
   
   public class GlossarySubListModule extends JournalRewardModule
   {
       
      
      public var mcLoader:W3UILoader;
      
      public function GlossarySubListModule()
      {
         super();
         mcRewards.titleString = "[[panel_glossary_recommended]]";
         dataBindingKey = "glossary.bestiary.sublist";
         mcRewards.dataBindingKeyReward = "glossary.bestiary.sublist.items";
         mcRewards.activeSelectionVisible = false;
      }
      
      override protected function configUI() : void
      {
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".image",[this.handleSetImage]));
         super.configUI();
         mcRewards.visible = true;
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         mcRewards.activeSelectionVisible = param1;
      }
      
      override public function toString() : String
      {
         return "[W3 GlossarySubListModule]";
      }
      
      public function handleSetImage(param1:String) : void
      {
         handleDataChanged();
         this.mcLoader.source = "img://textures/journal/bestiary/" + param1;
      }
   }
}
