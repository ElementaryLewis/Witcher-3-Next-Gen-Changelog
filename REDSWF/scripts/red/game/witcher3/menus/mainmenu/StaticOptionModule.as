package red.game.witcher3.menus.mainmenu
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import red.core.CoreMenuModule;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.ui.InputDetails;
   
   public class StaticOptionModule extends CoreMenuModule
   {
       
      
      public function StaticOptionModule()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         enabled = false;
         visible = false;
         alpha = 0;
      }
      
      public function show() : void
      {
         visible = true;
         GTweener.removeTweens(this);
         GTweener.to(this,0.2,{"alpha":1},{});
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
               }
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
