package red.game.witcher3.tooltips
{
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.interfaces.IAnchorable;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.utils.CommonUtils;
   
   public class TooltipSkill extends TooltipBase implements IAnchorable
   {
      
      private static const TEXT_PADDING:Number = 5;
      
      private static const TEXT_BIG_PADDING:Number = 15;
      
      private static const BLOCK_PADDING:Number = 8;
       
      
      public var mcBackground:MovieClip;
      
      public var mcHeaderBackground:MovieClip;
      
      public var mcShadow:MovieClip;
      
      public var tfSkillName:TextField;
      
      public var tfSkillLevel:TextField;
      
      public var tfCurrentLevelDescription:TextField;
      
      public var tfNextLevelDescription:TextField;
      
      public var txfRequiredPoints:TextField;
      
      public var tfType:TextField;
      
      private var _textValue:String;
      
      public function TooltipSkill()
      {
         super();
         visible = false;
         this.tfSkillName.text = "";
         this.tfSkillLevel.text = "";
         this.tfCurrentLevelDescription.text = "";
         this.tfNextLevelDescription.text = "";
      }
      
      override protected function populateData() : void
      {
         var pointsColor:String = null;
         super.populateData();
         if(!data)
         {
            return;
         }
         this._textValue = _data.skillName;
         this.tfSkillName.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfSkillName.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
         }
         if(Boolean(_data.skillSubCategory) && _data.skillSubCategory != "")
         {
            this._textValue = _data.skillSubCategory;
            this.tfType.htmlText = CommonUtils.toUpperCaseSafe(this._textValue);
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfType.htmlText = "<p align=\"left\">" + this._textValue + "</p>";
            }
            this.tfType.visible = true;
         }
         else
         {
            this.tfType.visible = false;
         }
         if(_data.isCoreSkill)
         {
            this._textValue = _data.skillLevelString;
            this.tfSkillLevel.htmlText = this._textValue;
            this.tfSkillLevel.visible = true;
         }
         else if(_data.skillLevelString != "")
         {
            this.tfSkillLevel.htmlText = "[[panel_character_tooltip_skills_level]]";
            this.tfSkillLevel.htmlText = CommonUtils.toUpperCaseSafe(this.tfSkillLevel.htmlText);
            this.tfSkillLevel.htmlText += "<font color = \'#FFFFFF\'>" + _data.skillLevelString + "</font>";
            this.tfSkillLevel.width = this.tfSkillLevel.textWidth + CommonConstants.SAFE_TEXT_PADDING;
            this.tfSkillLevel.visible = true;
         }
         else
         {
            this.tfSkillLevel.text = "";
            this.tfSkillLevel.visible = false;
         }
         pointsColor = "#FFFFFF";
         if(_data.level < _data.maxLevel)
         {
            if(!_data.hasEnoughPoints)
            {
               pointsColor = "#EE0404";
            }
            else if(_data.curSkillPoints > 0)
            {
               pointsColor = "#93FF93";
            }
         }
         if(_data.requiredPointsSpent >= 0)
         {
            this.txfRequiredPoints.htmlText = "[[panel_character_tooltip_skills_req_points]]";
            this._textValue = this.txfRequiredPoints.htmlText;
            this._textValue = this._textValue + " " + _data.requiredPointsSpent;
            this.txfRequiredPoints.htmlText = this._textValue;
            this._textValue = this.txfRequiredPoints.htmlText;
            this.txfRequiredPoints.visible = true;
         }
         else
         {
            this.txfRequiredPoints.text = "";
            this.txfRequiredPoints.visible = false;
         }
         var INIT_TEXT_POS:Number = 85;
         var curHeight:Number = INIT_TEXT_POS;
         if(_data.currentLevelDescription)
         {
            this.tfCurrentLevelDescription.y = curHeight;
            this._textValue = _data.currentLevelDescription;
            this.tfCurrentLevelDescription.htmlText = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfCurrentLevelDescription.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this.tfCurrentLevelDescription.height = this.tfCurrentLevelDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            curHeight += this.tfCurrentLevelDescription.height + TEXT_PADDING;
         }
         if(_data.nextLevelDescription)
         {
            this.tfNextLevelDescription.y = curHeight;
            this._textValue = _data.nextLevelDescription;
            this.tfNextLevelDescription.htmlText = this._textValue;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfNextLevelDescription.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            this.tfNextLevelDescription.height = this.tfNextLevelDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            curHeight += this.tfNextLevelDescription.height + TEXT_PADDING;
         }
         this.mcBackground.gotoAndStop("solid");
         this.mcShadow.height = this.mcBackground.height = curHeight;
         visible = true;
      }
      
      override protected function updatePosition() : void
      {
         var resultPoint:Point = new Point();
         if(_anchorRect)
         {
            this.x = _anchorRect.x + _anchorRect.width;
            this.y = _anchorRect.y + _anchorRect.height;
            resultPoint.x = this.x;
            resultPoint.y = this.y;
         }
         var actualVisibleRect:Rectangle = this.mcBackground.getRect(parent);
         var screenHeight:Number = 1080;
         var screenWidth:Number = 1920;
         var bottomEdge:Number = actualVisibleRect.y + actualVisibleRect.height;
         var rightEdge:Number = actualVisibleRect.x + actualVisibleRect.width;
         if(InputManager.getInstance().getPlatform() != PlatformType.PLATFORM_PC)
         {
            screenHeight *= 0.95;
            screenWidth *= 0.95;
         }
         trace("GFX updatePosition _anchorRect ",_anchorRect,"; bottomEdge: ",bottomEdge,"; screenHeight ",screenHeight);
         trace("GFX actualVisibleRect ",actualVisibleRect);
         if(bottomEdge > screenHeight)
         {
            if(_anchorRect)
            {
               if(_anchorRect.y - actualVisibleRect.height < screenHeight && _anchorRect.y - actualVisibleRect.height > 0)
               {
                  resultPoint.y = _anchorRect.y - actualVisibleRect.height;
               }
               else
               {
                  resultPoint.y -= bottomEdge - screenHeight;
               }
            }
            else
            {
               resultPoint.y -= bottomEdge - screenHeight;
            }
         }
         if(rightEdge > screenWidth)
         {
            if(_anchorRect)
            {
               if(_anchorRect.x - actualVisibleRect.width < screenWidth && _anchorRect.x - actualVisibleRect.width > 0)
               {
                  resultPoint.x = _anchorRect.x - actualVisibleRect.width;
               }
               else
               {
                  resultPoint.x -= rightEdge - screenWidth;
               }
            }
            else
            {
               resultPoint.x -= rightEdge - screenWidth;
            }
         }
         x = resultPoint.x;
         y = resultPoint.y;
      }
      
      override public function set backgroundVisibility(value:Boolean) : void
      {
         super.backgroundVisibility = value;
         if(this.mcBackground)
         {
            this.mcBackground.gotoAndStop(_backgroundVisibility ? "solid" : "transparent");
         }
      }
   }
}
