package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.HintButton;
   import red.game.witcher3.controls.W3Label;
   import red.game.witcher3.data.KeyBindingData;
   
   public class HudModuleControlsFeedback extends HudModuleBase
   {
       
      
      public var mcBackground:MovieClip;
      
      public var mcSwordDisplay:MovieClip;
      
      public var mcLabel:W3Label;
      
      public var mcBtn1:HintButton;
      
      public var mcBtn2:HintButton;
      
      public var mcBtn3:HintButton;
      
      public var mcBtn4:HintButton;
      
      public var mcBtn5:HintButton;
      
      public function HudModuleControlsFeedback()
      {
         super();
         isAlwaysDynamic = true;
      }
      
      override public function get moduleName() : String
      {
         return "ControlsFeedbackModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         registerDataBinding("hud.module.controlsfeedback",this.populateData);
         alpha = 0;
         this.mcSwordDisplay.visible = false;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function populateData(param1:Object, param2:int) : void
      {
         var _loc4_:KeyBindingData = null;
         var _loc3_:Array = param1 as Array;
         var _loc5_:int = !!_loc3_ ? int(_loc3_.length) : 0;
         visible = true;
         if(_loc5_ > 0)
         {
            _loc4_ = _loc3_[0] as KeyBindingData;
            this.mcBtn1.label = _loc4_.label;
            this.mcBtn1.keyBinding = _loc4_;
            if(_loc5_ > 1)
            {
               _loc4_ = _loc3_[1] as KeyBindingData;
               this.mcBtn2.label = _loc4_.label;
               this.mcBtn2.keyBinding = _loc4_;
               if(_loc5_ > 2)
               {
                  _loc4_ = _loc3_[2] as KeyBindingData;
                  this.mcBtn3.label = _loc4_.label;
                  this.mcBtn3.keyBinding = _loc4_;
                  if(_loc5_ > 3)
                  {
                     _loc4_ = _loc3_[3] as KeyBindingData;
                     this.mcBtn4.label = _loc4_.label;
                     this.mcBtn4.keyBinding = _loc4_;
                     if(_loc5_ > 4)
                     {
                        _loc4_ = _loc3_[4] as KeyBindingData;
                        this.mcBtn5.label = _loc4_.label;
                        this.mcBtn5.keyBinding = _loc4_;
                        return;
                     }
                     this.mcBtn5.visible = false;
                     return;
                  }
                  this.mcBtn4.visible = false;
                  this.mcBtn5.visible = false;
                  return;
               }
               this.mcBtn3.visible = false;
               this.mcBtn4.visible = false;
               this.mcBtn5.visible = false;
               return;
            }
            this.mcBtn2.visible = false;
            this.mcBtn3.visible = false;
            this.mcBtn4.visible = false;
            this.mcBtn5.visible = false;
            return;
         }
         this.mcBtn1.visible = false;
         this.mcBtn2.visible = false;
         this.mcBtn3.visible = false;
         this.mcBtn4.visible = false;
         this.mcBtn5.visible = false;
      }
      
      public function setSwordText(param1:String) : void
      {
         if(this.mcSwordDisplay)
         {
            if(param1 == "")
            {
               this.mcSwordDisplay.visible = false;
            }
            else if(this.mcSwordDisplay.textField)
            {
               if(this.mcSwordDisplay.textField.htmlText != param1)
               {
                  this.mcSwordDisplay.textField.htmlText = param1;
                  this.mcSwordDisplay.visible = true;
               }
            }
         }
      }
   }
}
