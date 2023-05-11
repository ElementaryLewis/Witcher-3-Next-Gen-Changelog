/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




exec function acticon( contentToActivate : name )
{
	theGame.DebugActivateContent( contentToActivate );
}

import class CGame extends CObject
{
	import final function DebugActivateContent( contentToActivate : name );

	
	import final function IsFinalBuild() : bool;
	
	
	import final function IsActive() : bool;	

	
	import final function IsPaused() : bool;
	
	
	import final function IsPausedForReason( reason : string ) : bool;

	
	import final function IsStopped() : bool;	
	
	
	import final function IsLoadingScreenVideoPlaying() : bool;	
	
	
	import final function Pause( reason : string );

	
	import final function Unpause( reason : string );
	
	
	import final function PauseCutscenes();
	
	
	import final function UnpauseCutscenes();
	
	
	import final function ExitGame();
	
	
	import final function IsActivelyPaused() : bool;
	
	
	import final function SetActivePause( flag : bool );

	
	import final function GetEngineTime() : EngineTime;
	
	
	import final function GetEngineTimeAsSeconds() : Float;
	
	
	import final function GetTimeScale( optional forCamera : Bool ) : float;
	
	
	import final function SetTimeScale( timeScale : float, sourceName : name, priority : Int32, optional affectCamera : Bool, optional dontSave : Bool );
	
	
	import final function RemoveTimeScale( sourceName : name );

	
	import final function RemoveAllTimeScales();

	
	import final function SetOrRemoveTimeScale( timeScale : float, sourceName : name, priority : Int32, optional affectCamera : Bool );

	
    import final function LogTimeScales();

	
	import final function GetLocalTimeAsMilliseconds() : int;	
	
	
	import final function GetGameTime() : GameTime;
	
	
	import final function SetGameTime( time : GameTime, callEvents : bool );

	
	import final function SetHoursPerMinute( f : float );
	
	
	import final function GetHoursPerMinute() : float;
	
	
	import final function GetDifficultyLevel() : int;	
	
	
	import final function SetDifficultyLevel( amount : int );
	
	
	event OnDifficultyChanged(newDifficulty : int);
	
	
	
	
	import final function IsVibrationEnabled() : bool;
	
	import final function SetVibrationEnabled( enabled : bool );
	
	import final function VibrateController( lowFreq, highFreq, duration : float );
	import final function StopVibrateController();
	import final function GetCurrentVibrationFreq( out lowFreq : float, out highFreq : float );
	import final function RemoveSpecificRumble( lowFreq : float, highFreq : float );
	import final function IsSpecificRumbleActive( lowFreq : float, highFreq : float ) : bool;
	
	import final function OverrideRumbleDuration( lowFreq : float, highFreq : float, newDuration : float );
	

	
	import final function IsPadConnected() : bool;

	
	
	
	
	
	
	
	
	import final function CreateEntity( entityTemplate : CEntityTemplate, pos : Vector, optional rot : EulerAngles,
										optional useAppearancesFromIncludes : bool , optional forceBehaviorPose : bool , 
										optional doNotAdjustPlacement : bool , optional persistanceMode : EPersistanceMode , optional tagList : array< name > ) : CEntity;
	
	
	import final function GetNodeByTag( tag : name ) : CNode;
	
	
	import final function GetEntityByTag( tag : name ) : CEntity;
	
	
	import final function GetEntitiesByTag( tag : name, out entities : array<CEntity> );
	
	
	import final function GetNodesByTag( tag : name, out nodes : array<CNode> );

	
	import final function GetNodesByTags( tagsList : array<name>, out nodes : array<CNode>, optional matchAll : bool );

	
	
	
	
	
	
	
	import final function GetWorld() : CWorld;
	
	
	import final function IsFreeCameraEnabled() : bool;
	
	
	import final function EnableFreeCamera( flag : bool );
	
	
	import final function GetFreeCameraPosition() : Vector;

	
	import function MoveFreeCamera(position : Vector, rotation : EulerAngles);
	
	
	import final function IsShowFlagEnabled( showFlag : EShowFlags ) : bool;
	
	
	import final function SetShowFlag( showFlag : EShowFlags, enabled : bool );
	
	
	import final function PlayCutsceneAsync( csName : string, actorNames : array<string>, actorEntities : array<CEntity>, csPos : Vector, csRot : EulerAngles, optional cameraNum : int ) : bool;

	
	import final function IsCurrentlyPlayingNonGameplayScene() : bool;
		
	
	import final function IsStreaming() : bool;
	
	
	
	
	import final latent function PlayCutscene( csName : string, actorNames : array<string>, actorEntities : array<CEntity>, csPos : Vector, csRot : EulerAngles, optional cameraNum : int ) : bool;
		
	
	import final latent function FadeOut( optional fadeTime : float , optional fadeColor : Color  );
	
	
	import final latent function FadeIn( optional fadeTime : float  );
	
	
	import final function FadeOutAsync( optional fadeTime : float , optional fadeColor : Color  );
	
	
	import final function FadeInAsync( optional fadeTime : float  );
	
	
	import final function IsFading() : bool;
	
	
	import final function IsBlackscreen() : bool;
	
	
	import final function HasBlackscreenRequested() : bool;
	
	import final function SetFadeLock( lockName : string );
	import final function ResetFadeLock( lockName : string );
	
	
	
	import final function UnlockAchievement( achName : name ) : bool;
	
	import final function LockAchievement( achName : name ) : bool;

	import final function NoticeAchievementProgress( achName : name, countNew : int, optional towards : int ) : bool;	
	
	import final function GetUnlockedAchievements( out unlockedAchievments : array< name > );
	
	import final function GetAllAchievements( out unlockedAchievments : array< name > );
	
	import final function IsAchievementUnlocked( achievement : name ) : bool;
	
	
	
	import final function ToggleUserProfileManagerInputProcessing( enabled : bool );
	
	
	
	
	import final function IsCheatEnabled( cheatFeature : ECheats ) : bool;
	
	import final function ReloadGameplayConfig();
	
	import final function GetGameplayChoice() : bool;
	
	import final function GetGameplayConfigFloatValue( propName : name ) : float;
	
	import final function GetGameplayConfigBoolValue( propName : name ) : bool;
	
	import final function GetGameplayConfigIntValue( propName : name ) : int;
	
	import final function GetGameplayConfigEnumValue( propName : name ) : int;
	
	
	import final function SetAIObjectsLooseTime( time : float );
	
	import final function AddInitialFact( factName : string );
	
	import final function RemoveInitialFact( faceName : string );
	
	import final function ClearInitialFacts();
	
	
	import final function GetCurrentViewportResolution( out width : int, out height : int ) : void;

	
	
	import final function SetSingleShotLoadingScreen( contextName : name, optional initString : string, optional videoToPlay : string );
	
	import final function ToggleRTEnabled() : void;
	
	import final function IsIntelGPU() : bool;
	import final function GetRTEnabled() : bool;
	import final function GetRTSupported() : bool;
	import final function GetHairWorksEnabled() : bool;
	import final function GetDLSSEnabled() : bool;
	import final function GetFSREnabled() : bool;
	import final function GetTAAEnabled() : bool;
	import final function GetXESSEnabled() : bool;
	import final function GetRTAOEnabled() : bool;
	import final function GetRTREnabled() : bool;
	import final function GetDLSSGEnabled() : bool;
	import final function GetDLSSGSupported() : bool;
	import final function GetReflexEnabled() : bool;
	import final function GetReflexSupported() : bool;
	import final function GetMotionBlurEnabled() : bool;
	
	import final function GetGameResource() : CGameResource;

	import final function GetPhotomodeEnabled() : bool;
	import final function SetPhotomodeEnabled( photomodeEnabled: bool ) : void;
	
	public function GetToggleButtonCaption() : string
	{
		if (theGame.GetRTEnabled()) {
			return GetLocStringByKeyExt("panel_video_performance_mode");
		} else {
			return GetLocStringByKeyExt("panel_video_quality_mode");
		}
	}

	
	
	import final function IsHdrSupported() : bool;
	import final function IsRayTracingSupported() : bool;
};


import function RadialBlurSetup( blurSourcePos : Vector, blurAmount, sineWaveAmount, sineWaveSpeed, sineWaveFreq : float );


import function RadialBlurDisable();


import function FullscreenBlurSetup( intensity : float );


import class CCreateEntityHelper
{
	import function SetPostAttachedCallback( caller : IScriptable, funcName : name );
	import function IsCreating() : bool;
	import function Reset();
	import function GetCreatedEntity() : CEntity;
}

import class CR4CreateEntityHelper extends CCreateEntityHelper
{
}
