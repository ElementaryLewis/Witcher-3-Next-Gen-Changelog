package red.game.witcher3.controls
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import red.core.constants.KeyCode;
   import red.game.witcher3.constants.EInputDeviceType;
   import red.game.witcher3.constants.KeyboardKeys;
   import red.game.witcher3.constants.PlatformType;
   import red.game.witcher3.data.KeyBindingData;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.managers.InputDelegate;
   
   public class HintButton extends UIComponent
   {
       
      
      protected const ICON_PADDING:Number = 5;
      
      protected const BACKGROUND_PADDING:Number = 25;
      
      protected const BACKGROUND_MIN_SIZE:Number = 120;
      
      public var mcBackground:MovieClip;
      
      public var textField:TextField;
      
      public var mcIconSteam:MovieClip;
      
      public var mcIconXbox:MovieClip;
      
      public var mcIconPS:MovieClip;
      
      public var mcMouseIcon1:KeyboardButtonMouseIcon;
      
      public var mcMouseIcon2:KeyboardButtonMouseIcon;
      
      public var mcKeyboardIcon1:KeyboardButtonIcon;
      
      public var mcKeyboardIcon2:KeyboardButtonIcon;
      
      protected var _label:String;
      
      protected var _isInvalid:Boolean;
      
      protected var _icons:Vector.<MovieClip>;
      
      protected var _keyBinding:KeyBindingData;
      
      public function HintButton()
      {
         super();
         this._isInvalid = false;
         this._icons = new Vector.<MovieClip>();
         visible = false;
         if(this.mcIconXbox)
         {
            this.mcIconXbox.visible = false;
         }
         if(this.mcIconPS)
         {
            this.mcIconPS.visible = false;
         }
         if(this.mcIconSteam)
         {
            this.mcIconSteam.visible = false;
         }
         if(this.mcMouseIcon1)
         {
            this.mcMouseIcon1.visible = false;
         }
         if(this.mcMouseIcon2)
         {
            this.mcMouseIcon2.visible = false;
         }
         if(this.mcKeyboardIcon1)
         {
            this.mcKeyboardIcon1.visible = false;
         }
         if(this.mcKeyboardIcon2)
         {
            this.mcKeyboardIcon2.visible = false;
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(param1:String) : void
      {
         this._label = param1;
         this.textField.htmlText = this._label;
         this.mcBackground.width = Math.max(this.BACKGROUND_MIN_SIZE,this.textField.textWidth + this.ICON_PADDING);
      }
      
      public function get keyBinding() : KeyBindingData
      {
         return this._keyBinding;
      }
      
      public function set keyBinding(param1:KeyBindingData) : void
      {
         this._keyBinding = param1;
         this.populateData();
      }
      
      protected function populateData() : void
      {
         this.cleanup();
         if(!this._keyBinding)
         {
            return;
         }
         var _loc1_:InputManager = InputManager.getInstance();
         var _loc2_:Boolean = _loc1_.isGamepad();
         var _loc3_:Boolean = false;
         if(_loc2_)
         {
            _loc3_ = this.setupGamepadIcon();
         }
         else
         {
            _loc3_ = this.setupKeyboardIcon();
         }
         this._isInvalid = !_loc3_;
         visible = _loc3_;
         if(_loc3_)
         {
            this.alignIcons();
         }
      }
      
      protected function setupGamepadIcon() : Boolean
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc1_:InputManager = InputManager.getInstance();
         var _loc2_:Boolean = _loc1_.getPlatform() == PlatformType.PLATFORM_PS4 || _loc1_.gamepadType == InputManager.GAMEPAD_TYPE_PS4;
         var _loc3_:MovieClip = this.getCurrentPadIcon();
         if(this.keyBinding.gamepad_navEquivalent)
         {
            _loc4_ = this.getPadIconFrameLabel(this.keyBinding.gamepad_navEquivalent);
         }
         else
         {
            if(!this.keyBinding.gamepad_keyCode)
            {
               return false;
            }
            _loc5_ = InputDelegate.getInstance().inputToNav("key",this.keyBinding.gamepad_keyCode);
            _loc4_ = this.getPadIconFrameLabel(_loc5_);
         }
         if(_loc4_)
         {
            _loc3_.gotoAndStop(_loc4_);
            _loc3_.visible = true;
            this._icons.push(_loc3_);
            return true;
         }
         return false;
      }
      
      protected function getCurrentPadIcon() : MovieClip
      {
         var _loc1_:uint = InputManager.getInstance().gamepadType;
         switch(_loc1_)
         {
            case EInputDeviceType.IDT_PS4:
               return this.mcIconPS;
            case EInputDeviceType.IDT_Xbox1:
               return this.mcIconXbox;
            case EInputDeviceType.IDT_Steam:
               return this.mcIconSteam;
            default:
               return this.mcIconXbox;
         }
      }
      
      protected function setupKeyboardIcon() : Boolean
      {
         this.addKeyboardIcon(this.keyBinding.keyboard_keyCode);
         if(this.keyBinding.altKeyCode)
         {
            this.addKeyboardIcon(this.keyBinding.altKeyCode,true);
         }
         return true;
      }
      
      protected function addKeyboardIcon(param1:uint, param2:Boolean = false) : void
      {
         var _loc3_:KeyboardButtonMouseIcon = null;
         var _loc4_:String = null;
         var _loc5_:KeyboardButtonIcon = null;
         if(this.isMouseKey(param1))
         {
            _loc3_ = param2 ? this.mcMouseIcon1 : this.mcMouseIcon2;
            _loc3_.keyCode = param1;
            _loc3_.visible = true;
            this._icons.push(_loc3_);
         }
         else
         {
            _loc4_ = KeyboardKeys.getKeyLabel(param1);
            (_loc5_ = param2 ? this.mcKeyboardIcon1 : this.mcKeyboardIcon2).label = _loc4_;
            _loc5_.visible = true;
            this._icons.push(_loc5_);
         }
      }
      
      protected function cleanup() : void
      {
         while(this._icons.length)
         {
            this._icons.pop().visible = false;
         }
      }
      
      protected function alignIcons() : void
      {
         var _loc4_:MovieClip = null;
         var _loc5_:Sprite = null;
         var _loc1_:Number = 0;
         var _loc2_:int = int(this._icons.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc5_ = (_loc4_ = this._icons[_loc3_])["viewrect"] as Sprite)
            {
               _loc4_.x = _loc1_ + _loc5_.width / 2;
               _loc1_ += _loc5_.width + this.ICON_PADDING;
            }
            else
            {
               _loc4_.x = _loc1_;
               _loc1_ += _loc4_.width + this.ICON_PADDING;
            }
            _loc3_++;
         }
      }
      
      private function getPadIconFrameLabel(param1:String) : String
      {
         return param1;
      }
      
      private function isMouseKey(param1:uint) : Boolean
      {
         return param1 >= KeyCode.LEFT_MOUSE && param1 <= KeyCode.MIDDLE_MOUSE || param1 == KeyCode.MOUSE_WHEEL_UP || param1 == KeyCode.MOUSE_WHEEL_DOWN || param1 == KeyCode.MOUSE_PAN || param1 == KeyCode.MOUSE_SCROLL;
      }
   }
}
