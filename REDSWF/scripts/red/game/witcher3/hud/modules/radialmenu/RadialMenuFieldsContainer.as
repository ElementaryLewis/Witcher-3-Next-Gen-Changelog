package red.game.witcher3.hud.modules.radialmenu
{
   import scaleform.clik.core.UIComponent;
   
   public class RadialMenuFieldsContainer extends UIComponent
   {
       
      
      public var mcRadialMenuItem1:RadialMenuItem;
      
      public var mcRadialMenuItem2:RadialMenuItem;
      
      public var mcRadialMenuItem3:RadialMenuItem;
      
      public var mcRadialMenuItem4:RadialMenuItem;
      
      public var mcRadialMenuItem5:RadialMenuItem;
      
      public var mcRadialMenuItem6:RadialMenuItem;
      
      public var mcRadialMenuItem7:RadialMenuItem;
      
      public var mcRadialMenuItem8:RadialMenuItem;
      
      private var RadialMenuFields:Array;
      
      private var SlotsNames:Array;
      
      public function RadialMenuFieldsContainer()
      {
         this.RadialMenuFields = new Array();
         this.SlotsNames = new Array();
         super();
      }
      
      public function setExternalViewer(param1:RadialMenuSubItemView) : void
      {
         (this.mcRadialMenuItem6 as RadialMenuItemEquipped).subListViewer = param1;
         (this.mcRadialMenuItem7 as RadialMenuItemEquipped).subListViewer = param1;
         (this.mcRadialMenuItem8 as RadialMenuItemEquipped).subListViewer = param1;
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.Init();
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem1,
            "initX":this.mcRadialMenuItem1.x,
            "initY":this.mcRadialMenuItem1.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem2,
            "initX":this.mcRadialMenuItem2.x,
            "initY":this.mcRadialMenuItem2.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem3,
            "initX":this.mcRadialMenuItem3.x,
            "initY":this.mcRadialMenuItem3.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem4,
            "initX":this.mcRadialMenuItem4.x,
            "initY":this.mcRadialMenuItem4.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem5,
            "initX":this.mcRadialMenuItem5.x,
            "initY":this.mcRadialMenuItem5.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem6,
            "initX":this.mcRadialMenuItem6.x,
            "initY":this.mcRadialMenuItem6.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem7,
            "initX":this.mcRadialMenuItem7.x,
            "initY":this.mcRadialMenuItem7.y
         });
         this.RadialMenuFields.push({
            "obj":this.mcRadialMenuItem8,
            "initX":this.mcRadialMenuItem8.x,
            "initY":this.mcRadialMenuItem8.y
         });
         this.mcRadialMenuItem6.SetAsItemField(true);
         this.mcRadialMenuItem7.SetAsItemField(true);
         this.mcRadialMenuItem8.SetAsItemField(true);
      }
      
      public function Init() : *
      {
         this.UpdateRadialMenuFieldsNames(this.SlotsNames);
      }
      
      public function SetSelected(param1:int) : Boolean
      {
         var _loc2_:RadialMenuItem = null;
         if(param1 < this.RadialMenuFields.length)
         {
            _loc2_ = this.RadialMenuFields[param1].obj as RadialMenuItem;
            if(_loc2_)
            {
               _loc2_.SetSelected();
            }
         }
         return true;
      }
      
      public function SetDeselected(param1:int) : void
      {
         var _loc2_:RadialMenuItem = null;
         if(param1 < this.RadialMenuFields.length)
         {
            _loc2_ = this.RadialMenuFields[param1].obj as RadialMenuItem;
            if(_loc2_)
            {
               _loc2_.SetDeselected();
            }
         }
      }
      
      public function SetDesatureted(param1:String, param2:Boolean) : void
      {
         var _loc3_:RadialMenuItem = null;
         _loc3_ = this.GetRadialMenuFieldByName(param1);
         if(_loc3_)
         {
            _loc3_.SetDesatureted(param2);
         }
      }
      
      public function IsDesatureted(param1:String) : Boolean
      {
         var _loc2_:RadialMenuItem = null;
         _loc2_ = this.GetRadialMenuFieldByName(param1);
         if(_loc2_)
         {
            return _loc2_.IsDesatureted();
         }
         return false;
      }
      
      public function GetSelectedRadialMenuField() : RadialMenuItem
      {
         var _loc1_:int = 0;
         var _loc2_:RadialMenuItem = null;
         _loc1_ = 0;
         while(_loc1_ < this.RadialMenuFields.length)
         {
            _loc2_ = this.RadialMenuFields[_loc1_].obj as RadialMenuItem;
            if(_loc2_.getIsSelected())
            {
               return _loc2_;
            }
            _loc1_++;
         }
         return null;
      }
      
      public function GetRadialMenuFieldByName(param1:String) : RadialMenuItem
      {
         var _loc2_:int = 0;
         var _loc3_:RadialMenuItem = null;
         _loc2_ = 0;
         while(_loc2_ < this.RadialMenuFields.length)
         {
            _loc3_ = this.RadialMenuFields[_loc2_].obj as RadialMenuItem;
            if(_loc3_.getRadialItemName() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetRadialMenuFieldByID(param1:int) : RadialMenuItem
      {
         var _loc2_:RadialMenuItem = null;
         _loc2_ = getChildByName("mcRadialMenuItem" + param1) as RadialMenuItem;
         if(_loc2_)
         {
            return _loc2_;
         }
         return null;
      }
      
      public function SetRadialMenuFieldsNames(param1:Array) : void
      {
         this.SlotsNames = param1;
      }
      
      public function IsEnabled(param1:int) : Boolean
      {
         var _loc2_:RadialMenuItem = null;
         _loc2_ = getChildByName("mcRadialMenuItem" + param1) as RadialMenuItem;
         if(_loc2_)
         {
            return _loc2_.enabled;
         }
         return false;
      }
      
      public function UpdateRadialMenuFieldsNames(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RadialMenuItem = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = this.GetRadialMenuFieldByID(_loc2_ + 1) as RadialMenuItem;
            if(param1[_loc2_] == "disabled")
            {
               if(_loc3_)
               {
                  _loc3_.visible = false;
                  _loc3_.enabled = false;
               }
            }
            else if(_loc3_)
            {
               _loc3_.visible = true;
               _loc3_.enabled = true;
            }
            if(_loc3_)
            {
               _loc3_.setRadialItemName(param1[_loc2_]);
               _loc3_["mcEquipped"].visible = false;
            }
            _loc2_++;
         }
      }
   }
}
