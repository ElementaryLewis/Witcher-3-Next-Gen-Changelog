package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import red.game.witcher3.controls.BaseListItem;
   
   public class CheckboxListItem extends BaseListItem
   {
       
      
      public var mcCheckbox:MovieClip;
      
      protected var _isChecked:Boolean = false;
      
      protected var _groupID:String = "";
      
      protected var _dataKey:String = "";
      
      public function CheckboxListItem()
      {
         super();
      }
      
      public function get isChecked() : Boolean
      {
         return this._isChecked;
      }
      
      public function set isChecked(param1:Boolean) : void
      {
         if(this._isChecked == param1)
         {
            return;
         }
         this._isChecked = param1;
         this.updateCheckbox();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.updateCheckbox();
      }
      
      protected function updateCheckbox() : void
      {
         if(this.mcCheckbox)
         {
            if(this._isChecked)
            {
               this.mcCheckbox.gotoAndStop("on");
            }
            else
            {
               this.mcCheckbox.gotoAndStop("off");
            }
         }
      }
      
      public function get groupID() : String
      {
         return this._groupID;
      }
      
      public function set groupID(param1:String) : void
      {
         this._groupID = param1;
      }
      
      public function get dataKey() : String
      {
         return this._dataKey;
      }
      
      public function set dataKey(param1:String) : void
      {
         this._dataKey = param1;
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         if(param1)
         {
            this.isChecked = param1.isChecked;
            this.dataKey = param1.key;
            if(param1.hasOwnProperty("groupId") && param1.groupId != "")
            {
               this.groupID = param1.groupId;
            }
            else
            {
               this.groupID = "";
            }
         }
      }
   }
}
