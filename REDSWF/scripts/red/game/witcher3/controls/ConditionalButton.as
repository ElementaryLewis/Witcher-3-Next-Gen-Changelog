package red.game.witcher3.controls
{
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.controls.Button;
   
   public class ConditionalButton extends Button
   {
       
      
      private var _showOnGamepad:Boolean = false;
      
      private var _showOnMouseKeyboard:Boolean = true;
      
      private var _showOnPC:Boolean = true;
      
      private var _showOnXbox:Boolean = true;
      
      private var _showOnPS4:Boolean = true;
      
      public var mcClickRect:KeyboardButtonClickArea;
      
      private var _visiblityEnabled:Boolean = true;
      
      protected var _clickRectWidth:Number = -1;
      
      public function ConditionalButton()
      {
         super();
         this.visible = false;
         preventAutosizing = true;
         constraintsDisabled = true;
      }
      
      public function get showOnGamepad() : Boolean
      {
         return this._showOnGamepad;
      }
      
      public function set showOnGamepad(param1:Boolean) : void
      {
         this._showOnGamepad = param1;
         this.updateControllerVisibility();
      }
      
      public function get showOnMouseKeyboard() : Boolean
      {
         return this._showOnMouseKeyboard;
      }
      
      public function set showOnMouseKeyboard(param1:Boolean) : void
      {
         this._showOnMouseKeyboard = param1;
         this.updateControllerVisibility();
      }
      
      public function get showOnPC() : Boolean
      {
         return this._showOnPC;
      }
      
      public function set showOnPC(param1:Boolean) : void
      {
         this._showOnPC = param1;
         this.updateControllerVisibility();
      }
      
      public function get showOnXbox() : Boolean
      {
         return this._showOnXbox;
      }
      
      public function set showOnXbox(param1:Boolean) : void
      {
         this._showOnXbox = param1;
         this.updateControllerVisibility();
      }
      
      public function get showOnPS4() : Boolean
      {
         return this._showOnPS4;
      }
      
      public function set showOnPS4(param1:Boolean) : void
      {
         this._showOnPS4 = param1;
         this.updateControllerVisibility();
      }
      
      override public function get visible() : Boolean
      {
         return this._visiblityEnabled;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._visiblityEnabled = param1;
         this.updateControllerVisibility();
      }
      
      override protected function configUI() : void
      {
         super.visible = false;
         super.configUI();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         this.updateControllerVisibility();
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this.updateControllerVisibility();
      }
      
      public function set visibleWidth(param1:Number) : void
      {
         this._clickRectWidth = param1;
         if(this.mcClickRect)
         {
            this.updateClickRectWidth();
         }
         else
         {
            super.width = param1;
         }
      }
      
      override protected function updateText() : void
      {
         super.updateText();
         if(this.mcClickRect)
         {
            this.mcClickRect.state = state;
            this.updateClickRectWidth();
         }
      }
      
      protected function updateClickRectWidth() : void
      {
         if(Boolean(this.mcClickRect) && this._clickRectWidth != -1)
         {
            this.mcClickRect.x = -(this._clickRectWidth / 2);
            this.mcClickRect.setActualSize(this._clickRectWidth,this.mcClickRect.height);
         }
      }
      
      protected function updateControllerVisibility() : void
      {
         var _loc1_:Boolean = InputManager.getInstance().isGamepad();
         var _loc2_:uint = InputManager.getInstance().getPlatform();
         if(this._visiblityEnabled)
         {
            if(_loc1_)
            {
               if(this.showOnGamepad)
               {
                  if(InputManager.getInstance().isXboxPlatform())
                  {
                     super.visible = this._showOnXbox;
                  }
                  else if(InputManager.getInstance().isPsPlatform())
                  {
                     super.visible = this._showOnPS4;
                  }
                  else
                  {
                     super.visible = this._showOnPC;
                  }
               }
               else
               {
                  super.visible = false;
               }
            }
            else if(this.showOnMouseKeyboard)
            {
               if(InputManager.getInstance().isXboxPlatform())
               {
                  super.visible = this._showOnXbox;
               }
               else if(InputManager.getInstance().isPsPlatform())
               {
                  super.visible = this._showOnPS4;
               }
               else
               {
                  super.visible = this._showOnPC;
               }
            }
            else
            {
               super.visible = false;
            }
         }
         else
         {
            super.visible = false;
         }
      }
   }
}
