package red.game.witcher3.slots
{
   import flash.events.MouseEvent;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.GridEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.menus.character_menu.SkillSocketsGroup;
   
   public class SlotSkillSocket extends SlotSkillGrid implements IDropTarget
   {
      
      public static const NULL_SKILL:String = "ESP_NotSet";
       
      
      protected var _slotId:int;
      
      protected var _connector:String;
      
      public var skillSocketGroupRef:SkillSocketsGroup;
      
      public function SlotSkillSocket()
      {
         super();
      }
      
      public function get connector() : String
      {
         return this._connector;
      }
      
      public function set connector(param1:String) : void
      {
         this._connector = param1;
      }
      
      public function get slotId() : int
      {
         return this._slotId;
      }
      
      public function set slotId(param1:int) : void
      {
         this._slotId = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         SlotsTransferManager.getInstance().addDropTarget(this);
      }
      
      override protected function loadIcon(param1:String) : void
      {
         if(Boolean(_data) && _data.skillPath != NULL_SKILL)
         {
            super.loadIcon(param1);
            if(_imageLoader)
            {
               _imageLoader.visible = true;
            }
         }
         else
         {
            unloadIcon();
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
         if(equipedIcon)
         {
            if(Boolean(_data) && !_data.isCoreSkill)
            {
               equipedIcon.visible = _data.isEquipped;
            }
            else
            {
               equipedIcon.visible = false;
            }
         }
      }
      
      protected function updateConnector(param1:String) : void
      {
         if(this.skillSocketGroupRef != null)
         {
            this.skillSocketGroupRef.updateData();
         }
      }
      
      override protected function fireTooltipShowEvent(param1:Boolean = false) : void
      {
         var _loc2_:GridEvent = null;
         if(Boolean(_data) && activeSelectionEnabled)
         {
            _loc2_ = new GridEvent(GridEvent.DISPLAY_TOOLTIP,true,false,index,-1,-1,null,_data as Object);
            _loc2_.tooltipContentRef = "SkillTooltipRef";
            _loc2_.tooltipMouseContentRef = "SkillTooltipRef";
            _loc2_.isMouseTooltip = param1;
            if(param1)
            {
               _loc2_.anchorRect = getGlobalSlotRect();
            }
            if(_data.skillPath != NULL_SKILL)
            {
               _loc2_.tooltipDataSource = "OnGetSkillTooltipData";
            }
            else if(_data.unlocked)
            {
               _loc2_.tooltipCustomArgs = [_data.unlockedOnLevel];
               _loc2_.tooltipDataSource = "OnGetEmptySlotTooltipData";
            }
            else
            {
               _loc2_.tooltipCustomArgs = [_data.unlockedOnLevel];
               _loc2_.tooltipDataSource = "OnGetLockedTooltipData";
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
      
      override protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         if(_data)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnUnequipSkill",[_data.slotId]));
         }
         else
         {
            super.handleMouseDoubleClick(param1);
         }
      }
      
      override public function applyDrop(param1:IDragTarget) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(_data)
         {
            _loc2_ = param1.getDragData() as Object;
            _loc3_ = uint(_data.slotId);
            _loc4_ = uint(_loc2_.skillTypeId);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnEquipSkill",[_loc4_,_loc3_]));
         }
      }
      
      override public function canDrop(param1:IDragTarget) : Boolean
      {
         var _loc2_:Object = param1.getDragData() as Object;
         return selectable && _loc2_.skillType && _loc2_.skillType != "S_Undefined" && !_isLocked;
      }
      
      override public function get dropSelection() : Boolean
      {
         return _dropSelection;
      }
      
      override public function set dropSelection(param1:Boolean) : void
      {
         _dropSelection = param1;
         invalidateState();
      }
      
      override public function processOver(param1:SlotDragAvatar) : void
      {
      }
   }
}
