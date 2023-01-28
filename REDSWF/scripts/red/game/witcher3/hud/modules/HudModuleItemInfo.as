package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.events.ControllerChangeEvent;
   import red.game.witcher3.hud.modules.iteminfo.HudItemInfo;
   import red.game.witcher3.hud.modules.iteminfo.HudPotionInfo;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.NavigationCode;
   
   public class HudModuleItemInfo extends HudModuleBase
   {
      
      public static const HudItemInfoBinding_item1:uint = 0;
      
      public static const HudItemInfoBinding_potion1:uint = 1;
      
      public static const HudItemInfoBinding_potion2:uint = 2;
      
      public static const HudItemInfoBinding_potion3:uint = 3;
      
      public static const HudItemInfoBinding_potion4:uint = 4;
       
      
      public var mcKbPotion1:HudItemInfo;
      
      public var mcKbPotion2:HudItemInfo;
      
      public var mcKbPotion3:HudItemInfo;
      
      public var mcKbPotion4:HudItemInfo;
      
      public var mcItemSlot:HudItemInfo;
      
      public var mcPotionSlot1:HudPotionInfo;
      
      public var mcPotionSlot2:HudPotionInfo;
      
      private var isAlwaysDisplayed:Boolean = false;
      
      private var _showHint:Boolean = false;
      
      public var btnSwitchHint:InputFeedbackButton;
      
      public var btnSwitchHintBackground:MovieClip;
      
      public function HudModuleItemInfo()
      {
         super();
         this.mcItemSlot.defaultIconName = "quick1";
         this.mcKbPotion1.showButtonHint = true;
         this.mcKbPotion2.showButtonHint = true;
         this.mcKbPotion3.showButtonHint = true;
         this.mcKbPotion4.showButtonHint = true;
         this.__setProp_mcItemSlot_Scene1_Item_0();
      }
      
      override public function get moduleName() : String
      {
         return "ItemInfoModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.btnSwitchHint.label = "[[hud_item_info_switch_potions]]";
         this.btnSwitchHint.setDataFromStage(NavigationCode.DPAD_UP_DOWN,-1,-1,300);
         visible = true;
         alpha = 0;
         this.updateHints();
         InputManager.getInstance().addEventListener(ControllerChangeEvent.CONTROLLER_CHANGE,this.updateHints,false,0,true);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      protected function updateHints(param1:Event = null) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         this.btnSwitchHint.visible = _loc2_ && this._showHint;
         this.btnSwitchHintBackground.visible = _loc2_ && this._showHint;
         this.mcPotionSlot1.visible = _loc2_;
         this.mcPotionSlot2.visible = _loc2_;
         this.mcKbPotion1.visible = !_loc2_;
         this.mcKbPotion2.visible = !_loc2_;
         this.mcKbPotion3.visible = !_loc2_;
         this.mcKbPotion4.visible = !_loc2_;
      }
      
      public function showButtonHints(param1:Boolean) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         this._showHint = param1;
         this.btnSwitchHint.visible = this._showHint && _loc2_ && (Boolean(this.mcPotionSlot1.alterIconPath) && Boolean(this.mcPotionSlot1.IconName) || Boolean(this.mcPotionSlot2.alterIconPath) && Boolean(this.mcPotionSlot2.IconName));
         this.mcItemSlot.showButtonHint = param1;
         this.mcPotionSlot1.showButtonHint = param1;
         this.mcPotionSlot2.showButtonHint = param1;
      }
      
      public function HideSlots(param1:Boolean) : void
      {
         var _loc2_:Boolean = InputManager.getInstance().isGamepad();
         if(param1)
         {
            this.updateHints();
         }
         else
         {
            this.mcPotionSlot1.visible = false;
            this.mcPotionSlot2.visible = false;
            this.mcKbPotion1.visible = false;
            this.mcKbPotion2.visible = false;
            this.mcKbPotion3.visible = false;
            this.mcKbPotion4.visible = false;
         }
      }
      
      public function animatePotionSwitch(param1:int) : void
      {
         var _loc2_:HudPotionInfo = null;
         switch(param1)
         {
            case HudItemInfoBinding_potion1:
               _loc2_ = this.mcPotionSlot1;
               break;
            case HudItemInfoBinding_potion2:
               _loc2_ = this.mcPotionSlot2;
         }
         if(_loc2_)
         {
            _loc2_.animateSwitching();
         }
      }
      
      public function setItemInfo(param1:int, param2:String, param3:String, param4:String, param5:String, param6:int, param7:int) : void
      {
         var _loc8_:HudItemInfo = null;
         var _loc9_:HudItemInfo = null;
         var _loc10_:HudPotionInfo = null;
         switch(param1)
         {
            case HudItemInfoBinding_item1:
               _loc9_ = this.mcItemSlot;
               break;
            case HudItemInfoBinding_potion1:
               _loc9_ = this.mcPotionSlot1;
               _loc8_ = this.mcKbPotion1;
               break;
            case HudItemInfoBinding_potion2:
               _loc9_ = this.mcPotionSlot2;
               _loc8_ = this.mcKbPotion2;
               break;
            case HudItemInfoBinding_potion3:
               _loc9_ = null;
               _loc10_ = this.mcPotionSlot1 as HudPotionInfo;
               _loc8_ = this.mcKbPotion3;
               break;
            case HudItemInfoBinding_potion4:
               _loc9_ = null;
               _loc10_ = this.mcPotionSlot2 as HudPotionInfo;
               _loc8_ = this.mcKbPotion4;
         }
         if(_loc9_)
         {
            _loc9_.IconName = param2;
            _loc9_.ItemCategory = param3;
            _loc9_.ItemName = param4;
            _loc9_.ItemAmmo = param5;
            _loc9_.setItemButtons(param6,param7);
         }
         if(_loc8_)
         {
            _loc8_.IconName = param2;
            _loc8_.ItemCategory = param3;
            _loc8_.ItemName = param4;
            _loc8_.ItemAmmo = param5;
            _loc8_.setItemButtons(param6,param7);
         }
         if(Boolean(_loc9_) || Boolean(_loc8_))
         {
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
         if(_loc10_)
         {
            _loc10_.alterIconPath = param2;
         }
         if(this._showHint && this.btnSwitchHint && InputManager.getInstance().isGamepad())
         {
            this.btnSwitchHint.visible = Boolean(this.mcPotionSlot1.alterIconPath) && Boolean(this.mcPotionSlot1.IconName) || Boolean(this.mcPotionSlot2.alterIconPath) && Boolean(this.mcPotionSlot2.IconName);
         }
      }
      
      public function EnableElement(param1:Boolean) : void
      {
      }
      
      override public function SetEnabled(param1:Boolean) : *
      {
         isEnabled = param1;
         if(!isEnabled)
         {
            SetState("Hide");
            this.alpha = 0;
            this.desiredAlpha = 0;
         }
         else if(this.isAlwaysDisplayed)
         {
            SetState("OnUpdate");
            this.setAlwaysDisplayed(this.isAlwaysDisplayed);
         }
      }
      
      public function UpdateElement() : void
      {
         dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
      }
      
      public function setAlwaysDisplayed(param1:Boolean) : *
      {
         this.isAlwaysDisplayed = param1;
         if(param1)
         {
            RemoveUpdateTimer();
            dispatchEvent(new GameEvent(GameEvent.UPDATE,this.moduleName));
         }
      }
      
      override public function ShowElement(param1:Boolean, param2:Boolean = false, param3:Boolean = false) : void
      {
         if(param3)
         {
            if(!this.isAlwaysDisplayed)
            {
               ShowElementFromState(param1,param2);
            }
         }
         else
         {
            stateMachine.ShowElement(param1,param2);
         }
      }
      
      override internal function UpdateTimerFinishedCounting(param1:TimerEvent) : void
      {
         if(this.isAlwaysDisplayed)
         {
            RemoveUpdateTimer();
            return;
         }
         super.UpdateTimerFinishedCounting(param1);
      }
      
      internal function __setProp_mcItemSlot_Scene1_Item_0() : *
      {
         try
         {
            this.mcItemSlot["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcItemSlot.enabled = true;
         this.mcItemSlot.enableInitCallback = false;
         this.mcItemSlot.minimalSize = 140;
         this.mcItemSlot.visible = true;
         try
         {
            this.mcItemSlot["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}
