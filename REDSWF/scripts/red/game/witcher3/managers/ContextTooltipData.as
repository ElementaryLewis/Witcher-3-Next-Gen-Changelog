package red.game.witcher3.managers
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import red.core.events.GameEvent;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.tooltips.TooltipBase;
   
   public class ContextTooltipData extends EventDispatcher
   {
       
      
      protected var _dataBinding:String;
      
      protected var _hideBinding:String;
      
      protected var _contentReference:String;
      
      protected var _anchor:DisplayObject;
      
      protected var _canvas:Sprite;
      
      protected var _tooltipInstance:TooltipBase;
      
      protected var _gamepadOnly:Boolean;
      
      public function ContextTooltipData(param1:String, param2:String)
      {
         super();
         this._dataBinding = param1;
         this._hideBinding = param2;
      }
      
      public function get gamepadOnly() : Boolean
      {
         return this._gamepadOnly;
      }
      
      public function set gamepadOnly(param1:Boolean) : void
      {
         this._gamepadOnly = param1;
      }
      
      public function setContentRefs(param1:String, param2:DisplayObject, param3:Sprite) : void
      {
         this._contentReference = param1;
         this._anchor = param2;
         this._canvas = param3;
         this._canvas.dispatchEvent(new GameEvent(GameEvent.REGISTER,this._dataBinding,[this.handleSetData]));
         this._canvas.dispatchEvent(new GameEvent(GameEvent.REGISTER,this._hideBinding,[this.handleHideRequest]));
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged);
      }
      
      public function destroyTooltip() : void
      {
         this._canvas.dispatchEvent(new GameEvent(GameEvent.UNREGISTER,this._dataBinding,[this.handleSetData]));
         this._canvas.dispatchEvent(new GameEvent(GameEvent.UNREGISTER,this._hideBinding,[this.handleHideRequest]));
         this.removeInstance();
      }
      
      public function removeInstance() : void
      {
         if(this._tooltipInstance)
         {
            this._canvas.removeChild(this._tooltipInstance);
            this._tooltipInstance = null;
         }
      }
      
      public function getAnchor() : DisplayObject
      {
         return this._anchor;
      }
      
      public function getDataBinding() : String
      {
         return this._dataBinding;
      }
      
      protected function handleSetData(param1:Object) : void
      {
         trace("GFX ContextTooltipData [",this._contentReference,"][",this._tooltipInstance,"], handleSetData ");
         if(!InputManager.getInstance().isGamepad() && this.gamepadOnly)
         {
            return;
         }
         if(this._contentReference)
         {
            if(!this._tooltipInstance)
            {
               dispatchEvent(new Event(Event.ACTIVATE));
               this.createInstance();
            }
            if(this._tooltipInstance)
            {
               this._tooltipInstance.data = param1;
            }
         }
      }
      
      protected function handleHideRequest(param1:Boolean) : void
      {
         if(!InputManager.getInstance().isGamepad() && this.gamepadOnly)
         {
            return;
         }
         dispatchEvent(new Event(Event.DEACTIVATE));
      }
      
      protected function createInstance() : void
      {
         if(!this._tooltipInstance)
         {
            this._tooltipInstance = this.getDefinition(this._contentReference) as TooltipBase;
            this._tooltipInstance.anchorRect = new Rectangle(this._anchor.x,this._anchor.y,0,0);
            this._tooltipInstance.lockFixedPosition = true;
            this._canvas.addChild(this._tooltipInstance);
            this._tooltipInstance.validateNow();
         }
      }
      
      protected function getDefinition(param1:String) : DisplayObject
      {
         var _loc2_:RuntimeAssetsManager = RuntimeAssetsManager.getInstanse();
         return _loc2_.getAsset(param1);
      }
      
      protected function handleControllerChanged(param1:ControllerChangeEvent) : void
      {
         if(Boolean(this._tooltipInstance) && this.gamepadOnly)
         {
            this._tooltipInstance.visible = param1.isGamepad;
         }
      }
      
      override public function toString() : String
      {
         return "ContextTooltipData ref: " + this._contentReference;
      }
   }
}
