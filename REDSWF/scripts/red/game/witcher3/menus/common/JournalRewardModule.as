package red.game.witcher3.menus.common
{
   import red.core.CoreMenuModule;
   import red.game.witcher3.slots.SlotBase;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class JournalRewardModule extends CoreMenuModule
   {
       
      
      public var mcRewards:JournalRewards;
      
      public var selectRewardsOnFocus:Boolean = true;
      
      protected var _moduleDisplayName:String = "";
      
      public function JournalRewardModule()
      {
         super();
         dataBindingKey = "journal.objectives.list";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         mouseEnabled = false;
         this.mcRewards.visible = false;
         this.mcRewards.mcRewardGrid.focusable = false;
      }
      
      override public function toString() : String
      {
         return "[W3 JournalRewardModule]";
      }
      
      override public function hasSelectableItems() : Boolean
      {
         var _loc1_:SlotBase = this.mcRewards.mcRewardGrid.getRendererAt(0) as SlotBase;
         if(this.mcRewards.visible == false || _loc1_ == null || _loc1_.data == null)
         {
            return false;
         }
         return true;
      }
      
      public function GetDataBindingKey() : String
      {
         return dataBindingKey;
      }
      
      override public function set focused(param1:Number) : void
      {
         if(param1 == _focused || !_focusable)
         {
            return;
         }
         super.focused = param1;
         if(this.selectRewardsOnFocus)
         {
            this.mcRewards.focused = param1;
            this.mcRewards.mcRewardGrid.selectedIndex = 0;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.handled || !_focused)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:Boolean = _loc2_.value == InputValue.KEY_DOWN || _loc2_.value == InputValue.KEY_HOLD;
         if(_loc3_ && this.mcRewards.enabled)
         {
            this.mcRewards.handleInput(param1);
         }
      }
   }
}
