package red.game.witcher3.menus.perks_menu
{
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.slots.SlotsListCategorized;
   
   public class ModuleSkillList extends CoreMenuModule
   {
       
      
      public var mcPlayerGrid:SlotsListCategorized;
      
      public var textField:TextField;
      
      public function ModuleSkillList()
      {
         super();
         this.mcPlayerGrid.disableGroupTitle = true;
         this.mcPlayerGrid.itemPadding = 0;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey,[this.handleDataSet]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,dataBindingKey + ".name",[this.handleTitleSet]));
      }
      
      protected function handleDataSet(param1:Object) : void
      {
         this.mcPlayerGrid.data = param1 as Array;
      }
      
      protected function handleTitleSet(param1:String) : void
      {
         this.textField.htmlText = param1;
      }
      
      override public function set focused(param1:Number) : void
      {
         super.focused = param1;
         this.mcPlayerGrid.focused = _focused;
         if(this.mcPlayerGrid.selectedIndex < 0)
         {
            this.mcPlayerGrid.selectedIndex = 0;
         }
         if(this.focused > 0)
         {
            this.bindModule();
         }
      }
      
      protected function bindModule() : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnModuleSelected",[this.dataBindingKey]));
      }
   }
}
