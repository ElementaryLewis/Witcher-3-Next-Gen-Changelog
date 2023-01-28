package red.game.witcher3.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import red.game.witcher3.managers.RuntimeAssetsManager;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.InteractiveObjectEx;
   
   public class MouseCursor
   {
      
      protected static const CURSOR_CONTENT_REF:String = "MouseCursorRef";
       
      
      protected var _canvas:DisplayObjectContainer;
      
      protected var _cursorInstance:Sprite;
      
      protected var _visible:Boolean = true;
      
      protected var _autoHide:Boolean = true;
      
      protected var _assetsMgr:RuntimeAssetsManager;
      
      protected var _inputMgr:InputManager;
      
      public function MouseCursor(param1:DisplayObjectContainer)
      {
         super();
         this._assetsMgr = RuntimeAssetsManager.getInstanse();
         this._inputMgr = InputManager.getInstance();
         this._canvas = param1;
         if(this._assetsMgr.isLoaded)
         {
            this.loadCursorAsset();
         }
         else
         {
            this._assetsMgr.addEventListener(Event.COMPLETE,this.loadCursorAsset,false,0,true);
         }
      }
      
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(param1:Boolean) : *
      {
         this._visible = param1;
         this.updateVisibility();
      }
      
      public function get autoHide() : Boolean
      {
         return this._autoHide;
      }
      
      public function set autoHide(param1:Boolean) : *
      {
         this._autoHide = param1;
         this.updateVisibility();
      }
      
      public function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this.updateVisibility();
      }
      
      protected function loadCursorAsset(param1:Event = null) : void
      {
         this._cursorInstance = this._assetsMgr.getAsset(CURSOR_CONTENT_REF) as Sprite;
         this._canvas.addChild(this._cursorInstance);
         this._cursorInstance.x = this._canvas.mouseX;
         this._cursorInstance.y = this._canvas.mouseY;
         InteractiveObjectEx.setHitTestDisable(this._cursorInstance,true);
         InteractiveObjectEx.setTopmostLevel(this._cursorInstance,true);
         this._canvas.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMove,false,0,true);
         this._inputMgr.addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
         this.updateVisibility();
      }
      
      protected function updateVisibility() : void
      {
         if(!Extensions.isScaleform)
         {
            return;
         }
         if(this._cursorInstance)
         {
            if(this._autoHide)
            {
               this._cursorInstance.visible = !this._inputMgr.isGamepad() && this._visible;
            }
            else
            {
               this._cursorInstance.visible = this._visible;
            }
         }
      }
      
      protected function handleMouseMove(param1:MouseEvent) : void
      {
         this._cursorInstance.x = param1.stageX;
         this._cursorInstance.y = param1.stageY;
      }
   }
}
