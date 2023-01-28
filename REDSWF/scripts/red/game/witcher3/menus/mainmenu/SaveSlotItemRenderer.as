package red.game.witcher3.menus.mainmenu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.menus.common.IconItemRenderer;
   
   public class SaveSlotItemRenderer extends IconItemRenderer
   {
      
      public static const TEXT_PADDING = 40;
      
      public static const HIGHLIGHT_PADDING = 30;
      
      public static const TWO_HIGHLIGHT_PADDING = 16;
      
      public static const HIT_PADDING = 15;
      
      public static const LARGE_HIT_PADDING = 7;
      
      public static const CST_INVALID = 10;
      
      public static const CST_LOCAL = 20;
      
      public static const CST_CLOUD = 30;
      
      public static const CST_INSYNC = 40;
      
      public static const CST_CONFILCT = 50;
      
      public static const CST_UPLOAD = 60;
      
      public static const CST_ROLL = 70;
       
      
      public var txtSlotType:TextField;
      
      public var mcSelection:MovieClip;
      
      public var mcHighlightFrame:MovieClip;
      
      public var mcHitArea:MovieClip;
      
      private var saveTextColor:Number;
      
      public function SaveSlotItemRenderer()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.saveTextColor = 10066329;
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            this.setSaveType(param1.saveType);
            this.setCloudStatus(param1.cloudStatus);
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
                  _loc3_ = PlatformType.getPlatformSpecificResourceString(_loc2_,"save_slot_type_auto");
                  this.saveTextColor = 10066329;
                  break;
               case 2:
                  _loc3_ = PlatformType.getPlatformSpecificResourceString(_loc2_,"save_slot_type_quick");
                  this.saveTextColor = 13800778;
                  break;
               case 3:
                  _loc3_ = PlatformType.getPlatformSpecificResourceString(_loc2_,"save_slot_type_manual");
                  this.saveTextColor = 5091642;
                  break;
               case 4:
               case 5:
                  _loc3_ = PlatformType.getPlatformSpecificResourceString(_loc2_,"save_slot_type_checkpoint");
                  this.saveTextColor = 10066329;
            }
            this.txtSlotType.htmlText = "<p align=\"right\">" + _loc3_ + "</p>";
            this.txtSlotType.textColor = this.saveTextColor;
         }
      }
      
      private function setCloudStatus(param1:int) : void
      {
         var _loc2_:Boolean = true;
         if(mcIconLoader)
         {
            switch(param1)
            {
               case CST_INVALID:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_cross.png";
                  break;
               case CST_LOCAL:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_arrow_up.png";
                  _loc2_ = false;
                  break;
               case CST_CLOUD:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_arrow_down.png";
                  break;
               case CST_INSYNC:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_tick_mark.png";
                  break;
               case CST_UPLOAD:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_arrow_up.png";
                  break;
               case CST_CONFILCT:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_exclaim.png";
                  break;
               case CST_ROLL:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_roll.png";
                  break;
               default:
                  mcIconLoader.source = "img://icons\\cloud\\cloud_empty.png";
            }
            mcIconLoader.visible = _loc2_;
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this.mcSelection)
         {
            this.mcSelection.visible = selected;
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(_label != null && textField != null)
         {
            if(!CoreComponent.isArabicAligmentMode && data && data.tag != -1)
            {
               _loc1_ = _label.lastIndexOf("-");
               if(_loc1_ != -1)
               {
                  _loc2_ = _label.slice(_loc1_);
                  _loc3_ = _label.slice(0,_loc1_ - 1);
                  textField.htmlText = _loc3_ + " <font color=\'#FFFFFF\'>" + _loc2_;
               }
               else
               {
                  textField.htmlText = _label;
               }
               textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            }
            else
            {
               textField.htmlText = _label;
            }
            if(textField.numLines > 1)
            {
               textField.y = -5.2;
               this.mcHitArea.height = textField.textHeight + HIT_PADDING;
               this.mcHighlightFrame.height = textField.textHeight + LARGE_HIT_PADDING;
               this.mcSelection.height = textField.textHeight + HIGHLIGHT_PADDING;
            }
            else
            {
               this.mcHitArea.height = textField.textHeight + HIT_PADDING;
               textField.y = 4.75;
               this.mcHighlightFrame.height = textField.textHeight + HIGHLIGHT_PADDING;
               this.mcSelection.height = textField.textHeight + TEXT_PADDING;
            }
         }
      }
   }
}
