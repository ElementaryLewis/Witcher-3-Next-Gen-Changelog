package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   
   public class MasterMutationItemRenderer extends MutationItemRenderer
   {
       
      
      private const MUTATION_STATE_FRAME_OFFSET:int = 5;
      
      private const TEXT_PADDING = 15;
      
      public var tfState:TextField;
      
      public var tfAdditionalState:TextField;
      
      public var tfMutationDescription:TextField;
      
      public var mcStateBackground:MovieClip;
      
      public var mcLevelBackground:MovieClip;
      
      public var mcIconLock:MovieClip;
      
      public var mcMutationBackground:MovieClip;
      
      public var mcMutationAnimation:MovieClip;
      
      public var mcDescriptionBackground:MovieClip;
      
      public var mcTitleBackground:MovieClip;
      
      private var _mcColorOverlay:MovieClip;
      
      private var _mcColorBackground:MovieClip;
      
      private var _equippedMutationData:Object;
      
      private var _color:String;
      
      private var _standalone:Boolean;
      
      public function MasterMutationItemRenderer()
      {
         super();
         this._mcColorOverlay = this.mcMutationAnimation.mcAnimation.mcColor;
         this._mcColorBackground = this.mcMutationAnimation.mcAnimation.background;
         mouseChildren = false;
      }
      
      public function setColorByMutationId(param1:int) : void
      {
         var _loc2_:String = getColorById(param1);
         this._color = _loc2_;
         this._mcColorOverlay.gotoAndStop(_loc2_);
         this._mcColorBackground.gotoAndStop(_loc2_);
         this.updateConnectors();
      }
      
      public function resetColor() : void
      {
         this._color = "";
         this._mcColorOverlay.gotoAndStop(1);
         this._mcColorBackground.gotoAndStop(1);
         this.updateConnectors();
      }
      
      public function hideDescription(param1:Boolean) : void
      {
         this.tfState.visible = !param1;
         this.tfMutationDescription.visible = !param1;
         this.mcDescriptionBackground.visible = !param1;
         this.mcTitleBackground.visible = !param1;
      }
      
      public function setEquippedMutationData(param1:Object) : void
      {
         this._equippedMutationData = param1;
         this.updateMutationData();
      }
      
      override protected function updateConnectors() : void
      {
         var _loc1_:String = null;
         var _loc4_:MutationConnector = null;
         if(this._color && this._color != "default" && !_blocked)
         {
            _loc1_ = this._color;
         }
         else
         {
            _loc1_ = "gray";
         }
         var _loc2_:int = int(_connectorsList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            (_loc4_ = _connectorsList[_loc3_]).alpha = _blocked ? 0.1 : 1;
            _loc4_.color = _loc1_;
            _loc3_++;
         }
      }
      
      override protected function updateMutationData() : *
      {
         if(_data)
         {
            if(mcProgressbar)
            {
               mcProgressbar.maximum = MAX_PROGRESS;
               mcProgressbar.value = _data.overallProgress;
            }
            if(Boolean(this.mcMutationAnimation) && Boolean(_data.stage))
            {
               this.mcMutationAnimation.gotoAndPlay("state" + _data.stage);
            }
            if(this.tfState)
            {
               if(this._equippedMutationData)
               {
                  this.tfState.text = this._equippedMutationData.name;
               }
               else
               {
                  this.tfState.text = _data.stageLabel;
               }
            }
            if(this.tfAdditionalState)
            {
               if(_data.stageNumbLabel)
               {
                  this.tfAdditionalState.text = _data.stageNumbLabel;
                  this.tfAdditionalState.visible = true;
                  this.mcIconLock.visible = true;
                  if(this.mcIconLock)
                  {
                     this.mcIconLock.visible = false;
                  }
               }
               else
               {
                  this.tfAdditionalState.visible = false;
                  if(this.mcIconLock)
                  {
                     this.mcIconLock.visible = true;
                  }
               }
            }
            if(Boolean(this.mcTitleBackground) && Boolean(this.tfState))
            {
               this.mcTitleBackground.x = this.tfState.x + (this.tfState.width - this.tfState.textWidth) - this.TEXT_PADDING;
               this.mcTitleBackground.width = this.tfState.textWidth + this.TEXT_PADDING * 2;
            }
            if(Boolean(this.tfMutationDescription) && Boolean(this._equippedMutationData))
            {
               this.tfMutationDescription.htmlText = this._equippedMutationData.description;
               this.tfMutationDescription.y = -this.tfMutationDescription.textHeight / 2;
               this.tfMutationDescription.height = this.tfMutationDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            }
            if(Boolean(this.mcDescriptionBackground) && Boolean(this.tfMutationDescription))
            {
               this.mcDescriptionBackground.y = this.tfMutationDescription.y - this.TEXT_PADDING;
               this.mcDescriptionBackground.width = this.tfMutationDescription.width + this.TEXT_PADDING;
               this.mcDescriptionBackground.height = this.tfMutationDescription.textHeight + this.TEXT_PADDING * 2;
            }
         }
      }
      
      override protected function loadIcon(param1:String) : void
      {
      }
      
      public function get standalone() : Boolean
      {
         return this._standalone;
      }
      
      public function set standalone(param1:Boolean) : void
      {
         this._standalone = param1;
      }
   }
}
