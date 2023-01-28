package red.game.witcher3.managers
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.controls.W3UILoader;
   import red.game.witcher3.menus.inventory.InventorySlot;
   import red.game.witcher3.menus.inventory.W3DragSlot;
   import scaleform.clik.events.DragEvent;
   import scaleform.clik.interfaces.IDragSlot;
   import scaleform.clik.managers.DragManager;
   
   public class W3DragManager
   {
      
      public static var _dragedLoader:W3UILoader;
      
      public static var _dragedSlot:W3DragSlot;
      
      protected static var _stage:Stage;
      
      protected static var _initialized:Boolean = false;
      
      protected static var _inDrag:Boolean = false;
      
      protected static var _dragData:Object;
      
      protected static var _dragTarget:MovieClip;
      
      protected static var _origDragSlot:IDragSlot;
       
      
      public function W3DragManager()
      {
         super();
      }
      
      public static function init(param1:Stage) : void
      {
         if(_initialized)
         {
            return;
         }
         _initialized = true;
         W3DragManager._stage = param1;
         _stage.addEventListener(DragEvent.DRAG_START,DragManager.handleStartDragEvent,false,0,true);
      }
      
      public static function inDrag() : Boolean
      {
         return _inDrag;
      }
      
      public static function handleStartDragEvent(param1:DragEvent) : void
      {
         if(param1.dragTarget == null || param1.dragData == null)
         {
            return;
         }
         var _loc2_:Class = getDefinitionByName("DragInventorySlot") as Class;
         _dragedSlot = new _loc2_();
         _dragedSlot.IconPath = param1.dragData.iconPath;
         _dragedSlot.scaleX = 2 / 3;
         _dragedSlot.scaleY = 2 / 3;
         _stage.addChild(_dragedSlot);
         _dragData = param1.dragData;
         _origDragSlot = param1.dragTarget;
         if(param1.dragData.dragTarget == null)
         {
            return;
         }
         var _loc3_:Point = new Point(0,0);
         var _loc4_:Point = MovieClip(param1.dragData.dragTarget).localToGlobal(_loc3_);
         _dragedSlot.x = _loc4_.x;
         _dragedSlot.y = _loc4_.y;
         _inDrag = true;
         var _loc5_:MovieClip = _dragedSlot as MovieClip;
         _loc5_.mouseEnabled = _loc5_.mouseChildren = false;
         _loc5_.trackAsMenu = true;
         _dragedSlot.startDrag(false);
         _stage.addEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false,0,true);
      }
      
      public static function handleEndDragEvent(param1:MouseEvent) : void
      {
         var _loc5_:DragEvent = null;
         _stage.removeEventListener(MouseEvent.MOUSE_UP,handleEndDragEvent,false);
         _inDrag = false;
         var _loc2_:Boolean = false;
         var _loc3_:IDragSlot = findSpriteAncestorOf(_dragedSlot.dropTarget) as IDragSlot;
         var _loc4_:DragEvent = new DragEvent(DragEvent.DRAG_END,_dragData,_origDragSlot,_loc3_,null);
         _origDragSlot.handleDragEndEvent(_loc4_,_loc2_);
         _origDragSlot.dispatchEvent(_loc4_);
         if(_loc3_ != null && _loc3_ is IDragSlot && _loc3_ != _origDragSlot)
         {
            _loc5_ = new DragEvent(DragEvent.DROP,_dragData,_origDragSlot,_loc3_,null);
            _loc2_ = _loc3_.handleDropEvent(_loc5_);
         }
         _origDragSlot = null;
         _dragedSlot.stopDrag();
         _stage.removeChild(_dragedSlot);
         _dragedSlot = null;
      }
      
      protected static function findSpriteAncestorOf(param1:DisplayObject) : IDragSlot
      {
         while(Boolean(param1) && !(param1 is IDragSlot))
         {
            param1 = param1.parent;
         }
         return param1 as IDragSlot;
      }
      
      public static function GetDragedSlotGridSize() : int
      {
         if(_origDragSlot != null)
         {
            return InventorySlot(_origDragSlot).gridSize;
         }
         return 1;
      }
   }
}
