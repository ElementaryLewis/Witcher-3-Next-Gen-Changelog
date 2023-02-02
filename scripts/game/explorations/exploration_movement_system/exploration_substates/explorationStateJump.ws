/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/





enum EJumpSubState
{
	JSS_TakingOff		,
	JSS_Flight			,
	JSS_Inertial		,
	JSS_PredictingLand	,
}

enum EJumpType
{
	EJT_Fall			= 0,
	EJT_Idle			= 1,
	EJT_IdleToWalk		= 2,
	EJT_Walk			= 3,
	EJT_WalkHigh		= 4,
	EJT_Run				= 5,
	EJT_Sprint			= 6,
	EJT_Slide			= 7,
	EJT_Hit				= 8,
	EJT_Vault			= 9,
	EJT_ToWater			= 10,
	EJT_Skate			= 11,
	EJT_KnockBack		= 12,
	EJT_KnockBackFall	= 13,
}

enum ELandPredictionType
{
	ELPT_FlatLand		= 0,
	ELPT_SlopedLand		= 1,
	ELPT_Water			= 2,
}



struct SJumpParams
{
	
	editable			var m_BehaviorEventN				: name;	
	editable			var	m_PredictionTimeF				: float;					default m_PredictionTimeF				= 0.5f;
	
	
	editable inlined	var m_VerticalMovementS				: SVerticalMovementParams;
	editable			var	m_HorImpulseAtStartB			: bool;						default	m_HorImpulseAtStartB			= false;
	editable			var	m_HorImpulseF					: float;					default	m_HorImpulseF					= 0.0f;
	editable inlined	var m_HorMovementS					: SPlaneMovementParameters;			
	editable			var	m_TakeOffTimeF					: float;					default	m_TakeOffTimeF					= 0.2f;
	editable			var	m_StartOrientTimeF				: float;					default	m_StartOrientTimeF				= 0.15f;
	editable			var m_UsePhysicJumpB				: bool;						default	m_UsePhysicJumpB				= false;
	editable			var	m_ConserveCoefsB				: bool;						default	m_ConserveCoefsB				= false;
	
	
	editable			var m_ExternalDirectionForcedB		: bool;						default	m_ExternalDirectionForcedB		= false;
	editable			var m_AllowAirDisplacementControlB	: bool;						default	m_AllowAirDisplacementControlB	= true;
	editable			var m_StartDirectionAllowanceF		: float;					default	m_StartDirectionAllowanceF		= 180.0f; hint m_StartDirectionAllowanceF	= "from 0 to 180";
	editable			var m_StartDirectionIgnoreF			: float;					default	m_StartDirectionIgnoreF			= 180.0f; hint m_StartDirectionIgnoreF		= "from 0 to 180";
	editable			var	m_OrientationSpeedF				: float;					default m_OrientationSpeedF				= 0.5f;
	
	
	editable			var m_ConserveAddB					: bool;						default	m_ConserveAddB					= false;
	editable			var m_RecalcSpeedOnInertialB		: bool;						default	m_RecalcSpeedOnInertialB		= false;
	
	
	editable			var	m_TimeToCheckCollisionsF		: float;					default	m_TimeToCheckCollisionsF		= 0.5f;
	editable			var	m_TimeToPrepareForLandF			: float;					default	m_TimeToPrepareForLandF			= 0.3f;
	
	
						var	m_JumpTypeE						: EJumpType;
	editable			var	m_DontRecalcFootOnLand			: bool;						default	m_DontRecalcFootOnLand			= false;
	editable			var	m_FlipFeetOnLandB				: bool;						default	m_FlipFeetOnLandB				= false;
}



class CExplorationStateJump extends CExplorationStateAbstract
{
	private editable			var	jumpEnabled					: bool;				default	jumpEnabled						= true;
	
	protected					var	m_SubstateE					: EJumpSubState;
	protected					var	m_OrientationInitialF		: float;
	protected					var	m_MaxHeightReachedF			: float;
	
	protected editable			var	m_SlopeAngleMaxToJump		: float;			default	m_SlopeAngleMaxToJump			= 70.0f;
	
	
	
	protected editable			var	m_UseGenericJumpB			: bool;				default	m_UseGenericJumpB				= false;
	protected editable			var	m_AllowSprintJumpB			: bool;				default	m_AllowSprintJumpB				= true;
	protected 					var	m_JumpParmsS				: SJumpParams;
	protected editable inlined	var	m_JumpParmsGenericS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsIdleS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsIdleToWalkS		: SJumpParams;
	protected editable inlined	var	m_JumpParmsWalkS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsWalkHighS		: SJumpParams;
	protected editable inlined	var	m_JumpParmsRunS				: SJumpParams;
	protected editable inlined	var	m_JumpParmsSprintS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsFallS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsHitS				: SJumpParams;
	protected editable inlined	var	m_JumpParmsSlideS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsVaultS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsToWaterS			: SJumpParams;
	protected editable inlined	var	m_JumpParmsKnockBackS		: SJumpParams;
	protected editable inlined	var	m_JumpParmsKnockBackFallS	: SJumpParams;
	protected editable inlined	var	m_JumpParmsSkateIdleS		: SJumpParams;
	
	
	protected editable			var	m_SprintJumpNeedsStaminaB	: bool;				default	m_SprintJumpNeedsStaminaB		= false;
	protected editable			var	m_SprintJumpTimeExtraF		: float;			default	m_SprintJumpTimeExtraF			= 0.2f;
	protected editable 			var	m_SprintJumpTimeGapF		: float;			default	m_SprintJumpTimeGapF			= 0.3f;

	
	protected editable			var m_ConserveHorizontalCoefF	: float;			default	m_ConserveHorizontalCoefF		= 0.75f;
	protected editable			var m_ConserveVertUpCoefF		: float;			default	m_ConserveVertUpCoefF			= 1.0f;
	protected editable			var m_ConserveVertDownCoefF		: float;			default	m_ConserveVertDownCoefF			= 0.5f;
	protected editable			var m_ConserveHorizontalMaxF	: float;			default	m_ConserveHorizontalMaxF		= 30.0f;
	protected editable			var m_ConserveVertUpMaxF		: float;			default	m_ConserveVertUpMaxF			= 10.0f;
	protected editable			var m_ConserveVertDownMaxF		: float;			default	m_ConserveVertDownMaxF			= 5.0f;
	protected editable			var m_SpeedSqrMinToConserveF	: float;			default	m_SpeedSqrMinToConserveF		= 0.1f;
	
	
	protected editable			var	m_ReactToHitCeilingB		: bool;				default	m_ReactToHitCeilingB			= true;
	protected					var	m_HitCeilingB				: bool;
	
	
	protected editable			var	m_BehEventPredictLandN		: name;				default	m_BehEventPredictLandN			= 'Jump_Predict_Land';
	protected editable			var	m_BehListenInertialJumpN	: name;				default	m_BehListenInertialJumpN		= 'Jump_Inertial';
	protected editable			var	m_BehListenFinishTakeOffN	: name;				default	m_BehListenFinishTakeOffN		= 'Jump_TakenOff';
	
