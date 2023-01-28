package red.game.witcher3.hud.modules.lootpopup
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.BaseListItem;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.menus.common.ColorSprite;
   
   public class HudLootItemsListItem extends BaseListItem
   {
      
      private static const TEXT_PADDING:Number = 4;
      
      private static const READ_BOOK_ALPHA:Number = 0.3;
       
      
      private var bTakeAllItem:Boolean = false;
      
      public var tfType:TextField;
      
      public var tfQuantity:TextField;
      
      public var mcFrame:MovieClip;
      
      public var mcIconLoader:W3UILoader;
      
      public var mcColorBackground:ColorSprite;
      
      public var genStatsList:RenderersList;
      
      public var mcQuestIndicator:MovieClip;
      
      public function HudLootItemsListItem()
      {
         super();
         this.tfType.text = "";
         this.tfQuantity.text = "";
         textField.text = "";
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function setStateOver() : *
      {
         this.setState("over");
      }
      
      override public function setData(param1:Object) : void
      {
         if(param1)
         {
            if(Boolean(param1.label) && param1.label != "")
            {
               super.setData(param1);
            }
            if(param1.quantity && this.tfQuantity && param1.quantity > 1)
            {
               this.tfQuantity.text = "x" + param1.quantity;
            }
            else
            {
               this.tfQuantity.text = "";
            }
            if(Boolean(param1.iconPath) && Boolean(this.mcIconLoader))
            {
               if(param1.iconPath != "")
               {
                  this.mcIconLoader.source = "img://" + param1.iconPath;
               }
               else
               {
                  this.mcIconLoader.source = "";
               }
            }
            if(this.mcIconLoader)
            {
               this.mcIconLoader.alpha = !!param1.isRead ? READ_BOOK_ALPHA : 1;
            }
            if(this.mcQuestIndicator)
            {
               if(param1.isQuestItem)
               {
                  this.mcQuestIndicator.visible = true;
                  this.mcQuestIndicator.gotoAndStop(param1.questTag);
               }
               else
               {
                  this.mcQuestIndicator.visible = false;
               }
            }
            if(Boolean(this.mcColorBackground) && Boolean(param1.quality))
            {
               this.mcColorBackground.visible = true;
               this.mcColorBackground.colorBlind = CoreComponent.isColorBlindMode;
               this.mcColorBackground.setByItemQuality(_data.quality);
            }
            else
            {
               this.mcColorBackground.visible = false;
            }
            if(Boolean(this.genStatsList) && Boolean(param1.genericStats))
            {
               this.genStatsList.dataList = param1.genericStats;
               this.genStatsList.validateNow();
            }
            this.updateTypeText();
         }
         else
         {
            visible = false;
         }
      }
      
      override protected function updateText() : void
      {
         var _loc1_:* = 30;
         var _loc2_:* = 47;
         var _loc3_:* = 17;
         var _loc4_:* = 6;
         var _loc5_:* = 53;
         var _loc6_:* = 58;
         var _loc7_:* = 34;
         var _loc8_:* = 30;
         super.updateText();
         this.updateTypeText();
         textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(textField.numLines > 1 && !CoreComponent.isArabicAligmentMode || CoreComponent.isArabicAligmentMode && textField.height > _loc7_)
         {
            textField.y = _loc4_;
            this.tfType.y = _loc6_;
         }
         else if(Boolean(data) && Boolean(data.itemType))
         {
            textField.y = _loc3_;
            this.tfType.y = _loc2_;
         }
         else
         {
            textField.y = _loc1_;
            this.tfType.y = _loc2_;
         }
      }
      
      protected function updateTypeText() : void
      {
         if(Boolean(data) && Boolean(data.itemType))
         {
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfType.htmlText = "<p align=\"right\">" + data.itemType + "</p>";
            }
            else
            {
               this.tfType.htmlText = data.itemType;
            }
         }
         else
         {
            this.tfType.htmlText = "";
         }
      }
   }
}
