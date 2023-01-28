package red.core
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.events.Event;
   import red.game.witcher3.controls.ModuleHighlighting;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ListEvent;
   
   public class CoreMenuModule extends UIComponent
   {
      
      public static const EVENT_MOUSE_FOCUSE:String = "EVENT_MOUSE_FOCUSE";
      
      protected static const INVALIDATE_CONTEXT:String = "invalidate_context";
       
      
      protected var _inputHandlers:Vector.<UIComponent>;
      
      public var mcHighlight:ModuleHighlighting;
      
      public var dataBindingKey:String = "core.menu.module.base";
      
      protected var DATA_UPDATE_ALPHA_ANIMATION_TIME:Number = 3;
      
      protected var _active:Boolean;
      
      protected var _isVisible:Boolean = true;
      
      public function CoreMenuModule()
      {
         super();
         this._inputHandlers = new Vector.<UIComponent>();
         if(stage)
         {
            this.init();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.init,false,int.MAX_VALUE,true);
         }
      }
      
      public function get active() : Boolean
      {
         return this._active;
      }
      
      public function set active(param1:Boolean) : void
      {
         this._active = param1;
         if(visible != this._active)
         {
            visible = this._active;
            if(visible)
            {
               alpha = 0;
               GTweener.removeTweens(this);
               GTweener.to(this,2,{"alpha":1},{"ease":Exponential.easeOut});
            }
         }
         if(enabled != this._active)
         {
            this.enabled = this._active;
         }
      }
      
      public function hasSelectableItems() : Boolean
      {
         return visible;
      }
      
      private function init(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.init,false);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false,int.MIN_VALUE,true);
         addEventListener(ListEvent.ITEM_CLICK,this.handleSlotClick,false,0,true);
         this.onCoreInit();
         tabEnabled = false;
         tabChildren = false;
      }
      
      protected function handleSlotClick(param1:ListEvent) : void
      {
         if(focused < 1)
         {
            dispatchEvent(new Event(EVENT_MOUSE_FOCUSE));
         }
      }
      
      protected function onCoreInit() : void
      {
      }
      
      protected function onCoreCleanup() : void
      {
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
      }
      
      override public function set enabled(param1:Boolean) : void
      {
         if(param1 != enabled && initialized)
         {
            if(param1)
            {
               dispatchEvent(new Event(Event.ACTIVATE));
            }
            else
            {
               dispatchEvent(new Event(Event.DEACTIVATE));
            }
         }
         super.enabled = param1;
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage,false);
      }
      
      override public function set focused(param1:Number) : void
      {
         var _loc2_:Error = new Error();
         if(_focused != param1)
         {
            _focused = param1;
            this.changeFocus();
         }
      }
      
      override protected function changeFocus() : void
      {
         super.changeFocus();
         this.handleFocusChanged();
      }
      
      protected function handleControllerChanged(param1:Event) : void
      {
         this.handleFocusChanged();
      }
      
      protected function handleFocusChanged() : void
      {
         if(_focused > 0)
         {
            if(Boolean(this.mcHighlight) && InputManager.getInstance().isGamepad())
            {
            }
            this.handleModuleSelected();
         }
         else if(Boolean(this.mcHighlight) && InputManager.getInstance().isGamepad())
         {
            this.mcHighlight.highlighted = false;
         }
      }
      
      protected function handleModuleSelected() : void
      {
      }
      
      public function handleDataChanged() : void
      {
         if(alpha == 0)
         {
            GTweener.removeTweens(this);
            GTweener.to(this,this.DATA_UPDATE_ALPHA_ANIMATION_TIME,{"alpha":1},{"ease":Exponential.easeOut});
         }
      }
      
      public function set backgroundVisible(param1:Boolean) : void
      {
         if(param1 != this._isVisible)
         {
            this._isVisible = param1;
            GTweener.removeTweens(this);
            if(param1)
            {
               visible = true;
               GTweener.to(this,0.2,{"alpha":1},{});
            }
            else
            {
               GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.handleHideComplete});
            }
         }
      }
      
      protected function handleHideComplete(param1:GTween) : void
      {
         visible = false;
      }
   }
}
