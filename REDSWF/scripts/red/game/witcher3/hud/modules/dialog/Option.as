package red.game.witcher3.hud.modules.dialog
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.core.CoreComponent;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class Option extends ListItemRenderer implements IListItemRenderer
   {
      
      public static var ALTERNATIVE_ARROW_SKIN:Boolean = false;
       
      
      private const DEFAULT_WIDTH:Number = 540;
      
      public var mcActionIcon:MovieClip;
      
      public var mcActionIconSmall:MovieClip;
      
      public var mcArrowPointer:MovieClip;
      
      public var mcShadow:MovieClip;
      
      public var mcSelectionBck:MovieClip;
      
      public var tfLine:TextField;
      
      public var mcHitTest:MovieClip;
      
      private var _isLocked:Boolean = false;
      
      public function Option()
      {
         super();
         constraintsDisabled = true;
         preventAutosizing = true;
         this.tfLine.mouseEnabled = false;
      }
      
      public function get isLocked() : Boolean
      {
         return this._isLocked;
      }
      
      public function set isLocked(param1:Boolean) : void
      {
         this._isLocked = param1;
         mouseEnabled = !this._isLocked;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function setData(param1:Object) : void
      {
         if(param1)
         {
            if(this.mcArrowPointer)
            {
               if(ALTERNATIVE_ARROW_SKIN)
               {
                  this.mcArrowPointer.mcArrowYellow.visible = false;
                  this.mcArrowPointer.mcArrowBlue.visible = true;
               }
               else
               {
                  this.mcArrowPointer.mcArrowYellow.visible = true;
                  this.mcArrowPointer.mcArrowBlue.visible = false;
               }
            }
         }
         super.setData(param1);
         this.updateTextLine();
         this.updateIcon();
         this.updateBck();
      }
      
      private function updateTextLine() : *
      {
         var _loc1_:* = null;
         this.isLocked = false;
         if(data)
         {
            if(this.tfLine)
            {
               if(InputManager.getInstance().isGamepad() || CoreComponent.isArabicAligmentMode)
               {
                  _loc1_ = "";
               }
               else
               {
                  _loc1_ = data.prefix + ". ";
               }
               if(data.locked)
               {
                  this.tfLine.textColor = 13369344;
                  this.isLocked = data.locked;
               }
               else if(!data.read)
               {
                  this.tfLine.textColor = 10987431;
               }
               else if(data.emphasis)
               {
                  if(data.read)
                  {
                     this.tfLine.textColor = 14266901;
                  }
                  else
                  {
                     this.tfLine.textColor = 10987431;
                  }
               }
               else
               {
                  this.tfLine.textColor = 15914679;
               }
               this.tfLine.text = _loc1_ + data.name;
               this.updateTextFieldSize();
            }
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
         super.selected = param1;
         this.mcArrowPointer.visible = param1;
         this.mcSelectionBck.visible = param1;
      }
      
      private function updateTextFieldSize() : void
      {
         if(this.tfLine)
         {
            this.tfLine.width = this.DEFAULT_WIDTH;
            this.tfLine.height = this.tfLine.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.mcHitTest.x = this.tfLine.x;
            this.mcHitTest.y = this.tfLine.y;
            this.mcHitTest.height = this.tfLine.height;
            this.mcHitTest.width = this.tfLine.width;
         }
      }
      
      private function updateBck() : *
      {
         if(label != "")
         {
            this.mcShadow.alpha = 1;
         }
         else
         {
            this.mcShadow.alpha = 0;
         }
         if(this.tfLine.textWidth > 0)
         {
            this.mcShadow.width = this.tfLine.textWidth + 20;
         }
         else
         {
            this.mcShadow.width = 0;
         }
      }
      
      private function updateIcon() : *
      {
         if(Boolean(data) && Boolean(data.icon))
         {
            this.showIcon(data.icon);
         }
         else
         {
            this.showIcon(0);
         }
      }
      
      private function showIcon(param1:uint) : *
      {
         switch(param1)
         {
            case 0:
               this.mcActionIcon.gotoAndStop("NoIcon");
               this.mcActionIconSmall.gotoAndStop("NoIcon");
               break;
            case DialogActionType.BRIBE:
               this.mcActionIcon.gotoAndStop("Bribe");
               this.mcActionIconSmall.gotoAndStop("Bribe");
               break;
            case DialogActionType.HOUSE:
               this.mcActionIcon.gotoAndStop("House");
               this.mcActionIconSmall.gotoAndStop("House");
               break;
            case DialogActionType.GAME_DICES:
               this.mcActionIcon.gotoAndStop("DicePoker");
               this.mcActionIconSmall.gotoAndStop("DicePoker");
               break;
            case DialogActionType.GAME_FIGHT:
               this.mcActionIcon.gotoAndStop("FistFighting");
               this.mcActionIconSmall.gotoAndStop("FistFighting");
               break;
            case DialogActionType.GAME_WRESTLE:
               this.mcActionIcon.gotoAndStop("Armwrestling");
               this.mcActionIconSmall.gotoAndStop("Armwrestling");
               break;
            case DialogActionType.SHOPPING:
               this.mcActionIcon.gotoAndStop("Shop");
               this.mcActionIconSmall.gotoAndStop("Shop");
               break;
            case DialogActionType.EXIT:
               this.mcActionIcon.gotoAndStop("Exit");
               this.mcActionIconSmall.gotoAndStop("Exit");
               break;
            case DialogActionType.GIFT:
               this.mcActionIcon.gotoAndStop("Gift");
               this.mcActionIconSmall.gotoAndStop("Gift");
               break;
            case DialogActionType.GAME_DRINK:
               this.mcActionIcon.gotoAndStop("Drinking");
               this.mcActionIconSmall.gotoAndStop("Drinking");
               break;
            case DialogActionType.GAME_DAGGER:
               this.mcActionIcon.gotoAndStop("DaggerThrowing");
               this.mcActionIconSmall.gotoAndStop("DaggerThrowing");
               break;
            case DialogActionType.SMITH:
               this.mcActionIcon.gotoAndStop("Blacksmith");
               this.mcActionIconSmall.gotoAndStop("Blacksmith");
               break;
            case DialogActionType.ARMORER:
               this.mcActionIcon.gotoAndStop("Armorer");
               this.mcActionIconSmall.gotoAndStop("Armorer");
               break;
            case DialogActionType.RUNESMITH:
               this.mcActionIcon.gotoAndStop("Enchant");
               this.mcActionIconSmall.gotoAndStop("Enchant");
               break;
            case DialogActionType.TEACHER:
               this.mcActionIcon.gotoAndStop("Teacher");
               this.mcActionIconSmall.gotoAndStop("Teacher");
               break;
            case DialogActionType.FAST_TRAVEL:
               this.mcActionIcon.gotoAndStop("FastTravel");
               this.mcActionIconSmall.gotoAndStop("FastTravel");
               break;
            case DialogActionType.AXII:
               this.mcActionIcon.gotoAndStop("Axii");
               this.mcActionIconSmall.gotoAndStop("Axii");
               break;
            case DialogActionType.SHAVING:
               this.mcActionIcon.gotoAndStop("Shaving");
               this.mcActionIconSmall.gotoAndStop("Shaving");
               break;
            case DialogActionType.HAIRCUT:
               this.mcActionIcon.gotoAndStop("Haircut");
               this.mcActionIconSmall.gotoAndStop("Haircut");
               break;
            case DialogActionType.GAME_CARDS:
               this.mcActionIcon.gotoAndStop("CardGame");
               this.mcActionIconSmall.gotoAndStop("CardGame");
               break;
            case DialogActionType.BET:
               this.mcActionIcon.gotoAndStop("Bet");
               this.mcActionIconSmall.gotoAndStop("Bet");
               break;
            case DialogActionType.MONSTERCONTRACT:
               this.mcActionIcon.gotoAndStop("MonsterContract");
               this.mcActionIconSmall.gotoAndStop("MonsterContract");
               break;
            case DialogActionType.GETBACK:
               this.mcActionIcon.gotoAndStop("GetBack");
               this.mcActionIconSmall.gotoAndStop("GetBack");
               break;
            case DialogActionType.AUCTION:
               this.mcActionIcon.gotoAndStop("Auction");
               this.mcActionIconSmall.gotoAndStop("Auction");
               break;
            case DialogActionType.LEVELUP1:
               this.mcActionIcon.gotoAndStop("EnchanterLvl1");
               this.mcActionIconSmall.gotoAndStop("EnchanterLvl1");
               break;
            case DialogActionType.LEVELUP2:
               this.mcActionIcon.gotoAndStop("EnchanterLvl2");
               this.mcActionIconSmall.gotoAndStop("EnchanterLvl2");
               break;
            case DialogActionType.LEVELUP3:
               this.mcActionIcon.gotoAndStop("EnchanterLvl3");
               this.mcActionIconSmall.gotoAndStop("EnchanterLvl3");
               break;
            default:
               this.mcActionIcon.gotoAndStop("NoIcon");
               this.mcActionIconSmall.gotoAndStop("NoIcon");
               return;
         }
         if(Boolean(data) && Boolean(data.emphasis))
         {
            this.mcActionIcon.visible = true;
            this.mcActionIconSmall.visible = false;
         }
         else
         {
            this.mcActionIconSmall.visible = true;
            this.mcActionIcon.visible = false;
         }
      }
      
      override public function handleInput(param1:InputEvent) : void
      {
         var _loc2_:InputDetails = param1.details;
         if(_loc2_.navEquivalent == NavigationCode.ENTER && _loc2_.code == KeyCode.SPACE)
         {
            return;
         }
         super.handleInput(param1);
      }
      
      override public function get scaleX() : Number
      {
         return super.actualScaleX;
      }
      
      override public function get scaleY() : Number
      {
         return super.actualScaleY;
      }
   }
}
