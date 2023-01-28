package red.game.witcher3.slots
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import red.game.witcher3.events.ItemDragEvent;
   import red.game.witcher3.interfaces.IDragTarget;
   import red.game.witcher3.interfaces.IDropTarget;
   import red.game.witcher3.utils.Math2;
   import scaleform.clik.core.UIComponent;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.MouseEventEx;
   
   public class SlotsTransferManager extends EventDispatcher
   {
      
      protected static const DRAG_START_OFFSET:Number = 10;
      
      protected static var _instance:SlotsTransferManager;
       
      
      protected var _dragTargets:Vector.<IDragTarget>;
      
      protected var _dropTargets:Vector.<IDropTarget>;
      
      protected var _actualDropTargets:Vector.<IDropTarget>;
      
      protected var _downPoint:Point;
      
      protected var _dragging:Boolean;
      
      protected var _canvas:Sprite;
      
      protected var _avatar:SlotDragAvatar;
      
      protected var _disabled:Boolean;
      
      protected var _currentStage:Stage;
      
      protected var _currentDragItem:IDragTarget;
      
      protected var _currentRecepient:IDropTarget;
      
      public function SlotsTransferManager()
      {
         super();
         this._dragTargets = new Vector.<IDragTarget>();
         this._dropTargets = new Vector.<IDropTarget>();
         this._actualDropTargets = new Vector.<IDropTarget>();
      }
      
      public static function getInstance() : SlotsTransferManager
      {
         if(!_instance)
         {
            _instance = new SlotsTransferManager();
         }
         return _instance;
      }
      
      public function get disabled() : Boolean
      {
         return this._disabled;
      }
      
      public function set disabled(param1:Boolean) : void
      {
         this._disabled = param1;
         if(this._disabled && this._dragging)
         {
            this.stopDrag();
         }
      }
      
      public function init(param1:Sprite) : void
      {
         this._canvas = param1;
      }
      
      public function isDragging() : Boolean
      {
         return this._dragging;
      }
      
      public function addDragTarget(param1:IDragTarget) : void
      {
         this._dragTargets.push(param1);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.handleDragRemovedFromStage,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleMouseDown,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver,false,0,true);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut,false,0,true);
      }
      
      public function addDropTarget(param1:IDropTarget) : void
      {
         this._dropTargets.push(param1);
         param1.addEventListener(Event.REMOVED_FROM_STAGE,this.handleDropRemovedFromStage,false,0,true);
      }
      
      public function removeDragTarget(param1:IDragTarget) : void
      {
         var _loc2_:int = this._dragTargets.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._dragTargets.splice(_loc2_,1);
         }
      }
      
      public function removeDropTarget(param1:IDropTarget) : void
      {
         var _loc2_:int = this._dropTargets.indexOf(param1);
         if(_loc2_ > -1)
         {
            this._dropTargets.splice(_loc2_,1);
         }
      }
      
      public function showDropTargets(param1:IDragTarget) : void
      {
         if(!this._dragging)
         {
            this.removeDropHighlighting();
            if(param1.canDrag())
            {
               this.highlightDropTargets(param1);
            }
         }
      }
      
      public function hideDropTargets() : void
      {
         if(!this._dragging)
         {
            this.removeDropHighlighting();
         }
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:IDragTarget = null;
         if(!this._dragging)
         {
            _loc2_ = param1.currentTarget as IDragTarget;
            this.removeDropHighlighting();
            if(Boolean(_loc2_) && _loc2_.canDrag())
            {
               this.highlightDropTargets(param1.currentTarget as IDragTarget);
            }
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:IDragTarget = param1.currentTarget as IDragTarget;
         if(Boolean(_loc2_) && !this._dragging)
         {
            this.removeDropHighlighting();
         }
      }
      
      private function handleMouseDown(param1:MouseEvent) : void
      {
         if(this._disabled)
         {
            return;
         }
         var _loc2_:MouseEventEx = param1 as MouseEventEx;
         if(Boolean(_loc2_) && _loc2_.buttonIdx != MouseEventEx.LEFT_BUTTON)
         {
            return;
         }
         var _loc3_:IDragTarget = param1.currentTarget as IDragTarget;
         if(_loc3_.canDrag())
         {
            this._downPoint = new Point(param1.stageX,param1.stageY);
            this.waitForDragging(_loc3_);
         }
      }
      
      private function handleDragRemovedFromStage(param1:Event) : void
      {
         this.removeDragTarget(param1.currentTarget as IDragTarget);
      }
      
      private function handleDropRemovedFromStage(param1:Event) : void
      {
         this.removeDropTarget(param1.currentTarget as IDropTarget);
      }
      
      protected function waitForDragging(param1:IDragTarget) : void
      {
         var _loc2_:UIComponent = param1 as UIComponent;
         var _loc3_:Stage = _loc2_.stage;
         this._currentStage = _loc3_;
         this._currentDragItem = param1;
         _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         _loc3_.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp,false,0,true);
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:IDropTarget = null;
         var _loc4_:IDropTarget = null;
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         if(!this._dragging)
         {
            this.tryStartDrag(param1.stageX,param1.stageY);
         }
         else if(this._dragging)
         {
            _loc2_ = Extensions.getMouseTopMostEntity(true);
            while(_loc2_ && !_loc3_ && Boolean(_loc2_.parent))
            {
               _loc3_ = _loc2_ as IDropTarget;
               _loc2_ = _loc2_.parent;
               if(Boolean(_loc3_) && _loc3_.dropEnabled)
               {
                  _loc4_ = _loc3_;
               }
               else
               {
                  _loc3_ = null;
               }
            }
            if(!_loc3_ && Boolean(_loc4_))
            {
               _loc3_ = _loc4_;
            }
            _loc5_ = Boolean(_loc3_) && _loc3_.canDrop(this._currentDragItem);
            if(Boolean(_loc3_) && _loc5_)
            {
               if(Boolean(this._currentRecepient) && this._currentRecepient != _loc3_)
               {
                  this._currentRecepient.processOver(null);
               }
               this._currentRecepient = _loc3_;
               this._currentRecepient.dropSelection = true;
               _loc6_ = this._currentRecepient.processOver(this._avatar);
               if(this._avatar)
               {
                  this._avatar.setActionIcon(_loc6_);
               }
            }
            else
            {
               if(this._currentRecepient)
               {
                  this._currentRecepient.processOver(null);
               }
               this._currentRecepient = null;
               if(this._avatar)
               {
                  if(!_loc5_ && _loc3_ && _loc3_ != this._currentDragItem)
                  {
                     this._avatar.setActionIcon(SlotDragAvatar.ACTION_ERROR);
                  }
                  else
                  {
                     this._avatar.setActionIcon(SlotDragAvatar.ACTION_NONE);
                  }
               }
            }
         }
      }
      
      protected function handleMouseUp(param1:MouseEvent) : void
      {
         this.stopDrag();
      }
      
      protected function tryStartDrag(param1:Number, param2:Number) : void
      {
         var _loc4_:ItemDragEvent = null;
         if(!this._currentDragItem || !this._downPoint || !this._canvas)
         {
            return;
         }
         var _loc3_:Number = Math2.getSegmentLength(this._downPoint,new Point(param1,param2));
         this._dragging = _loc3_ > DRAG_START_OFFSET;
         if(this._dragging && !this._avatar)
         {
            this._avatar = new SlotDragAvatar(this._currentDragItem.getAvatar(),this._currentDragItem.getDragData(),this._currentDragItem);
            if(!this._avatar)
            {
               this._dragging = false;
               throw new Error("Can\'t get dragging view avatar from object ",this._currentDragItem);
            }
            this._canvas.addChild(this._avatar);
            this._avatar.x = param1;
            this._avatar.y = param2;
            this._avatar.startDrag(true);
            this._avatar.mouseChildren = false;
            this._avatar.mouseEnabled = false;
            this._currentDragItem.dragSelection = true;
            (_loc4_ = new ItemDragEvent(ItemDragEvent.START_DRAG)).targetItem = this._currentDragItem;
            dispatchEvent(_loc4_);
            this.highlightDropTargets(this._currentDragItem);
         }
      }
      
      protected function stopDrag() : void
      {
         var _loc1_:ItemDragEvent = new ItemDragEvent(ItemDragEvent.STOP_DRAG);
         if(this._dragging)
         {
            if(this._currentRecepient)
            {
               this._currentRecepient.processOver(null);
               this._currentRecepient.applyDrop(this._currentDragItem);
               _loc1_.targetRecepient = this._currentRecepient;
            }
            if(this._avatar)
            {
               this._avatar.stopDrag();
               this._canvas.removeChild(this._avatar);
               this._avatar = null;
            }
            this._dragging = false;
            this._currentDragItem.dragSelection = false;
            this.removeDropHighlighting();
         }
         if(this._currentStage)
         {
            this._currentStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove);
            this._currentStage.removeEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
            this._currentDragItem = null;
         }
         dispatchEvent(_loc1_);
      }
      
      protected function highlightDropTargets(param1:IDragTarget) : void
      {
         var _loc4_:IDropTarget = null;
         var _loc5_:* = false;
         var _loc2_:int = int(this._dropTargets.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._dropTargets[_loc3_];
            _loc5_ = param1 == _loc4_;
            if(_loc4_.canDrop(param1) && !_loc5_)
            {
               _loc4_.dropSelection = true;
               this._actualDropTargets.push(_loc4_);
            }
            _loc3_++;
         }
      }
      
      protected function removeDropHighlighting() : void
      {
         while(this._actualDropTargets.length)
         {
            this._actualDropTargets.pop().dropSelection = false;
         }
      }
   }
}
