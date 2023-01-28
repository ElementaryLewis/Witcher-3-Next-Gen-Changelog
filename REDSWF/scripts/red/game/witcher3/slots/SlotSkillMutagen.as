package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import scaleform.clik.events.InputEvent;
   
   public class SlotSkillMutagen extends SlotBase implements IDropTarget
   {
      
      protected static const DISABLED_ALPHA:Number = 0.4;
       
      
      public var iconLock:Sprite;
      
      public var background:MovieClip;
      
      protected var _slotType:int;
      
      protected var _locked:Boolean;
      
      public function SlotSkillMutagen()
      {
         super();
         this.iconLock.visible = false;
      }
      
      public function get slotType() : int
      {
         return this._slotType;
      }
      
      public function set slotType(param1:int) : void
      {
         this._slotType = param1;
      }
      
      public function isLocked() : Boolean
      {
         return this._locked;
      }
      
      public function isMutEquiped() : Boolean
      {
         return Boolean(_data) && Boolean(_data.id);
      }
      
      override protected function canExecuteAction() : Boolean
      {
         return true;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         SlotsTransferManager.getInstance().addDropTarget(this);
      }
      
      override protected function updateData() : *
      {
         if(_data)
         {
            this._locked = !_data.unlocked;
            this.iconLock.visible = this._locked;
            if(Boolean(_data.iconPath) && _loadedImagePath != _data.iconPath)
            {
               _loadedImagePath = _data.iconPath;
               loadIcon(_loadedImagePath);
            }
            this.background.gotoAndStop(_data.color);
         }
      }
      
      override protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
      {
         if(param1 == KeyCode.PAD_A_CROSS)
         {
            fireActionEvent(InventoryActionType.EQUIP,SlotActionEvent.EVENT_ACTIVATE);
         }
         if(param1 == KeyCode.PAD_X_SQUARE)
         {
            fireActionEvent(InventoryActionType.SUB_ACTION,SlotActionEvent.EVENT_SECONDARY_ACTION);
         }
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         super.enabled = param1;
         alpha = enabled ? 1 : DISABLED_ALPHA;
      }
      
      override protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if(param1 && owner && !owner.focused)
         {
            return;
         }
         if(this.isMutEquiped())
         {
            super.fireTooltipShowEvent(param1);
         }
         else if(data && activeSelectionEnabled)
         {
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            _loc2_.tooltipContentRef = "SkillTooltipRef";
            _loc2_.tooltipMouseContentRef = "SkillTooltipRef";
            _loc2_.tooltipCustomArgs = [_data.unlockedAtLevel];
            _loc2_.isMouseTooltip = param1;
            if(param1)
            {
               _loc2_.anchorRect = getGlobalSlotRect();
            }
            if(_data.unlocked)
            {
               _loc2_.tooltipDataSource = "OnGetMutagenEmptyTooltipData";
            }
            else
            {
               _loc2_.tooltipDataSource = "OnGetMutagenLockedTooltipData";
            }
            _tooltipRequested = true;
            dispatchEvent(_loc2_);
         }
      }
      
      override protected function fireTooltipHideEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if(_tooltipRequested)
         {
            _loc2_ = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            dispatchEvent(_loc2_);
            _tooltipRequested = false;
         }
      }
      
      override public function canDrag() : Boolean
      {
         return false;
      }
      
      public function get dropSelection() : Boolean
      {
         return _dropSelection;
      }
      
      public function set dropSelection(param1:Boolean) : void
      {
         _dropSelection = param1;
         invalidateState();
      }
      
      public function processOver(param1:SlotDragAvatar) : void
      {
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         return !(param1 is SlotPaperdoll) && !this._locked;
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:Object = null;
         if(_data)
         {
            _loc2_ = param1.getDragData() as Object;
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[_loc2_.id,this.slotType]));
         }
      }
   }
}
