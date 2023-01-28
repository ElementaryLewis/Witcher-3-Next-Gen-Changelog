package red.game.witcher3.controls
{
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.gfx.Extensions;
   import scaleform.gfx.InteractiveObjectEx;
   
   public class MouseCursorComponent
   {
      
      protected static const CURSOR_CONTENT_REF:String = "MouseCursorRef";
       
      
      protected var _canvas:DisplayObjectContainer;
      
      protected var _cursorInstance:MovieClip;
      
      protected var _visible:Boolean = true;
      
      protected var _autoHide:Boolean = true;
      
      protected var _inputMgr:InputManager;
      
      protected var _cursorType:int = 1;
      
      public function MouseCursorComponent(param1:DisplayObjectContainer)
      {
         var target:DisplayObjectContainer = param1;
         super();
         try
         {
            this._inputMgr = InputManager.getInstance();
            this._canvas = target;
            this.loadCursorInstance();
         }
         catch(er:Error)
         {
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
      
      public function get cursorType() : int
      {
         return this._cursorType;
      }
      
      public function set cursorType(param1:int) : void
      {
         this._cursorType = param1;
         if(Boolean(this._cursorInstance) && this._cursorType > 0)
         {
            this._cursorInstance.gotoAndStop(this._cursorType);
         }
      }
      
      public function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         this.updateVisibility();
      }
      
      protected function loadCursorInstance() : void
      {
         var _loc1_:Class = getDefinitionByName(CURSOR_CONTENT_REF) as Class;
         this._cursorInstance = new _loc1_() as MovieClip;
         this._canvas.addChild(this._cursorInstance);
         if(this._cursorType > 0)
         {
            this._cursorInstance.gotoAndStop(this._cursorType);
         }
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
