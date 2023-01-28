package red.game.witcher3.menus.common
{
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.game.witcher3.constants.CommonConstants;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.managers.InputDelegate;
   import scaleform.clik.ui.InputDetails;
   
   public class TextAreaModuleCustomInput extends TextAreaModule
   {
      
      public static const TEXT_HEADER_PADDING:int = 10;
       
      
      public var _scrollSpeed:Number = 1;
      
      public function TextAreaModuleCustomInput()
      {
         super();
         InputDelegate.getInstance().addEventListener(InputEvent.INPUT,this.handleCustomInput,false,0,true);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         SetAsActiveContainer(true);
         updateInputFeedback();
      }
      
      private function handleCustomInput(param1:InputEvent) : void
      {
         var _loc3_:InputAxisData = null;
         var _loc4_:Number = NaN;
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.code == KeyCode.PAD_RIGHT_STICK_AXIS)
         {
            _loc3_ = InputAxisData(_loc2_.value);
            _loc4_ = _loc3_.yvalue;
            mcScrollbar.position -= _loc4_;
         }
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return false;
      }
      
      override public function SetText(param1:String) : void
      {
         super.SetText(param1);
         mcTextArea.validateNow();
         updateInputFeedback();
      }
      
      override public function SetTitle(param1:String) : void
      {
         super.SetTitle(param1);
         tfTitle.height = tfTitle.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         mcTextArea.y = tfTitle.y + tfTitle.textHeight + TEXT_HEADER_PADDING * 2;
         mcScrollbar.y = mcTextArea.y;
      }
      
      override protected function scrollFocusCheck() : Boolean
      {
         return true;
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
      }
   }
}
