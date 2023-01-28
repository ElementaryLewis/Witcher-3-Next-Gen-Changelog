package red.game.witcher3.menus.character_menu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import red.core.constants.KeyCode;
   import red.core.data.InputAxisData;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.TooltipAlignment;
   import red.game.witcher3.controls.TooltipAnchor;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.events.ListEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class MutationsPanel extends UIComponent
   {
       
      
      protected const RESEARCH_BUTTON_PADDING:Number = 20;
      
      public var mcMutationList:MutationItemsList;
      
      public var mcMutation1:MutationItemRenderer;
      
      public var mcMutation2:MutationItemRenderer;
      
      public var mcMutation3:MutationItemRenderer;
      
      public var mcMutation4:MutationItemRenderer;
      
      public var mcMutation5:MutationItemRenderer;
      
      public var mcMutation6:MutationItemRenderer;
      
      public var mcMutation7:MutationItemRenderer;
      
      public var mcMutation8:MutationItemRenderer;
      
      public var mcMutation9:MutationItemRenderer;
      
      public var mcMutation10:MutationItemRenderer;
      
      public var mcMutation11:MutationItemRenderer;
      
      public var mcMutation12:MutationItemRenderer;
      
      public var mcMutation13:MutationItemRenderer;
      
      public var mcMutConnector3_8:MutationConnector;
      
      public var mcMutConnector8_7:MutationConnector;
      
      public var mcMutConnector8_9:MutationConnector;
      
      public var mcMutConnector9_12:MutationConnector;
      
      public var mcMutConnector7_11:MutationConnector;
      
      public var mcMutConnector6_7:MutationConnector;
      
      public var mcMutConnector10_9:MutationConnector;
      
      public var mcMutConnector4_10:MutationConnector;
      
      public var mcMutConnector2_6:MutationConnector;
      
      public var mcMutConnector6_1:MutationConnector;
      
      public var mcMutConnector10_5:MutationConnector;
      
      public var mcMasterMutationConnector1:MutationConnector;
      
      public var mcMasterMutationConnector2:MutationConnector;
      
      public var mcMasterMutationConnector3:MutationConnector;
      
      public var mcAnchor1:TooltipAnchor;
      
      public var mcAnchor2:TooltipAnchor;
      
      public var mcAnchor3:TooltipAnchor;
      
      public var mcAnchor4:TooltipAnchor;
      
      public var mcAnchor5:TooltipAnchor;
      
      public var mcAnchor6:TooltipAnchor;
      
      public var mcAnchor7:TooltipAnchor;
      
      public var mcAnchor8:TooltipAnchor;
      
      public var mcAnchor9:TooltipAnchor;
      
      public var mcAnchor10:TooltipAnchor;
      
      public var mcAnchor11:TooltipAnchor;
      
      public var mcAnchor12:TooltipAnchor;
      
      public var mcAnchor13:TooltipAnchor;
      
      public var mcFadeoutSprite:MovieClip;
      
      public var mcMutationBackground:MovieClip;
      
      public var mcMutagenTooltip:MutationTooltip;
      
      public var equippedMutationId:int = -1;
      
      protected var _fadeOutComponents:Vector.<MovieClip>;
      
      protected var _fadeInComponent:Vector.<MovieClip>;
      
      protected var _selectedMutationData:Object;
      
      protected var _selectedMutationRenderer:MutationItemRenderer;
      
      protected var _researchMode:Boolean;
      
      protected var _active:Boolean;
      
      protected var _data:Array;
      
      protected var _linesCanvas:Sprite;
      
      protected var _mutationChanged:Boolean = false;
      
      private var tooltipTimer:Timer;
      
      private var _cachedChangeList:Object;
      
      public function MutationsPanel()
      {
         super();
         visible = false;
         this.mcMutationList.sortData = true;
         this.mcMutationList.focusable = false;
         this.mcMutationList.addEventListener(ListEvent.INDEX_CHANGE,this.handleMutationSelected,false,0,true);
         this.mcMutationList.addEventListener(ListEvent.ITEM_CLICK,this.hanldeMutationClick,false,0,true);
         this.mcMutationList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.hanldeMutationDoubleClick,false,0,true);
         this.mcMutationList.addEventListener(ListEvent.ITEM_ROLL_OVER,this.hanldeMutationOver,false,0,true);
         this.mcMutationList.addEventListener(ListEvent.ITEM_ROLL_OUT,this.hanldeMutationOut,false,0,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      private function handleControllerChanged(param1:Event) : void
      {
         if(this._selectedMutationRenderer)
         {
            this.alignControls();
         }
      }
      
      private function hanldeMutationClick(param1:ListEvent) : void
      {
      }
      
      private function hanldeMutationDoubleClick(param1:ListEvent) : void
      {
         this.mutationAction();
      }
      
      private function hanldeMutationOver(param1:ListEvent) : void
      {
         var _loc2_:MutationItemRenderer = null;
         _loc2_ = param1.itemRenderer as MutationItemRenderer;
         this.mcMutationList.selectedIndex = _loc2_.index;
         this.mcMutationList.validateNow();
         if(Boolean(_loc2_) && !_loc2_.blocked)
         {
            if(this.tooltipTimer)
            {
               this.tooltipTimer.stop();
               this.tooltipTimer.removeEventListener(TimerEvent.TIMER,this.handleTooltipTimer,false);
               this.tooltipTimer = null;
            }
            GTweener.removeTweens(this.mcMutagenTooltip);
            this.mcMutagenTooltip.alpha = 0;
            this.mcMutagenTooltip.visible = true;
            this.mcMutagenTooltip.data = _loc2_.data;
            this.mcMutagenTooltip.validateNow();
            this.alignTooltip(_loc2_);
            GTweener.to(this.mcMutagenTooltip,1,{"alpha":1},{"ease":Exponential.easeOut});
         }
      }
      
      private function hanldeMutationOut(param1:ListEvent) : void
      {
         if(this.tooltipTimer)
         {
            this.tooltipTimer.stop();
            this.tooltipTimer.removeEventListener(TimerEvent.TIMER,this.handleTooltipTimer,false);
            this.tooltipTimer = null;
         }
         this.mcMutagenTooltip.visible = false;
         this.mcMutagenTooltip.alpha = 0;
         GTweener.removeTweens(this.mcMutagenTooltip);
      }
      
      private function handleMutationSelected(param1:ListEvent) : void
      {
         var _loc2_:MutationItemRenderer = this.mcMutationList.getSelectedRenderer() as MutationItemRenderer;
         this.selectMutation(_loc2_);
      }
      
      private function selectMutation(param1:MutationItemRenderer, param2:Boolean = false) : void
      {
         var _loc3_:Boolean = InputManager.getInstance().isGamepad();
         if(this._selectedMutationRenderer == param1 && !param2)
         {
            return;
         }
         if(_loc3_)
         {
            if(this.tooltipTimer)
            {
               this.tooltipTimer.stop();
               this.tooltipTimer.removeEventListener(TimerEvent.TIMER,this.handleTooltipTimer,false);
               this.tooltipTimer = null;
            }
            this.mcMutagenTooltip.alpha = 0;
            GTweener.removeTweens(this.mcMutagenTooltip);
         }
         if(Boolean(param1) && param1.data)
         {
            this._selectedMutationRenderer = param1;
            this._selectedMutationData = param1.data;
            if(_loc3_)
            {
               this.mcMutagenTooltip.data = this._selectedMutationData;
               this.mcMutagenTooltip.validateNow();
               this.tooltipTimer = new Timer(500);
               this.tooltipTimer.addEventListener(TimerEvent.TIMER,this.handleTooltipTimer,false,0,true);
               this.tooltipTimer.start();
            }
            else if(this.mcMutagenTooltip.data != param1.data)
            {
               this.mcMutagenTooltip.visible = false;
            }
         }
         else if(_loc3_)
         {
            this.mcMutagenTooltip.visible = false;
         }
         if(this._selectedMutationData)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMutationSelected",[int(this._selectedMutationData.mutationId)]));
         }
         if(_loc3_)
         {
            this.alignControls();
         }
      }
      
      private function alignControls() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.validateAlignControls);
         addEventListener(Event.ENTER_FRAME,this.validateAlignControls,false,0,true);
      }
      
      private function validateAlignControls(param1:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.validateAlignControls);
         if(this._selectedMutationRenderer)
         {
            this.alignTooltip(this._selectedMutationRenderer);
         }
      }
      
      private function alignTooltip(param1:MutationItemRenderer, param2:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc7_:TooltipAnchor;
         if(_loc7_ = param1.getTooltipAnchorComponent())
         {
            _loc8_ = _loc7_.alignment;
            _loc9_ = this.mcMutagenTooltip.currentHeight;
            _loc10_ = this.mcMutagenTooltip.mcBackground.width;
            this.mcMutagenTooltip.anchor = _loc7_;
            switch(_loc8_)
            {
               case TooltipAlignment.BOTTOM_LEFT:
                  _loc6_ = _loc7_.y;
                  _loc5_ = _loc7_.x - _loc10_;
                  break;
               case TooltipAlignment.BOTTOM_RIGHT:
                  _loc6_ = _loc7_.y;
                  _loc5_ = _loc7_.x;
                  break;
               case TooltipAlignment.TOP_LEFT:
                  _loc6_ = _loc7_.y - _loc9_;
                  _loc5_ = _loc7_.x - _loc10_;
                  break;
               case TooltipAlignment.TOP_RIGHT:
                  _loc6_ = _loc7_.y - _loc9_;
                  _loc5_ = _loc7_.x;
            }
         }
         if(param2)
         {
            GTweener.removeTweens(this.mcMutagenTooltip);
            GTweener.to(this.mcMutagenTooltip,0.5,{
               "x":_loc5_,
               "y":_loc6_,
               "alpha":1
            },{"ease":Exponential.easeOut});
         }
         else
         {
            this.mcMutagenTooltip.x = _loc5_;
            this.mcMutagenTooltip.y = _loc6_;
         }
      }
      
      private function handleTooltipTimer(param1:TimerEvent) : void
      {
         this.tooltipTimer.stop();
         this.tooltipTimer.removeEventListener(TimerEvent.TIMER,this.handleTooltipTimer,false);
         this.tooltipTimer = null;
         GTweener.removeTweens(this.mcMutagenTooltip);
         this.mcMutagenTooltip.alpha = 0;
         if(this._selectedMutationRenderer)
         {
            this.alignControls();
         }
         if(!GTweener.getTweens(this.mcMutagenTooltip).length)
         {
            GTweener.to(this.mcMutagenTooltip,1,{"alpha":1},{"ease":Exponential.easeOut});
         }
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         if(this._active != param1)
         {
            this._active = param1;
            enabled = this._active;
            stage.removeEventListener(InputEvent.INPUT,this.handleInput,false);
            if(this._active)
            {
               stage.addEventListener(InputEvent.INPUT,this.handleInput,false,1000,true);
               dispatchEvent(new Event(Event.ACTIVATE));
               this.mcMutationList.enabled = true;
               this.initPopulateData(true);
               this._mutationChanged = false;
            }
            else
            {
               this.mcMutationList.selectedIndex = -1;
               this.mcMutationList.enabled = false;
               this.mcMutationList.focused = 0;
               dispatchEvent(new Event(Event.DEACTIVATE));
               if(this._mutationChanged)
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnUpdateMutationData",[]));
                  this._mutationChanged = false;
               }
            }
         }
      }
      
      public function get data() : Array
      {
         return this._data;
      }
      
      public function set data(param1:Array) : void
      {
         this._data = param1;
         if(this._active)
         {
            this.initPopulateData();
         }
      }
      
      public function setSingleMutationData(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         if(this._data)
         {
            _loc2_ = int(this._data.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               if((_loc4_ = this._data[_loc3_]).mutationId == param1.mutationId)
               {
                  this._data[_loc3_] = param1;
                  this.mcMutationList.data[_loc3_] = param1;
                  this.mcMutationList.updateSingleMutation(param1);
                  this.mcMutationList.validateNow();
                  return;
               }
               _loc3_++;
            }
         }
      }
      
      public function setDataList(param1:Array) : void
      {
         this.data = param1;
      }
      
      private function initPopulateData(param1:Boolean = false) : void
      {
         var _loc2_:int = this.mcMutationList.selectedIndex;
         this.mcMutationList.focused = 1;
         this.mcMutationList.selectedIndex = -1;
         this.mcMutationList.data = this.data as Array;
         this.mcMutationList.validateNow();
         if(!param1)
         {
            this.mcMutationList.selectedIndex = _loc2_;
            this.selectMutation(this.mcMutationList.getSelectedRenderer() as MutationItemRenderer,true);
         }
         else
         {
            this.mcMutationList.selectedIndex = 12;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc3_:InputAxisData = null;
         var _loc2_:InputDetails = param1.details;
         var _loc4_:* = _loc2_.value == InputValue.KEY_UP;
         var _loc5_:* = _loc2_.value == InputValue.KEY_DOWN;
         var _loc6_:Boolean = false;
         super.handleInput(param1);
         if(this._active && _loc4_)
         {
            switch(_loc2_.code)
            {
               case KeyCode.E:
               case KeyCode.SPACE:
               case KeyCode.ENTER:
               case KeyCode.PAD_A_CROSS:
                  this.mutationAction();
                  _loc6_ = true;
                  break;
               case KeyCode.C:
               case KeyCode.ESCAPE:
               case KeyCode.PAD_B_CIRCLE:
               case KeyCode.PAD_Y_TRIANGLE:
                  _loc6_ = true;
                  this.active = false;
            }
         }
         if(this._active && !_loc6_)
         {
            this.mcMutationList.handleInputPreset(param1);
            _loc6_ = true;
         }
         if(_loc6_)
         {
            param1.handled = true;
            param1.stopImmediatePropagation();
         }
      }
      
      private function mutationAction() : void
      {
         var _loc1_:Array = null;
         this._selectedMutationRenderer = this.mcMutationList.getSelectedRenderer() as MutationItemRenderer;
         if(this._selectedMutationRenderer)
         {
            this._selectedMutationData = this._selectedMutationRenderer.data;
         }
         if(Boolean(this._selectedMutationData) && Boolean(this._selectedMutationData.enabled))
         {
            if(!this._selectedMutationData.researchCompleted)
            {
               if(this._selectedMutationData.canResearch)
               {
                  _loc1_ = [this._selectedMutationData.mutationId,this._selectedMutationData.skillpointsRequired,this._selectedMutationData.redRequired,this._selectedMutationData.greenRequired,this._selectedMutationData.blueRequired];
                  MutationItemRenderer.TRIGGER_RESEARCHED_ID_FX = this._selectedMutationData.mutationId;
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnResearchMutation",_loc1_));
               }
               else
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnCantResearchMutation",[]));
                  this.mcMutagenTooltip.mcRequaredResources.playFeedbackAnim();
               }
            }
            else if(this._selectedMutationData.isEquipped)
            {
               MutationItemRenderer.TRIGGER_UNEQUIP_FX = true;
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipMutation",[]));
            }
            else
            {
               MutationItemRenderer.TRIGGER_EQUIP_FX = true;
               if(this.equippedMutationId != -1 && this.equippedMutationId != this._selectedMutationData.mutationId)
               {
                  MutationItemRenderer.TRIGGER_UNEQUIP_FX = true;
               }
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutation",[this._selectedMutationData.mutationId]));
            }
         }
      }
   }
}
