package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.events.InputEvent;
   
   public class SlotSkillMutagen extends SlotBase implements IDropTarget
   {
      
      protected static const DISABLED_ALPHA:Number = 0.4;
       
      
      public var iconLock:Sprite;
      
      public var background:MovieClip;
      
      public var mcCollapsedTooltipIcon:MovieClip;
      
      protected var _slotType:int;
      
      protected var _locked:Boolean;
      
      private var _dropEnabled:Boolean = true;
      
      public function SlotSkillMutagen()
      {
         super();
         this.iconLock.visible = false;
      }
      
      override public function set data(param1:*) : void
      {
         super.data = param1;
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
      
      override protected function initCollapsedIconBehavior() : void
      {
         AUTO_SHOW_COLLAPSED_ICON = true;
         _mcCollapsedTooltipIcon = this.mcCollapsedTooltipIcon;
         if(_mcCollapsedTooltipIcon)
         {
            _mcCollapsedTooltipIcon.visible = false;
         }
         super.initCollapsedIconBehavior();
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
         if(!selectable || !enabled)
         {
            return;
         }
         if(param1 == KeyCode.PAD_A_CROSS || param1 == KeyCode.ENTER || param1 == KeyCode.NUMPAD_ENTER || param1 == KeyCode.SPACE)
         {
            fireActionEvent(InventoryActionType.EQUIP,SlotActionEvent.EVENT_ACTIVATE);
            if(param2)
            {
               dispatchEvent(new SlotActionEvent(SlotActionEvent.EVENT_SELECT,true));
               param2.handled = true;
            }
         }
         if(param1 == KeyCode.PAD_X_SQUARE)
         {
            fireActionEvent(InventoryActionType.SUB_ACTION,SlotActionEvent.EVENT_SECONDARY_ACTION);
            if(param2)
            {
               param2.handled = true;
            }
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
         if(!(activeSelectionEnabled || !InputManager.getInstance().isGamepad()) && isParentEnabled())
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
            _loc2_.anchorRect = getGlobalSlotRect();
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
      
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(param1:Boolean) : void
      {
         this._dropEnabled = param1;
      }
      
      override public function canDrag() : Boolean
      {
         return !this.isLocked() && this.isMutEquiped();
      }
      
      public function canDrop(param1:IDragTarget) : Boolean
      {
         return !(param1 is SlotPaperdoll) && !this._locked;
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
      
      public function processOver(param1:SlotDragAvatar) : int
      {
         if(param1)
         {
            _highlight = true;
         }
         else
         {
            _highlight = false;
         }
         invalidateState();
         return this.isMutEquiped() ? int(SlotDragAvatar.ACTION_SWAP) : int(SlotDragAvatar.ACTION_DROP);
      }
      
      public function applyDrop(param1:IDragTarget) : void
      {
         var _loc4_:SlotsListPreset = null;
         var _loc2_:Object = param1.getDragData() as Object;
         var _loc3_:SlotSkillMutagen = param1 as SlotSkillMutagen;
         if(_loc2_)
         {
            if(_loc3_)
            {
               if(!this.isMutEquiped())
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnMoveMutagenToEmptySlot",[uint(_loc2_.id),_loc3_.slotType,this.slotType]));
               }
               else
               {
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[uint(data.id),_loc3_.slotType]));
                  dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[uint(_loc2_.id),this.slotType]));
               }
            }
            else
            {
               dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipMutagen",[uint(_loc2_.id),this.slotType]));
            }
            if(_loc4_ = owner as SlotsListPreset)
            {
               _loc4_.dispatchItemClickEvent(this);
            }
         }
      }
      
      override public function set dragSelection(param1:Boolean) : void
      {
         super.dragSelection = param1;
      }
      
      override protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         super.handleMouseDoubleClick(param1);
         if(selectable)
         {
            dispatchEvent(new SlotActionEvent(SlotActionEvent.EVENT_SELECT,true));
         }
      }
   }
}
