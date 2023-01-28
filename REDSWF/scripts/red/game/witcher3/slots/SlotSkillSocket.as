package red.game.witcher3.slots
{
   import flash.events.MouseEvent;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.menus.character_menu.SkillSlotConnector;
   
   public class SlotSkillSocket extends SlotSkillGrid implements IDropTarget
   {
      
      public static const NULL_SKILL:String = "ESP_NotSet";
       
      
      protected var _slotId:int;
      
      protected var _connector:String;
      
      public function SlotSkillSocket()
      {
         super();
      }
      
      public function get connector() : String
      {
         return this._connector;
      }
      
      public function set connector(value:String) : void
      {
         this._connector = value;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function set slotId(value:int) : void
      {
         this._slotId = value;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         SlotsTransferManager.getInstance().addDropTarget(this);
      }
      
      override protected function loadIcon(iconPath:String) : void
      {
         if(Boolean(_data) && _data.skillPath != NULL_SKILL)
         {
            super.loadIcon(iconPath);
         }
      }
      
      override protected function applyAvailability() : void
      {
         if(_data)
         {
            _isLocked = !_data.unlocked;
            iconLock.visible = _isLocked;
            this.updateConnector(_data.color);
         }
      }
      
      protected function updateConnector(targetColor:String) : void
      {
         if(!this._connector)
         {
            return;
         }
         var connectorRef:SkillSlotConnector = parent.getChildByName(this._connector) as SkillSlotConnector;
         if(connectorRef)
         {
            connectorRef.currentColor = targetColor;
         }
      }
      
      override protected function fireTooltipShowEvent(isMouseTooltip:Boolean = false) : void
      {
         var displayEvent:GridEvent = null;
         if(Boolean(_data) && activeSelectionEnabled)
         {
            displayEvent = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            displayEvent.tooltipContentRef = "SkillTooltipRef";
            displayEvent.tooltipMouseContentRef = "SkillTooltipRef";
            displayEvent.isMouseTooltip = isMouseTooltip;
            if(isMouseTooltip)
            {
               displayEvent.anchorRect = getGlobalSlotRect();
            }
            if(_data.skillPath != NULL_SKILL)
            {
               displayEvent.tooltipDataSource = "OnGetSkillTooltipData";
            }
            else if(_data.unlocked)
            {
               displayEvent.tooltipCustomArgs = [_data.unlockedOnLevel];
               displayEvent.tooltipDataSource = "OnGetEmptySlotTooltipData";
            }
            else
            {
               displayEvent.tooltipCustomArgs = [_data.unlockedOnLevel];
               displayEvent.tooltipDataSource = "OnGetLockedTooltipData";
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
      
      override protected function handleMouseDoubleClick(event:MouseEvent) : void
      {
         if(_data)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipSkill",[_data.slotId]));
         }
         else
         {
            super.handleMouseDoubleClick(event);
         }
      }
      
      override public function applyDrop(source:IDragTarget) : void
      {
         var itemData:Object = null;
         var slotId:uint = 0;
         var skillId:uint = 0;
         if(_data)
         {
            itemData = source.getDragData() as Object;
            slotId = uint(_data.slotId);
            skillId = uint(itemData.skillTypeId);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipSkill",[skillId,slotId]));
         }
      }
      
      override public function canDrop(dragData:IDragTarget) : Boolean
      {
         var itemData:Object = dragData.getDragData() as Object;
         return selectable && itemData.skillType && itemData.skillType != "S_Undefined" && !_isLocked;
      }
      
      override public function get dropSelection() : Boolean
      {
         return _dropSelection;
      }
      
      override public function set dropSelection(value:Boolean) : void
      {
         _dropSelection = value;
         invalidateState();
      }
      
      override public function processOver(avatar:SlotDragAvatar) : void
      {
      }
   }
}
