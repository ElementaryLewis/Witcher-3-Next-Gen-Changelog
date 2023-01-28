package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.constants.TooltipAlignment;
   import red.game.witcher3.controls.RenderersList;
   import red.game.witcher3.controls.TooltipAnchor;
   import red.game.witcher3.menus.character.MutationTooltipTitle;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InvalidationType;
   import scaleform.clik.core.UIComponent;
   
   public class MutationTooltip extends UIComponent
   {
       
      
      protected const TXT_DESCRIPTION_PADDING:Number = 10;
      
      protected const TXT_LIST_PADDING:Number = 20;
      
      protected const BK_PADDING:Number = 4;
      
      protected const BLOCK_PADDING:Number = 10;
      
      public var tfDescription:TextField;
      
      public var tfColorsTitle:TextField;
      
      public var mcRequaredResources:MutationResourcePanel;
      
      public var mcMasterRequirements:MutationMasterRequirements;
      
      public var mcColorsList:RenderersList;
      
      public var mcRequirements:MutationRequirements;
      
      public var mcBackground:MovieClip;
      
      public var mcName:MutationTooltipTitle;
      
      public var mcButtonPanel:MutationTooltipButton;
      
      private var _textValue:String;
      
      private var _showApplyResearchBtn:Boolean;
      
      protected var _data:Object;
      
      protected var _mode:uint;
      
      protected var _anchor:TooltipAnchor;
      
      protected var _currentHeight:Number = 0;
      
      public function MutationTooltip()
      {
         super();
         visible = false;
         mouseEnabled = mouseChildren = false;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         invalidateData();
      }
      
      public function get anchor() : TooltipAnchor
      {
         return this._anchor;
      }
      
      public function set anchor(param1:TooltipAnchor) : void
      {
         this._anchor = param1;
         invalidateData();
      }
      
      public function get currentHeight() : Number
      {
         return this._currentHeight;
      }
      
      public function set currentHeight(param1:Number) : void
      {
         this._currentHeight = param1;
      }
      
      public function get showApplyResearchBtn() : Boolean
      {
         return this._showApplyResearchBtn;
      }
      
      public function set showApplyResearchBtn(param1:Boolean) : void
      {
         if(this._showApplyResearchBtn != param1)
         {
            this._showApplyResearchBtn = param1;
            this.populateData();
         }
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalid(InvalidationType.DATA))
         {
            this.populateData();
         }
      }
      
      private function populateData() : void
      {
         var _loc3_:* = false;
         var _loc1_:Number = 8;
         this.currentHeight = 0;
         if(!this._data)
         {
            visible = false;
            return;
         }
         visible = true;
         this.mcName.visible = false;
         var _loc2_:Boolean = true;
         if(this._anchor)
         {
            _loc2_ = this._anchor.alignment == TooltipAlignment.BOTTOM_LEFT || this._anchor.alignment == TooltipAlignment.BOTTOM_RIGHT;
         }
         if(_loc2_)
         {
            this.mcName.visible = true;
            this.mcName.y = 0;
            this.mcName.setText(this._data.name);
            this.currentHeight += this.mcName.height;
         }
         _loc3_ = this._data.overallProgress >= 100;
         this.mcBackground.y = this.currentHeight;
         if(CoreComponent.isArabicAligmentMode)
         {
            this.tfDescription.htmlText = "<p align=\"right\">" + this._data.description + "</p>";
         }
         else
         {
            this.tfDescription.htmlText = this._data.description;
         }
         this.tfDescription.height = this.tfDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         this.tfDescription.y = this.mcBackground.y + _loc1_;
         this.currentHeight = this.tfDescription.y + this.tfDescription.height + this.BLOCK_PADDING;
         if(!this._data.isMasterMutation && Boolean(this.data.colorsList))
         {
            this.tfColorsTitle.y = this.currentHeight;
            this.tfColorsTitle.visible = true;
            this._textValue = "[[mutation_allow_equip_of]]";
            if(CoreComponent.isArabicAligmentMode)
            {
               this.tfColorsTitle.htmlText = "<p align=\"right\">" + this._textValue + "</p>";
            }
            else
            {
               this.tfColorsTitle.text = this._textValue;
               this.tfColorsTitle.text = CommonUtils.toUpperCaseSafe(this.tfColorsTitle.text);
            }
            this.currentHeight += this.tfColorsTitle.height;
            this.mcColorsList.dataList = this.data.colorsList;
            this.mcColorsList.validateNow();
            this.mcColorsList.y = this.currentHeight;
            this.mcColorsList.visible = true;
            this.currentHeight += this.mcColorsList.actualHeight + this.BLOCK_PADDING;
            if(CoreComponent.isArabicAligmentMode)
            {
               this.mcColorsList.x = this.mcBackground.x + this.mcBackground.width - this.mcColorsList.actualWidth;
            }
         }
         else
         {
            this.mcColorsList.visible = false;
            this.tfColorsTitle.visible = false;
         }
         if(Boolean(this._data.progressDataList) && Boolean(this._data.enabled) && !this._data.researchCompleted)
         {
            this.currentHeight += this.BLOCK_PADDING;
            this.mcRequaredResources.visible = true;
            this.mcRequaredResources.data = this._data.progressDataList;
            this.mcRequaredResources.y = this.currentHeight;
            this.currentHeight += this.mcRequaredResources.getListHeight();
            this.currentHeight += this.BLOCK_PADDING;
         }
         else
         {
            this.mcRequaredResources.y = 0;
            this.mcRequaredResources.visible = false;
         }
         if(Boolean(this._data.isMasterMutation) && Boolean(this._data.lockedDescription))
         {
            this.mcMasterRequirements.text = this._data.lockedDescription;
            this.mcMasterRequirements.visible = true;
            this.mcMasterRequirements.y = this.currentHeight;
            this.currentHeight += this.mcMasterRequirements.actualHeight;
         }
         else
         {
            this.mcMasterRequirements.visible = false;
            this.mcMasterRequirements.y = 0;
         }
         var _loc4_:Array = this._data.requiredMutations as Array;
         if(!this._data.enabled && _loc4_ && _loc4_.length > 0)
         {
            this.currentHeight += this.BLOCK_PADDING;
            this.mcRequirements.y = this.currentHeight;
            this.mcRequirements.setData(_loc4_);
            this.mcRequirements.visible = true;
            this.currentHeight += this.mcRequirements.actualHeight;
         }
         else
         {
            this.mcRequirements.visible = false;
         }
         if(Boolean(this._data.enabled) && !this._data.isMasterMutation)
         {
            this.mcButtonPanel.filters = [];
            this.mcButtonPanel.alpha = 1;
            if(_loc3_)
            {
               this.mcButtonPanel.setType(!!this.data.isEquipped ? MutationTooltipButton.TYPE_UNEQUIP : MutationTooltipButton.TYPE_EQUIP);
            }
            else
            {
               this.mcButtonPanel.setType(MutationTooltipButton.TYPE_START_RESEARCH);
               if(!this._data.canResearch)
               {
                  this.mcButtonPanel.filters = [CommonUtils.generateDesaturationFilter(0.1)];
                  this.mcButtonPanel.alpha = 0.2;
               }
            }
            this.mcButtonPanel.y = this.currentHeight;
            this.mcButtonPanel.visible = true;
            addChild(this.mcButtonPanel);
            this.currentHeight += this.mcButtonPanel.height;
         }
         else
         {
            this.mcButtonPanel.visible = false;
         }
         if(this.mcName.visible)
         {
            this.mcBackground.height = this.currentHeight - this.mcName.height + this.BK_PADDING;
         }
         else
         {
            this.mcBackground.height = this.currentHeight + this.BK_PADDING;
         }
         if(!_loc2_)
         {
            this.mcName.visible = true;
            this.mcName.y = this.currentHeight;
            this.mcName.setText(this._data.name);
         }
         if(Boolean(this.mcName) && Boolean(this._anchor))
         {
            if(this.anchor.alignment == TooltipAlignment.BOTTOM_LEFT || this.anchor.alignment == TooltipAlignment.TOP_LEFT)
            {
               this.mcName.x = this.mcBackground.x + this.mcBackground.width - this.mcName.actualWidth;
            }
            else if(this.anchor.alignment == TooltipAlignment.BOTTOM_RIGHT || this.anchor.alignment == TooltipAlignment.TOP_RIGHT)
            {
               this.mcName.x = 0;
            }
         }
      }
   }
}
