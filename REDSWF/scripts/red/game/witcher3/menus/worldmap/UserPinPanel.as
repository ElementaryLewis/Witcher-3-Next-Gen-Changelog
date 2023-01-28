package red.game.witcher3.menus.worldmap
{
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.W3ScrollingList;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class UserPinPanel extends UIComponent
   {
       
      
      public var mcUserPin1:UserPinItemRenderer;
      
      public var mcUserPin2:UserPinItemRenderer;
      
      public var mcUserPin3:UserPinItemRenderer;
      
      public var mcUserPin4:UserPinItemRenderer;
      
      public var mcUserPinsList:W3ScrollingList;
      
      public var btnClose:InputFeedbackButton;
      
      public var enableUserPinPanel:Function;
      
      public var setUserMapPin:Function;
      
      public function UserPinPanel()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcUserPinsList.focusable = true;
         this.mcUserPinsList.dataProvider = new DataProvider([{"pinId":"User2"},{"pinId":"User3"},{"pinId":"User4"}]);
         this.mcUserPinsList.validateNow();
         this.mcUserPinsList.addEventListener(ListEvent.ITEM_PRESS,this.handleUserPinsPress,false,0,true);
         this.btnClose.clickable = true;
         this.btnClose.label = "[[panel_common_cancel]]";
         this.btnClose.setDataFromStage("",KeyCode.ESCAPE);
         this.btnClose.visible = true;
         this.btnClose.addEventListener(ButtonEvent.CLICK,this.handleCloseButtonClicked,false,0,true);
         this.btnClose.validateNow();
         this.mcUserPinsList.focusable = false;
         this.mcUserPinsList.bSkipFocusCheck = true;
         this.mcUserPinsList.selectOnOver = true;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         super.handleInput(param1);
         if(param1.handled)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.value == InputValue.KEY_UP;
         if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_X)
         {
            if(_loc3_)
            {
               this.closePanelAndSetUserPin();
               param1.handled = true;
            }
         }
         else if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_B)
         {
            if(_loc3_)
            {
               this.enableUserPinPanel(false);
               param1.handled = true;
            }
         }
         else
         {
            this.mcUserPinsList.handleInput(param1);
         }
      }
      
      private function handleUserPinsPress(param1:ListEvent) : void
      {
         this.closePanelAndSetUserPin();
      }
      
      public function handleCloseButtonClicked(param1:ButtonEvent) : *
      {
         this.enableUserPinPanel(false);
      }
      
      private function closePanelAndSetUserPin() : *
      {
         var _loc1_:int = this.mcUserPinsList.selectedIndex;
         this.enableUserPinPanel(false);
         this.setUserMapPin(_loc1_,true);
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.mcUserPinsList.selectedIndex = 0;
         }
      }
   }
}
