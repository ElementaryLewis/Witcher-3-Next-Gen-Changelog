package red.game.witcher3.menus.character_menu
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   
   public class MutationTooltipButton extends UIComponent
   {
      
      public static const TYPE_START_RESEARCH:uint = 0;
      
      public static const TYPE_CLOSE_RESEARCH:uint = 1;
      
      public static const TYPE_EQUIP:uint = 2;
      
      public static const TYPE_UNEQUIP:uint = 3;
      
      public static const TYPE_APPLY:uint = 4;
      
      private static const RED_FRAME:uint = 1;
      
      private static const GREEN_FRAME:uint = 2;
      
      private static const BTN_PADDING:Number = 5;
       
      
      public var mcBackground:MovieClip;
      
      public var tfLabelRequirements:TextField;
      
      public var btnAction:InputFeedbackButton;
      
      private var _type:uint;
      
      private var _canBeHighlighted:Boolean;
      
      public function MutationTooltipButton()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver,false,0,true);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut,false,0,true);
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.handleControllerChanged,false,0,true);
      }
      
      public function setType(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         this.btnAction.clickable = false;
         this._type = param1;
         switch(this._type)
         {
            case TYPE_APPLY:
               _loc3_ = "[[panel_common_apply]]";
               _loc2_ = GREEN_FRAME;
               this.btnAction.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
               this._canBeHighlighted = true;
               break;
            case TYPE_START_RESEARCH:
               _loc3_ = "[[mutation_input_research_mutation]]";
               _loc2_ = GREEN_FRAME;
               this.btnAction.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
               break;
            case TYPE_CLOSE_RESEARCH:
               _loc3_ = "[[mutation_input_close_research]]";
               _loc2_ = RED_FRAME;
               this.btnAction.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
               this._canBeHighlighted = true;
               break;
            case TYPE_EQUIP:
               _loc3_ = "[[mutation_input_activate_mutation]]";
               _loc2_ = GREEN_FRAME;
               this.btnAction.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
               break;
            case TYPE_UNEQUIP:
               _loc3_ = "[[mutation_input_deactivate_mutation]]";
               _loc2_ = RED_FRAME;
               this.btnAction.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.ENTER);
         }
         gotoAndStop(_loc2_);
         this.tfLabelRequirements.text = _loc3_;
         this.updateAlignment();
      }
      
      private function handleControllerChanged(param1:Event) : void
      {
         this.updateAlignment();
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(this._canBeHighlighted && Boolean(this.mcBackground))
         {
            this.mcBackground.gotoAndStop("highlighted");
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(this._canBeHighlighted && Boolean(this.mcBackground))
         {
            this.mcBackground.gotoAndStop("normal");
         }
      }
      
      private function updateAlignment() : void
      {
         this.tfLabelRequirements.x = this.btnAction.x + this.btnAction.getViewWidth() + BTN_PADDING;
      }
   }
}
