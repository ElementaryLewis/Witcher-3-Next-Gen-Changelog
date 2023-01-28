package red.game.witcher3.controls
{
   import red.game.witcher3.utils.CommonUtils;
   
   public class InputFeedbackButtonCustom extends InputFeedbackButton
   {
      
      protected static const TEXT_OFFSET_HIGH:Number = 20;
       
      
      public function InputFeedbackButtonCustom()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override protected function updateText() : void
      {
         var _loc1_:KeyboardButtonClickArea = null;
         if(_label != null && textField != null)
         {
            if(_overrideTextColor >= 0)
            {
               textField.textColor = _overrideTextColor;
               textField.text = _label;
            }
            else
            {
               textField.htmlText = _label;
            }
            if(_lowercaseLabels)
            {
               textField.text = CommonUtils.toLowerCaseExSafe(textField.text);
            }
            textField.height = textField.textHeight + TEXT_OFFSET;
            if(Boolean(mcClickRect) && mcClickRect.visible)
            {
               _loc1_ = mcClickRect as KeyboardButtonClickArea;
               if(_loc1_)
               {
                  _loc1_.state = state;
                  _loc1_.setActualSize(textField.textWidth + TEXT_OFFSET_HIGH,tfKeyLabel.height + textField.textHeight + TEXT_OFFSET_HIGH + TEXT_OFFSET);
                  mcClickRect.x = textField.x + textField.width / 2;
                  mcClickRect.y = tfKeyLabel.y - TEXT_OFFSET;
                  mcClickRect.visible = true;
               }
               else if(mcClickRect)
               {
                  mcClickRect.visible = false;
               }
            }
         }
      }
      
      override protected function displayKeyboardIcon() : void
      {
         super.displayKeyboardIcon();
         tfKeyLabel.x = textField.x + textField.width / 2 - tfKeyLabel.width / 2;
      }
   }
}
