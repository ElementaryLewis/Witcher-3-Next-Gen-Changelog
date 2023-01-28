package red.game.witcher3.menus.mainmenu
{
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.IconItemRenderer;
   
   public class SaveSlotItemRenderer extends IconItemRenderer
   {
       
      
      public var txtSlotType:TextField;
      
      public function SaveSlotItemRenderer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            this.setSaveType(param1.saveType);
         }
      }
      
      private function setSaveType(param1:int) : void
      {
         var _loc3_:String = null;
         var _loc2_:uint = InputManager.getInstance().getPlatform();
         if(this.txtSlotType)
         {
            switch(param1)
            {
               case 1:
                  if(_loc2_ == CommonConstants.PLATFORM_XBOX1)
                  {
                     _loc3_ = "[[save_slot_type_auto_x1]]";
                  }
                  else if(_loc2_ == CommonConstants.PLATFORM_PS4)
                  {
                     _loc3_ = "[[save_slot_type_auto_ps4]]";
                  }
                  else
                  {
                     _loc3_ = "[[save_slot_type_auto]]";
                  }
                  break;
               case 2:
                  if(_loc2_ == CommonConstants.PLATFORM_XBOX1)
                  {
                     _loc3_ = "[[save_slot_type_quick_x1]]";
                  }
                  else if(_loc2_ == CommonConstants.PLATFORM_PS4)
                  {
                     _loc3_ = "[[save_slot_type_quick_ps4]]";
                  }
                  else
                  {
                     _loc3_ = "[[save_slot_type_quick]]";
                  }
                  break;
               case 3:
                  if(_loc2_ == CommonConstants.PLATFORM_XBOX1)
                  {
                     _loc3_ = "[[save_slot_type_manual_x1]]";
                  }
                  else if(_loc2_ == CommonConstants.PLATFORM_PS4)
                  {
                     _loc3_ = "[[save_slot_type_manual_ps4]]";
                  }
                  else
                  {
                     _loc3_ = "[[save_slot_type_manual]]";
                  }
                  break;
               case 4:
               case 5:
                  if(_loc2_ == CommonConstants.PLATFORM_XBOX1)
                  {
                     _loc3_ = "[[save_slot_type_checkpoint_x1]]";
                  }
                  else if(_loc2_ == CommonConstants.PLATFORM_PS4)
                  {
                     _loc3_ = "[[save_slot_type_checkpoint_ps4]]";
                  }
                  else
                  {
                     _loc3_ = "[[save_slot_type_checkpoint]]";
                  }
            }
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtSlotType.htmlText = "<p align=\"left\">" + _loc3_ + "</p>";
            }
            else
            {
               this.txtSlotType.htmlText = "<p align=\"right\">" + _loc3_ + "</p>";
            }
         }
      }
      
      override protected function updateText() : void
      {
         if(_label != null && textField != null)
         {
            textField.htmlText = _label;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         }
      }
   }
}
