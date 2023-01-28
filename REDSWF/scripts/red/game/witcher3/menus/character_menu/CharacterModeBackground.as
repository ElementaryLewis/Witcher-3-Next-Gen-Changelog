package red.game.witcher3.menus.character_menu
{
   import com.gskinner.motion.GTweener;
   import com.gskinner.motion.easing.Exponential;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import red.core.constants.KeyCode;
   import red.game.witcher3.controls.InputFeedbackButton;
   import red.game.witcher3.slots.SlotBase;
   import scaleform.clik.constants.NavigationCode;
   import scaleform.clik.core.UIComponent;
   import scaleform.clik.events.ButtonEvent;
   
   public class CharacterModeBackground extends UIComponent
   {
      
      protected static const ANIM_DURATION:Number = 1;
      
      public static var CANCEL:String = "Background.Close.Cancel";
      
      public static var ACCEPT:String = "Background.Close.Accept";
       
      
      public var txtCaption:TextField;
      
      public var btnApply:InputFeedbackButton;
      
      public var btnCancel:InputFeedbackButton;
      
      public var mcBackground:MovieClip;
      
      public var mcBackgroundHitTest:MovieClip;
      
      protected var _isActive:Boolean;
      
      protected var _slotAvatar:SlotBase;
      
      protected var _avatarCanvas:Sprite;
      
      public var originalSlot:SlotBase;
      
      public function CharacterModeBackground()
      {
         super();
         this._isActive = false;
         visible = false;
         tabEnabled = tabChildren = focusable = false;
         this._avatarCanvas = new Sprite();
         addChild(this._avatarCanvas);
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.txtCaption.htmlText = "[[panel_character_skill_dialog_title]]";
         this.btnApply.label = "[[panel_common_accept]]";
         this.btnCancel.label = "[[panel_common_cancel]]";
         this.btnApply.setDataFromStage(NavigationCode.GAMEPAD_A,KeyCode.E);
         this.btnCancel.setDataFromStage(NavigationCode.GAMEPAD_B,KeyCode.ESCAPE);
         this.btnApply.addEventListener(ButtonEvent.CLICK,this.handleApplyClick,false,0,true);
         this.btnCancel.addEventListener(ButtonEvent.CLICK,this.handleCancelClick,false,0,true);
      }
      
      public function setCaption(param1:String) : void
      {
         this.txtCaption.htmlText = param1;
      }
      
      public function activate(param1:SlotBase = null) : void
      {
         this.createSlotAvatar(param1);
         visible = this._isActive = true;
         this.mcBackground.visible = true;
         this.mcBackground.alpha = 0;
         GTweener.to(this.mcBackground,ANIM_DURATION,{"alpha":1},{"ease":Exponential.easeOut});
         this.originalSlot = param1;
      }
      
      public function deactivate() : void
      {
         if(this._slotAvatar)
         {
            GTweener.removeTweens(this._avatarCanvas);
            this._avatarCanvas.removeChild(this._slotAvatar);
         }
         visible = this._isActive = false;
         this.mcBackground.visible = false;
      }
      
      public function isActive() : Boolean
      {
         return this._isActive;
      }
      
      protected function createSlotAvatar(param1:SlotBase) : void
      {
         var _loc2_:Class = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1)
         {
            _loc2_ = Class(getDefinitionByName(getQualifiedClassName(param1)));
            _loc3_ = new Point(param1.x,param1.y);
            _loc4_ = param1.parent.localToGlobal(_loc3_);
            this._slotAvatar = new _loc2_() as SlotBase;
            this._slotAvatar.data = param1.data;
            this._slotAvatar.tabEnabled = true;
            this._slotAvatar.focusable = false;
            this._slotAvatar.alpha = 1;
            this._avatarCanvas.addChild(this._slotAvatar);
            this._slotAvatar.validateNow();
            _loc6_ = (_loc5_ = this._slotAvatar.getSlotRect()).width / 2;
            _loc7_ = _loc5_.height / 2;
            this._avatarCanvas.x = _loc4_.x + _loc6_;
            this._avatarCanvas.y = _loc4_.y + _loc7_;
            this._slotAvatar.x = -_loc6_;
            this._slotAvatar.y = -_loc7_;
            this._avatarCanvas.alpha = 0;
            this._slotAvatar.filters = [new GlowFilter(16777144,0.5,8,8,1,BitmapFilterQuality.HIGH)];
            GTweener.to(this._avatarCanvas,ANIM_DURATION,{
               "scaleX":1.1,
               "scaleY":1.1,
               "alpha":1
            },{"ease":Exponential.easeOut});
         }
      }
      
      private function handleApplyClick(param1:ButtonEvent) : void
      {
         this.userApply();
      }
      
      private function handleCancelClick(param1:ButtonEvent) : void
      {
         this.userCancel();
      }
      
      protected function userCancel() : void
      {
         dispatchEvent(new Event(CharacterModeBackground.CANCEL));
      }
      
      protected function userApply() : void
      {
         dispatchEvent(new Event(CharacterModeBackground.ACCEPT));
      }
   }
}
