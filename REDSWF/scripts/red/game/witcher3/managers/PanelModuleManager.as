package red.game.witcher3.managers
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import scaleform.clik.core.UIComponent;
   
   public class PanelModuleManager extends UIComponent
   {
       
      
      private const MAX_SCREEN_WIDTH:Number = 1920;
      
      private const MAX_SCREEN_HEIGHT:Number = 1080;
      
      public var m_moduleClasses:Array;
      
      public var m_moduleClassesOverride:Array;
      
      public var m_moduleChilds:Array;
      
      public var m_moduleAnchors:Array;
      
      private var m_modulesA:Vector.<MovieClip>;
      
      private var m_anchorsDefaultPositionsVP:Vector.<Point>;
      
      private var m_bUsingGamepad:Boolean = true;
      
      public function PanelModuleManager()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         dispatchEvent(new GameEvent(GameEvent.REGISTER,"inventory.gamepad.state",[this.SetUsingGamepad]));
         if(this.m_moduleAnchors)
         {
            this.SaveAnchorsDefaultPosition();
            this.InstanciateModules();
            this.MatchModulesWithAnchors();
         }
         super.configUI();
      }
      
      private function SaveAnchorsDefaultPosition() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         this.m_anchorsDefaultPositionsVP = new Vector.<Point>();
         var _loc3_:int = 0;
         while(_loc3_ < this.m_moduleAnchors.length)
         {
            _loc1_ = String(this.m_moduleAnchors[_loc3_]);
            _loc2_ = this.parent[_loc1_];
            if(_loc2_)
            {
               this.m_anchorsDefaultPositionsVP.push(new Point(_loc2_.x,_loc2_.y));
            }
            _loc3_++;
         }
      }
      
      public function SetUsingGamepad(param1:Boolean) : void
      {
         this.m_bUsingGamepad = param1;
      }
      
      public function IsUsingGamepad() : Boolean
      {
         if(ExternalInterface.available)
         {
            this.m_bUsingGamepad = ExternalInterface.call("isPadConnected");
         }
         return this.m_bUsingGamepad;
      }
      
      private function InstanciateModules() : void
      {
         var _loc1_:String = null;
         var _loc2_:Class = null;
         var _loc3_:MovieClip = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         this.m_modulesA = new Vector.<MovieClip>();
         _loc5_ = 0;
         if(this.m_moduleChilds)
         {
            _loc5_ = 0;
            while(_loc5_ < this.m_moduleChilds.length)
            {
               _loc1_ = String(this.m_moduleChilds[_loc5_]);
               _loc3_ = this.parent.getChildByName(_loc1_) as MovieClip;
               if(_loc3_)
               {
                  this.m_modulesA.push(_loc3_);
               }
               _loc5_++;
            }
         }
         if(this.m_moduleClasses)
         {
            _loc5_ = 0;
            while(_loc5_ < this.m_moduleClasses.length)
            {
               _loc1_ = String(this.m_moduleClasses[_loc5_]);
               _loc2_ = getDefinitionByName(_loc1_) as Class;
               if(_loc2_ != null)
               {
                  _loc3_ = new _loc2_() as MovieClip;
                  this.m_modulesA.push(_loc3_);
               }
               _loc5_++;
            }
         }
         if(this.m_moduleClassesOverride)
         {
            if(this.IsUsingGamepad())
            {
               _loc4_ = "_CONSOLE";
            }
            else
            {
               _loc4_ = "_PC";
            }
            _loc5_ = 0;
            while(_loc5_ < this.m_moduleClassesOverride.length)
            {
               _loc1_ = String(this.m_moduleClassesOverride[_loc5_]);
               _loc2_ = getDefinitionByName(_loc1_ + _loc4_) as Class;
               if(_loc2_ != null)
               {
                  _loc3_ = new _loc2_() as MovieClip;
                  this.m_modulesA.push(_loc3_);
               }
               _loc5_++;
            }
         }
      }
      
      private function MatchModulesWithAnchors() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:int = 0;
         this.UpdateAnchorsPositions();
         _loc3_ = 0;
         while(_loc3_ < this.m_modulesA.length)
         {
            if(this.m_moduleAnchors.length >= _loc3_)
            {
               _loc1_ = String(this.m_moduleAnchors[_loc3_]);
               _loc2_ = this.parent[_loc1_];
               if(_loc2_)
               {
                  _loc2_.visible = false;
                  this.m_modulesA[_loc3_].x = _loc2_.x;
                  this.m_modulesA[_loc3_].y = _loc2_.y;
                  if(!parent.contains(this.m_modulesA[_loc3_]))
                  {
                     parent.addChild(this.m_modulesA[_loc3_]);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      public function UpdateAnchorsPositions() : void
      {
         var _loc1_:String = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         while(_loc5_ < this.m_moduleAnchors.length)
         {
            _loc1_ = String(this.m_moduleAnchors[_loc5_]);
            _loc2_ = this.parent[_loc1_];
            if(_loc2_)
            {
               _loc3_ = this.m_anchorsDefaultPositionsVP[_loc5_].x / this.MAX_SCREEN_WIDTH;
               _loc4_ = this.m_anchorsDefaultPositionsVP[_loc5_].y / this.MAX_SCREEN_HEIGHT;
               _loc2_.x = stage.stageWidth * _loc3_;
               _loc2_.y = stage.stageHeight * _loc4_;
            }
            _loc5_++;
         }
      }
      
      public function GetModules() : Vector.<MovieClip>
      {
         return this.m_modulesA;
      }
   }
}
