package red.game.witcher3.controls
{
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.controls.Button;
   
   public class ConditionalButton extends Button
   {
       
      
      private var _showOnGamepad:Boolean = false;
      
      private var _showOnMouseKeyboard:Boolean = true;
      
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
         this.updateControllerVisibility(InputManager.getInstance().isGamepad());
      }
      
      public function get showOnMouseKeyboard() : Boolean
      {
         return this._showOnMouseKeyboard;
      }
      
      public function set showOnMouseKeyboard(param1:Boolean) : void
      {
         this._showOnMouseKeyboard = param1;
         this.updateControllerVisibility(InputManager.getInstance().isGamepad());
      }
      
      override public function get visible() : Boolean
      {
         return this._visiblityEnabled;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         this._visiblityEnabled = param1;
         this.updateControllerVisibility(InputManager.getInstance().isGamepad());
      }
      
      override protected function configUI() : void
      {
         super.visible = false;
         super.configUI();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChange,false,0,true);
         this.updateControllerVisibility(InputManager.getInstance().isGamepad());
      }
      
      protected function handleControllerChange(param1:ControllerChangeEvent) : void
      {
         this.updateControllerVisibility(param1.isGamepad);
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
      
      protected function updateControllerVisibility(param1:Boolean) : void
      {
         if(this._visiblityEnabled)
         {
            if(param1)
            {
               super.visible = this.showOnGamepad;
            }
            else
            {
               super.visible = this.showOnMouseKeyboard;
            }
         }
         else
         {
            super.visible = false;
         }
      }
   }
}
