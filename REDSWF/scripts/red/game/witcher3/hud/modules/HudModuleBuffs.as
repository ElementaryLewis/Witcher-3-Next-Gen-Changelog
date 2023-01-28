package red.game.witcher3.hud.modules
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import red.core.events.GameEvent;
   import red.game.witcher3.controls.W3ScrollingList;
   import red.game.witcher3.hud.modules.buffs.HudBuff;
   import scaleform.clik.data.DataProvider;
   import scaleform.clik.interfaces.IListItemRenderer;
   
   public class HudModuleBuffs extends HudModuleBase
   {
      
      protected static const MINIM_CELL_HEIGHT:int = 50;
      
      protected static const MINIM_CELL_WIDTH:int = 50;
      
      protected static const MAXIM_CELL_HEIGHT:int = 150;
      
      protected static const MAXIM_CELL_WIDTH:int = 130;
      
      protected static const MINIM_NUM_COLUMNS:int = 6;
      
      protected static const MINIM_NUM_ROWS:int = 4;
      
      protected static const MAXIM_NUM_COLUMNS:int = 4;
      
      protected static const MAXIM_NUM_ROWS:int = 6;
       
      
      public var mcMinimViewAnchor:MovieClip;
      
      public var mcMaximViewAnchor:MovieClip;
      
      private var itemListVector:Vector.<IListItemRenderer>;
      
      public var minimViewMode:Boolean;
      
      public var mcBuffsList:W3ScrollingList;
      
      public function HudModuleBuffs()
      {
         addFrameScript(0,this.frame1);
         super();
         this.__setProp_mcBuffsList_Scene1_mcBuffsList_0();
      }
      
      override public function get moduleName() : String
      {
         return "BuffsModule";
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.minimViewMode = true;
         this.mcMinimViewAnchor.visible = false;
         this.mcMaximViewAnchor.visible = false;
         this.itemListVector = new Vector.<IListItemRenderer>();
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnConfigUI"));
         registerDataBinding("hud.buffs",this.handleDataSet);
         this.createBuffGrid(MINIM_NUM_COLUMNS,MINIM_NUM_ROWS,MINIM_CELL_HEIGHT,MINIM_CELL_WIDTH,this.mcMinimViewAnchor);
      }
      
      public function setViewMode(param1:Boolean) : void
      {
         this.minimViewMode = param1;
         this.updateViewMode();
      }
      
      public function updateViewMode() : *
      {
         var _loc2_:HudBuff = null;
         var _loc3_:int = 0;
         var _loc1_:int = int(this.mcBuffsList.dataProvider.length);
         if(_loc1_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ <= _loc1_)
            {
               _loc2_ = this.mcBuffsList.getRendererAt(_loc3_) as HudBuff;
               if(_loc2_)
               {
                  _loc2_.setMinimalView(this.minimViewMode);
               }
               _loc3_++;
            }
         }
         if(this.minimViewMode)
         {
            this.repositionGrid(MINIM_NUM_COLUMNS,MINIM_NUM_ROWS,MINIM_CELL_HEIGHT,MINIM_CELL_WIDTH,this.minimViewMode);
         }
         else
         {
            this.repositionGrid(MAXIM_NUM_COLUMNS,MAXIM_NUM_ROWS,MAXIM_CELL_HEIGHT,MAXIM_CELL_WIDTH,this.minimViewMode);
         }
      }
      
      public function createBuffGrid(param1:Number, param2:Number, param3:Number, param4:Number, param5:MovieClip) : void
      {
         var _loc10_:HudBuff = null;
         var _loc12_:Class = null;
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:uint = 1;
         var _loc9_:int = 16;
         while(this.itemListVector.length)
         {
            removeChild(this.itemListVector.pop());
         }
         var _loc11_:int = 0;
         while(_loc11_ < _loc9_)
         {
            (_loc10_ = new (_loc12_ = getDefinitionByName("BuffItemRendererRef") as Class)() as HudBuff).x = param5.x + _loc6_ * param4;
            _loc10_.y = param5.y + _loc7_ * param3;
            addChild(_loc10_);
            this.itemListVector.push(_loc10_);
            if(_loc6_ >= param1)
            {
               _loc6_ = 0;
               _loc7_++;
            }
            else
            {
               _loc6_++;
            }
            _loc11_++;
         }
         this.mcBuffsList.itemRendererList = this.itemListVector;
      }
      
      public function repositionGrid(param1:Number, param2:Number, param3:Number, param4:Number, param5:Boolean) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc9_:HudBuff = null;
         var _loc8_:uint = 0;
         var _loc10_:MovieClip = param5 ? this.mcMinimViewAnchor : this.mcMaximViewAnchor;
         _loc7_ = 0;
         while(_loc7_ < param2)
         {
            _loc6_ = 0;
            while(_loc6_ < param1)
            {
               if(_loc9_ = this.mcBuffsList.getRendererAt(_loc8_) as HudBuff)
               {
                  _loc9_.x = _loc10_.x + _loc6_ * param4;
                  _loc9_.y = _loc10_.y + _loc7_ * param3;
                  _loc8_++;
               }
               _loc6_++;
            }
            _loc7_++;
         }
      }
      
      public function setPercent(param1:int, param2:Number, param3:Number, param4:int) : void
      {
         var _loc5_:HudBuff = null;
         (_loc5_ = HudBuff(this.mcBuffsList.getRendererAt(param1))).updatePercent(param3 > 0 ? param2 / param3 : 0);
         if(_loc5_.getFormat() == 1 || _loc5_.getFormat() == 2)
         {
            _loc5_.updateCounter(param2,param3);
         }
         else if(_loc5_.getFormat() == 3)
         {
            _loc5_.updateTimer(int(param2),int(param3));
         }
         else if(_loc5_.getFormat() == 4)
         {
            _loc5_.updateTimerAndCounter(int(param2),int(param3),param4);
         }
         else
         {
            _loc5_.updateEmpty();
         }
      }
      
      public function showBuffUpdateFx() : void
      {
         var _loc4_:HudBuff = null;
         var _loc5_:Object = null;
         var _loc1_:Vector.<IListItemRenderer> = this.mcBuffsList.getRenderers();
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc4_ = _loc1_[_loc3_] as HudBuff)
            {
               if((Boolean(_loc5_ = _loc4_.data)) && Boolean(_loc5_.IsPotion))
               {
                  _loc4_.mcBuffUpdate.gotoAndPlay("start");
               }
            }
            _loc3_++;
         }
      }
      
      protected function handleDataSet(param1:Object, param2:int) : void
      {
         var _loc3_:Array = param1 as Array;
         if(param2 > 0)
         {
            if(param1)
            {
               this.mcBuffsList.dataProvider = new DataProvider(_loc3_);
               this.mcBuffsList.ShowRenderers(true);
            }
         }
         else if(param1)
         {
            this.mcBuffsList.dataProvider = new DataProvider(_loc3_);
            this.mcBuffsList.ShowRenderers(true);
            this.updateViewMode();
            this.mcBuffsList.validateNow();
         }
      }
      
      override public function ShowElementFromState(param1:Boolean, param2:Boolean = false) : void
      {
         super.ShowElementFromState(param1,param2);
         dispatchEvent(new GameEvent(GameEvent.CALL,"OnBuffsDisplay",[param1]));
      }
      
      internal function __setProp_mcBuffsList_Scene1_mcBuffsList_0() : *
      {
         try
         {
            this.mcBuffsList["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.mcBuffsList.DownAction = 40;
         this.mcBuffsList.enabled = true;
         this.mcBuffsList.enableInitCallback = false;
         this.mcBuffsList.focusable = false;
         this.mcBuffsList.itemRendererName = "";
         this.mcBuffsList.itemRendererInstanceName = "";
         this.mcBuffsList.margin = 0;
         this.mcBuffsList.inspectablePadding = {
            "top":0,
            "right":0,
            "bottom":0,
            "left":0
         };
         this.mcBuffsList.rowHeight = 0;
         this.mcBuffsList.scrollBar = "";
         this.mcBuffsList.UpAction = 38;
         this.mcBuffsList.visible = true;
         this.mcBuffsList.wrapping = "normal";
         try
         {
            this.mcBuffsList["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
