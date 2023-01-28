package red.game.witcher3.menus.blacksmith
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import scaleform.clik.constants.NavigationCode;
   
   public class ItemRepairInfo extends BlacksmithItemPanel
   {
       
      
      public var txtDurabilityLabel:TextField;
      
      public var txtDurabilityValue:TextField;
      
      public var btnRepairAll:InputFeedbackButton;
      
      public function ItemRepairInfo()
      {
         super();
         this.txtDurabilityLabel.text = "[[panel_inventory_tooltip_durability]]";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.btnRepairAll.label = "[[repair_equipped_items]]";
         this.btnRepairAll.setDataFromStage(NavigationCode.GAMEPAD_X,KeyCode.SPACE);
         this.btnRepairAll.visible = false;
         this.btnRepairAll.validateNow();
         this.btnRepairAll.addEventListener(MouseEvent.CLICK,this.handleRepairClick,false,0,true);
      }
      
      override protected function updateData() : void
      {
         super.updateData();
         if(_data.durability)
         {
            this.txtDurabilityLabel.visible = true;
            this.txtDurabilityValue.text = Math.round(_data.durability) + " %";
            this.txtDurabilityValue.visible = true;
         }
      }
      
      override protected function cleanupView() : void
      {
         super.cleanupView();
         this.txtDurabilityValue.text = "";
         this.txtDurabilityValue.visible = false;
         this.txtDurabilityLabel.visible = false;
      }
      
      private function handleRepairClick(param1:Event) : void
      {
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnRepairAllItems"));
      }
   }
}
