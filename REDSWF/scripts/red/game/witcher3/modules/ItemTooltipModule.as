package red.game.witcher3.modules
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import red.core.CoreComponent;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.tooltips.TooltipPrimaryStat;
   import red.game.witcher3.utils.CommonUtils;
   
   public class ItemTooltipModule extends CoreMenuModule
   {
      
      protected static const PRIM_BLOCK_PADDING:Number = 10;
      
      protected static const LIST_BLOCK_PADDING:Number = 12;
      
      protected static const LEVEL_BLOCK_PADDING:Number = 10;
      
      protected static const WEIGHT_BLOCK_PADDING:Number = 15;
      
      protected static const STATS_BLOCK_PADDING:Number = 8;
      
      protected static const HEADER_DESCR_PADDING:Number = 20;
      
      protected static const BLOCK_PADDING:Number = 8;
      
      protected static const BLOCK_PADDING_SMALL:Number = 3;
      
      protected static const DESCRIPTION_PADDING:Number = 8;
      
      protected static const DELIMITER_PADDING:Number = 9;
      
      protected static const ICON_PADDING:Number = 0;
       
      
      public var moduleMerchantInfo:MovieClip;
      
      protected var _tooltipInfoDataProvider:String = "INVALID_STRING_PARAM!";
      
      public var mcHeaderColor:MovieClip;
      
      public var txtItemName:TextField;
      
      public var txtItemDescription:TextField;
      
      public var txtItemRarity:TextField;
      
      public var txtItemType:TextField;
      
      public var txtCraftsmanReqirementsLabel:TextField;
      
      public var txtCraftsmanReqirementsValue:TextField;
      
      public var txtReqirementsLabel:TextField;
      
      public var mcWeightIcon:MovieClip;
      
      public var txtWeight:TextField;
      
      public var mcSocketsIcon:MovieClip;
      
      public var txtSockets:TextField;
      
      public var tfSetBonusDescription:TextField;
      
      public var tfSetBonusDescription2:TextField;
      
      public var mcSetBonusDescription:MovieClip;
      
      public var mcSetAttributeList:RenderersList;
      
      public var mcAttributesList:RenderersList;
      
      public var mcPrimaryStat:TooltipPrimaryStat;
      
      private var _textValue:String;
      
      public function ItemTooltipModule()
      {
         super();
         this.mcAttributesList.alignment = TextFormatAlign.RIGHT;
         if(this.mcSetAttributeList)
         {
            this.mcSetAttributeList.itemPadding = 0;
         }
      }
      
      public function get tooltipInfoDataProvider() : String
      {
         return this._tooltipInfoDataProvider;
      }
      
      public function set tooltipInfoDataProvider(param1:String) : void
      {
         this._tooltipInfoDataProvider = param1;
      }
      
      override public function hasSelectableItems() : Boolean
      {
         return false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this._tooltipInfoDataProvider != CommonConstants.INVALID_STRING_PARAM)
         {
            dispatchEvent(new GameEvent(GameEvent.REGISTER,this._tooltipInfoDataProvider,[this.setTooltipInfo]));
         }
         active = false;
      }
      
      public function setItemColorQuality(param1:int) : *
      {
         if(this.mcHeaderColor)
         {
            if(!isNaN(param1) && param1 != 0)
            {
               this.mcHeaderColor.gotoAndStop(param1);
            }
            else
            {
               this.mcHeaderColor.gotoAndStop(1);
            }
         }
      }
      
      protected function setTooltipInfo(param1:Object) : void
      {
         var _loc2_:Number = NaN;
         var _loc4_:* = new Namespace("");
         var _loc5_:* = new Namespace("");
         var _loc6_:Array = null;
         if(!param1)
         {
            trace("GFX ERROR undefined item\'s data");
            this.visible = false;
            return;
         }
         if(Boolean(this.tfSetBonusDescription) && Boolean(this.tfSetBonusDescription2))
         {
            _loc4_ = 5;
            _loc5_ = 20;
            if(param1.SetBonusDescription)
            {
               this._textValue = param1.SetBonusDescription;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.tfSetBonusDescription.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
               }
               else
               {
                  this.tfSetBonusDescription.htmlText = param1.SetBonusDescription;
               }
               this.tfSetBonusDescription.height = this.tfSetBonusDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
               this._textValue = param1.SetBonusDescription2;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.tfSetBonusDescription2.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
               }
               else
               {
                  this.tfSetBonusDescription2.htmlText = param1.SetBonusDescription2;
               }
               this.tfSetBonusDescription2.height = this.tfSetBonusDescription2.textHeight + CommonConstants.SAFE_TEXT_PADDING;
               this.tfSetBonusDescription2.y = this.tfSetBonusDescription.y + this.tfSetBonusDescription.height + _loc4_;
               this.mcSetBonusDescription.height = this.tfSetBonusDescription.height + this.tfSetBonusDescription2.height + _loc5_;
               this.tfSetBonusDescription.visible = true;
               this.tfSetBonusDescription2.visible = true;
               this.mcSetBonusDescription.visible = true;
            }
            else
            {
               this.tfSetBonusDescription.visible = false;
               this.tfSetBonusDescription2.visible = false;
               this.mcSetBonusDescription.visible = false;
            }
         }
         if(Boolean(this.moduleMerchantInfo) && this.moduleMerchantInfo.visible == true)
         {
            _loc2_ = this.moduleMerchantInfo.y + this.moduleMerchantInfo.height;
            this.mcHeaderColor.y = _loc2_;
            _loc2_ += BLOCK_PADDING;
         }
         else
         {
            _loc2_ = this.mcHeaderColor.y;
            _loc2_ += BLOCK_PADDING;
         }
         active = true;
         this._textValue = param1.itemName;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.txtItemName.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
         }
         else
         {
            this.txtItemName.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
         }
         this.txtItemName.y = _loc2_;
         this.txtItemName.height = this.txtItemName.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         _loc2_ += this.txtItemName.textHeight + BLOCK_PADDING;
         if(param1.type != "")
         {
            this.txtItemType.visible = true;
            this.txtItemType.htmlText = this.addArabicWrapper(param1.type);
            this.txtItemType.htmlText = this.txtItemType.htmlText.toUpperCase();
            this.txtItemType.y = _loc2_;
            _loc2_ += this.txtItemType.textHeight + BLOCK_PADDING;
         }
         else
         {
            this.txtItemType.visible = false;
         }
         if(this.mcPrimaryStat)
         {
            if(param1.PrimaryStatValue > 0)
            {
               this.mcPrimaryStat.y = _loc2_;
               this.mcPrimaryStat.setValue(param1.PrimaryStatValue,param1.PrimaryStatLabel,param1.PrimaryStatDiff,param1.PrimaryStatDelta,param1.PrimaryStatDiffStr);
               _loc2_ += this.mcPrimaryStat.actualHeight - PRIM_BLOCK_PADDING;
               this.mcPrimaryStat.visible = true;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.mcPrimaryStat.x = 490 - this.mcPrimaryStat.actualWidth;
               }
               _loc2_ += BLOCK_PADDING;
            }
            else
            {
               this.mcPrimaryStat.visible = false;
            }
         }
         if(this.mcPrimaryStat.visible)
         {
            this.mcHeaderColor.height = this.txtItemName.textHeight + this.txtItemType.textHeight + this.mcPrimaryStat.actualHeight + HEADER_DESCR_PADDING;
         }
         else
         {
            this.mcHeaderColor.height = this.txtItemName.textHeight + this.txtItemType.textHeight + HEADER_DESCR_PADDING + BLOCK_PADDING;
         }
         _loc2_ = this.mcHeaderColor.y + this.mcHeaderColor.height + DESCRIPTION_PADDING;
         if(param1.itemDescription != "")
         {
            this.txtItemDescription.y = _loc2_;
            this.txtItemDescription.visible = true;
            this.txtItemDescription.htmlText = this.addArabicWrapper(param1.itemDescription);
            this.txtItemDescription.height = this.txtItemDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            _loc2_ += this.txtItemDescription.height + DESCRIPTION_PADDING;
         }
         else
         {
            this.txtItemDescription.visible = false;
         }
         _loc2_ += BLOCK_PADDING;
         if(this.mcAttributesList)
         {
            if((Boolean(_loc6_ = param1.attributesList as Array)) && _loc6_.length > 0)
            {
               this.mcAttributesList.y = _loc2_;
               this.mcAttributesList.visible = true;
               this.mcAttributesList.dataList = param1.attributesList;
               this.mcAttributesList.validateNow();
               _loc2_ += this.mcAttributesList.actualHeight - LIST_BLOCK_PADDING;
            }
            else
            {
               this.mcAttributesList.visible = false;
            }
         }
         var _loc3_:Boolean = false;
         if(param1.rarity != "")
         {
            _loc2_ += BLOCK_PADDING_SMALL;
            this.txtItemRarity.visible = true;
            this.txtItemRarity.htmlText = this.addArabicWrapper(param1.rarity);
            this.txtItemRarity.htmlText = this.txtItemRarity.htmlText.toUpperCase();
            this.txtItemRarity.y = _loc2_;
            _loc2_ += this.txtItemRarity.textHeight + BLOCK_PADDING;
         }
         else
         {
            _loc2_ += BLOCK_PADDING;
            this.txtItemRarity.visible = false;
         }
         if(Boolean(this.txtWeight) && Boolean(this.mcWeightIcon))
         {
            if(param1.weight != "" && Boolean(param1.weight))
            {
               this.txtWeight.visible = true;
               this.mcWeightIcon.visible = true;
               this._textValue = param1.weight;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.txtWeight.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
                  this.mcWeightIcon.x = 468;
                  this.txtWeight.x = this.mcWeightIcon.x - this.txtWeight.width - this.mcWeightIcon.width / 2;
               }
               else
               {
                  this.txtWeight.htmlText = this._textValue;
               }
               this.txtWeight.y = _loc2_ + ICON_PADDING;
               this.mcWeightIcon.y = _loc2_;
               _loc2_ += this.mcWeightIcon.height + WEIGHT_BLOCK_PADDING;
               _loc3_ = true;
            }
            else
            {
               this.mcWeightIcon.visible = false;
               this.txtWeight.visible = false;
            }
         }
         if(Boolean(this.txtSockets) && Boolean(this.mcSocketsIcon))
         {
            if(param1.enhancementSlots)
            {
               this._textValue = param1.enhancementSlots;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.txtSockets.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
                  this.mcSocketsIcon.x = 475.2;
                  this.txtSockets.x = this.mcSocketsIcon.x - this.txtSockets.width - this.mcSocketsIcon.width;
               }
               else
               {
                  this.txtSockets.htmlText = this._textValue;
               }
               this.txtSockets.visible = true;
               this.mcSocketsIcon.visible = true;
               this.txtSockets.y = _loc2_ + ICON_PADDING;
               this.mcSocketsIcon.y = _loc2_;
               _loc2_ += this.mcSocketsIcon.height + WEIGHT_BLOCK_PADDING;
               _loc3_ = true;
            }
            else
            {
               this.txtSockets.visible = false;
               this.mcSocketsIcon.visible = false;
            }
         }
         if(_loc3_)
         {
            _loc2_ += DELIMITER_PADDING;
         }
         if(this.txtReqirementsLabel)
         {
            if(param1.requiredLevel)
            {
               this.txtReqirementsLabel.y = _loc2_;
               this._textValue = param1.requiredLevel;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.txtReqirementsLabel.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
               }
               else
               {
                  this.txtReqirementsLabel.htmlText = this._textValue;
               }
               this.txtReqirementsLabel.visible = true;
               _loc2_ += this.txtReqirementsLabel.textHeight + LEVEL_BLOCK_PADDING;
            }
            else
            {
               this.txtReqirementsLabel.visible = false;
            }
         }
         if(this.txtCraftsmanReqirementsLabel)
         {
            this.txtCraftsmanReqirementsLabel.text = "[[panel_shop_crating_required_crafter]]";
            this._textValue = this.txtCraftsmanReqirementsLabel.text;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtCraftsmanReqirementsLabel.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            else
            {
               this.txtCraftsmanReqirementsLabel.htmlText = this._textValue;
            }
            this.txtCraftsmanReqirementsLabel.y = _loc2_;
            _loc2_ += this.txtCraftsmanReqirementsLabel.textHeight + BLOCK_PADDING_SMALL;
         }
         if(this.txtCraftsmanReqirementsValue)
         {
            this.txtCraftsmanReqirementsValue.y = _loc2_;
            this._textValue = param1.crafterRequirements;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.txtCraftsmanReqirementsValue.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            else
            {
               this.txtCraftsmanReqirementsValue.htmlText = this._textValue;
            }
            _loc2_ += this.txtCraftsmanReqirementsValue.textHeight;
         }
      }
      
      private function addArabicWrapper(param1:String) : String
      {
         if(CoreComponent.isArabicAligmentMode)
         {
            return "<p align=\"right\">" + param1 + "</p>";
         }
         return param1;
      }
   }
}
