package red.game.witcher3.menus.character_menu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.game.witcher3.controls.TooltipAnchor;
   import red.game.witcher3.slots.SlotBase;
   import red.game.witcher3.slots.SlotsListPreset;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.gfx.MouseEventEx;
   
   public class MutationItemRenderer extends SlotBase
   {
      
      protected static const COLOR_MAP:Object = [{
         "color":"yellow",
         "id_list":[1,7,11,12,9,5]
      },{
         "color":"red",
         "id_list":[3,8]
      },{
         "color":"green",
         "id_list":[4,10]
      },{
         "color":"blue",
         "id_list":[2,6]
      }];
      
      public static var TRIGGER_EQUIP_FX:Boolean = false;
      
      public static var TRIGGER_UNEQUIP_FX:Boolean = false;
      
      public static var TRIGGER_RESEARCHED_ID_FX:int = -1;
       
      
      internal const DISABLED_ALPHA_COLOR = 0.7;
      
      internal const DISABLED_ALPHA_ICON = 0.3;
      
      protected const MAX_PROGRESS = 100;
      
      public var tfMutationName:TextField;
      
      public var tfTempText:TextField;
      
      public var mcFakeProgressbar:StatusIndicator;
      
      public var mcProgressbar:StatusIndicator;
      
      public var mcMutagenColor:MovieClip;
      
      public var mcIconBackground:MovieClip;
      
      public var mcEquippedIndicator:MovieClip;
      
      public var mcFlashAnimation:MovieClip;
      
      public var mcMutagenColorAnim:MovieClip;
      
      public var mcEquippedBkg:MovieClip;
      
      public var mcResearchCompleteAnim:MovieClip;
      
      private var _mutationId:int;
      
      private var _slotNavigationId:int;
      
      private var _firstDataUpdate:Boolean;
      
      protected var _blocked:Boolean;
      
      protected var _tooltipAnchorName:String;
      
      protected var _tooltipAnchorComponent:TooltipAnchor;
      
      protected var _renderersContainer:Sprite;
      
      public var mcProgressList:SlotsListPreset;
      
      public var mcMutationResource1:MutationProgressItemRenderer;
      
      public var mcMutationResource2:MutationProgressItemRenderer;
      
      public var mcMutationResource3:MutationProgressItemRenderer;
      
      public var mcMutationResource4:MutationProgressItemRenderer;
      
      protected var _connectorsList:Vector.<MutationConnector>;
      
      public function MutationItemRenderer()
      {
         super();
         this._firstDataUpdate = true;
         if(this.tfMutationName)
         {
            this.tfMutationName.visible = false;
         }
         this._connectorsList = new Vector.<MutationConnector>();
         addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         if(this.mcMutagenColorAnim)
         {
            this.mcMutagenColorAnim.visible = false;
         }
      }
      
      public static function getColorById(param1:int) : String
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         for each(_loc2_ in COLOR_MAP)
         {
            _loc3_ = _loc2_.id_list as Array;
            if(Boolean(_loc3_) && _loc3_.indexOf(param1) > -1)
            {
               return _loc2_.color;
            }
         }
         return "";
      }
      
      public function addConnector(param1:MutationConnector) : void
      {
         this._connectorsList.push(param1);
         this.updateConnectors();
      }
      
      public function get tooltipAnchorName() : String
      {
         return this._tooltipAnchorName;
      }
      
      public function set tooltipAnchorName(param1:String) : void
      {
         this._tooltipAnchorName = param1;
         if(Boolean(this._tooltipAnchorName) && Boolean(parent))
         {
            this._tooltipAnchorComponent = parent.getChildByName(this._tooltipAnchorName) as TooltipAnchor;
         }
      }
      
      public function getTooltipAnchorComponent() : TooltipAnchor
      {
         return this._tooltipAnchorComponent;
      }
      
      override public function getSlotRect() : Rectangle
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(mcStateSelectedActive)
         {
            if(this.tfMutationName)
            {
               _loc3_ = this.tfMutationName.textWidth;
            }
            _loc1_ = mcStateSelectedActive.width;
            _loc2_ = Math.max(_loc3_,_loc1_);
            return new Rectangle(-_loc2_ / 2,-_loc1_ / 2,_loc2_,_loc1_);
         }
         return super.getSlotRect();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcEquippedIndicator)
         {
            this.mcEquippedIndicator.visible = false;
         }
         if(this.mcIconBackground)
         {
            this.mcEquippedBkg = this.mcIconBackground.getChildByName("mcEquipped") as MovieClip;
            if(this.mcEquippedBkg)
            {
               this.mcEquippedBkg.visible = false;
            }
         }
      }
      
      override public function set data(param1:*) : void
      {
         super.data = param1;
      }
      
      override protected function updateData() : *
      {
         super.updateData();
         this.updateMutationData();
      }
      
      public function setFakeProgressValue(param1:Number) : void
      {
         if(!this.mcFakeProgressbar)
         {
            return;
         }
         if(param1 >= 0)
         {
            this.mcFakeProgressbar.maximum = this.MAX_PROGRESS;
            this.mcFakeProgressbar.value = (_data.usedResourcesCount + param1) / _data.requaredResourcesCount * 100;
            this.mcFakeProgressbar.visible = true;
         }
         else
         {
            this.mcFakeProgressbar.visible = false;
         }
      }
      
      protected function handleEnterFrame(param1:Event) : void
      {
         if(this.mcMutagenColorAnim && this.mcMutagenColorAnim.visible && _data && Boolean(_data.researchCompleted))
         {
            this.mcMutagenColorAnim.rotation += 0.5;
         }
      }
      
      protected function updateMutationData() : *
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc1_:* = true;
         if(_data)
         {
            if(this.mcProgressbar)
            {
               this.mcProgressbar.maximum = this.MAX_PROGRESS;
               this.mcProgressbar.value = _data.overallProgress;
               this.mcProgressbar.visible = false;
            }
            _loc2_ = getColorById(_data.mutationId);
            if(_loc2_ != "")
            {
               if(this.mcMutagenColor)
               {
                  this.mcMutagenColor.gotoAndStop(_loc2_);
                  this.mcIconBackground.gotoAndStop(_loc2_);
                  if(_imageLoader)
                  {
                     _imageLoader.alpha = 1;
                  }
                  if(this.mcMutagenColorAnim)
                  {
                     this.mcMutagenColorAnim.gotoAndStop(_loc2_);
                  }
               }
               if(Boolean(this.mcEquippedIndicator) && Boolean(this.mcEquippedIndicator["mcEquippedIndicator"]))
               {
                  this.mcEquippedIndicator["mcEquippedIndicator"].gotoAndStop(_loc2_);
               }
            }
            if(this.tfMutationName)
            {
               if(_data.name)
               {
                  this.tfMutationName.text = _data.name;
               }
               else
               {
                  this.tfMutationName.text = "";
               }
            }
            if(Boolean(this.mcMutagenColor) && !_data.enabled)
            {
               this.mcMutagenColor.gotoAndStop("gray");
               this.mcIconBackground.gotoAndStop("gray");
               if(this.mcMutagenColorAnim)
               {
                  this.mcMutagenColorAnim.gotoAndStop("gray");
               }
            }
            _loc3_ = Boolean(_data.isEquipped);
            if(Boolean(this.mcEquippedIndicator) && this.mcEquippedIndicator.visible != _loc3_)
            {
               GTweener.removeTweens(this.mcEquippedIndicator);
               if(_loc3_)
               {
                  this.mcEquippedIndicator.visible = true;
                  this.mcEquippedBkg.visible = true;
                  this.mcMutagenColor.scaleX = 1.15;
                  this.mcMutagenColor.scaleY = 1.15;
                  if(TRIGGER_EQUIP_FX)
                  {
                     TRIGGER_EQUIP_FX = false;
                     this.mcEquippedIndicator.alpha = 0;
                     this.mcEquippedIndicator.scaleX = this.mcEquippedIndicator.scaleY = 0.1;
                     GTweener.to(this.mcEquippedIndicator,1,{
                        "alpha":1,
                        "scaleX":1,
                        "scaleY":1
                     },{"ease":Exponential.easeOut});
                     this.mcFlashAnimation.gotoAndPlay("animation");
                  }
                  else
                  {
                     this.mcEquippedIndicator.alpha = 1;
                     this.mcEquippedIndicator.scaleX = this.mcEquippedIndicator.scaleY = 1;
                  }
               }
               else if(TRIGGER_UNEQUIP_FX)
               {
                  TRIGGER_UNEQUIP_FX = false;
                  GTweener.to(this.mcEquippedIndicator);
                  GTweener.to(this.mcEquippedIndicator,0.3,{
                     "alpha":0,
                     "scaleX":0.1,
                     "scaleY":0.1
                  },{
                     "onComplete":this.handleUnequippedAnimation,
                     "ease":Exponential.easeIn
                  });
               }
               else
               {
                  this.handleUnequippedAnimation();
               }
            }
            if(!(!_loc1_ && _data.iconPath && _data.iconPath != "None"))
            {
               if(mcHitArea)
               {
                  addChild(mcHitArea);
               }
            }
            this._firstDataUpdate = false;
            if(this.mcFakeProgressbar)
            {
               this.mcFakeProgressbar.visible = false;
            }
            if(this.mcMutagenColorAnim)
            {
               this.mcMutagenColorAnim.visible = _data.researchCompleted;
            }
            if(this.mcMutagenColor)
            {
               this.mcMutagenColor.alpha = !!_data.researchCompleted ? 1 : this.DISABLED_ALPHA_COLOR;
            }
            if(_imageLoader)
            {
               _imageLoader.alpha = Boolean(_data.researchCompleted) && enabled ? 1 : this.DISABLED_ALPHA_ICON;
            }
            if(enabled && _data && Boolean(_data.researchCompleted) && _data.mutationId == TRIGGER_RESEARCHED_ID_FX)
            {
               if(this.mcResearchCompleteAnim)
               {
                  this.mcResearchCompleteAnim.gotoAndPlay("start");
                  TRIGGER_RESEARCHED_ID_FX = -1;
               }
            }
            this.updateConnectors();
         }
      }
      
      protected function updateConnectors() : void
      {
         var _loc1_:String = null;
         var _loc4_:MutationConnector = null;
         if(_data && _data.enabled && !this._blocked && Boolean(_data.researchCompleted))
         {
            _loc1_ = getColorById(_data.mutationId);
         }
         else
         {
            _loc1_ = "gray";
         }
         var _loc2_:int = int(this._connectorsList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            (_loc4_ = this._connectorsList[_loc3_]).alpha = this._blocked ? 0.1 : 1;
            _loc4_.color = _loc1_;
            _loc3_++;
         }
      }
      
      private function handleUnequippedAnimation(param1:GTween = null) : void
      {
         this.mcEquippedIndicator.visible = false;
         this.mcMutagenColor.scaleX = 1;
         this.mcMutagenColor.scaleY = 1;
         this.mcEquippedBkg.visible = false;
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         if(this.tfMutationName)
         {
            this.tfMutationName.visible = _selected;
         }
      }
      
      override protected function handleIconLoaded(param1:Event) : void
      {
         super.handleIconLoaded(param1);
         if(_imageLoader)
         {
            _imageLoader.x = this.mcIconBackground.x - _imageLoader.width / 2;
            _imageLoader.y = this.mcIconBackground.y - _imageLoader.height / 2;
            _imageLoader.alpha = Boolean(_data.researchCompleted) && enabled ? 1 : this.DISABLED_ALPHA_ICON;
         }
         addChild(this.mcProgressbar);
         addChild(this.mcIconBackground);
         addChild(_imageLoader);
         addChild(this.mcProgressbar);
         addChild(this.mcFakeProgressbar);
         addChild(mcHitArea);
      }
      
      override protected function updateImageLoaderStates() : void
      {
      }
      
      override protected function loadIcon(param1:String) : void
      {
         super.loadIcon(param1);
      }
      
      override protected function canExecuteAction() : Boolean
      {
         return false;
      }
      
      override protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(_data && _loc2_ && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
         {
            fireActionEvent(_data.actionType);
         }
      }
      
      public function get mutationId() : int
      {
         return this._mutationId;
      }
      
      public function set mutationId(param1:int) : void
      {
         this._mutationId = param1;
      }
      
      public function get slotNavigationId() : int
      {
         return this._slotNavigationId;
      }
      
      public function set slotNavigationId(param1:int) : void
      {
         this._slotNavigationId = param1;
      }
      
      public function get blocked() : Boolean
      {
         return this._blocked;
      }
      
      public function set blocked(param1:Boolean) : void
      {
         this._blocked = param1;
         this.updateConnectors();
      }
   }
}
