package red.game.witcher3.hud.modules.iteminfo
{
   import scaleform.clik.managers.InputDelegate;
   
   public class HudPotionKeyboardInfo extends HudItemInfo
   {
       
      
      public function HudPotionKeyboardInfo()
      {
         super();
      }
      
      override public function setItemButtons(param1:int, param2:*) : void
      {
         var _loc3_:InputDelegate = null;
         var _loc4_:String = null;
         _loc3_ = InputDelegate.getInstance();
         switch(param1)
         {
            case -10:
               _loc4_ = "double_dpad_up";
               break;
            case 0:
               mcButton.visible = false;
               return;
            default:
               _loc4_ = _loc3_.inputToNav("key",param1);
         }
         mcButton.visible = showButtonHint;
         mcButton.clickable = false;
         mcButton.setDataFromStage(_loc4_,param2);
         mcButton.validateNow();
         if(!mcIconLoader.source)
         {
            mcButton.visible = false;
         }
         else
         {
            mcButton.visible = showButtonHint;
         }
      }
      
      override public function set IconName(param1:String) : void
      {
         super.IconName = param1;
         mcButton.visible = Boolean(mcIconLoader.source) && showButtonHint;
      }
   }
}
