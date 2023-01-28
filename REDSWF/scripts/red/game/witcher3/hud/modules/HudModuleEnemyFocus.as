package red.game.witcher3.hud.modules
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import red.core.events.GameEvent;
   import red.game.witcher3.constants.CommonConstants;
   
   public class HudModuleEnemyFocus extends HudModuleBase
   {
       
      
      public var mcNPCFocus:MovieClip;
      
      public var m_attitude:int;
      
      private var _tweenedTFList:Vector.<TextField>;
      
      private var _freeTFList:Vector.<TextField>;
      
      private var _maxTF:Number;
      
      internal var m_showEverythingExceptName:Boolean = false;
      
      internal var m_showName:Boolean = false;
      
      internal var m_isBossOrDead:Boolean = false;
      
      private var m_repositionOnNameChange:Boolean = false;
      
      internal var m_visibleHealthBar:Boolean = false;
      
      internal var m_visibleStaminaBar:Boolean = false;
      
      internal var m_visibleFocusLock:Boolean = false;
      
      internal var m_visibleEnemyLevel:Boolean = false;
      
      internal var m_visibleDodgeFeedback:Boolean = false;
      
      internal var m_visibleName:Boolean = false;
      
      internal var staminaTween:GTween;
      
      private var m_lastEssenceVisibility:Boolean = false;
      
      private var m_lastNPCQuestIcon:String;
      
      private var m_lastEnemyLevelDifference:String;
      
      private var m_lastEnemyLevelString:String;
      
      public function HudModuleEnemyFocus()
      {
         super();
         this.m_attitude = 0;
      }
      
      override public function get moduleName() : String
      {
         return "EnemyFocusModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         alpha = 0;
         this.setEssenceBarVisibility(false,true);
         this.displayMutationEight(false);
         this.mcNPCFocus.visible = false;
         this.mcNPCFocus.mcStaminaDelay.minimum = 0;
         this.mcNPCFocus.mcStaminaDelay.maximum = 100;
         this._tweenedTFList = new Vector.<TextField>();
         this._freeTFList = new Vector.<TextField>();
         this._maxTF = 5;
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
      }
      
      public function displayMutationEight(param1:Boolean) : void
      {
         var _loc2_:MovieClip = this.mcNPCFocus.mcMutation8Feedback;
         if(_loc2_)
         {
            _loc2_.visible = param1;
         }
      }
      
      public function setEnemyName(param1:String) : *
      {
         this.mcNPCFocus.tfName.text = param1;
         if(this.m_repositionOnNameChange)
         {
            this.mcNPCFocus.mcCharacterIcon.x = this.mcNPCFocus.tfName.x + this.mcNPCFocus.tfName.width / 2 - this.mcNPCFocus.tfName.textWidth / 2;
         }
      }
      
      public function setEnemyHealth(param1:int) : *
      {
         this.mcNPCFocus.mcHealthBar.value = param1;
      }
      
      public function setEnemyStamina(param1:int) : *
      {
         var _loc2_:int = int(this.mcNPCFocus.mcStaminaBar.value);
         this.mcNPCFocus.mcStaminaBar.value = param1;
         if(_loc2_ > param1)
         {
            this.mcNPCFocus.mcStaminaDelay.value = _loc2_;
            GTweener.removeTweens(this.mcNPCFocus.mcStaminaDelay);
            this.staminaTween = GTweener.to(this.mcNPCFocus.mcStaminaDelay,1,{"value":param1},{"onComplete":this.handleStaminaTweenCompleted});
         }
         else if(this.staminaTween)
         {
         }
      }
      
      private function handleStaminaTweenCompleted(param1:GTween) : void
      {
         this.staminaTween = null;
         GTweener.removeTweens(this.mcNPCFocus.mcStaminaDelay);
         this.mcNPCFocus.mcStaminaDelay.value == 0;
      }
      
      public function setAttitude(param1:int) : *
      {
         var _loc2_:String = null;
         this.m_attitude = param1;
         if(param1 == 4)
         {
            _loc2_ = "vip";
         }
         else
         {
            _loc2_ = this.getFrameByAttitude();
         }
         this.setVisibility(_loc2_);
      }
      
      public function setDodgeFeedback(param1:Boolean) : *
      {
         this.m_visibleDodgeFeedback = param1;
         this.UpdateVisibilityOfDodgeFeedback();
      }
      
      public function SetBossOrDead(param1:Boolean) : *
      {
         this.m_isBossOrDead = param1;
         this.UpdateVisibilityOfHealthStaminaBars();
         this.UpdateVisibilityOfFocusLock();
         this.UpdateVisibilityOfEnemyLevel();
         this.UpdateVisibilityOfDodgeFeedback();
      }
      
      private function createDamageTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         var _loc2_:TextFormat = new TextFormat("$NormalFont",24);
         _loc2_.align = TextFormatAlign.CENTER;
         _loc2_.font = "$NormalFont";
         _loc1_.embedFonts = true;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.setTextFormat(_loc2_);
         this.mcNPCFocus.addChild(_loc1_);
         _loc1_.x = 0;
         _loc1_.y = 0;
         return _loc1_;
      }
      
      private function getNextFreeTextField() : TextField
      {
         var _loc1_:TextField = null;
         if(this._freeTFList.length > 0)
         {
            return this._freeTFList.pop();
         }
         if(this._tweenedTFList.length < this._maxTF)
         {
            return this.createDamageTextField();
         }
         return this._tweenedTFList.shift();
      }
      
      public function setDamageText(param1:String, param2:Number, param3:Number) : void
      {
         var _loc4_:TextField;
         if((_loc4_ = this.getNextFreeTextField()).textColor != param3)
         {
            _loc4_.textColor = param3;
         }
         if(param2 == 0)
         {
            _loc4_.text = param1;
         }
         else
         {
            _loc4_.text = param1 + " " + param2;
         }
         _loc4_.y = 0;
         _loc4_.width = _loc4_.textWidth + CommonConstants.SAFE_TEXT_PADDING;
         _loc4_.x = -_loc4_.width / 2;
         _loc4_.visible = true;
         this._tweenedTFList.push(_loc4_);
         GTweener.removeTweens(_loc4_);
         GTweener.to(_loc4_,1,{"y":-50},{
            "ease":Exponential.easeOut,
            "onComplete":this.handleTweenCompleted
         });
      }
      
      private function handleTweenCompleted(param1:GTween) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         _loc2_.visible = false;
         GTweener.removeTweens(_loc2_);
         this._tweenedTFList.splice(this._tweenedTFList.indexOf(_loc2_),1);
         this._freeTFList.push(_loc2_);
      }
      
      public function hideDamageText() : void
      {
         this.mcNPCFocus.mcDamageTextAnim.visible = false;
      }
      
      public function setStaminaVisibility(param1:Boolean) : *
      {
         if(this.m_attitude != 2)
         {
            this.m_visibleStaminaBar = false;
         }
         else
         {
            this.m_visibleStaminaBar = param1;
         }
         this.UpdateVisibilityOfHealthStaminaBars();
      }
      
      public function setVisibility(param1:String) : *
      {
         this.m_visibleName = true;
         switch(param1)
         {
            case "enemy":
               this.mcNPCFocus.tfName.textColor = 16711680;
               this.m_visibleHealthBar = true;
               this.m_visibleStaminaBar = true;
               break;
            case "neutral":
               this.mcNPCFocus.tfName.textColor = 7977213;
               this.m_visibleHealthBar = false;
               this.m_visibleStaminaBar = false;
               break;
            case "friendly":
               this.mcNPCFocus.tfName.textColor = 13869949;
               this.m_visibleHealthBar = false;
               this.m_visibleStaminaBar = false;
               break;
            case "axii":
               this.mcNPCFocus.tfName.textColor = 16561481;
               this.m_visibleHealthBar = true;
               this.m_visibleStaminaBar = true;
               break;
            case "vip":
               this.mcNPCFocus.tfName.textColor = 5963520;
               this.m_visibleHealthBar = false;
               this.m_visibleStaminaBar = false;
         }
         this.UpdateVisibilityOfHealthStaminaBars();
         this.UpdateVisibilityOfName();
      }
      
      public function setEssenceBarVisibility(param1:Boolean, param2:Boolean = false) : *
      {
         if(!param2)
         {
            if(this.m_lastEssenceVisibility == param1)
            {
               return;
            }
         }
         this.m_lastEssenceVisibility = param1;
         if(param1)
         {
            this.mcNPCFocus.mcHealthBar.mcHealthBar.visible = false;
            this.mcNPCFocus.mcHealthBar.mcEssenceBar.visible = true;
         }
         else
         {
            this.mcNPCFocus.mcHealthBar.mcHealthBar.visible = true;
            this.mcNPCFocus.mcHealthBar.mcEssenceBar.visible = false;
         }
      }
      
      public function getFrameByAttitude() : String
      {
         switch(this.m_attitude)
         {
            case 0:
               return "neutral";
            case 1:
               return "friendly";
            case 2:
               return "enemy";
            case 3:
               return "axii";
            default:
               return "friendly";
         }
      }
      
      override public function SetScaleFromWS(param1:Number) : void
      {
      }
      
      public function setShowHardLock(param1:Boolean) : *
      {
         this.m_visibleFocusLock = param1;
         this.UpdateVisibilityOfFocusLock();
      }
      
      public function setNPCQuestIcon(param1:String) : *
      {
         if(this.m_lastNPCQuestIcon != param1)
         {
            this.m_lastNPCQuestIcon = param1;
            if(this.mcNPCFocus.tfName)
            {
               this.mcNPCFocus.mcCharacterIcon.gotoAndStop(param1);
               this.mcNPCFocus.mcCharacterIcon.x = this.mcNPCFocus.tfName.x + this.mcNPCFocus.tfName.width / 2 - this.mcNPCFocus.tfName.textWidth / 2;
            }
         }
         this.m_repositionOnNameChange = param1 != "none";
      }
      
      public function setEnemyLevel(param1:String, param2:String) : *
      {
         this.m_visibleEnemyLevel = true;
         this.UpdateVisibilityOfEnemyLevel();
         if(this.m_lastEnemyLevelDifference != param1)
         {
            this.m_lastEnemyLevelDifference = param1;
            this.mcNPCFocus.mcEnemyLevel.gotoAndStop(param1);
            if(param1 == "none" || param1 == "deadlyLevel")
            {
               this.mcNPCFocus.mcEnemyLevel.textField.alpha = 0;
            }
            else
            {
               this.mcNPCFocus.mcEnemyLevel.textField.alpha = 1;
            }
         }
         if(this.m_lastEnemyLevelString != param2)
         {
            this.m_lastEnemyLevelString = param2;
            this.mcNPCFocus.mcEnemyLevel.textField.htmlText = param2;
         }
      }
      
      private function UpdateVisibilityOfHealthStaminaBars() : *
      {
         this.mcNPCFocus.mcHealthBar.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleHealthBar;
         this.mcNPCFocus.mcStaminaBar.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleStaminaBar;
         this.mcNPCFocus.mcStaminaDelay.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleStaminaBar;
      }
      
      private function UpdateVisibilityOfFocusLock() : *
      {
         this.mcNPCFocus.mcFocusLock.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleFocusLock;
      }
      
      private function UpdateVisibilityOfEnemyLevel() : *
      {
         this.mcNPCFocus.mcEnemyLevel.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleEnemyLevel;
      }
      
      private function UpdateVisibilityOfDodgeFeedback() : *
      {
         this.mcNPCFocus.mcDodgeFeedback.visible = this.m_showEverythingExceptName && !this.m_isBossOrDead && this.m_visibleDodgeFeedback;
      }
      
      private function UpdateVisibilityOfName() : *
      {
         this.mcNPCFocus.mcCharacterIcon.visible = this.m_showName && this.m_visibleName;
         this.mcNPCFocus.tfName.visible = this.m_showName && this.m_visibleName;
      }
      
      public function SetGeneralVisibility(param1:Boolean, param2:Boolean) : *
      {
         this.m_showEverythingExceptName = param1;
         this.m_showName = param2;
         this.UpdateVisibilityOfHealthStaminaBars();
         this.UpdateVisibilityOfFocusLock();
         this.UpdateVisibilityOfEnemyLevel();
         this.UpdateVisibilityOfDodgeFeedback();
         this.UpdateVisibilityOfName();
      }
   }
}
