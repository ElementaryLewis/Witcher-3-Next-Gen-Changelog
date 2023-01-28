package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import red.core.CoreMenuModule;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.ConditionalButton;
   import red.game.witcher3.controls.W3TextArea;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.ButtonEvent;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class GamepadMappingModule extends CoreMenuModule
   {
       
      
      public var txtRightJoy:W3TextArea;
      
      public var txtXButton:W3TextArea;
      
      public var txtAButton:W3TextArea;
      
      public var txtBButton:W3TextArea;
      
      public var txtYButton:W3TextArea;
      
      public var txtRightBumper:W3TextArea;
      
      public var txtRightTrigger:W3TextArea;
      
      public var txtStartButton:W3TextArea;
      
      public var txtSelectButton:W3TextArea;
      
      public var txtLeftTrigger:W3TextArea;
      
      public var txtLeftBumper:W3TextArea;
      
      public var txtLeftJoy:W3TextArea;
      
      public var txtDPad:W3TextArea;
      
      public var mcLeftPCButton:ConditionalButton;
      
      public var mcRightPCButton:ConditionalButton;
      
      public var txtLayoutName:TextField;
      
      protected var dataArray:Array;
      
      protected var selectedIndex:int = 0;
      
      public function GamepadMappingModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         if(this.mcLeftPCButton)
         {
            this.mcLeftPCButton.addEventListener(ButtonEvent.PRESS,this.handlePrevButtonPress,false,0,true);
         }
         if(this.mcRightPCButton)
         {
            this.mcRightPCButton.addEventListener(ButtonEvent.PRESS,this.handleNextButtonPress,false,0,true);
         }
         enabled = false;
         visible = false;
         alpha = 0;
      }
      
      public function showWithData(param1:Array, param2:int) : void
      {
         visible = true;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
         switch(param2)
         {
            case CommonConstants.PLATFORM_PC:
               gotoAndStop("pc");
               break;
            case CommonConstants.PLATFORM_XBOX1:
               gotoAndStop("xbox");
               break;
            case CommonConstants.PLATFORM_PS4:
               gotoAndStop("ps");
               addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
         this.dataArray = param1;
         this.selectedIndex = 0;
         this.updateButtonMapping();
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         if(this.txtLeftBumper)
         {
            this.txtLeftBumper.x = 125.7;
            this.txtLeftBumper.y = 376.9;
         }
         if(this.txtRightBumper)
         {
            this.txtRightBumper.x = 1098.05;
            this.txtRightBumper.y = 312.15;
         }
         if(this.txtYButton)
         {
            this.txtYButton.x = 1108.95;
            this.txtYButton.y = 438.3;
         }
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame);
      }
      
      public function hide() : void
      {
         if(visible)
         {
            GTweener.removeTweens(this);
            enabled = false;
            GTweener.to(this,0.2,{"alpha":0},{"onComplete":this.onHideComplete});
         }
      }
      
      protected function onHideComplete(param1:GTween) : void
      {
         visible = false;
      }
      
      protected function handlePrevButtonPress(param1:ButtonEvent) : void
      {
         this.navigateLeft();
      }
      
      protected function handleNextButtonPress(param1:ButtonEvent) : void
      {
         this.navigateRight();
      }
      
      public function handleInputNavigate(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = null;
         var _loc3_:* = false;
         if(visible)
         {
            _loc2_ = param1.details;
            _loc3_ = _loc2_.value == InputValue.KEY_UP;
            if(_loc3_ && !param1.handled)
            {
               switch(_loc2_.navEquivalent)
               {
                  case NavigationCode.GAMEPAD_B:
                     this.handleNavigateBack();
                     break;
                  case NavigationCode.LEFT:
                     this.navigateLeft();
                     break;
                  case NavigationCode.RIGHT:
                     this.navigateRight();
               }
            }
         }
      }
      
      protected function navigateLeft() : void
      {
         if(this.selectedIndex > 0)
         {
            --this.selectedIndex;
         }
         else
         {
            this.selectedIndex = this.dataArray.length - 1;
         }
         this.updateButtonMapping();
      }
      
      protected function navigateRight() : void
      {
         if(this.selectedIndex < this.dataArray.length - 1)
         {
            this.selectedIndex += 1;
         }
         else
         {
            this.selectedIndex = 0;
         }
         this.updateButtonMapping();
      }
      
      protected function updateButtonMapping() : void
      {
         var _loc1_:Object = null;
         _loc1_ = this.dataArray[this.selectedIndex];
         if(this.txtLayoutName)
         {
            this.txtLayoutName.htmlText = _loc1_.layoutName;
         }
         if(this.txtRightJoy)
         {
            if(_loc1_.txtRightJoy == "")
            {
               this.txtRightJoy.visible = false;
            }
            else
            {
               this.txtRightJoy.visible = true;
               this.txtRightJoy.htmlText = _loc1_.txtRightJoy;
            }
         }
         if(this.txtXButton)
         {
            if(_loc1_.txtXButton == "")
            {
               this.txtXButton.visible = false;
            }
            else
            {
               this.txtXButton.visible = true;
               this.txtXButton.htmlText = _loc1_.txtXButton;
            }
         }
         if(this.txtAButton)
         {
            if(_loc1_.txtAButton == "")
            {
               this.txtAButton.visible = false;
            }
            else
            {
               this.txtAButton.visible = true;
               this.txtAButton.htmlText = _loc1_.txtAButton;
            }
         }
         if(this.txtBButton)
         {
            if(_loc1_.txtBButton == "")
            {
               this.txtBButton.visible = false;
            }
            else
            {
               this.txtBButton.visible = true;
               this.txtBButton.htmlText = _loc1_.txtBButton;
            }
         }
         if(this.txtYButton)
         {
            if(_loc1_.txtYButton == "")
            {
               this.txtYButton.visible = false;
            }
            else
            {
               this.txtYButton.visible = true;
               this.txtYButton.htmlText = _loc1_.txtYButton;
            }
         }
         if(this.txtRightBumper)
         {
            if(_loc1_.txtRightBumper == "")
            {
               this.txtRightBumper.visible = false;
            }
            else
            {
               this.txtRightBumper.visible = true;
               this.txtRightBumper.htmlText = _loc1_.txtRightBumper;
            }
         }
         if(this.txtRightTrigger)
         {
            if(_loc1_.txtRightTrigger == "")
            {
               this.txtRightTrigger.visible = false;
            }
            else
            {
               this.txtRightTrigger.visible = true;
               this.txtRightTrigger.htmlText = _loc1_.txtRightTrigger;
            }
         }
         if(this.txtStartButton)
         {
            if(_loc1_.txtStartButton == "")
            {
               this.txtStartButton.visible = false;
            }
            else
            {
               this.txtStartButton.visible = true;
               this.txtStartButton.htmlText = _loc1_.txtStartButton;
            }
         }
         if(this.txtSelectButton)
         {
            if(_loc1_.txtSelectButton == "")
            {
               this.txtSelectButton.visible = false;
            }
            else
            {
               this.txtSelectButton.visible = true;
               this.txtSelectButton.htmlText = _loc1_.txtSelectButton;
            }
         }
         if(this.txtLeftTrigger)
         {
            if(_loc1_.txtLeftTrigger == "")
            {
               this.txtLeftTrigger.visible = false;
            }
            else
            {
               this.txtLeftTrigger.visible = true;
               this.txtLeftTrigger.htmlText = _loc1_.txtLeftTrigger;
            }
         }
         if(this.txtLeftBumper)
         {
            if(_loc1_.txtLeftBumper == "")
            {
               this.txtLeftBumper.visible = false;
            }
            else
            {
               this.txtLeftBumper.visible = true;
               this.txtLeftBumper.htmlText = _loc1_.txtLeftBumper;
            }
         }
         if(this.txtLeftJoy)
         {
            if(_loc1_.txtLeftJoy == "")
            {
               this.txtLeftJoy.visible = false;
            }
            else
            {
               this.txtLeftJoy.visible = true;
               this.txtLeftJoy.htmlText = _loc1_.txtLeftJoy;
            }
         }
         if(this.txtDPad)
         {
            if(_loc1_.txtDPad == "")
            {
               this.txtDPad.visible = false;
            }
            else
            {
               this.txtDPad.visible = true;
               this.txtDPad.htmlText = _loc1_.txtDPad;
            }
         }
      }
      
      public function onRightClick(param1:MouseEvent) : void
      {
         if(visible)
         {
            this.handleNavigateBack();
         }
      }
      
      protected function handleNavigateBack() : void
      {
         dispatchEvent(new Event(IngameMenu.OnOptionPanelClosed,false,false));
      }
   }
}
