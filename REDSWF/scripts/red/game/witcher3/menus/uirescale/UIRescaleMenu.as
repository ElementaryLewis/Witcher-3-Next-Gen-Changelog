package red.game.witcher3.menus.uirescale
{
   import flash.text.TextField;
   import red.core.CoreMenu;
   import red.core.constants.KeyCode;
   import red.core.events.GameEvent;
   import red.game.witcher3.menus.mainmenu.UIRescaleModule;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class UIRescaleMenu extends CoreMenu
   {
       
      
      public var mcUIRescaleModule:UIRescaleModule;
      
      protected var initialH:Number = -1;
      
      protected var initialV:Number = -1;
      
      public var txtUserName:TextField;
      
      public var mcInputFeedbackModule:ModuleInputFeedback;
      
      public function UIRescaleMenu()
      {
         addFrameScript(0,this.frame1);
         super();
      }
      
      override protected function get menuName() : String
      {
         return "RescaleMenu";
      }
      
      public function setCurrentUsername(param1:String) : void
      {
         if(this.txtUserName)
         {
            this.txtUserName.text = param1;
         }
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.setCurrentUsername("");
         stage.addEventListener(InputEvent.INPUT,this.handleInput,false,100,true);
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"uirescale.initial.horizontal",[this.SetInitialScaleHorizontal]));
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"uirescale.initial.vertical",[this.SetInitialScaleVertical]));
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         this.mcInputFeedbackModule.appendButton(0,NavigationCode.GAMEPAD_L3,-1,"[[panel_button_common_navigation]]",false);
         this.mcInputFeedbackModule.appendButton(1,NavigationCode.GAMEPAD_A,KeyCode.E,"[[panel_continue]]",true);
      }
      
      public function SetInitialScaleHorizontal(param1:Number) : *
      {
         this.initialH = param1;
         if(this.initialV != -1)
         {
            this.mcUIRescaleModule.showWithScale(this.initialH,this.initialV);
         }
      }
      
      public function SetInitialScaleVertical(param1:Number) : *
      {
         this.initialV = param1;
         if(this.initialH != -1)
         {
            this.mcUIRescaleModule.showWithScale(this.initialH,this.initialV);
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         CommonUtils.convertWASDCodeToNavEquivalent(_loc2_);
         if(_loc2_.navEquivalent == NavigationCode.GAMEPAD_A && _loc2_.value == InputValue.KEY_UP)
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfirmRescale",[this.mcUIRescaleModule._lastSentHValue,this.mcUIRescaleModule._lastSentVValue]));
            closeMenu();
            param1.handled = true;
         }
         else
         {
            this.mcUIRescaleModule.handleInputNavigate(param1);
         }
         if(_loc2_.value == InputValue.KEY_UP && (_loc2_.code == KeyCode.SPACE || _loc2_.code == KeyCode.ENTER || _loc2_.code == KeyCode.E))
         {
            closeMenu();
            param1.handled = true;
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
