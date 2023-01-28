package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   
   public class AdaptiveStatsListItem extends W3StatisticsListItem
   {
       
      
      private const MAX_LABEL_WIDTH = 390;
      
      private const MAX_LABEL_WIDTH_ARAB = 370;
      
      private const EMPTY_ROW_HEIGHT:Number = 15;
      
      private const EMPTY_ROW_HEIGHT_ARAB:Number = -8;
      
      private const HEADER_SUPER_POS_Y:Number = 16;
      
      private const HEADER_SUPER_POS_X:Number = 18;
      
      private const HEADER_POS_Y:Number = 0;
      
      private const HEADER_POS_X:Number = 0;
      
      private var otherTextFormat:TextFormat;
      
      private var lTextFormat:TextFormat;
      
      public var tfHeader:TextField;
      
      public var mcBackground:MovieClip;
      
      public function AdaptiveStatsListItem()
      {
         super();
         this.mcBackground.visible = false;
         this.lTextFormat = new TextFormat("$NormalFont",24);
         this.otherTextFormat = new TextFormat("$NormalFont",22);
         this.lTextFormat.font = "$NormalFont";
         this.otherTextFormat.font = "$NormalFont";
      }
      
      override public function setData(param1:Object) : void
      {
         var _loc2_:String = null;
         super.setData(param1);
         if(param1)
         {
            validateNow();
            textField.multiline = true;
            if(CoreComponent.isArabicAligmentMode)
            {
               textField.width = this.MAX_LABEL_WIDTH_ARAB;
               textField.defaultTextFormat = this.otherTextFormat;
               textField.setTextFormat(this.otherTextFormat);
            }
            else
            {
               textField.width = this.MAX_LABEL_WIDTH;
               textField.defaultTextFormat = this.lTextFormat;
               textField.setTextFormat(this.lTextFormat);
            }
            textField.htmlText = textField.htmlText;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            if(param1.tag == "Header" || param1.tag == "SuperHeader")
            {
               tfStatValue.visible = false;
               textField.visible = false;
               this.tfHeader.visible = true;
               _loc2_ = String(param1.name);
               this.mcBackground.visible = false;
               if(param1.tag == "SuperHeader")
               {
                  _loc2_ = _loc2_;
                  if(param1.backgroundColor)
                  {
                     this.mcBackground.gotoAndStop(param1.backgroundColor);
                     this.mcBackground.visible = true;
                     this.tfHeader.x = this.HEADER_SUPER_POS_X;
                     this.tfHeader.y = this.HEADER_SUPER_POS_Y;
                     this.tfHeader.textColor = 16777215;
                  }
               }
               else
               {
                  this.tfHeader.x = this.HEADER_POS_X;
                  this.tfHeader.y = this.HEADER_POS_Y;
                  this.tfHeader.textColor = 8944223;
               }
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.tfHeader.htmlText = "<p align=\"right\">" + _loc2_ + "</p>";
               }
               else
               {
                  this.tfHeader.htmlText = _loc2_;
                  this.tfHeader.htmlText = CommonUtils.toUpperCaseSafe(this.tfHeader.htmlText);
               }
            }
            else
            {
               tfStatValue.visible = true;
               textField.visible = true;
               this.tfHeader.visible = false;
            }
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(CoreComponent.isArabicAligmentMode)
         {
            textField.width = this.MAX_LABEL_WIDTH_ARAB;
            textField.defaultTextFormat = this.otherTextFormat;
            textField.setTextFormat(this.otherTextFormat);
         }
         else
         {
            textField.width = this.MAX_LABEL_WIDTH;
            textField.defaultTextFormat = this.lTextFormat;
            textField.setTextFormat(this.lTextFormat);
         }
      }
      
      public function get rendererHeight() : Number
      {
         if(tfStatValue.text == "" && textField.text == "")
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               return this.EMPTY_ROW_HEIGHT_ARAB;
            }
            return this.EMPTY_ROW_HEIGHT;
         }
         if(Boolean(this.mcBackground) && this.mcBackground.visible)
         {
            return this.mcBackground.height;
         }
         if(Boolean(this.tfHeader) && this.tfHeader.visible)
         {
            return this.tfHeader.textHeight;
         }
         if(textField)
         {
            return textField.height;
         }
         return super.actualHeight;
      }
   }
}