	protected editable			var	m_BehParamJumpTypeN			: name;				default	m_BehParamJumpTypeN				= 'JumpType';
	protected editable			var	m_BehEventPredictingS		: name;				default	m_BehEventPredictingS			= 'jumpPredicting';
	protected editable			var m_BehEventPredictTypeS		: name;				default	m_BehEventPredictTypeS			= 'jumpPredictionType';
	protected editable			var	m_BehParamIsHandledByAnimS	: name;				default	m_BehParamIsHandledByAnimS		= 'JumpIsAllAnimation';
	protected editable			var	m_BehParamWalkOrSprintS		: name;				default	m_BehParamWalkOrSprintS			= 'JumpIsSprinting';
	protected editable			var	m_BehParamNormalLandS		: name;				default	m_BehParamNormalLandS			= 'JumpNormalLandMode';
	protected editable			var	m_BehEventCeilingHit		: name;				default	m_BehEventCeilingHit			= 'Jump_Hit_Ceiling';
	
	
	protected editable 			var	m_InteractAlwaysB			: bool;				default	m_InteractAlwaysB				= true;
	protected editable 			var	m_InteractTimeMinFallF		: float;			default	m_InteractTimeMinFallF			= 0.05f;
	protected editable 			var	m_InteractTimeMinF			: float;			default	m_InteractTimeMinF				= 0.2f;
	protected editable 			var	m_InteractTimeMinVaultF		: float;			default	m_InteractTimeMinVaultF			= 0.2f;
	protected editable 			var	m_InteractHeightFallMaxF	: float;			default	m_InteractHeightFallMaxF		= 6.0f;
	protected editable			var	m_InteractTimeAdjustingF	: float;			default	m_InteractTimeAdjustingF		= 0.0f; 
	protected editable			var m_InteractDistanceExtraF	: float;			default m_InteractDistanceExtraF		= 0.9f; 
	protected editable			var m_InteractSpeedDiffAllowedF	: float;			default m_InteractSpeedDiffAllowedF		= 0.5f;
	protected editable 			var	m_InteractOwnerOffsetV		: Vector;
	protected editable 			var	m_LockingJumpOnInteractionAreaB : bool;			default	m_LockingJumpOnInteractionAreaB	= false;
	protected editable 			var	m_LockingJumpOnHorseAreaB 	: bool;				default	m_LockingJumpOnHorseAreaB		= true;
	protected editable 			var	m_AllowJumpInSlopesB		: bool;				default	m_AllowJumpInSlopesB			= false;
	
	
	protected editable 			var	m_FallDistToUseHelpF		: float;			default m_FallDistToUseHelpF			= 2.0f;
	protected editable 			var	m_FallRecoverMaxHeightUpF	: float;			default m_FallRecoverMaxHeightUpF		= 0.7f;
	protected editable 			var	m_FallRecoverMaxHeightDownF	: float;			default m_FallRecoverMaxHeightDownF		= 1.7f;
	protected editable 			var	m_FallRecoverMaxDistF		: float;			default m_FallRecoverMaxDistF			= 2.0f;
	
	
	private						var	m_CanSetVelocityB			: bool;
	
	
	private	 editable			var m_ForceIdleJumpOnColliisonB	: bool;				default	m_ForceIdleJumpOnColliisonB		= true;
	private	 editable			var m_ForceIdleJumpHeightFreeF	: float;			default	m_ForceIdleJumpHeightFreeF		= 1.3f;
	private	 editable			var m_ForceIdleJumpDistFreeF	: float;			default	m_ForceIdleJumpDistFreeF		= 0.2f;
	
	
	private						var	m_InteractionLastLockingF	: float;
	
	
	
	protected editable 			var	m_LandPredictedB			: bool;
	protected editable 			var	m_LandGroundPredictB		: bool;				default	m_LandGroundPredictB			= false;
	protected editable 			var	m_LandWaterPredictB			: bool;				default	m_LandWaterPredictB				= true;
	protected editable 			var	m_LandPredictTimeMin		: float;			default	m_LandPredictTimeMin			= 0.15f;
	protected editable 			var	m_LandPredictionTimeF		: float;			default	m_LandPredictionTimeF			= 1.5f;
	private 					var m_CollisionGroupsNamesNArr	: array<name>;
	private						var m_LandPredicedTypeE			: ELandPredictionType;
	private						var m_LandPredicedCoefF			: float;
	private editable			var	m_LandPredicedBlendF		: float;			default	m_LandPredicedBlendF			= 2.0f;
	private editable			var	m_SlopedLandZF				: float;			default	m_SlopedLandZF					= 0.5f;
	private						var	m_JumpOriginalPositionV		: Vector;
	
	
	protected editable			var	m_CameraDebugB				: bool;				default	m_CameraDebugB					= false;
	protected					var	m_CameraStartB				: bool;
	protected					var	m_CameraPositionV			: Vector;
	protected					var	m_CameraRotationEA			: EulerAngles;
	protected editable			var	m_CameraTimeToEndF			: float;			default	m_CameraTimeToEndF				= 5.0f;
	
	protected editable			var	cameraRoationName			: name;				default cameraRoationName				= 'LongFall';
	protected editable			var	cameraToFallHeightNeed		: float;			default	cameraToFallHeightNeed			= 2.5f;
	private 					var	cameraFallIsSet				: bool;	
	
	
	private editable			var m_CollideBehGraphSideNameS	: name;				default	m_CollideBehGraphSideNameS		= 'CollidingSide';
	private						var	m_CollidingSideE			: ESideSelected;
	
	
	
	private editable			var m_CooldownTotalF			: float;			default	m_CooldownTotalF				= 0.3f;
	private						var	m_CooldownCurF				: float;
	
	
	
	private 					var	useWalkJump					: bool;				default	useWalkJump						= true;
	private 					var	useIdleWalkJump				: bool;				default	useIdleWalkJump					= true;
	private 					var	useHighJump					: bool;				default	useHighJump						= false;
	private 					var	jumpingOnIdleIsForward		: bool;				default	jumpingOnIdleIsForward			= true;
	private 					var	jumpIdleWhenObstructed		: bool;				default	jumpIdleWhenObstructed			= false;
	
	
	
