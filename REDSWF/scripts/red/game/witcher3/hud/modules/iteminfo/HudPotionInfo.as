package red.game.witcher3.hud.modules.iteminfo
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Sine;
   import red.game.witcher3.controls.W3UILoader;
   import scaleform.clik.managers.InputDelegate;
   
   public class HudPotionInfo extends HudItemInfo
   {
       
      
      public var mcAlterIconLoader:W3UILoader;
      
      protected var _alterIconPath:String = "";
      
      public function HudPotionInfo()
      {
         super();
      }
      
      public function get alterIconPath() : String
      {
         return this._alterIconPath;
      }
      
      public function set alterIconPath(param1:String) : void
      {
         this._alterIconPath = param1;
         this.updateAlterIcon();
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
      }
      
      public function animateSwitching() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(this.mcAlterIconLoader && mcIconLoader && this.mcAlterIconLoader.source && Boolean(mcIconLoader.source))
         {
            _loc1_ = 1.2;
            _loc2_ = 0.6;
            _loc3_ = 38;
            _loc4_ = 46;
            _loc5_ = 1.78;
            _loc6_ = 1;
            _loc7_ = 70;
            _loc8_ = 38;
            GTweener.removeTweens(this.mcAlterIconLoader);
            GTweener.removeTweens(mcIconLoader);
            this.mcAlterIconLoader.x = _loc7_;
            this.mcAlterIconLoader.y = _loc8_;
            this.mcAlterIconLoader.alpha = _loc6_;
            mcIconLoader.x = _loc3_;
            mcIconLoader.y = _loc4_;
            mcIconLoader.alpha = _loc2_;
            GTweener.to(this.mcAlterIconLoader,0.25,{
               "x":_loc3_,
               "y":_loc4_,
               "alpha":_loc2_
            },{"ease":Sine.easeIn});
            GTweener.to(mcIconLoader,0.25,{
               "x":_loc7_,
               "y":_loc8_,
               "alpha":_loc6_
            },{"ease":Sine.easeIn});
         }
      }
      
      protected function updateAlterIcon() : void
      {
         if(this.mcAlterIconLoader)
         {
            if(this._alterIconPath)
            {
               this.mcAlterIconLoader.visible = true;
               this.mcAlterIconLoader.source = "img://" + this._alterIconPath;
            }
            else
            {
               this.mcAlterIconLoader.unload();
               this.mcAlterIconLoader.source = "";
               this.mcAlterIconLoader.visible = false;
            }
         }
      }
   }
}
