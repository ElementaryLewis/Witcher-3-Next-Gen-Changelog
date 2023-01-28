package red.game.witcher3.controls
{
   import red.game.witcher3.data.GridData;
   import scaleform.clik.controls.ListItemRenderer;
   import scaleform.clik.data.ListData;
   
   public class W3BaseSlot extends ListItemRenderer
   {
      
      public static const DEFAULT_GROUPNAME:String = "default";
       
      
      public var mcLoader:W3UILoader;
      
      protected var _iconPath:String;
      
      protected var gridData:GridData;
      
      public function W3BaseSlot()
      {
         super();
         mouseChildren = tabChildren = false;
      }
      
      public function getGridData() : GridData
      {
         return this.gridData;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.mcLoader.maintainAspectRatio = false;
      }
      
      public function get IconPath() : String
      {
         return this._iconPath;
      }
      
      public function set IconPath(param1:String) : void
      {
         if(this._iconPath != param1 || this._iconPath == "")
         {
            this._iconPath = param1;
            if(this._iconPath != "")
            {
               this.mcLoader.source = "img://" + this._iconPath;
            }
            else
            {
               this.mcLoader.fallbackIconPath = "";
               this.mcLoader.source = "";
            }
         }
      }
      
      override public function setListData(param1:ListData) : void
      {
         this.gridData = param1 as GridData;
         if(this.gridData)
         {
            this.IconPath = this.gridData.iconPath;
         }
         else
         {
            this.IconPath = "";
            this.ResetIcons();
         }
         this.update();
      }
      
      override public function setData(param1:Object) : void
      {
         super.setData(param1);
         this.update();
      }
      
      override protected function updateAfterStateChange() : void
      {
         super.updateAfterStateChange();
         this.update();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         toggle = true;
         allowDeselect = false;
         if(_group == null)
         {
            groupName = DEFAULT_GROUPNAME;
         }
      }
      
      override public function setActualSize(param1:Number, param2:Number) : void
      {
      }
      
      override public function toString() : String
      {
         return "[W3 BaseSlot: iconPath " + this._iconPath + ", index " + _index + "]";
      }
      
      protected function update() : void
      {
      }
      
      protected function ResetIcons() : void
      {
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         trace("INVENTORY setSize ",this);
      }
   }
}
