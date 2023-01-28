package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import flash.utils.getDefinitionByName;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.gfx.Extensions;
   
   public class TooltipInventory extends TooltipBase
   {
      
      public static var ingnoreSafeRect:Boolean = false;
       
      
      protected const BACKGROUND_PADDING:Number = 5;
      
      protected const SOCKETS_BLOCK_PADDING:Number = 0;
      
      protected const EQUIPPED_TOOLTIP_PADDING_X:Number = 15;
      
      protected const EQUIPPED_TOOLTIP_PADDING_Y:Number = 40;
      
      protected const LIST_OFFSET:Number = 10;
      
      protected const ENCHANT_ICON_PADDING:Number = -4;
      
      protected const BLOCK_PADDING:Number = 5;
      
      protected const AR_BLOCK_PADDING:Number = 35;
      
      protected const LIST_PADDING:Number = 15;
      
      protected const BOTTOM_SMALL_PADDING:Number = 2;
      
      protected const CONTENT_RIGHT_EDGE_POS:Number = 470;
      
      public var tfEquippedTitle:TextField;
      
      public var tfItemName:TextField;
      
      public var tfItemRarity:TextField;
      
      public var tfItemType:TextField;
      
      public var tfDescription:TextField;
      
      public var tfRequiredLevel:TextField;
      
      public var tfWarningMessage:TextField;
      
      public var tfEnchantmentInfo:TextField;
      
      public var tfEnchantedName:TextField;
      
      public var tfCharges:TextField;
      
      public var tfSetCounter:TextField;
      
      public var mcAttributeList:RenderersList;
      
      public var mcPropertyList:RenderersList;
      
      public var mcSocketList:RenderersList;
      
      public var mcSetAttributeList:RenderersList;
      
      public var btnCompareHint:InputFeedbackButton;
      
      public var mcEnchantmentIcon:MovieClip;
      
      public var mcPrimaryStat:TooltipPrimaryStat;
      
      public var mcOilInfo1:MovieClip;
      
      public var mcOilInfo2:MovieClip;
      
      public var mcOilInfo3:MovieClip;
      
      public var mcBackground:MovieClip;
      
      public var mcHeaderBackground:MovieClip;
      
      public var mcWarningBackground:MovieClip;
      
      public var mcEnchantedTypeIcon:MovieClip;
      
      public var mcShadow:MovieClip;
      
      private var _textValue:String;
      
      protected var _invalidateData:Boolean;
      
      protected var _comparisonTooltip:TooltipInventory;
      
      protected var _comparisonMode:Boolean;
      
      protected var _comparisonTooltipRef:String = "ItemTooltipRef";
      
      protected var _availableNameWidthConst:Number;
      
      protected var _strikethroughCanvas:Sprite;
      
      protected var backgroundAdditionalHeight:Number = 0;
      
      private var _stopSafeRectCheck:Boolean = false;
      
      public function TooltipInventory()
      {
         super();
         visible = false;
         this.mcPropertyList.isHorizontal = true;
         this.mcPropertyList.alignment = TextFormatAlign.LEFT;
         this.mcSocketList.isHorizontal = false;
         this.mcPropertyList.itemPadding = 0;
         this.mcAttributeList.itemPadding = 0;
         if(this.mcSetAttributeList)
         {
            this.mcSetAttributeList.itemPadding = 0;
         }
         this.mcAttributeList.straightenColumn = true;
         this.mcSocketList.straightenColumn = true;
         this._availableNameWidthConst = 326;
         this._comparisonTooltipRef = "ItemTooltipRef_mouse";
      }
      
      override public function set data(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         super.data = param1;
         this._invalidateData = true;
         if(_data && Boolean(_data.equippedItemData))
         {
            _loc2_ = _data.StatsList as Array;
            _loc3_ = _data.equippedItemData.StatsList as Array;
            _loc4_ = int(_loc2_.length);
            _loc5_ = int(_loc3_.length);
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc9_ = false;
               _loc10_ = _loc2_[_loc7_];
               _loc11_ = 0;
               while(_loc11_ < _loc5_)
               {
                  _loc6_ = _loc3_[_loc11_];
                  if(_loc10_.id == _loc6_.id)
                  {
                     _loc12_ = _loc6_.floatValue - _loc10_.floatValue;
                     _loc6_.diff = _loc12_;
                     _loc10_.diff = -_loc12_;
                     _loc9_ = true;
                     break;
                  }
                  _loc11_++;
               }
               if(!_loc9_)
               {
                  _loc10_.diff = _loc10_.floatValue;
               }
               _loc7_++;
            }
            _loc8_ = 0;
            while(_loc8_ < _loc5_)
            {
               _loc6_ = _loc3_[_loc8_];
               if(isNaN(_loc6_.diff))
               {
                  _loc6_.diff = _loc6_.floatValue;
               }
               _loc8_++;
            }
         }
      }
      
      override public function set backgroundVisibility(param1:Boolean) : void
      {
         super.backgroundVisibility = param1;
         if(this.mcBackground)
         {
            this.mcBackground.gotoAndStop(_backgroundVisibility ? "solid" : "transparent");
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(!Extensions.isScaleform)
         {
            this.applyDebugData();
         }
         if(CoreComponent.isArabicAligmentMode)
         {
            this.mcAttributeList.itemRendererName = "AttributeRenderer_mouse_ar";
         }
      }
      
      override protected function populateData() : void
      {
         super.populateData();
         if(!_data)
         {
            return;
         }
         this.populateItemData();
         visible = true;
      }
      
      public function updateStats() : void
      {
         this.populateItemData(true);
      }
      
      protected function populateItemData(param1:Boolean = false) : void
      {
         var _loc4_:* = new Namespace("");
         var _loc8_:* = new Namespace("");
         var _loc12_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:* = 15;
         _loc4_ = 31;
         var _loc5_:* = 25;
         var _loc6_:* = 1;
         var _loc7_:* = 3;
         _loc8_ = 8;
         this.mcWarningBackground.visible = false;
         if(_data.EquippedTitle)
         {
            applyTextValue(this.tfEquippedTitle,_data.EquippedTitle,true,true);
            if(this.tfWarningMessage)
            {
               this.tfWarningMessage.visible = false;
            }
            this.mcBackground.y = -_loc4_;
            this.backgroundAdditionalHeight = _loc4_ + this.EQUIPPED_TOOLTIP_PADDING_X;
            this.mcWarningBackground.visible = true;
            this.mcWarningBackground.gotoAndStop("equip");
         }
         else
         {
            if(this.tfEquippedTitle)
            {
               this.tfEquippedTitle.visible = false;
            }
            applyTextValue(this.tfWarningMessage,_data.WarningMessage,false,true);
            if(this.tfWarningMessage.visible)
            {
               this.mcWarningBackground.gotoAndStop("warning");
               this.mcWarningBackground.visible = true;
               this.mcBackground.y = -_loc5_;
               this.backgroundAdditionalHeight = _loc5_;
            }
         }
         if(this.mcShadow)
         {
            this.mcShadow.y = this.mcBackground.y;
         }
         applyTextValue(this.tfItemName,_data.ItemName,true,true);
         this.tfItemName.height = this.tfItemName.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.cutTextFieldContent(this.tfItemName,2);
         _loc2_ += this.tfItemName.height + _loc6_;
         if(_data.hasEnchantedType)
         {
            this.tfItemType.text = _data.ItemType;
            this._textValue = this.tfItemType.text;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfItemType.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            else
            {
               this.tfItemType.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
            }
         }
         else
         {
            this.tfItemType.text = _data.ItemType;
            this._textValue = this.tfItemType.text;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfItemType.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            else
            {
               this.tfItemType.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
            }
         }
         if(this.tfItemType)
         {
            this.tfItemType.y = _loc2_;
            this.tfItemType.textColor = 13158343;
            if(this.mcEnchantedTypeIcon)
            {
               if(_data.hasEnchantedType)
               {
                  if(CoreComponent.isArabicAligmentMode)
                  {
                     this.mcEnchantedTypeIcon.visible = true;
                     this.mcEnchantedTypeIcon.x = this.tfItemType.x + this.tfItemType.width - this.tfItemType.textWidth - this.mcEnchantedTypeIcon.width;
                  }
                  else
                  {
                     this.mcEnchantedTypeIcon.visible = true;
                     this.mcEnchantedTypeIcon.x = this.tfItemType.x - this.mcEnchantedTypeIcon.width - this.ENCHANT_ICON_PADDING;
                  }
                  this.tfItemType.textColor = 16154884;
               }
               else
               {
                  this.mcEnchantedTypeIcon.visible = false;
               }
            }
            _loc2_ += this.tfItemType.textHeight + _loc7_;
         }
         else if(this.mcEnchantedTypeIcon)
         {
            this.mcEnchantedTypeIcon.visible = false;
         }
         if(this.tfCharges)
         {
            if(_data.charges)
            {
               this.tfCharges.htmlText = _data.charges;
               this.tfCharges.visible = true;
            }
            else
            {
               this.tfCharges.visible = false;
            }
            this.tfCharges.y = !!this.tfItemType ? this.tfItemType.y : this.tfItemName.y;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfCharges.x = this.tfItemType.x - this.tfItemType.textWidth - this.ENCHANT_ICON_PADDING;
            }
         }
         if(_data.PrimaryStatValue > 0)
         {
            this.mcPrimaryStat.y = _loc2_;
            this.mcPrimaryStat.setValue(data.PrimaryStatValue,data.PrimaryStatLabel,data.PrimaryStatDiff,_data.PrimaryStatDelta,data.PrimaryStatDiffStr,data.PrimaryStatDurabilityPenalty);
            this.mcPrimaryStat.visible = true;
            _loc2_ += this.mcPrimaryStat.tfLabel.height + _loc8_;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.mcPrimaryStat.x = 451 - this.mcPrimaryStat.thisWidth;
            }
            else
            {
               this.mcPrimaryStat.x = 8.3;
            }
         }
         else
         {
            this.mcPrimaryStat.visible = false;
            _loc2_ += _loc8_;
         }
         this.mcHeaderBackground.height = _loc2_;
         _loc2_ += _loc7_;
         this.setHeaderColor(_data.ItemRarityIdx);
         var _loc9_:Array = _data.StatsList as Array;
         if(this.mcAttributeList && _loc9_ && Boolean(_loc9_.length))
         {
            this.mcAttributeList.y = _loc2_;
            this.mcAttributeList.dataList = _loc9_;
            this.mcAttributeList.validateNow();
            this.mcAttributeList.visible = true;
            _loc2_ = this.mcAttributeList.y + this.mcAttributeList.actualHeight;
         }
         else
         {
            this.mcAttributeList.visible = false;
         }
         var _loc10_:Array = _data.SocketsList as Array;
         if(this.mcSocketList && _loc10_ && _loc10_.length && !_data.appliedEnchantmentInfo)
         {
            this.mcSocketList.y = _loc2_;
            this.mcSocketList.dataList = _loc10_;
            this.mcSocketList.validateNow();
            this.mcSocketList.visible = true;
            _loc2_ += this.mcSocketList.actualHeight + this.BLOCK_PADDING;
         }
         else
         {
            this.mcSocketList.visible = false;
         }
         if(Boolean(this.mcEnchantmentIcon) && Boolean(this.tfEnchantmentInfo))
         {
            if(_data.appliedEnchantmentInfo)
            {
               this.tfEnchantmentInfo.htmlText = _data.appliedEnchantmentInfo;
               this.tfEnchantmentInfo.height = this.tfEnchantmentInfo.textHeight + CommonConstants.SAFE_TEXT_PADDING;
               if(this.tfEnchantmentInfo.textHeight > this.mcEnchantmentIcon.height)
               {
                  this.tfEnchantmentInfo.y = _loc2_;
                  this.mcEnchantmentIcon.y = this.tfEnchantmentInfo.y + this.tfEnchantmentInfo.height / 2;
               }
               else
               {
                  this.mcEnchantmentIcon.y = _loc2_ + this.mcEnchantmentIcon.height / 2;
                  this.tfEnchantmentInfo.y = this.mcEnchantmentIcon.y - this.tfEnchantmentInfo.textHeight / 2;
               }
               _loc2_ += Math.max(this.tfEnchantmentInfo.textHeight,this.mcEnchantmentIcon.height) + this.BLOCK_PADDING;
            }
            else
            {
               this.tfEnchantmentInfo.visible = false;
               this.mcEnchantmentIcon.visible = false;
            }
         }
         _loc2_ = this.displayOil(this.mcOilInfo1,_data.appliedOilInfo1,_loc2_);
         _loc2_ = this.displayOil(this.mcOilInfo2,_data.appliedOilInfo2,_loc2_);
         _loc2_ = this.displayOil(this.mcOilInfo3,_data.appliedOilInfo3,_loc2_);
         applyTextValue(this.tfDescription,_data.Description,false,true);
         if(this.tfDescription)
         {
            if(_data.Description)
            {
               this.tfDescription.y = _loc2_;
               _loc2_ += this.tfDescription.height;
            }
            else
            {
               this.tfDescription.visible = false;
            }
         }
         this._textValue = _data.ItemRarity;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfItemRarity.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
         }
         else
         {
            this.tfItemRarity.htmlText = this._textValue;
         }
         if(this.tfItemRarity)
         {
            if(!CoreComponent.isArabicAligmentMode)
            {
               this.tfItemRarity.width = this.tfItemRarity.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            }
            this.tfItemRarity.y = _loc2_;
            _loc2_ += this.tfItemRarity.textHeight + this.BLOCK_PADDING;
         }
         if(this.tfSetCounter)
         {
            if(_data.SetCounter)
            {
               this.tfSetCounter.htmlText = _data.SetCounter;
               this.tfSetCounter.visible = true;
               if(this.tfItemRarity)
               {
                  if(!CoreComponent.isArabicAligmentMode)
                  {
                     this.tfSetCounter.x = this.tfItemRarity.x + this.tfItemRarity.textWidth + this.BLOCK_PADDING;
                  }
                  else
                  {
                     this.tfSetCounter.x = this.tfItemRarity.x + this.tfItemRarity.width - this.tfItemRarity.textWidth - this.AR_BLOCK_PADDING;
                  }
                  this.tfSetCounter.y = this.tfItemRarity.y;
               }
               else
               {
                  this.tfSetCounter.visible = false;
               }
            }
            else
            {
               this.tfSetCounter.visible = false;
            }
         }
         var _loc11_:Array = _data.SetStatsList as Array;
         if(this.mcSetAttributeList && _loc11_ && Boolean(_loc11_.length))
         {
            this.mcSetAttributeList.y = _loc2_;
            this.mcSetAttributeList.dataList = _loc11_;
            this.mcSetAttributeList.validateNow();
            this.mcSetAttributeList.visible = true;
            _loc2_ = this.mcSetAttributeList.y + this.mcSetAttributeList.actualHeight;
         }
         else
         {
            this.mcSetAttributeList.visible = false;
         }
         if(this.tfRequiredLevel)
         {
            if(_data.RequiredLevel)
            {
               this.tfRequiredLevel.y = _loc2_;
               this._textValue = _data.RequiredLevel;
               if(CoreComponent.isArabicAligmentMode)
               {
                  this.tfRequiredLevel.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
               }
               else
               {
                  this.tfRequiredLevel.htmlText = this._textValue;
               }
               _loc2_ += this.tfRequiredLevel.height + this.BOTTOM_SMALL_PADDING;
               this.tfRequiredLevel.visible = true;
            }
            else
            {
               this.tfRequiredLevel.visible = false;
            }
         }
         if(this.mcPropertyList)
         {
            this.mcPropertyList.dataList = _data.PropertiesList as Array;
            this.mcPropertyList.validateNow();
            this.mcPropertyList.y = _loc2_;
            _loc2_ += this.mcPropertyList.actualHeight + this.BOTTOM_SMALL_PADDING;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.mcPropertyList.x = this.mcBackground.x + this.mcBackground.width - this.mcPropertyList._thisWidth - this.LIST_OFFSET;
            }
            else
            {
               this.mcPropertyList.x = 7.85;
            }
         }
         if(this.btnCompareHint)
         {
            if(Boolean(_data.equippedItemData) && !InputManager.getInstance().isGamepad())
            {
               _loc12_ = 30;
               this.btnCompareHint.clickable = false;
               this.btnCompareHint.setDataFromStage("",KeyCode.SHIFT);
               this.btnCompareHint.label = "[[panel_common_compare]]";
               this.btnCompareHint.visible = true;
               this.btnCompareHint.addHoldPrefix = true;
               this.btnCompareHint.validateNow();
               this.btnCompareHint.y = _loc2_ + _loc12_;
               _loc2_ += _loc12_ * 2;
            }
            else
            {
               this.btnCompareHint.visible = false;
            }
         }
         this.mcBackground.height = _loc2_ + this.backgroundAdditionalHeight;
         if(this.mcShadow)
         {
            this.mcShadow.height = this.mcBackground.height;
         }
         if(Boolean(_data.equippedItemData) && !param1)
         {
            this.createComparisonTooltip(_data.equippedItemData);
         }
         else
         {
            removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
            addEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate,false,0,true);
         }
      }
      
      private function displayOil(param1:MovieClip, param2:String, param3:Number) : Number
      {
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         if(param1)
         {
            if(param2)
            {
               _loc4_ = param1["txtOilInfo"];
               _loc5_ = param1["mcOilIcon"];
               if(_loc4_)
               {
                  this._textValue = param2;
                  if(CoreComponent.isArabicAligmentMode)
                  {
                     _loc4_.x = -1.5;
                     _loc5_.x = _loc4_.x + _loc4_.width + _loc5_.width / 2;
                     _loc4_.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
                  }
                  else
                  {
                     _loc4_.htmlText = this._textValue;
                  }
                  _loc4_.height = _loc4_.textHeight + CommonConstants.SAFE_TEXT_PADDING;
                  param1.y = param3;
                  param1.visible = true;
                  param3 += param1.height + this.BLOCK_PADDING;
               }
               else
               {
                  param1.visible = false;
               }
            }
            else
            {
               param1.visible = false;
            }
         }
         return param3;
      }
      
      private function setHeaderColor(param1:int) : void
      {
         switch(param1)
         {
            case 1:
               this.mcHeaderBackground.gotoAndStop("gray");
               break;
            case 2:
               this.mcHeaderBackground.gotoAndStop("blue");
               break;
            case 3:
               this.mcHeaderBackground.gotoAndStop("yellow");
               break;
            case 4:
               this.mcHeaderBackground.gotoAndStop("orange");
               break;
            case 5:
               this.mcHeaderBackground.gotoAndStop("green");
         }
      }
      
      protected function cutTextFieldContent(param1:TextField, param2:Number) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:* = null;
         if(param1.numLines > param2 && !(param1.numLines - 1 == param2 && CommonUtils.strTrim(param1.getLineText(param1.numLines)) == ""))
         {
            _loc3_ = param1.getLineLength(param2 - 1);
            _loc5_ = (_loc4_ = param1.getLineOffset(param2 - 1)) + _loc3_ - 2;
            while(param1.text.charAt(_loc5_) == " " && _loc5_ > 0)
            {
               _loc5_--;
            }
            _loc6_ = param1.text.substr(0,_loc5_) + "…";
            param1.text = _loc6_;
         }
      }
      
      public function showEquippedTooltip(param1:Boolean) : void
      {
         this._comparisonMode = param1;
         if(this._comparisonTooltip)
         {
            if(param1)
            {
               addChild(this._comparisonTooltip);
               if(!CoreComponent.isArabicAligmentMode)
               {
                  TooltipStatRenderer.showComparison = true;
               }
               else
               {
                  TooltipStatRenderer_ar.showComparison = true;
               }
               this.updateStats();
               this._comparisonTooltip.updateStats();
            }
            else
            {
               removeChild(this._comparisonTooltip);
               if(!CoreComponent.isArabicAligmentMode)
               {
                  TooltipStatRenderer.showComparison = false;
               }
               else
               {
                  TooltipStatRenderer_ar.showComparison = false;
               }
               this.updateStats();
            }
            this._comparisonTooltip.visible = param1;
            removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
            addEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate,false,0,true);
         }
      }
      
      override public function stopSafeRectCheck(param1:Boolean = false) : void
      {
         this._stopSafeRectCheck = param1;
         if(this._stopSafeRectCheck)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
         }
      }
      
      override public function updateSafeRectCheck() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
         addEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate,false,0,true);
      }
      
      override public function getPositionAfterScale(param1:Number = -1) : Point
      {
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         var _loc2_:Point = new Point(x,y);
         var _loc3_:Number = 1080;
         var _loc4_:Number = 1920;
         if(ingnoreSafeRect)
         {
            return _loc2_;
         }
         var _loc5_:Rectangle = this.mcBackground.getRect(parent);
         if(Boolean(this._comparisonTooltip) && this._comparisonTooltip.visible)
         {
            _loc9_ = this._comparisonTooltip.mcBackground.getRect(parent);
            _loc5_ = _loc5_.union(_loc9_);
         }
         if(InputManager.getInstance().getPlatform() != PlatformType.PLATFORM_PC)
         {
            _loc3_ *= 0.95;
            _loc4_ *= 0.95;
         }
         else
         {
            _loc3_ -= 5;
         }
         if(param1 > 0)
         {
            if((_loc10_ = param1 / this.scaleX) < 1)
            {
               _loc2_.x = _actualPosition.x;
               _loc2_.y = _actualPosition.y;
            }
            _loc5_.width *= _loc10_;
            _loc5_.height *= _loc10_;
         }
         var _loc6_:Number = _loc5_.y + _loc5_.height;
         var _loc7_:Number = _loc5_.x + _loc5_.width;
         var _loc8_:Boolean = false;
         if(_loc6_ > _loc3_)
         {
            if(_anchorRect)
            {
               if(_anchorRect.y - _loc5_.height < _loc3_ && _anchorRect.y - _loc5_.height > 0)
               {
                  _loc2_.y = _anchorRect.y - _loc5_.height;
               }
               else
               {
                  _loc2_.y -= _loc6_ - _loc3_;
               }
            }
            else
            {
               _loc2_.y -= _loc6_ - _loc3_;
            }
         }
         if(_loc7_ > _loc4_)
         {
            if(_anchorRect)
            {
               if(_anchorRect.x - _loc5_.width < _loc4_ && _anchorRect.x - _loc5_.width > 0)
               {
                  _loc2_.x = _anchorRect.x - _loc5_.width;
               }
               else
               {
                  _loc2_.x -= _loc7_ - _loc4_;
               }
            }
            else
            {
               _loc2_.x -= _loc7_ - _loc4_;
            }
         }
         return _loc2_;
      }
      
      override protected function updatePosition() : void
      {
         if(this._stopSafeRectCheck)
         {
            return;
         }
         applyPositioning();
         x = _actualPosition.x;
         y = _actualPosition.y;
         this.updateTooltipPosition();
         if(this._invalidateData)
         {
            this._invalidateData = false;
            dispatchEvent(new Event(Event.ACTIVATE));
         }
      }
      
      protected function updateTooltipPosition() : void
      {
         if(this._stopSafeRectCheck)
         {
            return;
         }
         var _loc1_:Point = this.getPositionAfterScale();
         this.x = _loc1_.x;
         this.y = _loc1_.y;
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
      
      protected function createComparisonTooltip(param1:Object) : void
      {
         var _loc2_:* = 0;
         if(this._comparisonTooltip)
         {
            removeChild(this._comparisonTooltip);
            this._comparisonTooltip = null;
         }
         var _loc3_:Class = getDefinitionByName(this._comparisonTooltipRef) as Class;
         this._comparisonTooltip = new _loc3_() as TooltipInventory;
         this._comparisonTooltip.isMouseTooltip = false;
         this._comparisonTooltip.lockFixedPosition = true;
         this._comparisonTooltip.backgroundVisibility = true;
         this._comparisonTooltip.data = param1;
         this._comparisonTooltip.validateNow();
         this._comparisonTooltip.visible = this._comparisonMode;
         var _loc4_:Number = 0;
         if(!param1.EquippedTitle)
         {
         }
         this._comparisonTooltip.x = this.mcBackground.x + this.mcBackground.width + this.EQUIPPED_TOOLTIP_PADDING_X + _loc2_;
         this._comparisonTooltip.y = _loc4_;
         removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
         addEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate,false,0,true);
      }
      
      protected function handleComparisonTooltipValidate(param1:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.handleComparisonTooltipValidate);
         this.updatePosition();
      }
      
      protected function applyDebugData() : void
      {
         var _loc1_:Object = {};
         _loc1_.PrimaryStatLabel = "damage";
         _loc1_.PrimaryStatValue = "10";
         _loc1_.ItemName = "Witcher Sword";
         _loc1_.ItemRarity = "Cool";
         _loc1_.ItemType = "Sword";
         _loc1_.CommonDescription = "Common Description";
         _loc1_.UniqDescription = "Sword Description";
         _loc1_.SocketsDescription = "ddddddddddddd";
         var _loc2_:Array = [];
         _loc2_.push({
            "type":"attack",
            "value":"10",
            "icon":"better"
         });
         _loc2_.push({
            "type":"attack",
            "value":"10",
            "icon":"better"
         });
         _loc2_.push({
            "type":"attack",
            "value":"10",
            "icon":"wayBetter"
         });
         _loc2_.push({
            "type":"attack",
            "value":"10",
            "icon":"none"
         });
         _loc1_.GenericStatsList = _loc2_;
         var _loc3_:Array = [];
         _loc3_.push({
            "type":"notforsale",
            "label":"",
            "value":""
         });
         _loc3_.push({
            "type":"price",
            "label":"price",
            "value":"100"
         });
         _loc3_.push({
            "type":"weight",
            "label":"weight",
            "value":"50"
         });
         _loc3_.push({
            "type":"repair",
            "label":"repair",
            "value":"10"
         });
         _loc1_.PropertiesList = _loc3_;
         this.anchorRect = new Rectangle((parent["testAnchor"] as MovieClip).x,(parent["testAnchor"] as MovieClip).y,0,0);
         this.lockFixedPosition = true;
         this.data = _loc1_;
      }
   }
}
