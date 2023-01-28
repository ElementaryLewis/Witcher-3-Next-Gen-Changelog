package red.game.witcher3.hud.modules.minimap2
{
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweener;
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import red.game.witcher3.hud.modules.HudModuleMinimap2;
   
   public class MapPin
   {
      
      private static const ARROW_REGULAR_USER = 1;
      
      private static const ARROW_REGULAR_QUEST = 2;
      
      private static const ARROW_HIGHLIGHTED_QUEST = 3;
       
      
      public var pinClip:MovieClip;
      
      public var arrowClip:MovieClip;
      
      public var id:int;
      
      public var tag:String;
      
      public var type:String;
      
      public var posX:Number;
      
      public var posY:Number;
      
      public var posZ:Number;
      
      public var radius:Number;
      
      public var highlighted:Boolean;
      
      public var canBePointedByArrow:Boolean;
      
      public var canHeightArrowsBeShown:Boolean;
      
      public var priority:int;
      
      public var isQuestPin:Boolean;
      
      public var isUserPin:Boolean;
      
      private var isUpArrowVisible:Boolean = false;
      
      private var isDownArrowVisible:Boolean = false;
      
      private var isNormalQuestIconVisible:Boolean = false;
      
      public function MapPin()
      {
         super();
         this.id = 0;
         this.posX = 0;
         this.posY = 0;
         this.posZ = 0;
         this.radius = 0;
         this.highlighted = false;
         this.canBePointedByArrow = false;
         this.canHeightArrowsBeShown = false;
         this.priority = 0;
         this.isQuestPin = false;
      }
      
      public function OnInitialize(param1:String) : *
      {
         var _loc2_:Class = getDefinitionByName("class" + param1) as Class;
         if(_loc2_)
         {
            this.pinClip.PinIcon = new _loc2_();
            this.pinClip.PinIcon.name = "PinIcon";
            this.pinClip.addChild(this.pinClip.PinIcon);
         }
      }
      
      public function OnDeinitialize() : *
      {
         this.pinClip.removeChild(this.pinClip.PinIcon);
         this.pinClip.PinIcon = null;
      }
      
      public function ShowPin(param1:Boolean) : *
      {
         this.pinClip.visible = param1;
      }
      
      public function ShowPinIcon(param1:Boolean) : *
      {
         this.pinClip.PinIcon.visible = param1;
      }
      
      public function ShowPinRadius(param1:Boolean) : *
      {
         this.pinClip.mcRadius.visible = param1;
      }
      
      public function UpdatePinRadiusColor() : *
      {
         if(this.radius == 0)
         {
            this.pinClip.mcRadius.mcRadiusQuest.visible = false;
            this.pinClip.mcRadius.mcRadiusRegular.visible = false;
            this.pinClip.mcRadius.mcRadiusBelgard.visible = false;
            this.pinClip.mcRadius.mcRadiusCoronata.visible = false;
            this.pinClip.mcRadius.mcRadiusVermentino.visible = false;
         }
         else if(this.isQuestPin)
         {
            if(this.type == "QuestBelgard")
            {
               this.pinClip.mcRadius.mcRadiusQuest.visible = false;
               this.pinClip.mcRadius.mcRadiusRegular.visible = false;
               this.pinClip.mcRadius.mcRadiusBelgard.visible = true;
               this.pinClip.mcRadius.mcRadiusCoronata.visible = false;
               this.pinClip.mcRadius.mcRadiusVermentino.visible = false;
            }
            else if(this.type == "QuestCoronata")
            {
               this.pinClip.mcRadius.mcRadiusQuest.visible = false;
               this.pinClip.mcRadius.mcRadiusRegular.visible = false;
               this.pinClip.mcRadius.mcRadiusBelgard.visible = false;
               this.pinClip.mcRadius.mcRadiusCoronata.visible = true;
               this.pinClip.mcRadius.mcRadiusVermentino.visible = false;
            }
            else if(this.type == "QuestVermentino")
            {
               this.pinClip.mcRadius.mcRadiusQuest.visible = false;
               this.pinClip.mcRadius.mcRadiusRegular.visible = false;
               this.pinClip.mcRadius.mcRadiusBelgard.visible = false;
               this.pinClip.mcRadius.mcRadiusCoronata.visible = false;
               this.pinClip.mcRadius.mcRadiusVermentino.visible = true;
            }
            else
            {
               this.pinClip.mcRadius.mcRadiusQuest.visible = true;
               this.pinClip.mcRadius.mcRadiusRegular.visible = false;
               this.pinClip.mcRadius.mcRadiusBelgard.visible = false;
               this.pinClip.mcRadius.mcRadiusCoronata.visible = false;
               this.pinClip.mcRadius.mcRadiusVermentino.visible = false;
            }
         }
         else
         {
            this.pinClip.mcRadius.mcRadiusQuest.visible = false;
            this.pinClip.mcRadius.mcRadiusRegular.visible = true;
            this.pinClip.mcRadius.mcRadiusBelgard.visible = false;
            this.pinClip.mcRadius.mcRadiusCoronata.visible = false;
            this.pinClip.mcRadius.mcRadiusVermentino.visible = false;
         }
      }
      
      public function ShowArrow(param1:Boolean) : *
      {
         if(this.arrowClip)
         {
            this.arrowClip.visible = param1;
         }
      }
      
      public function ShowNewFeedback(param1:Boolean) : *
      {
         var _loc2_:GTween = null;
         if(this.pinClip.mcNewFeedback)
         {
            this.pinClip.mcNewFeedback.visible = param1;
            if(param1)
            {
               this.pinClip.mcNewFeedback.mcCircle.alpha = 1;
               this.pinClip.mcNewFeedback.mcCircle.scaleX = 0.31;
               this.pinClip.mcNewFeedback.mcCircle.scaleY = 0.31;
               GTweener.removeTweens(this);
               _loc2_ = GTweener.to(this.pinClip.mcNewFeedback.mcCircle,0.33,{"alpha":0});
               _loc2_.paused = true;
               GTweener.to(this.pinClip.mcNewFeedback.mcCircle,0.33,{
                  "scaleX":1,
                  "scaleY":1
               },{"nextTween":_loc2_});
            }
         }
      }
      
      public function SetPinRotation(param1:Number) : *
      {
         this.pinClip.rotation = param1;
      }
      
      public function SetArrowRotation(param1:Number) : *
      {
         this.arrowClip.rotation = param1;
      }
      
      public function AddArrowRotation(param1:Number) : *
      {
         this.arrowClip.rotation += param1;
      }
      
      public function SetIconScale(param1:*) : *
      {
         if(this.pinClip.PinIcon)
         {
            this.pinClip.PinIcon.scaleX = param1;
            this.pinClip.PinIcon.scaleY = param1;
         }
         if(this.pinClip.PinGlow)
         {
            this.pinClip.PinGlow.scaleX = param1;
            this.pinClip.PinGlow.scaleY = param1;
         }
         if(this.pinClip.mcArrows)
         {
            this.pinClip.mcArrows.scaleX = param1;
            this.pinClip.mcArrows.scaleY = param1;
         }
         if(this.pinClip.mcNewFeedback)
         {
            this.pinClip.mcNewFeedback.scaleX = param1;
            this.pinClip.mcNewFeedback.scaleY = param1;
         }
      }
      
      public function SetRadiusScale(param1:Number, param2:Number) : *
      {
         if(param1 > 0)
         {
            this.pinClip.mcRadius.scaleX = param1 / 5 * param2;
            this.pinClip.mcRadius.scaleY = param1 / 5 * param2;
         }
         else
         {
            this.pinClip.mcRadius.scaleX = 0.1;
            this.pinClip.mcRadius.scaleY = 0.1;
         }
      }
      
      public function UpdateMapPinPosition(param1:Number, param2:Number) : *
      {
         this.pinClip.x = param1;
         this.pinClip.y = param2;
      }
      
      public function UpdateMapPinArrowRotation(param1:Number) : *
      {
         if(this.CanArrowBeShown())
         {
            this.AddArrowRotation(param1);
         }
      }
      
      public function UpdateMapPinAppearance(param1:Number, param2:Boolean = true) : *
      {
         var _loc3_:Number = NaN;
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         if(this.CanArrowBeShown())
         {
            _loc3_ = (HudModuleMinimap2.m_playerWorldPosX - this.posX) * (HudModuleMinimap2.m_playerWorldPosX - this.posX) + (HudModuleMinimap2.m_playerWorldPosY - this.posY) * (HudModuleMinimap2.m_playerWorldPosY - this.posY);
            if(_loc3_ > param1)
            {
               _loc4_ = HudModuleMinimap2.WorldToMapX(HudModuleMinimap2.m_playerWorldPosX);
               _loc5_ = HudModuleMinimap2.WorldToMapY(HudModuleMinimap2.m_playerWorldPosY);
               _loc6_ = HudModuleMinimap2.WorldToMapX(this.posX);
               _loc7_ = HudModuleMinimap2.WorldToMapY(this.posY);
               this.ShowArrow(true);
               this.SetArrowRotation(HudModuleMinimap2.GetCameraAngle() + Math.atan2(_loc7_ - _loc5_,_loc6_ - _loc4_) * 180 / Math.PI);
            }
            else
            {
               this.ShowArrow(false);
            }
         }
         if(param2)
         {
            this.UpdateHeightArrows();
         }
      }
      
      public function UpdateHeightArrowsForQuestPins() : *
      {
         if(this.isQuestPin)
         {
            this.pinClip.mcArrows.mcUp.mcStatic.visible = false;
            this.pinClip.mcArrows.mcUp.mcDynamic.visible = true;
            this.pinClip.mcArrows.mcDown.mcStatic.visible = false;
            this.pinClip.mcArrows.mcDown.mcDynamic.visible = true;
         }
         else
         {
            this.pinClip.mcArrows.mcUp.mcStatic.visible = true;
            this.pinClip.mcArrows.mcUp.mcDynamic.visible = false;
            this.pinClip.mcArrows.mcDown.mcStatic.visible = true;
            this.pinClip.mcArrows.mcDown.mcDynamic.visible = false;
         }
      }
      
      public function UpdateHeightArrows() : *
      {
         var _loc1_:Number = HudModuleMinimap2.m_playerWorldPosZ;
         var _loc2_:Number = HudModuleMinimap2.HEIGHT_THRESHOLD;
         if(this.CanHeightArrowsBeShown())
         {
            if(_loc1_ > this.posZ + _loc2_)
            {
               this.ShowHeightArrows(false,true,true,false);
            }
            else if(_loc1_ < this.posZ - _loc2_)
            {
               this.ShowHeightArrows(true,false,true,false);
            }
            else
            {
               this.ShowHeightArrows(false,false,true,true);
            }
         }
         else
         {
            this.ShowHeightArrows(false,false,false,false);
         }
      }
      
      public function ForceShowHeightArrows(param1:*, param2:*, param3:Boolean) : *
      {
         this.isUpArrowVisible = param1;
         this.pinClip.mcArrows.mcUp.visible = param1;
         this.isDownArrowVisible = param2;
         this.pinClip.mcArrows.mcDown.visible = param2;
         this.isNormalQuestIconVisible = param3;
         if(this.pinClip.PinIcon.mcQuestNormal)
         {
            this.pinClip.PinIcon.mcQuestNormal.visible = param3;
         }
      }
      
      private function ShowHeightArrows(param1:*, param2:*, param3:*, param4:Boolean) : *
      {
         if(this.isUpArrowVisible != param1)
         {
            this.isUpArrowVisible = param1;
            this.pinClip.mcArrows.mcUp.visible = param1;
         }
         if(this.isDownArrowVisible != param2)
         {
            this.isDownArrowVisible = param2;
            this.pinClip.mcArrows.mcDown.visible = param2;
         }
         if(param3 && this.isQuestPin)
         {
            if(this.isNormalQuestIconVisible != param4)
            {
               this.isNormalQuestIconVisible = param4;
               this.pinClip.PinIcon.mcQuestNormal.visible = param4;
            }
         }
      }
      
      public function UpdateHighlighting() : *
      {
         if(this.radius == 0)
         {
            this.pinClip.PinGlow.visible = this.highlighted;
         }
         else
         {
            this.pinClip.PinGlow.visible = false;
         }
         if(this.highlighted)
         {
            if(this.arrowClip)
            {
               this.arrowClip.mcUser.visible = false;
               this.arrowClip.mcRegularQuest.visible = false;
               this.arrowClip.mcHighlightedQuest.visible = true;
            }
         }
         else if(this.arrowClip)
         {
            if(this.isQuestPin)
            {
               this.arrowClip.mcUser.visible = false;
               this.arrowClip.mcRegularQuest.visible = true;
               this.arrowClip.mcHighlightedQuest.visible = false;
            }
            else
            {
               this.arrowClip.mcUser.visible = true;
               this.arrowClip.mcUser.gotoAndStop(this.type);
               this.arrowClip.mcRegularQuest.visible = false;
               this.arrowClip.mcHighlightedQuest.visible = false;
            }
         }
      }
      
      public function CanHeightArrowsBeShown() : Boolean
      {
         return this.canHeightArrowsBeShown;
      }
      
      public function CanArrowBeShown() : Boolean
      {
         return this.canBePointedByArrow || this.highlighted;
      }
   }
}
