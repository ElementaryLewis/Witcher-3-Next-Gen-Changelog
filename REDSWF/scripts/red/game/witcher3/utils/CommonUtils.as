package red.game.witcher3.utils
{
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import red.game.witcher3.constants.InventorySlotType;
   import red.game.witcher3.constants.KeyCode;
   import red.game.witcher3.interfaces.IBaseSlot;
   import red.game.witcher3.managers.InputManager;
   import scaleform.clik.constants.InputValue;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.ui.InputDetails;
   import scaleform.gfx.Extensions;
   
   public class CommonUtils
   {
      
      private static var isTurkish:Boolean = false;
      
      private static const GERMAN_SS_STRING:String = "ß";
      
      private static const GERMAN_SS_REPLACEMENT:String = "SS";
      
      private static const TURKISH_FIRST_LC_I_STRING:String = "i";
      
      private static const TURKISH_FIRST_UC_I_STRING:String = "İ";
      
      private static const TURKISH_SECOND_LC_I_STRING:String = "ı";
      
      private static const TURKISH_SECOND_UC_I_STRING:String = "I";
       
      
      public function CommonUtils()
      {
         super();
      }
      
      public static function drawPie(param1:Graphics, param2:Number, param3:Number = 30, param4:Number = -90, param5:Number = 270) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc6_:Number = param4 / 180 * Math.PI;
         var _loc7_:Number;
         var _loc8_:Number = ((_loc7_ = param5 / 180 * Math.PI) - _loc6_) / param3;
         var _loc9_:Number = _loc6_;
         param1.beginFill(16711680,1);
         param1.moveTo(0,0);
         var _loc10_:int = 0;
         while(_loc10_ <= param3)
         {
            _loc11_ = param2 * Math.cos(_loc9_);
            _loc12_ = param2 * Math.sin(_loc9_);
            param1.lineTo(_loc11_,_loc12_);
            _loc9_ += _loc8_;
            _loc10_++;
         }
         param1.lineTo(0,0);
         param1.endFill();
      }
      
      public static function traceObject(param1:Object, param2:String = "") : void
      {
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            if(param1[_loc3_] is Object || param1[_loc3_] is Array)
            {
               traceObject(param1[_loc3_],param2);
            }
         }
      }
      
      public static function getDesaturateFilter() : ColorMatrixFilter
      {
         var _loc1_:Array = new Array(0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0.309,0.609,0.082,0,0,0,0,0,1,0);
         return new ColorMatrixFilter(_loc1_);
      }
      
      public static function getRedWarningFilter() : ColorMatrixFilter
      {
         var _loc1_:Array = new Array(0.9,0,0,0,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0);
         return new ColorMatrixFilter(_loc1_);
      }
      
      public static function convertAxisToNavigationCode(param1:Number) : InputDetails
      {
         var _loc2_:InputDetails = new InputDetails("key",0,InputValue.KEY_DOWN,null,0,true,false,false,true);
         var _loc3_:Boolean = InputManager.getInstance().isGamepad();
         var _loc4_:Number;
         if((_loc4_ = param1 * 180 / Math.PI) < 135 && _loc4_ > 45)
         {
            _loc2_.code = _loc3_ ? KeyCode.PAD_DIGIT_UP : KeyCode.UP;
            _loc2_.navEquivalent = _loc3_ ? NavigationCode.DPAD_UP : NavigationCode.UP;
            return _loc2_;
         }
         if(_loc4_ <= 45 && _loc4_ >= 0 || _loc4_ > 315 && _loc4_ <= 360)
         {
            _loc2_.code = _loc3_ ? KeyCode.PAD_DIGIT_RIGHT : KeyCode.RIGHT;
            _loc2_.navEquivalent = _loc3_ ? NavigationCode.DPAD_RIGHT : NavigationCode.RIGHT;
            return _loc2_;
         }
         if(_loc4_ >= 135 && _loc4_ <= 225)
         {
            _loc2_.code = _loc3_ ? KeyCode.PAD_DIGIT_LEFT : KeyCode.LEFT;
            _loc2_.navEquivalent = _loc3_ ? NavigationCode.DPAD_LEFT : NavigationCode.LEFT;
            return _loc2_;
         }
         if(_loc4_ > 225 && _loc4_ <= 315)
         {
            _loc2_.code = _loc3_ ? KeyCode.PAD_DIGIT_DOWN : KeyCode.DOWN;
            _loc2_.navEquivalent = _loc3_ ? NavigationCode.DPAD_DOWN : NavigationCode.DOWN;
            return _loc2_;
         }
         return null;
      }
      
      public static function convertNavigationCodeToAxis(param1:Number) : Number
      {
         switch(param1)
         {
            case KeyCode.UP:
               return 0;
            case KeyCode.RIGHT:
               return Math.PI / 2;
            case KeyCode.DOWN:
               return Math.PI;
            case KeyCode.LEFT:
               return -Math.PI / 2;
            default:
               return NaN;
         }
      }
      
      public static function traceCallstack(param1:String) : void
      {
         var _loc2_:Error = new Error();
      }
      
      public static function convertKeyCodeToFrame(param1:uint) : uint
      {
         switch(param1)
         {
            case KeyCode.PAD_X_SQUARE:
               return 2;
            case KeyCode.PAD_A_CROSS:
               return 3;
            case KeyCode.PAD_B_CIRCLE:
               return 4;
            case KeyCode.PAD_Y_TRIANGLE:
               return 5;
            case KeyCode.PAD_LEFT_SHOULDER:
               return 6;
            case KeyCode.PAD_RIGHT_SHOULDER:
               return 7;
            case KeyCode.PAD_LEFT_TRIGGER:
            case KeyCode.PAD_LEFT_TRIGGER_AXIS:
               return 8;
            case KeyCode.PAD_RIGHT_TRIGGER:
            case KeyCode.PAD_RIGHT_TRIGGER_AXIS:
               return 9;
            case KeyCode.PAD_LEFT_STICK_AXIS:
            case KeyCode.PAD_LEFT_STICK_UP:
            case KeyCode.PAD_LEFT_STICK_DOWN:
            case KeyCode.PAD_LEFT_STICK_LEFT:
            case KeyCode.PAD_LEFT_STICK_RIGHT:
               return 10;
            case KeyCode.PAD_RIGHT_STICK_AXIS:
            case KeyCode.PAD_RIGHT_STICK_UP:
            case KeyCode.PAD_RIGHT_STICK_DOWN:
            case KeyCode.PAD_RIGHT_STICK_LEFT:
            case KeyCode.PAD_RIGHT_STICK_RIGHT:
               return 11;
            case KeyCode.PAD_DIGIT_UP:
               return 14;
            case KeyCode.PAD_DIGIT_DOWN:
               return 15;
            case KeyCode.PAD_DIGIT_RIGHT:
               return 16;
            case KeyCode.PAD_DIGIT_LEFT:
               return 17;
            case KeyCode.PAD_START:
               return 18;
            case KeyCode.PAD_BACK_SELECT:
               return 19;
            default:
               return 1;
         }
      }
      
      public static function hasFrameLabel(param1:MovieClip, param2:String) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.currentLabels.length)
         {
            if(param1.currentLabels[_loc3_].name == param2)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public static function getScreenRect() : Rectangle
      {
         if(Extensions.isScaleform)
         {
            return Extensions.visibleRect;
         }
         return new Rectangle(0,0,1920,1080);
      }
      
      public static function createSolidColorSprite(param1:Rectangle, param2:Number, param3:Number) : Sprite
      {
         var _loc5_:Graphics;
         var _loc4_:Sprite;
         (_loc5_ = (_loc4_ = new Sprite()).graphics).lineStyle(0,0,0);
         _loc5_.beginFill(param2,param3);
         _loc5_.moveTo(param1.x,param1.y);
         _loc5_.lineTo(param1.x + param1.width,param1.y);
         _loc5_.lineTo(param1.x + param1.width,param1.y + param1.height);
         _loc5_.lineTo(param1.x,param1.y + param1.height);
         _loc5_.lineTo(param1.x,param1.y);
         _loc5_.endFill();
         return _loc4_;
      }
      
      public static function createFullscreenSprite(param1:Number, param2:Number) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Graphics = _loc3_.graphics;
         var _loc5_:Rectangle = CommonUtils.getScreenRect();
         _loc4_.lineStyle(0,0,0);
         _loc4_.beginFill(param1,param2);
         _loc4_.moveTo(_loc5_.x,_loc5_.y);
         _loc4_.lineTo(_loc5_.x + _loc5_.width,_loc5_.y);
         _loc4_.lineTo(_loc5_.x + _loc5_.width,_loc5_.y + _loc5_.height);
         _loc4_.lineTo(_loc5_.x,_loc5_.y + _loc5_.height);
         _loc4_.lineTo(_loc5_.x,_loc5_.y);
         _loc4_.endFill();
         return _loc3_;
      }
      
      public static function strTrim(param1:String) : String
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:int = 0;
         var _loc2_:String = "";
         var _loc3_:int = param1.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_ - 1 && (param1.charCodeAt(_loc4_) == 32 || param1.charCodeAt(_loc4_) == 9))
         {
            _loc4_++;
         }
         _loc5_ = _loc4_;
         _loc4_ = _loc3_ - 1;
         while(_loc4_ > 0 && (param1.charCodeAt(_loc4_) == 32 || param1.charCodeAt(_loc4_) == 9))
         {
            _loc4_--;
         }
         _loc6_ = _loc4_;
         return param1.slice(_loc5_,_loc6_ + 1);
      }
      
      public static function generateDesaturationFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:* = 1 - param1;
         var _loc3_:* = 1 - param1;
         var _loc4_:* = 1 - param1;
         var _loc5_:Number;
         var _loc6_:Number = (_loc5_ = param1) * 0.5;
         var _loc7_:Array = (_loc7_ = (_loc7_ = (_loc7_ = (_loc7_ = (_loc7_ = new Array()).concat([_loc2_ + param1,_loc2_,_loc2_,0,0])).concat([_loc3_,_loc3_ + param1,_loc3_,0,0])).concat([_loc4_,_loc4_,_loc4_ + param1,0,0])).concat([0,0,0,1,0])).concat([0,0,0,0,2]);
         return new ColorMatrixFilter(_loc7_);
      }
      
      public static function generateDarkenFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc2_:Array = new Array();
         _loc2_ = _loc2_.concat([param1,0,0,0,0]);
         _loc2_ = _loc2_.concat([0,param1,0,0,0]);
         _loc2_ = _loc2_.concat([0,0,param1,0,0]);
         _loc2_ = _loc2_.concat([0,0,0,1,0]);
         return new ColorMatrixFilter(_loc2_);
      }
      
      public static function generateGrayscaleFilter() : ColorMatrixFilter
      {
         var _loc1_:Number = 1 / 3;
         var _loc2_:Number = 2 / 3;
         var _loc3_:Array = new Array();
         _loc3_ = _loc3_.concat([_loc1_,_loc1_,_loc1_,0,0]);
         _loc3_ = _loc3_.concat([_loc1_,_loc1_,_loc1_,0,0]);
         _loc3_ = _loc3_.concat([_loc1_,_loc1_,_loc1_,0,0]);
         _loc3_ = _loc3_.concat([0,0,0,1,0]);
         return new ColorMatrixFilter(_loc3_);
      }
      
      public static function toArray(param1:*) : Array
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_);
         }
         return _loc2_;
      }
      
      public static function getMiddlePoint(param1:Point, param2:Point) : Point
      {
         var _loc3_:Number = Point.distance(param1,param2) / 2;
         var _loc4_:Number = param1.x - param2.x;
         var _loc5_:Number = param1.x - param2.x;
         var _loc6_:Number = Math.atan2(_loc4_,_loc5_);
         var _loc7_:Number = _loc4_ + _loc3_ * Math.cos(_loc6_);
         var _loc8_:Number = _loc5_ + _loc3_ * Math.sin(_loc6_);
         return new Point(_loc7_,_loc8_);
      }
      
      public static function setTurkish(param1:Boolean) : *
      {
         isTurkish = param1;
      }
      
      public static function toLowerCaseExSafe(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         if(!param1 || param1.length == 0)
         {
            return _loc2_;
         }
         _loc3_ = param1.charAt(0);
         if(isTurkish)
         {
            if(_loc3_ == TURKISH_FIRST_LC_I_STRING)
            {
               _loc2_ += TURKISH_FIRST_UC_I_STRING;
            }
            else if(_loc3_ == TURKISH_SECOND_LC_I_STRING)
            {
               _loc2_ += TURKISH_SECOND_UC_I_STRING;
            }
            else if(_loc3_ == TURKISH_FIRST_UC_I_STRING || _loc3_ == TURKISH_SECOND_UC_I_STRING)
            {
               _loc2_ += _loc3_;
            }
            else
            {
               _loc2_ += _loc3_.toUpperCase();
            }
         }
         else if(_loc3_ == GERMAN_SS_STRING)
         {
            _loc2_ += GERMAN_SS_REPLACEMENT;
         }
         else
         {
            _loc2_ += _loc3_.toUpperCase();
         }
         var _loc4_:String = param1.slice(1,param1.length);
         return _loc2_ + _loc4_.toLowerCase();
      }
      
      public static function toSmallCaps(param1:TextField) : void
      {
         var _loc2_:* = 2;
         var _loc3_:* = 2;
         var _loc4_:String = toUpperCaseSafe(param1.text);
         var _loc5_:TextFormat;
         var _loc6_:Number = !!(_loc5_ = param1.getTextFormat()).size ? _loc5_.size as Number : 12;
         var _loc7_:* = "<font size = \"" + (_loc6_ + _loc3_) + "\"  >" + _loc4_.charAt(0) + "</font><font size = \"" + (_loc6_ - _loc2_) + "\"  >" + _loc4_.slice(1) + "</font>";
         param1.htmlText = _loc7_;
      }
      
      public static function toUpperCaseSafe(param1:String) : String
      {
         var _loc2_:String = null;
         if(isTurkish)
         {
            _loc2_ = param1.split(TURKISH_FIRST_LC_I_STRING).join(TURKISH_FIRST_UC_I_STRING);
            _loc2_ = _loc2_.split(TURKISH_SECOND_LC_I_STRING).join(TURKISH_SECOND_UC_I_STRING);
            _loc2_ = _loc2_.toUpperCase();
         }
         else
         {
            _loc2_ = param1.split(GERMAN_SS_STRING).join(GERMAN_SS_REPLACEMENT);
            _loc2_ = _loc2_.toUpperCase();
         }
         return _loc2_;
      }
      
      public static function convertWASDCodeToNavEquivalent(param1:InputDetails) : *
      {
         switch(param1.code)
         {
            case KeyCode.W:
               param1.navEquivalent = NavigationCode.UP;
               break;
            case KeyCode.S:
               param1.navEquivalent = NavigationCode.DOWN;
               break;
            case KeyCode.A:
               param1.navEquivalent = NavigationCode.LEFT;
               break;
            case KeyCode.D:
               param1.navEquivalent = NavigationCode.RIGHT;
         }
      }
      
      public static function checkSlotsCompatibility(param1:int, param2:int) : Boolean
      {
         if((param1 == InventorySlotType.Quickslot1 || param1 == InventorySlotType.Quickslot2) && (param2 == InventorySlotType.Quickslot1 || param2 == InventorySlotType.Quickslot2))
         {
            return true;
         }
         if((param1 == InventorySlotType.Potion1 || param1 == InventorySlotType.Potion2) && (param2 == InventorySlotType.Potion1 || param2 == InventorySlotType.Potion2))
         {
            return true;
         }
         if((param1 == InventorySlotType.Petard1 || param1 == InventorySlotType.Petard2) && (param2 == InventorySlotType.Petard1 || param2 == InventorySlotType.Petard2))
         {
            return true;
         }
         return param1 == param2;
      }
      
      public static function getPointOfIntersection(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc5_:Number = (param1.x - param2.x) * (param4.y - param3.y) - (param1.y - param2.y) * (param4.x - param3.x);
         var _loc6_:Number = (param1.x - param3.x) * (param4.y - param3.y) - (param1.y - param3.y) * (param4.x - param3.x);
         var _loc7_:Number = (param1.x - param2.x) * (param1.y - param3.y) - (param1.y - param2.y) * (param1.x - param3.x);
         var _loc8_:Number = _loc6_ / _loc5_;
         var _loc9_:Number = _loc7_ / _loc5_;
         if(_loc8_ >= 0 && _loc8_ <= 1 && _loc9_ >= 0 && _loc9_ <= 1)
         {
            _loc10_ = param1.x + _loc8_ * (param2.x - param1.x);
            _loc11_ = param1.y + _loc8_ * (param2.y - param1.y);
            return new Point(_loc10_,_loc11_);
         }
         return null;
      }
      
      public static function fixFontStyleTags(param1:String) : String
      {
         var _loc2_:RegExp = null;
         var _loc3_:String = null;
         _loc2_ = /<i>/g;
         _loc3_ = param1.replace(_loc2_,"<font face=\'$ItalicFont\'>");
         _loc2_ = /<b>/g;
         _loc3_ = _loc3_.replace(_loc2_,"<font face=\'$BoldFont\'>");
         _loc2_ = /<\/i>/g;
         _loc3_ = _loc3_.replace(_loc2_,"</font>");
         _loc2_ = /<\/b>/g;
         return _loc3_.replace(_loc2_,"</font>");
      }
      
      public static function spawnTextField(param1:Number = 24, param2:Number = 16777215, param3:Boolean = false) : TextField
      {
         var _loc4_:TextField = new TextField();
         var _loc5_:TextFormat;
         (_loc5_ = new TextFormat("$NormalFont",param1)).align = TextFormatAlign.CENTER;
         _loc5_.font = "$NormalFont";
         _loc4_.embedFonts = true;
         _loc4_.defaultTextFormat = _loc5_;
         _loc4_.setTextFormat(_loc5_);
         _loc4_.textColor = param2;
         if(param3)
         {
            _loc4_.background = true;
            _loc4_.backgroundColor = 8388608;
         }
         return _loc4_;
      }
      
      public static function getClosestSlot(param1:Point, param2:Vector.<IBaseSlot>) : IBaseSlot
      {
         var _loc4_:IBaseSlot = null;
         var _loc7_:IBaseSlot = null;
         var _loc8_:Sprite = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Point = null;
         var _loc13_:Number = NaN;
         var _loc3_:Number = -1;
         var _loc5_:int = int(param2.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = ((_loc7_ = param2[_loc6_]) as Sprite).parent as Sprite;
            _loc9_ = _loc7_.getSlotRect();
            _loc10_ = _loc7_.x + _loc9_.x + _loc9_.width / 2;
            _loc11_ = _loc7_.y + _loc9_.y + _loc9_.height / 2;
            _loc12_ = _loc8_.localToGlobal(new Point(_loc10_,_loc11_));
            _loc13_ = Point.distance(param1,_loc12_);
            if(_loc3_ > _loc13_ || _loc3_ == -1)
            {
               _loc3_ = _loc13_;
               _loc4_ = _loc7_;
            }
            _loc6_++;
         }
         return _loc4_;
      }
      
      public static function replicateDataObject(param1:Object) : Object
      {
         var _loc3_:String = null;
         var _loc2_:Object = {};
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
      
      public static function getLocalization(param1:String) : String
      {
         var _loc2_:TextField = new TextField();
         _loc2_.text = "[[" + param1 + "]]";
         return _loc2_.text;
      }
   }
}
