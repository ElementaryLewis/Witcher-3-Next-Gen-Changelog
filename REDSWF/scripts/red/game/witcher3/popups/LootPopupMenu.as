package red.game.witcher3.popups
{
   import red.core.CorePopup;
   import red.core.events.GameEvent;
   import red.game.witcher3.hud.modules.lootpopup.HudLootItemModule;
   import scaleform.clik.events.InputEvent;
   
   public class LootPopupMenu extends CorePopup
   {
       
      
      public var mcLootItemModule:HudLootItemModule;
      
      public function LootPopupMenu()
      {
         super();
         _enableInputValidation = true;
         this.mcLootItemModule.mcInputFeedback.filterKeyCodeFunction = isKeyCodeValid;
         this.mcLootItemModule.mcInputFeedback.filterNavCodeFunction = isNavEquivalentValid;
      }
      
      override protected function get popupName() : String
      {
         return "LootPopup";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         registerDataBinding("LootItemList",this.mcLootItemModule.handleItemListData);
         stage.addEventListener(InputEvent.INPUT,this.mcLootItemModule.handleInput,false,0,true);
         this.mcLootItemModule._bWaitForKey = true;
         this.mcLootItemModule.visible = false;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function SetWindowTitle(param1:String) : *
      {
         this.mcLootItemModule.tfTitle.text = param1;
      }
      
      public function SetWindowScale(param1:Number) : *
      {
         this.mcLootItemModule.scaleX = param1;
         this.mcLootItemModule.scaleY = param1;
         this.mcLootItemModule.visible = true;
      }
      
      public function resizeBackground(param1:Boolean) : void
      {
         this.mcLootItemModule.resizeBackground(param1);
      }
      
      public function SetSelectionIndex(param1:int) : *
      {
         this.mcLootItemModule.m_indexToSelect = param1;
      }
   }
}
