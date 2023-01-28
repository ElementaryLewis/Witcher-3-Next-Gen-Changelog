package red.game.witcher3.controls
{
   import red.core.CoreComponent;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class BaseListItem extends ListItemRenderer
   {
       
      
      public var canBePressed:Boolean = true;
      
      public function BaseListItem()
      {
         super();
         doubleClickEnabled = true;
         preventAutosizing = true;
         constraintsDisabled = true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.htmlText = "<p align=\"right\">" + _label + "</p>";
               return;
            }
            textField.htmlText = _label;
         }
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(!param1)
         {
            return;
         }
         if(param1.selected)
         {
            selected = true;
         }
         this.update();
      }
      
      public function hasData() : Boolean
      {
         return data != null;
      }
      
      override protected function updateAfterStateChange() : void
      {
      }
      
      protected function update() : *
      {
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         if(param1.isDefaultPrevented() || !this.canBePressed)
         {
            return;
         }
         var _loc2_:InputDetails = param1.details;
         var _loc3_:* = _loc2_.controllerIndex;
         switch(_loc2_.navEquivalent)
         {
            case NavigationCode.ENTER:
            case NavigationCode.GAMEPAD_A:
               if(_loc2_.value == InputValue.KEY_DOWN)
               {
                  handlePress(_loc3_);
                  param1.handled = true;
               }
               else if(_loc2_.value == InputValue.KEY_UP)
               {
                  if(_pressedByKeyboard)
                  {
                     handleRelease(_loc3_);
                     param1.handled = true;
                  }
               }
         }
      }
      
      public function getRendererWidth() : Number
      {
         return actualWidth;
      }
      
      public function getRendererHeight() : Number
      {
         return actualHeight;
      }
   }
}