	protected function InitializeSpecific( _Exploration : CExplorationStateManager )
	{	
		if( !IsNameValid( m_StateNameN ) )
		{
			m_StateNameN	= 'Jump';
		}
		
		SetCanSave( false );
		
		
		
		m_JumpParmsIdleS.m_JumpTypeE			= EJT_Idle;
		m_JumpParmsIdleToWalkS.m_JumpTypeE		= EJT_IdleToWalk;
		m_JumpParmsWalkS.m_JumpTypeE			= EJT_Walk;
		m_JumpParmsWalkHighS.m_JumpTypeE		= EJT_WalkHigh;
		m_JumpParmsRunS.m_JumpTypeE				= EJT_Run;
		m_JumpParmsSprintS.m_JumpTypeE			= EJT_Sprint;
		m_JumpParmsFallS.m_JumpTypeE			= EJT_Fall;
		m_JumpParmsHitS.m_JumpTypeE				= EJT_Hit;
		m_JumpParmsSlideS.m_JumpTypeE			= EJT_Slide;
		m_JumpParmsSkateIdleS.m_JumpTypeE		= EJT_Skate;
		m_JumpParmsVaultS.m_JumpTypeE			= EJT_Vault;
		m_JumpParmsToWaterS.m_JumpTypeE			= EJT_ToWater;
		m_JumpParmsKnockBackS.m_JumpTypeE		= EJT_KnockBack;
		m_JumpParmsKnockBackFallS.m_JumpTypeE	= EJT_KnockBackFall;
		
		
		
		m_JumpParmsRunS.m_TakeOffTimeF		= 0.2f;
		m_JumpParmsSprintS.m_TakeOffTimeF	= 0.2f;
		
		
		
		m_CollidingSideE			= SS_SelectedNone;
		
		
		
		m_StateTypeE				= EST_OnAir;
		m_InputContextE				= EGCI_JumpClimb; 		
		m_UpdatesWhileInactiveB		= true;
		
	}
	
	
	protected function AddActionsToBlock()
	{
		super.AddActionsToBlock();
		AddActionToBlock( EIAB_Signs );
		AddActionToBlock( EIAB_CallHorse );
		AddActionToBlock( EIAB_Crossbow );
		if ( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
		{
			AddActionToBlock( EIAB_RunAndSprint );
		}
	}
	
	
	private function AddDefaultStateChangesSpecific()
	{
	}
	
	
	function StateWantsToEnter() : bool
	{			
		var potentialTarget	: Vector;
		var angle			: float;
		var direction		: Vector;
		
		
		
		if(!theInput.LastUsedPCInput() && thePlayer.GetInputHandler().GetIsAltSignCasting() && theInput.IsActionPressed('CastSign'))
		{
			return false;
		}
		
		
		
		
		
		if( m_CooldownCurF > 0.0f )
		{
			return false;
		}	
		
		
		if(	!m_ExplorationO.m_InputO.IsJumpJustPressed() )
		{
			return false;
		}
		
		
		if( thePlayer.IsInCombatAction() )
		{
			return false;
		}
		
		if( thePlayer.IsInShallowWater() )
		{
			return false;
		}
		
		
		if( m_InteractionLastLockingF > 0.0f )
		{
			if( !m_ExplorationO.m_InputO.IsJumpJustReleased() )
			{
				return false;
			}
		}
		
		
		if( !m_AllowJumpInSlopesB )
		{
			direction	= m_ExplorationO.m_MoverO.GetSlideDir();
			if(  m_ExplorationO.m_InputO.IsModuleConsiderable() )
			{
				if( VecDot( VecNormalize( direction ), m_ExplorationO.m_InputO.GetMovementOnPlaneNormalizedV() ) < -0.2f )
				{
					angle		= m_ExplorationO.m_MoverO.GetRealSlideAngle();
					angle		= m_ExplorationO.m_MoverO.ConvertAngleDegreeToSlidECoef( angle );
					if( angle >= m_ExplorationO.m_MoverO.GetSlidingLimitMinCur() )
					{
						return false;
					}
				}
			}
		}
		
		return true;
	}
	
	
	function StateCanEnter( curStateName : name ) : bool
	{			
		if( curStateName == 'Swim' )
		{
			return false;
		}
		
		if( curStateName == 'StartFalling' || curStateName == 'AirCollision' )
		{
			return true;
		}
		
		if( curStateName == 'Land' && ( m_ExplorationO.m_SharedDataO.m_JumpTypeE == EJT_KnockBack || m_ExplorationO.m_SharedDataO.m_JumpTypeE == EJT_KnockBackFall ) )
		{
			return true;
		}
		
		if( curStateName == 'Vault' )
		{
			return true;
		}	
		
		if( !thePlayer.IsActionAllowed( EIAB_Jump ) || !thePlayer.IsActionAllowed( EIAB_Movement ) )
		{
			
			if(	m_ExplorationO.m_InputO.IsJumpJustPressed() )
			{
				thePlayer.DisplayActionDisallowedHudMessage( EIAB_Jump, false, false, true );
			}
			
			return false;
		}
		
		
		
		return true;
	}
	
	
	protected function StateEnterSpecific( prevStateName : name )	
	{	
		GetProperJumpTypeParameters( prevStateName );
		
		SetSpeedOverrideCheck();
		
		SaveProperJumpParameters();
		
		SetBehaviorParameters();
		
		GetJumpInitialOrientation();
		
		SetInitialOrientation();
		
		AddConservingVelocityToTheParams();
		
		AddActionsToBlock();
		BlockActions();
		
		thePlayer.OnRangedForceHolster( true, true );
		
		thePlayer.SetBehaviorVariable( 'inJumpState', 1.f );
		
		BlockStamina( prevStateName );
		
		
		if( prevStateName != 'StartFalling' )
		{
			m_ExplorationO.m_SharedDataO.ResetHeightFallen();
		}
		
		
		ChangeTo( JSS_TakingOff );
		
		m_CameraStartB											= true;
		m_LandPredictedB										= false;
		m_JumpOriginalPositionV									= m_ExplorationO.m_OwnerE.GetWorldPosition();
		m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF		= 20.0f;
		m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB		= true;
		m_ExplorationO.m_SharedDataO.m_ShouldFlipFootOnLandB	= m_JumpParmsS.m_FlipFeetOnLandB;
		m_ExplorationO.m_SharedDataO.m_DontRecalcFootOnLandB	= m_JumpParmsS.m_DontRecalcFootOnLand;
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_Vault && m_ExplorationO.m_SharedDataO.m_ClimbStateTypeE == ECRT_Running )
		{
			m_ExplorationO.m_SharedDataO.m_DontRecalcFootOnLandB	= true;
		}
		
		m_HitCeilingB											= false;
		cameraFallIsSet											= false;
		
		m_ExplorationO.m_MoverO.SetManualMovement( true );
		
		
		
		thePlayer.AbortSign();		
	}	
	
	
	public function GetIfCameraIsKept() : bool
	{
		return m_JumpParmsS.m_JumpTypeE == EJT_Vault;
	}
	
	
	private function AddAnimEventCallbacks()
	{
		m_ExplorationO.m_OwnerE.AddAnimEventCallback( m_BehListenFinishTakeOffN,	'OnAnimEvent_SubstateManager' );
		m_ExplorationO.m_OwnerE.AddAnimEventCallback( m_BehListenInertialJumpN,		'OnAnimEvent_SubstateManager' );
		m_ExplorationO.m_OwnerE.AddAnimEventCallback( 'AnimEnd',					'OnAnimEvent_SubstateManager' );
	}
	
	
	function GetBehaviorEventName() : name
	{
		if( m_JumpParmsS.m_JumpTypeE == EJT_Fall )
		{
			return 'Fall';
		}
		
		return m_StateNameN;
	}	

	
	function GetBehaviorIsEventForced( fromState : name ) : bool
	{
		return fromState == 'CombatExploration';
	}
	
	
	function NeedsBehaviorConfirmation() : bool
	{
		return m_BehaviorNeedsConfirmB && ( m_JumpParmsS.m_JumpTypeE != EJT_Fall || m_JumpParmsS.m_JumpTypeE != EJT_Vault ); 
	}
	
	
	private function StateEnterConfirmedSpecific()
	{
		
		
	}
	
	
	function StateChangePrecheck( )	: name
	{		
		
		if( CanWeCheckForInteraction() )
		{
			
			if( m_ExplorationO.StateWantsAndCanEnter( 'Climb' ) )
			{
				return 'Climb';
			}
			
			
			
		}
		
		if( ShouldAirCollide() )
		{
			return 'AirCollision';
		}
		
		return super.StateChangePrecheck();
	}
	
	
	protected function StateUpdateSpecific( _Dt : float )
	{
		var l_DispF			: Vector;
		var l_VerticalDispF	: float;
		
		
		l_VerticalDispF	= 0.0f;
		
		switch( m_SubstateE )
		{
			case JSS_TakingOff :
				if ( m_JumpParmsS.m_TakeOffTimeF >= 0.0f && m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_TakeOffTimeF )
				{
					ChangeTo( JSS_Flight );
				}
				
				if( m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_StartOrientTimeF && m_ExplorationO.m_InputO.IsModuleConsiderable() )
				{
					m_ExplorationO.m_MoverO.UpdateOrientToInput( m_JumpParmsS.m_OrientationSpeedF, _Dt );
				}
				if( m_JumpParmsS.m_HorImpulseAtStartB )
				{
					Update2DLogicMovement( _Dt );
				}
				break;
			case JSS_Flight :
				if( CheckLandPrediction() )
				{
					ChangeTo( JSS_PredictingLand );
				}				
				Update2DLogicMovement( _Dt );
				break;
			case JSS_Inertial:	
				if( CheckLandPrediction() )
				{
					ChangeTo( JSS_PredictingLand );
				}
				Update2DLogicMovement( _Dt );
				l_VerticalDispF	= UpdateVerticalMovement( _Dt );
				break;
			case JSS_PredictingLand :
				m_LandPredicedCoefF	=	MinF( m_LandPredicedCoefF + m_LandPredicedBlendF * _Dt, 1.0f );
				m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehEventPredictingS, m_LandPredicedCoefF );	
				Update2DLogicMovement( _Dt );
				l_VerticalDispF	= UpdateVerticalMovement( _Dt );
				break;
		}	

		
		if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
		{
			
			
			m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF	= MaxF( -60.0f, m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF - _Dt * 100.0f );
			m_ExplorationO.m_OwnerE.SetBehaviorVariable( 'Slide_Inclination', m_ExplorationO.m_SharedDataO.m_JumpSwimRotationF );
			thePlayer.OnMeleeForceHolster(true);
		}
		
		
		if( m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB && m_ExplorationO.GetStateTimeF() >= m_JumpParmsS.m_TimeToPrepareForLandF )
		{
			m_ExplorationO.m_SharedDataO.m_JumpIsTooSoonToLandB	= false;
		}
		
