package red.game.witcher3.slots
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.InventoryActionType;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.events.SlotActionEvent;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.events.InputEvent;
   
   public class SlotSkillGrid extends SlotPaperdoll implements IInventorySlot
   {
       
      
      public var slotBackground:MovieClip;
      
      public var txtLevel:TextField;
      
      public var equipedIcon:Sprite;
      
      public function SlotSkillGrid()
      {
         super();
         _isLocked = false;
         if(iconLock)
         {
            iconLock.visible = false;
         }
         if(this.equipedIcon)
         {
            this.equipedIcon.visible = false;
         }
      }
      
      override public function get isLocked() : Boolean
      {
         return _isLocked;
      }
      
      override protected function updateData() : *
      {
         super.updateData();
         if(!_data)
         {
            return;
         }
         if(_data.color && this.slotBackground && _data.level > 0 && !_data.isCoreSkill)
         {
            this.slotBackground.gotoAndStop(_data.color);
         }
         else
         {
            this.slotBackground.gotoAndPlay("SC_None");
         }
         if(_data.maxLevel && _data.maxLevel > 0 && !_data.isCoreSkill && Boolean(_data.hasRequiredPointsSpent))
         {
            this.txtLevel.text = _data.level + "/" + _data.maxLevel;
            this.txtLevel.visible = true;
         }
         else
         {
            this.txtLevel.visible = false;
         }
         this.applyAvailability();
      }
      
      override protected function handleIconLoaded(event:Event) : void
      {
         super.handleIconLoaded(event);
         if(this.txtLevel)
         {
            addChild(this.txtLevel);
            addChild(iconLock);
         }
      }
      
      protected function applyAvailability() : void
      {
         this.filters = [];
         if(this.equipedIcon)
         {
            if(!_data.isCoreSkill)
            {
               this.equipedIcon.visible = _data.isEquipped;
            }
            else
            {
               this.equipedIcon.visible = false;
            }
         }
         this.alpha = 1;
         if(_data.level < 1 && !_data.hasRequiredPointsSpent)
         {
            darkenIcon(0.2);
            _isLocked = true;
         }
         else
         {
            _isLocked = false;
         }
         iconLock.visible = _isLocked;
      }
      
      override protected function setBackgroundColor() : void
      {
         mcColorBackground.setBySkillType(_data.color);
      }
      
      override protected function fireTooltipShowEvent(isMouseTooltip:Boolean = false) : void
      {
         var displayEvent:GridEvent = null;
         var checkOwner:Boolean = activeSelectionEnabled || !InputManager.getInstance().isGamepad();
         if(_data && checkOwner && isParentEnabled())
         {
            displayEvent = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            displayEvent.tooltipContentRef = "SkillTooltipRef";
            displayEvent.tooltipMouseContentRef = "SkillTooltipRef";
            displayEvent.tooltipDataSource = "OnGetSkillTooltipData";
            displayEvent.isMouseTooltip = isMouseTooltip;
            if(isMouseTooltip)
            {
               displayEvent.anchorRect = getGlobalSlotRect();
            }
            _tooltipRequested = true;
            dispatchEvent(displayEvent);
         }
      }
      
      override protected function fireTooltipHideEvent(isMouseTooltip:Boolean = false) : void
      {
         var hideEvent:GridEvent = null;
         if(_tooltipRequested)
         {
            hideEvent = new GridEvent(GridEvent.HIDE_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            dispatchEvent(hideEvent);
            _tooltipRequested = false;
         }
      }
      
      override public function canDrag() : Boolean
      {
         return _data && !this.isLocked && _data.level > 0 && !data.isCoreSkill;
      }
      
      override protected function executeDefaultAction(keyCode:Number, event:InputEvent) : void
      {
         trace("GFX <SlotSkillGrid> executeDefaultAction  ",canExecuteAction());
         if(keyCode == KeyCode.PAD_A_CROSS)
         {
            if(event)
            {
               event.handled = true;
            }
            fireActionEvent(_data.actionType);
         }
         else if(keyCode == KeyCode.PAD_Y_TRIANGLE)
         {
            if(_data.slotType != InventorySlotType.Potion1 && _data.slotType != InventorySlotType.Potion2 && _data.slotType != InventorySlotType.Petard1 && _data.slotType != InventorySlotType.Petard2 && _data.slotType != InventorySlotType.Quickslot1 && _data.slotType != InventorySlotType.Quickslot2)
            {
               defaultSlotDropAction(_data);
            }
            fireActionEvent(InventoryActionType.DROP);
         }
         else if(keyCode == KeyCode.PAD_X_SQUARE)
         {
            fireActionEvent(InventoryActionType.SUB_ACTION,SlotActionEvent.EVENT_SECONDARY_ACTION);
         }
      }
      
      override public function executeAction(keyCode:Number, event:InputEvent) : Boolean
      {
         if(canExecuteAction())
         {
            this.executeDefaultAction(keyCode,event);
            return true;
         }
         return false;
      }
   }
}
