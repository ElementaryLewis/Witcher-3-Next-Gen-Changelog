package red.game.witcher3.controls
{
   import flash.display.Sprite;
   import scaleform.clik.core.UIComponent;
   
   public class ModuleHighlighting extends UIComponent
   {
      
      protected static const STATE_FOCUSED_LABEL:String = "focused";
      
      protected static const STATE_NORMAL_LABEL:String = "normal";
       
      
      public var imageStumb:Sprite;
      
      public var navigationIcons:Sprite;
      
      protected var _highlighted:Boolean;
      
      protected var _showNavigation:Boolean;
      
      protected var _alwaysHighlight:Boolean;
      
      public function ModuleHighlighting()
      {
         super();
         if(this.imageStumb)
         {
            this.imageStumb.visible = false;
         }
      }
      
      public function get showNavigation() : Boolean
      {
         return this._showNavigation;
      }
      
      public function set showNavigation(param1:Boolean) : void
      {
         this._showNavigation = param1;
         this.navigationIcons.visible = this._showNavigation && this._highlighted;
      }
      
      public function get alwaysHighlight() : Boolean
      {
         return this._alwaysHighlight;
      }
      
      public function set alwaysHighlight(param1:Boolean) : void
      {
         this._alwaysHighlight = param1;
         if(this._alwaysHighlight)
         {
            this.highlighted = true;
         }
      }
      
      public function get highlighted() : Boolean
      {
         return this._highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         this._highlighted = param1;
      }
      
      protected function applyState(param1:String) : void
      {
         if(!_labelHash[param1])
         {
         }
      }
   }
}