		m_ExplorationO.m_SharedDataO.UpdateFallHeight();
		
		
		UpdateCameraChange();
	}
	
	
	
	private var petHoldTimer : float;
	
	
	
	function StateUpdateInactive( _Dt : float )
	{
		if( m_LockingJumpOnInteractionAreaB && thePlayer.IsInsideInteraction() && thePlayer.IsActionAllowed( EIAB_Interactions ) )
		{
			m_InteractionLastLockingF	= m_ExplorationO.m_InputO.GetJumpTimeGap() + _Dt;
		}
		else if( m_LockingJumpOnHorseAreaB && thePlayer.IsMountingHorseAllowed( true ) )
		{
			m_InteractionLastLockingF	= m_ExplorationO.m_InputO.GetJumpTimeGap() + _Dt;
			
			
			if(theInput.IsActionPressed('Jump'))
			{
				petHoldTimer += _Dt;
				if( petHoldTimer > 0.5f )
				{
					thePlayer.TryPetHorse();
					petHoldTimer = 0.f;
				}
			}	
			else
			{
				petHoldTimer = 0.f;
			}
			
		}
		else
		{
			m_InteractionLastLockingF	-=_Dt;
		}
		
		m_CooldownCurF	-= _Dt;
	}
	
	
	private function UpdateCameraChange()
	{
		if( cameraFallIsSet )
		{
			return;
		}
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater && m_ExplorationO.GetStateTimeF() >= 0.2f )
		{
			ChangeCameraToFall();
		}
		
		else if( m_ExplorationO.m_SharedDataO.GetFallingHeight() <= -cameraToFallHeightNeed )
		{
			ChangeCameraToFall();
		}
	}
	
	
	private function StateExitSpecific( nextStateName : name )
	{
		thePlayer.SetBIsCombatActionAllowed( true );
		
		thePlayer.SetBehaviorVariable( 'inJumpState', 0.f );
		
		
		
		if( nextStateName == m_ExplorationO.GetDefaultStateName() )
		{
			m_ExplorationO.SendAnimEvent( 'AnimEndAUX' );
		}
		
		
		if( nextStateName != 'Land' && nextStateName != 'AirCollision' && nextStateName != 'Slide' && nextStateName != 'Idle'  && nextStateName != 'Interaction' && nextStateName != 'Climb'  && nextStateName != 'Swim' ) 
		{
			m_ExplorationO.SendAnimEvent( 'Idle' );
		}
		
		
		if( nextStateName != 'AirCollision' && nextStateName != 'Climb' && nextStateName != 'Land' ) 
		{
			m_ExplorationO.m_OwnerMAC.SetEnabledFeetIK( true, 0.05f );
		}
		
		m_ExplorationO.m_MoverO.SetManualMovement( false );
		
		
		m_CooldownCurF		= m_CooldownTotalF;
		
		m_ExplorationO.m_SharedDataO.SetFallFromCritical( false );
		
		
		LogExploration( GetStateName() + ": Jumped distance: " + VecDistance( m_ExplorationO.m_OwnerE.GetWorldPosition(), m_JumpOriginalPositionV ) + " Height: " + ( m_ExplorationO.m_SharedDataO.GetFallingMaxHeightReached() ) );
	}
	
	
	private function RemoveAnimEventCallbacks()
	{
		m_ExplorationO.m_OwnerE.RemoveAnimEventCallback( m_BehListenFinishTakeOffN );
		m_ExplorationO.m_OwnerE.RemoveAnimEventCallback( m_BehListenInertialJumpN );
		m_ExplorationO.m_OwnerE.RemoveAnimEventCallback( 'AnimEnd' );
	}
	
	
	public function GetDebugText() : string
	{
		var text	: string;
		
		text = "Type: " + m_JumpParmsS.m_JumpTypeE + "   SubState: ";
		
		switch( m_SubstateE )
		{
			case JSS_TakingOff:
				text += " Take Off";
				break;
			case JSS_Flight:
				text += " Flight";
				break;
			case JSS_Inertial:
				text += " Inertial";
				break;
			case JSS_PredictingLand:
				text += " PredictingLand";
				break;
			default :
				text += " Unknown substate";
				break;
		}
		
		return text;
	}
	
	
	private function GetProperJumpTypeParameters( prevStateName : name )
	{		
		var	l_JumpTypeE	: EJumpType;
		
		
		l_JumpTypeE	= GetJumpTypeThatShouldPlay( prevStateName );
		
		
		
		
		SetJumpParametersBasedOnType( l_JumpTypeE );
		
		
		if( m_UseGenericJumpB )
		{
			if( m_JumpParmsS.m_JumpTypeE	== EJT_Idle || m_JumpParmsS.m_JumpTypeE == EJT_Walk ||  m_JumpParmsS.m_JumpTypeE == EJT_WalkHigh || m_JumpParmsS.m_JumpTypeE == EJT_Run || m_JumpParmsS.m_JumpTypeE == EJT_Sprint )
			{
				l_JumpTypeE					= m_JumpParmsS.m_JumpTypeE;
				m_JumpParmsS				= m_JumpParmsGenericS;
				m_JumpParmsS.m_HorImpulseF	= VecLength( m_ExplorationO.m_OwnerMAC.GetVelocity() );
				m_JumpParmsS.m_JumpTypeE	= l_JumpTypeE;
			}
		}
	}
	
	
	private function SetSpeedOverrideCheck()
	{
		if( m_JumpParmsS.m_JumpTypeE == EJT_Fall )
		{		
			m_CanSetVelocityB	= m_ExplorationO.m_SharedDataO.m_CanFallSetVelocityB;
		}
		else if( m_JumpParmsS.m_JumpTypeE == EJT_KnockBackFall )
		{
			m_CanSetVelocityB	= false;
		}
		else
		{
			m_CanSetVelocityB	= true;
		}	
		
		m_ExplorationO.m_SharedDataO.m_CanFallSetVelocityB	= true;
	}
	
	
	private function SaveProperJumpParameters()
	{
		
		
		m_ExplorationO.m_SharedDataO.m_JumpTypeE		= m_JumpParmsS.m_JumpTypeE;
		m_ExplorationO.m_SharedDataO.m_LandingOnWater	= false;
		
		LogExploration( " Jump type: " + m_JumpParmsS.m_JumpTypeE );
		
		
	}
	
	
	private function GetJumpTypeThatShouldPlay( prevStateName : name ) : EJumpType
	{
		var dir, normal : Vector;
		var toWater	: bool;
		
		
		if( m_ExplorationO.m_SharedDataO.GetFallFromCritical() )
		{
			return EJT_KnockBackFall;
		}
		
		
		if( prevStateName == 'Land' && ( m_ExplorationO.m_SharedDataO.m_JumpTypeE == EJT_KnockBack || m_ExplorationO.m_SharedDataO.m_JumpTypeE == EJT_KnockBackFall ) )
		{
			return EJT_KnockBackFall;
		}
		if( ( m_ExplorationO.m_InputO.IsJumpPressed() && m_ExplorationO.m_SharedDataO.hackKnockBackAlways ) ) 
		{
			
			return EJT_KnockBack;
		}
		
		
		if( prevStateName == 'Interaction' )
		{
			return EJT_Fall;
		}
		
		
		if( m_ExplorationO.m_InputO.IsSprintPressed() || m_ExplorationO.m_InputO.IsJumpPressed() ) 
		{
			if( m_ExplorationO.m_CollisionManagerO.GetJumpGoesToWater() )
			{
				toWater	= true;
			}			
			else if( m_ExplorationO.m_SharedDataO.GetJumpToWaterArea() )
			{
				toWater	= true;
				m_ExplorationO.m_SharedDataO.m_JumpDirectionForcedV	= m_ExplorationO.m_SharedDataO.m_JumpToWaterForcedDirV;
			}
			else
			{
				toWater	= false;
			}
			if( toWater )
			{
				thePlayer.OnRangedForceHolster();
				
				return EJT_ToWater;
			}
		}	
		
		
		if( prevStateName == 'Climb' )
		{
			return EJT_Vault;
		}
		
		
		if( prevStateName == 'AirCollision' )
		{
			
			
				return EJT_Hit;
			
			
		}
		
		
		if( prevStateName == 'StartFalling' )
		{
			return EJT_Fall;
		}
		
		
		else if( prevStateName == 'Slide' )
		{ 
			return EJT_Slide;			
		}
		
		
		else if( m_ExplorationO.GetStateType( prevStateName ) == EST_Skate )
		{
			return EJT_Skate;
		}
		
		
		else if( m_ExplorationO.m_InputO.IsModuleConsiderable() && m_ExplorationO.m_MoverO.GetRealSlideAngle() >= 36.0f ) 
		{
			m_ExplorationO.m_MoverO.GetSlideDirAndNormal( dir, normal );
			if( VecDot( VecNormalize( dir ), m_ExplorationO.m_InputO.GetMovementOnPlaneNormalizedV() ) < -0.2f )
			{
				return EJT_Walk;
			}
		}
		
		
		
		if( thePlayer.GetSprintingTime() > 0.2f )
		
		
		{
			
			if( m_AllowSprintJumpB && ( !m_SprintJumpNeedsStaminaB || thePlayer.HasStaminaToUseAction( ESAT_Jump ) ) )
			{
				return EJT_Sprint;
			}
			else
			{
				return EJT_Run;
			}
		}
		
		
		else if(jumpIdleWhenObstructed && m_ForceIdleJumpOnColliisonB && m_ExplorationO.m_CollisionManagerO.CheckCollisionsToNoStepOnInputDir( m_ForceIdleJumpDistFreeF, m_ForceIdleJumpHeightFreeF ) )
		{
			LogExploration("Collision forced idle jump" );
			return EJT_Idle;
		}
		
		
		if( thePlayer.IsOnBoat() )
		{
			if( m_ExplorationO.m_CollisionManagerO.GetJumpGoesOutOfBoat() )
			{
				return EJT_Run;
			}
		}
		
		
		else if( thePlayer.GetIsRunning() )
		{
			return EJT_Run;
		}		
		
		
		else if( m_ExplorationO.m_InputO.IsModuleConsiderable() || prevStateName == 'TurnToJump' )
		{
			if( !useWalkJump || thePlayer.GetIsRunning() )
			{
				return EJT_Run;
			}
			
			if( useHighJump && m_ExplorationO.m_CollisionManagerO.CheckCollisionsInJumpTrajectory( 0.5f, 2.5f ) )
			{
				return EJT_WalkHigh;
			}
			
			
			if( useIdleWalkJump && m_ExplorationO.m_SharedDataO.m_TimeSinceIdleF < 0.2f ) 
			{
				return EJT_IdleToWalk;
			}
			else
			{
				return EJT_Walk;
			}
		}
		
		
		if( jumpingOnIdleIsForward )
		{
			return EJT_IdleToWalk;
		}
	
		return EJT_Idle;
	}
	
	
	private function SetJumpParametersBasedOnType( type : EJumpType )
	{
		switch( type )
		{
			case EJT_Idle:
				m_JumpParmsS	= m_JumpParmsIdleS;
				break;
			case EJT_IdleToWalk:
				m_JumpParmsS	= m_JumpParmsIdleToWalkS;
				break;
			case EJT_Walk :
				m_JumpParmsS	= m_JumpParmsWalkS;
				break;
			case EJT_WalkHigh :
				m_JumpParmsS	= m_JumpParmsWalkHighS;
				break;
			case EJT_Run :
				m_JumpParmsS	= m_JumpParmsRunS;
				break;
			case EJT_Sprint :
				m_JumpParmsS	= m_JumpParmsSprintS;
				break;
			case EJT_Fall :
				m_JumpParmsS	= m_JumpParmsFallS;
				break;
			case EJT_Slide :
				m_JumpParmsS	= m_JumpParmsSlideS;
				break;
			case EJT_Hit :
				m_JumpParmsS	= m_JumpParmsHitS;
				break;
			case EJT_Vault :
				m_JumpParmsS	= m_JumpParmsVaultS;
				break;
			case EJT_Skate :
				m_JumpParmsS	= m_JumpParmsSkateIdleS;
				break;
			case EJT_ToWater :
				m_JumpParmsS	= m_JumpParmsToWaterS;
				break;
			case EJT_KnockBack :
				m_JumpParmsS	= m_JumpParmsKnockBackS;
				break;
			case EJT_KnockBackFall:
				m_JumpParmsS	= m_JumpParmsKnockBackFallS;
				break;
				
			default:
				m_JumpParmsS	= m_JumpParmsWalkS;
				LogExplorationError( "Trying to get jump params for a missing jump type" );
				break;
		}
	}
	
	
	private function BlockStamina( prevStateName : name )
	{		
		
		if( prevStateName != 'StartFalling' )
		{
			
		}
	}
	
	
	private function AddConservingVelocityToTheParams()
	{
		var conserving		: float;
		var velocity		: Vector;
		var jumpDirection	: Vector;
		
		
		
		if( !m_JumpParmsS.m_UsePhysicJumpB )
		{
			return;
		}
		
		jumpDirection	= VecFromHeading( m_OrientationInitialF );
		
		
		
		
		velocity		= m_ExplorationO.m_MoverO.GetMovementVelocity();
		
		
		
		if( m_CanSetVelocityB && m_JumpParmsS.m_HorImpulseAtStartB )
		{
			LogExploration("Jump Conserve: Impulse at start: " + m_JumpParmsS.m_HorImpulseF );
			m_ExplorationO.m_MoverO.SetVelocity( jumpDirection * m_JumpParmsS.m_HorImpulseF );
		}
		
		if( VecLengthSquared( velocity ) < m_SpeedSqrMinToConserveF )
		{
			LogExploration("Jump Conserve: No Conserved Speed, going too slow" );
			return;
		}
		
		
		conserving		= VecDot( velocity, jumpDirection );
		if( m_JumpParmsS.m_ConserveCoefsB )
		{
			conserving		*= m_ConserveHorizontalCoefF;
			conserving		= MinF( conserving, m_ConserveHorizontalMaxF );
			if( m_JumpParmsS.m_ConserveAddB )
			{
				conserving	= m_JumpParmsS.m_HorImpulseF + conserving;
			}
			else
			{
				conserving	=  ClampF( conserving, -m_JumpParmsS.m_HorImpulseF, m_JumpParmsS.m_HorImpulseF );
			}
			
			m_JumpParmsS.m_HorImpulseF	=  conserving;
			LogExploration("Jump Conserve: Conserved Horizontal speed: " + conserving );
		}
		
		
		if( m_JumpParmsS.m_ConserveCoefsB )
		{
			conserving		= VecDot( velocity, Vector( 0.0f, 0.0f, 1.0f ) );
			if( velocity.Z >= 0.0f )
			{
				conserving	*= m_ConserveVertUpCoefF;
				conserving	= MinF( conserving, m_ConserveVertUpMaxF );
			}
			else
			{
				conserving	*= m_ConserveVertDownCoefF;
				conserving	= MaxF( conserving, -m_ConserveVertDownMaxF );
			}		
			if( m_JumpParmsS.m_ConserveAddB )
			{
				conserving	= m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF + conserving;
			}
			else
			{
				if( velocity.Z >= 0.0f )
				{
					conserving	=  MaxF( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF, conserving );
				}
				else
				{
					conserving	=  MaxF( 0.0f, m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF + conserving );
				}
			}
			m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF		=  conserving;
			LogExploration("Jump Conserve: Conserved Vertical speed: " + conserving );
		}
	}
	
	
	private function WantsToInteractWithExploration() : bool
	{
		var exploration					: SExplorationQueryToken;
		var queryContext				: SExplorationQueryContext;
		
		
		if( m_ExplorationO.m_SharedDataO.m_UseClimbB )
		{
			return false;
		}
		
		
		queryContext.inputDirectionInWorldSpace	= m_ExplorationO.m_InputO.GetMovementOnPlaneV();	
		queryContext.forJumping = true;	
		queryContext.dontDoZAndDistChecks = true;
		
		
		
		exploration = theGame.QueryExplorationSync( m_ExplorationO.m_OwnerE, queryContext );
		
		
		
		if ( !exploration.valid )
		{
			return false;
		}
		
		
		if( !IsInteractionPointInRange( exploration.pointOnEdge ) )
		{
			return false;
		}
		
		
		m_ExplorationO.m_SharedDataO.SetExplorationToken( exploration, GetStateName() );
		
		
		return true;
	}
	
	
	private function CanWeCheckForInteraction() : bool
	{
		
		if( !m_InteractAlwaysB )
		{
			return false;
		}
		
		
		if( false )
		{
			return false;
		}
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_Vault )
		{
			if( AbsF( m_ExplorationO.m_InputO.GetHeadingDiffFromPlayerF() ) > 60.0f )
			{
				return false;
			}
			else if( m_InteractTimeMinVaultF > m_ExplorationO.GetStateTimeF() )
			{			
				return false;
			}
			else
			{
				m_InteractTimeMinVaultF	= m_InteractTimeMinVaultF;
			}
		}
		else if( m_JumpParmsS.m_JumpTypeE == EJT_Fall )
		{
			if( m_InteractTimeMinFallF > m_ExplorationO.GetStateTimeF() )
			{
				return false;
			}
		}
		else
		{
			if( m_InteractTimeMinF > m_ExplorationO.GetStateTimeF() ) 
			{			
				return false;
			}
		}
		
		
		if( -m_ExplorationO.m_SharedDataO.GetFallingHeight() > m_InteractHeightFallMaxF	)
		{
			return false;
		}
		
		
		if( !m_ExplorationO.m_InputO.IsModuleConsiderable() )
		{
			return false;
		}
		
		return true;
	}
	
	
	private function IsInteractionPointInRange( point : Vector ) : bool
	{
		var explorationOwnerPosition	: Vector;
		var	explorationDirection		: Vector;
		var	speed						: Vector;
		var	coef						: float;
		var	aux							: float;
		
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_Fall )
		{
			if(  -m_ExplorationO.m_SharedDataO.GetFallingHeight() <= m_FallDistToUseHelpF ) 
			{
				if( VecDot( m_ExplorationO.m_InputO.GetMovementOnPlaneV(), Vector( speed.X, speed.Y, 0.0f ) ) < 0.5f )
				{
					return IsInteractionPointInRangeOnStartFalling( point );
				}
			}
		}
		
		
		explorationOwnerPosition	= GetExplorationOwnerPosition();
		explorationDirection		= point - explorationOwnerPosition;
		
		
		if( m_JumpParmsS.m_UsePhysicJumpB )
		{
			speed	= m_ExplorationO.m_MoverO.GetMovementVelocity();
		}
		else
		{
			speed	= m_ExplorationO.m_OwnerMAC.GetVelocity();
		}		
		
		
		coef	= speed.Z * explorationDirection.Z;
		if( coef < -m_InteractSpeedDiffAllowedF )
		{
			return false;
		}
		
		
		coef	= VecDot( speed, explorationDirection );
		if( coef < -m_InteractSpeedDiffAllowedF )
		{
			return false;
		}		
		
		
		coef	= VecLength( speed ) * m_InteractTimeAdjustingF + m_InteractDistanceExtraF;
		aux		= VecLength( explorationDirection );
		if( coef < aux )
		{
			return false;
		}
		
		return true;
	}
	
	
	
	private function IsInteractionPointInRangeOnStartFalling( point : Vector ) : bool
	{
		var explorationOwnerPosition	: Vector;
		
		
		explorationOwnerPosition	= GetExplorationOwnerPosition();
		
		if( explorationOwnerPosition.Z > point.Z + m_FallRecoverMaxHeightUpF )
		{
			return false;
		}
		
		if( explorationOwnerPosition.Z < point.Z  - m_FallRecoverMaxHeightDownF )
		{
			return false;
		}
		
		if( VecDistance( point, explorationOwnerPosition ) > m_FallRecoverMaxDistF )
		{
			return false;
		}			
		
		LogExploration( "FallRecover" );
		
		return true;
	}
	
	
	
	private function ShouldAirCollide() : bool
	{			
		if( m_HitCeilingB )
		{
			return false;
		}
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
		{
			return false;
		}
		
		if( m_ExplorationO.GetStateTimeF() < m_JumpParmsS.m_TimeToCheckCollisionsF )
		{
			return false;
		}
		
		if( m_SubstateE <= JSS_TakingOff )
		{
			return false;
		}
		
		
		if( HasQueuedState() )
		{
			return false;
		}		
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_Skate )
		{
			return false;
		}		
		
		if( !m_ExplorationO.StateWantsAndCanEnter( 'AirCollision' ) )
		{
			return false;
		}
		
		return true;
	}
	
	
	private function ShouldSideCollide() : bool
	{
		if( m_ExplorationO.m_InputO.IsSprintJustPressed() )
		{		
			m_CollidingSideE	= SS_SelectedLeft;
			
		}
		
		return true;
	}
	
	
	private function GetExplorationOwnerPosition() : Vector
	{
		var position	: Vector;
		
		position 	= m_ExplorationO.m_OwnerE.GetWorldPosition()
					+ m_ExplorationO.m_OwnerE.GetWorldForward()	* m_InteractOwnerOffsetV.X 
					+ m_ExplorationO.m_OwnerE.GetWorldRight()	* m_InteractOwnerOffsetV.Y 
					+ m_ExplorationO.m_OwnerE.GetWorldUp()		* m_InteractOwnerOffsetV.Z;
		
		return position;
	}
	
	
	private function Update2DLogicMovement( _Dt : float )
	{
		
		if( m_JumpParmsS.m_AllowAirDisplacementControlB || m_ExplorationO.GetStateTimeF() > 2.0f )
		{
			m_ExplorationO.m_MoverO.UpdateMovementOnPlaneWithInput( _Dt );
		}
		else
		{
			m_ExplorationO.m_MoverO.UpdateMovementOnPlaneWithInertia( _Dt );
		}
		
		
		if( m_ExplorationO.m_InputO.IsModuleConsiderable() )
		{
			m_ExplorationO.m_MoverO.UpdateOrientToInput( m_JumpParmsS.m_OrientationSpeedF, _Dt );
		}
	}
	
	
	private function UpdateVerticalMovement( _Dt : float ) : float
	{
		
		
		
		return m_ExplorationO.m_MoverO.UpdatePerfectMovementVertical( _Dt );
	}
	
	
	
	private function ChangeTo( jumpSubstate : EJumpSubState )
	{			
		m_SubstateE	= jumpSubstate;
		
		LogExploration("	Substate changing to: " + m_SubstateE );	
		
		switch( jumpSubstate )
		{
			case JSS_TakingOff :
				ChangeToTakeOff();
				break;
			case JSS_Flight :
				ChangeToFlight();
				break;
			case JSS_Inertial:	
				ChangeToInertial();
				break;
			case JSS_PredictingLand :
				ChangeToPredictingLand();
				break;
		}
	}
	
	
	private function ChangeToTakeOff()
	{		
		
		if ( m_JumpParmsS.m_TakeOffTimeF == 0.0f )
		{
			ChangeTo( JSS_Flight );
		}
	}
	
	
	private function ChangeToFlight()
	{
		var succeeded	: bool;
		var direction	: Vector;
		
		
		
		m_ExplorationO.m_MoverO.SetPlaneMovementParams( m_JumpParmsS.m_HorMovementS );
		direction	= VecFromHeading( m_OrientationInitialF );
		
		
		if( m_CanSetVelocityB && !m_JumpParmsS.m_HorImpulseAtStartB )
		{
			m_ExplorationO.m_MoverO.SetVelocity( direction * m_JumpParmsS.m_HorImpulseF );
		}
		
		
		m_ExplorationO.m_OwnerMAC.SetEnabledFeetIK( false );
		
		
		if( m_JumpParmsS.m_UsePhysicJumpB && m_JumpParmsS.m_JumpTypeE != EJT_Sprint )
		{		
			ChangeTo( JSS_Inertial );
			
		}
		m_ExplorationO.m_MoverO.SetVerticalSpeed( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF );
	}
	
	
	private function ChangeToInertial()
	{		
		var velocity 		: Vector;
		var vertVelocity	: float;
		
		
		m_ExplorationO.m_MoverO.SetPlaneMovementParams( m_JumpParmsFallS.m_HorMovementS );
		
		
		
		
		m_ExplorationO.m_MoverO.SetVerticalMovementParams( m_JumpParmsFallS.m_VerticalMovementS ); 
		
		
		if( !m_JumpParmsS.m_RecalcSpeedOnInertialB )
		{
			return;
		}
		
		velocity		= m_ExplorationO.m_OwnerMAC.GetVelocity();
		vertVelocity	= velocity.Z;
		velocity.Z		= 0.0f;
		m_ExplorationO.m_MoverO.SetVelocity( velocity );
		if( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF != 0.0f )
		{		
			m_ExplorationO.m_MoverO.SetVerticalSpeed( m_JumpParmsS.m_VerticalMovementS.m_VertImpulseF );
		}
		else
		{
			m_ExplorationO.m_MoverO.SetVerticalSpeed( vertVelocity );	
		}
	}
	
	
	private function ChangeToPredictingLand()
	{
		var succeeded	: bool;
		
		
		
			succeeded	= m_ExplorationO.SendAnimEvent( m_BehEventPredictLandN );	
			if( !succeeded )
			{
				LogExplorationWarning( "Invalid predict land event name" );
			}
		
		m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehEventPredictTypeS, ( float ) ( int ) m_LandPredicedTypeE );	
		
	}
	
	
	private function CheckLandPrediction() : bool
	{
		var velocity		: Vector;
		var vertVelocity	: float;
		var world 			: CWorld;
		var res 			: bool;
		var distanceToCheck	: float;
		var posCurrent		: Vector;
		var posPredicted	: Vector;
		var posCollided		: Vector;
		var normalCollided	: Vector;
		
		if( m_LandPredictedB )
		{
			return false;
		}
		
		if( !m_LandGroundPredictB && !m_LandWaterPredictB )
		{
			return false;
		}
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
		{
			return false;
		}
		
		
		if( !m_JumpParmsS.m_UsePhysicJumpB && m_ExplorationO.GetStateTimeF() < m_LandPredictTimeMin )
		{
			return false;
		}
		
		
		if( m_JumpParmsS.m_UsePhysicJumpB )
		{
			vertVelocity	= m_ExplorationO.m_MoverO.GetMovementVerticalSpeedF();
		}
		else
		{
			velocity		= m_ExplorationO.m_OwnerMAC.GetVelocity();
			vertVelocity	= velocity.Z;
		}
		
		
		if( vertVelocity >= 0.0f )
		{
			return false;
		}
		
		
		
		posCurrent		= m_ExplorationO.m_OwnerE.GetWorldPosition();
		distanceToCheck	= vertVelocity * m_LandPredictionTimeF;		
		posPredicted	= posCurrent + Vector( 0.0f, 0.0f, distanceToCheck );
		
		
		if( m_LandWaterPredictB )
		{
			if( m_ExplorationO.m_CollisionManagerO.IsThereWaterAndIsItDeepEnough( posCurrent, posPredicted.Z, 0.4f ) )
			{ 
				m_LandPredicedTypeE	= ELPT_Water;
				m_ExplorationO.m_SharedDataO.m_LandingOnWater	= true;
				m_LandPredictedB	= true;
				return true;
			}
		}
		
		
		if( m_LandGroundPredictB )
		{		
			world	= theGame.GetWorld();
			res 	= world.StaticTrace( posCurrent, posPredicted, posCollided, normalCollided, m_CollisionGroupsNamesNArr );
			
			if( res )
			{
				
				if( AbsF( normalCollided.Z ) <= m_SlopedLandZF )
				{
					m_LandPredicedTypeE	= ELPT_FlatLand;
				}
				
				else
				{
					m_LandPredicedTypeE	= ELPT_SlopedLand;
				}
				
				m_LandPredictedB	= true;
				return true;
			}
		}
		
		return false;
	}		
	
	
	private function SetBehaviorParameters()
	{
		var startRightFoot	: bool;
		
		
		
		m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehParamJumpTypeN, ( float ) ( int ) m_JumpParmsS.m_JumpTypeE );
		
		
		if( m_JumpParmsS.m_JumpTypeE != EJT_Vault && m_JumpParmsS.m_JumpTypeE != EJT_Hit )
		{
			if( m_JumpParmsS.m_JumpTypeE == EJT_IdleToWalk )
			{		
				m_ExplorationO.m_SharedDataO.ForceFotForward( true );
			}
			else
			{
				m_ExplorationO.m_SharedDataO.SetFotForward();
			}
		}
		
		
		m_ExplorationO.SetBehaviorParamBool( m_BehParamIsHandledByAnimS, !m_JumpParmsS.m_UsePhysicJumpB );
		
		
		m_LandPredicedCoefF	= 0.0f;		
		m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehEventPredictingS, m_LandPredicedCoefF );	
		
		
		
		m_ExplorationO.m_OwnerE.SetBehaviorVariable( m_BehParamNormalLandS, ( float ) ( int ) m_JumpParmsS.m_JumpTypeE );
		
		
		
		if( m_JumpParmsS.m_JumpTypeE == EJT_ToWater )
		{
			
		}
	}
	
	
	private function SetInitialOrientation()
	{	
		var movAdj 	: CMovementAdjustor;
		var ticket 	: SMovementAdjustmentRequestTicket;
		
		
		if( m_ExplorationO.m_OwnerE.GetHeading() == m_OrientationInitialF )
		{
			return;
		}
		
		
		movAdj = m_ExplorationO.m_OwnerMAC.GetMovementAdjustor();
		ticket = movAdj.CreateNewRequest( 'turnOnJump' );
		
		
		movAdj.AdjustmentDuration( ticket, 0.3f );
		
		movAdj.RotateTo( ticket, m_OrientationInitialF );
		
		
		
	}
	
	
	private function HasToTurnBack() : bool
	{
		var turnAround	: bool;
		
		turnAround	= AngleDistance( m_OrientationInitialF, m_ExplorationO.m_OwnerE.GetHeading() ) >= 90.0f;
		
		if( turnAround )
		{
			return true;
		}
		
		return false;
	}
	
	
	private function GetJumpInitialOrientation()
	{
		var	yawDifference	: float;
		var	yawExceeding	: float;
		
		
		
		if( m_JumpParmsS.m_ExternalDirectionForcedB )
		{
			m_OrientationInitialF	=  VecHeading( m_ExplorationO.m_SharedDataO.m_JumpDirectionForcedV );
		}		
		
		else
		{
			m_OrientationInitialF	= m_ExplorationO.m_OwnerE.GetHeading();			
			
			
			
			if( m_ExplorationO.m_InputO.IsModuleConsiderable() )
			{			
				
				yawDifference	= m_ExplorationO.m_InputO.GetHeadingDiffFromYawF( m_OrientationInitialF );
				
				
				if( AbsF( yawDifference ) < m_JumpParmsS.m_StartDirectionIgnoreF )
				{					
					
					m_OrientationInitialF	= m_ExplorationO.m_InputO.GetHeadingOnPlaneF();
					
					
					if( m_JumpParmsS.m_StartDirectionAllowanceF < 180.0f )
					{
						yawExceeding	= yawDifference - m_JumpParmsS.m_StartDirectionAllowanceF;
						if( yawExceeding > 0.0f )
						{
							m_OrientationInitialF	-= yawExceeding;
						}
						
						yawExceeding	= yawDifference + m_JumpParmsS.m_StartDirectionAllowanceF;
						if( yawExceeding < 0.0f )
						{
							m_OrientationInitialF	-= yawExceeding;
						}
					}
				}
			}
		}
	}
	

	
	function UpdateCameraIfNeeded( out moveData : SCameraMovementData, dt : float ) : bool
	{
		return true;
	}
	
	
	private function ChangeCameraToFall()
	{
		var camera	: CCustomCamera = theGame.GetGameCamera();
		
		camera.ChangePivotRotationController( cameraRoationName );
		
		cameraFallIsSet	= true;
	}
	
	
	
	
	
	
	function ReactToHitCeiling() : bool
	{
		if( m_ReactToHitCeilingB && !m_HitCeilingB )
		{
			m_ExplorationO.m_OwnerE.RaiseEvent( m_BehEventCeilingHit );
			m_HitCeilingB	= true;
		}
		
		return true;
	}
	
	
	function ReactToLoseGround() : bool
	{
		return true;
	}
	
	
	function ReactToHitGround() : bool
	{	
		var direction	: Vector;
		var dot			: float;
		var time		: float;
		
		
		
		
		
		if( m_ExplorationO.GetStateTimeF() <= 0.0f )
		{
			return true;
		}
		
		if( m_SubstateE == JSS_TakingOff )
		{
			return true; 
		}
		
		if( m_JumpParmsS.m_JumpTypeE != EJT_Fall )
		{
			time	= m_ExplorationO.GetStateTimeF();
			if( time < m_JumpParmsS.m_TakeOffTimeF )
			{
				return true;
			}
			if( time < 0.1f ) 
			{	
				return true;
			}
		}		
		
		
		
		
		if( m_ExplorationO.m_MoverO.GetMovementVerticalSpeedF() == 0.0f )
		{
			direction	= m_ExplorationO.m_OwnerMAC.GetVelocityBasedOnRequestedMovement();
			dot			= VecDot( direction, m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false ) );
			
			if( dot >= -0.0001f )
			{
				LogExploration( GetStateName() + ": HitGround, But done nothing cause GetVelocityBasedOnRequestedMovement is moving away from the terrain normal" );
				return true;
			}
		}
		else
		{
			direction	= m_ExplorationO.m_MoverO.GetMovementVelocity();
			
			dot			= VecDot( direction, m_ExplorationO.m_OwnerMAC.GetTerrainNormal( false ) );
			
			if( dot > 0.0f )
			{
				LogExploration( GetStateName() + ": HitGround, But done nothing cause GetMovementVelocity().Z is > 0.0f" );
				return true;
			}
		}
		
		if( m_ExplorationO.StateWantsAndCanEnter( 'Slide' ) )
		{
			SetReadyToChangeTo( 'Slide' );
			return true;
		}
		if( m_JumpParmsS.m_JumpTypeE == EJT_Skate )
		{
			SetReadyToChangeTo( 'SkateLand' );
			return true;
		}
		
		if( m_SubstateE >= JSS_Flight )
		{
			
			SetReadyToChangeTo( 'Land' );
			return true;
		}
		
		
		LogExploration( GetStateName() + ": HitGround, But did nothing with it cause the jump state is not ready to land still" );
		return true;
	}
	
	
	function CanInteract( ) : bool
	{		
		return false;
	}
	
	
	function OnAnimEvent( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		if ( animEventName == m_BehListenFinishTakeOffN )
		{
			
			if( m_SubstateE == JSS_TakingOff || m_SubstateE == JSS_Flight )
			{
				ChangeTo( JSS_Inertial ); 
			}
			
		}
		
		else if ( m_SubstateE != JSS_Inertial )
		{
			if( animEventName == m_BehListenInertialJumpN )
			{
				ChangeTo( JSS_Inertial );
			}
			
			else if( animEventName == 'AnimEnd' )
			{
				ChangeTo( JSS_Inertial );
			}
		}
	}
}
