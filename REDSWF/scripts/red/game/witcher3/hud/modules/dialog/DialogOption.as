package red.game.witcher3.hud.modules.dialog
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.events.InputEvent;
   import scaleform.clik.interfaces.IListItemRenderer;
   import scaleform.clik.ui.InputDetails;
   
   public class DialogOption extends ListItemRenderer implements IListItemRenderer
   {
      
      public static var currentOffset:Number = 0;
       
      
      private const DEFAULT_WIDTH:Number = 540;
      
      public var mcActionIcon:MovieClip;
      
      public var mcSelectedOverlay:MovieClip;
      
      public var mcShadow:MovieClip;
      
      public var mcSelectionBck:MovieClip;
      
      public var mcActionIconSmall:MovieClip;
      
      public var isLocked:Boolean = false;
      
      public var mcHitTest:MovieClip;
      
      public function DialogOption()
      {
         super();
         constraintsDisabled = true;
         preventAutosizing = true;
         textField.mouseEnabled = false;
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
         setState("up");
         super.setData(param1);
         this.updateIcon();
      }
      
      override protected function updateText() : void
      {
         var _loc1_:* = null;
         this.isLocked = false;
         if(_label != null && textField != null)
         {
            if(data)
            {
               if(InputManager.getInstance().isGamepad())
               {
                  _loc1_ = "";
               }
               else
               {
                  _loc1_ = index + currentOffset + 1 + ". ";
               }
               if(data.locked)
               {
                  textField.htmlText = "<font color=\'#CC0000\'>" + _loc1_ + _label + "</font>";
                  this.isLocked = data.locked;
                  this.updateBck();
                  this.updateTextFieldSize();
                  return;
               }
               if(data.emphasis)
               {
                  if(data.read)
                  {
                     textField.htmlText = "<font color=\'#d9b215\'>" + _loc1_ + _label + "</font>";
                  }
                  else
                  {
                     textField.htmlText = "<font color=\'#a7a7a7\'>" + _loc1_ + _label + "</font>";
                  }
                  this.updateBck();
                  this.updateTextFieldSize();
                  return;
               }
               if(!data.read)
               {
                  textField.htmlText = "<font color=\'#a7a7a7\'>" + _loc1_ + _label + "</font>";
                  this.updateBck();
                  this.updateTextFieldSize();
                  return;
               }
            }
            textField.htmlText = _loc1_ + _label;
            this.updateTextFieldSize();
         }
         this.updateBck();
         textField.mouseEnabled = false;
      }
      
      public function updateRendererSize() : void
      {
         this.updateText();
         this.updateIcon();
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
         this.updateBck();
         this.updateIcon();
         this.updateTextFieldSize();
         stage.dispatchEvent(new Event(W3ScrollingList.REPOSITION));
      }
      
      private function updateTextFieldSize() : void
      {
         if(textField)
         {
            textField.width = this.DEFAULT_WIDTH;
            textField.height = textField.textHeight + CommonConstants.SAFE_TEXT_PADDING;
            this.mcHitTest.x = textField.x;
            this.mcHitTest.y = textField.y;
            this.mcHitTest.height = textField.height;
            this.mcHitTest.width = textField.width;
         }
      }
      
      private function updateIcon() : *
      {
         if(data)
         {
            if(data.icon)
            {
               this.showIcon(data.icon);
               return;
            }
         }
         this.hideIcon();
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
         if(textField.textWidth > 0)
         {
            this.mcShadow.width = textField.textWidth + 20;
         }
         else
         {
            this.mcShadow.width = 0;
         }
      }
      
      private function showIcon(param1:uint) : *
      {
         switch(param1)
         {
            case DialogActionType.BRIBE:
               this.mcActionIcon.gotoAndStop("Bribe");
               this.mcActionIconSmall.gotoAndStop("Bribe");
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
               this.mcActionIcon.gotoAndStop("Runesmith");
               this.mcActionIconSmall.gotoAndStop("Runesmith");
               break;
            case DialogActionType.TEACHER:
               this.mcActionIcon.gotoAndStop("Teacher");
               this.mcActionIconSmall.gotoAndStop("Teacher");
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
            default:
               this.hideIcon();
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
      
      private function hideIcon() : void
      {
         this.mcActionIcon.gotoAndStop("NoIcon");
         this.mcActionIconSmall.gotoAndStop("NoIcon");
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
