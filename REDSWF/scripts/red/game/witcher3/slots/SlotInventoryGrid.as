package red.game.witcher3.slots
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.core.events.GameEvent;
   import red.game.witcher3.interfaces.IInventorySlot;
   import red.game.witcher3.menus.common.ItemDataStub;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.InputEvent;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotInventoryGrid extends SlotBase implements IInventorySlot
   {
      
      private static const ENABLE_DEBUG_IDX:Boolean = false;
       
      
      protected var so_bottom:Number = 6;
      
      protected var so_top:Number = 9;
      
      protected var so_left_right:Number = 4;
      
      protected var so_left_padding:Number = 1;
      
      public var textIdx:TextField;
      
      public var mcGridBackground:MovieClip;
      
      public var equipedIcon:MovieClip;
      
      protected var _isOverburdened:Boolean = false;
      
      protected var _uplink:IInventorySlot;
      
      public function SlotInventoryGrid()
      {
         super();
         if(this.equipedIcon)
         {
            this.equipedIcon.visible = false;
         }
      }
      
      override public function set index(param1:uint) : void
      {
         super.index = param1;
         if(Boolean(this.textIdx) && ENABLE_DEBUG_IDX)
         {
            this.textIdx.text = String(param1);
         }
      }
      
      override protected function updateData() : *
      {
         super.updateData();
         if(Boolean(_data) && Boolean(this.equipedIcon))
         {
            this.equipedIcon.visible = _data.isEquipped;
         }
         if(mcStateDropTarget)
         {
            if(Boolean(_data) && Boolean(_data.highlighted))
            {
               mcStateDropTarget.visible = true;
               mcStateDropTarget.alpha = 1;
            }
            else
            {
               mcStateDropTarget.visible = false;
            }
         }
      }
      
      public function setOverburdened(param1:Boolean) : void
      {
         if(this._isOverburdened != param1 && Boolean(this.mcGridBackground))
         {
            this._isOverburdened = param1;
            if(this._isOverburdened)
            {
               this.mcGridBackground.gotoAndPlay("Overburdened");
            }
            else
            {
               this.mcGridBackground.gotoAndPlay("Normal");
            }
         }
      }
      
      public function get uplink() : IInventorySlot
      {
         return this._uplink;
      }
      
      public function set uplink(param1:IInventorySlot) : void
      {
         var _loc2_:DisplayObject = null;
         this._uplink = param1;
         mouseEnabled = !this._uplink;
         if(this._uplink)
         {
            _loc2_ = this._uplink as DisplayObject;
            _loc2_.parent.addChild(_loc2_);
         }
      }
      
      public function get highlight() : Boolean
      {
         return _highlight;
      }
      
      public function set highlight(param1:Boolean) : void
      {
         _highlight = param1;
         invalidateState();
      }
      
      override public function toString() : String
      {
         return "SlotInventoryGrid [ " + this.name + " ] index: " + this.index;
      }
      
      override public function cleanup() : void
      {
         super.cleanup();
         this.wipeIndicators();
         gridSize = 1;
         this._uplink = null;
         mouseEnabled = true;
         if(this.equipedIcon)
         {
            this.equipedIcon.visible = false;
         }
      }
      
      protected function wipeIndicators() : void
      {
         _currentIdicator = null;
         resetIndicators();
      }
      
      override public function get selectable() : Boolean
      {
         return super.selectable && this._uplink == null && !_isEmpty;
      }
      
      override protected function updateSize() : *
      {
         var _loc2_:Rectangle = null;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:* = new Namespace("");
         super.updateSize();
         var _loc1_:int = int(_indicators.length);
         _loc2_ = getSlotRect();
         while(_loc3_ < _loc1_)
         {
            _loc4_ = _indicators[_loc3_];
            this.updateItemSize(_loc4_,_loc2_);
            _loc3_++;
         }
         if(mcHitArea)
         {
            this.updateItemSize(mcHitArea,_loc2_);
         }
         if(mcColorBackground)
         {
            this.updateItemSize(mcColorBackground,_loc2_);
         }
         if(mcCantEquipIcon)
         {
            mcCantEquipIcon.x = _loc2_.x + _loc2_.width / 2;
            mcCantEquipIcon.y = _loc2_.y + _loc2_.height / 2;
         }
         if(this.equipedIcon)
         {
            _loc5_ = 14;
            this.equipedIcon.width = _loc2_.width + _loc5_;
            this.equipedIcon.height = _loc2_.height + _loc5_;
            this.equipedIcon.x = _loc2_.x + _loc2_.width / 2;
            this.equipedIcon.y = _loc2_.y + _loc2_.height / 2;
         }
         if(mcSlotOverlays)
         {
            mcSlotOverlays.updateSize(getSlotRect());
         }
      }
      
      protected function updateItemSize(param1:MovieClip, param2:Rectangle) : void
      {
         var _loc3_:* = new Namespace("");
         if(param1 != null && param1 == mcStateSelectedActive)
         {
            _loc3_ = 2;
            param1.width = param2.width;
            param1.height = param2.height;
            param1.x = param2.x + param1.width / 2;
            param1.y = param2.y + param1.height / 2;
            return;
         }
         if(param1 as UIComponent)
         {
            (param1 as UIComponent).setActualSize(param2.width,param2.height);
         }
         else
         {
            param1.width = param2.width;
            param1.height = param2.height;
         }
         param1.x = param2.x + param1.width / 2;
         param1.y = param2.y + param1.height / 2;
      }
      
      public function tryExecuteAssignedAction() : void
      {
         if(useContextMgr)
         {
            this.callContextFunction();
         }
      }
      
      override protected function handleMouseDoubleClick(param1:MouseEvent) : void
      {
         var _loc2_:MouseEventEx = null;
         if(useContextMgr)
         {
            _loc2_ = param1 as MouseEventEx;
            if(Boolean(_loc2_) && _loc2_.buttonIdx == MouseEventEx.LEFT_BUTTON)
            {
               this.callContextFunction();
            }
         }
         else
         {
            super.handleMouseDoubleClick(param1);
         }
      }
      
      protected function callContextFunction() : void
      {
         var _loc3_:Array = null;
         if(!owner)
         {
            return;
         }
         var _loc1_:ItemDataStub = data as ItemDataStub;
         var _loc2_:CoreMenuModule = this.getParentModule();
         if(Boolean(_loc2_) && Boolean(_loc1_))
         {
            _loc3_ = [];
            _loc3_.push("enter-gamepad_A");
            _loc3_.push(_loc1_.id);
            _loc3_.push(_loc1_.slotType);
            _loc3_.push(_loc2_.dataBindingKey);
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnMouseInputHandled",_loc3_));
         }
      }
      
      protected function getParentModule() : CoreMenuModule
      {
         var _loc1_:DisplayObjectContainer = owner;
         var _loc2_:CoreMenuModule = _loc1_ as CoreMenuModule;
         while(!_loc2_ && _loc1_ && Boolean(_loc1_.parent))
         {
            _loc1_ = _loc1_.parent;
            _loc2_ = _loc1_ as CoreMenuModule;
         }
         return _loc2_;
      }
      
      override protected function updateMouseContext() : void
      {
         var _loc1_:ItemDataStub = data as ItemDataStub;
         var _loc2_:CoreMenuModule = this.getParentModule();
         if(Boolean(_loc2_) && Boolean(_loc1_))
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSetMouseInventoryComponent",[_loc2_.dataBindingKey,_loc1_.slotType]));
         }
      }
      
      override protected function executeDefaultAction(param1:Number, param2:InputEvent) : void
      {
         if(!useContextMgr)
         {
            super.executeDefaultAction(param1,param2);
         }
      }
   }
}
