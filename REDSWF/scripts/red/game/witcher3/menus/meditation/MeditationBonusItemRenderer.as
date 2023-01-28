package red.game.witcher3.menus.meditation
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import red.game.witcher3.constants.CommonConstants;
   import red.game.witcher3.utils.CommonUtils;
   import scaleform.clik.core.UIComponent;
   
   public class MeditationBonusItemRenderer extends UIComponent
   {
       
      
      public var mcColoredBorder:MovieClip;
      
      public var mcIcon:MovieClip;
      
      public var mcLockIcon:MovieClip;
      
      public var tfTitle:TextField;
      
      public var tfDuration:TextField;
      
      public var tfDescription:TextField;
      
      private var _data:Object;
      
      private var _activate:Boolean;
      
      private var _locked:Boolean;
      
      public function MeditationBonusItemRenderer()
      {
         super();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(param1:Object) : void
      {
         this._data = param1;
         this.tfTitle.text = CommonUtils.toUpperCaseSafe(this._data.title);
         this.tfDuration.text = this._data.duration;
         this.tfDescription.text = this._data.description;
         this.tfDescription.height = this.tfDescription.textHeight + CommonConstants.SAFE_TEXT_PADDING;
         if(this._data.duration)
         {
            this.tfDescription.y = this.tfDuration.y + this.tfDuration.textHeight;
         }
         else
         {
            this.tfDescription.y = this.tfDuration.y;
         }
         this._locked = !this._data.available;
         this.mcIcon.gotoAndStop(this._data.type);
         this.updateLockedState();
      }
      
      public function get activate() : Boolean
      {
         return this._activate;
      }
      
      public function set activate(param1:Boolean) : void
      {
         this._activate = param1;
         this.updateLockedState();
      }
      
      private function updateLockedState() : void
      {
         if(this._locked)
         {
            this.mcColoredBorder.gotoAndStop(3);
            this.mcIcon.visible = false;
            this.mcLockIcon.visible = true;
            this.tfTitle.textColor = 6184542;
            this.tfDuration.textColor = 6184542;
            this.tfDescription.textColor = 6184542;
         }
         else
         {
            this.mcColoredBorder.gotoAndStop(this._activate ? 2 : 1);
            this.mcIcon.alpha = this._activate ? 1 : 0.5;
            this.mcColoredBorder.mcGreenFrame.gotoAndPlay(this._activate ? "show" : "hide");
            this.mcIcon.visible = true;
            this.mcLockIcon.visible = false;
            this.tfTitle.textColor = 10195332;
            this.tfDuration.textColor = 10195332;
            this.tfDescription.textColor = 13816530;
         }
      }
   }
}
