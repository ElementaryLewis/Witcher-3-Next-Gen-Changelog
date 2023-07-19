/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/




state Meditation in W3PlayerWitcher extends MeditationBase
{
	private var meditationPointHeading : float;				
	private var meditationHeadingSet : bool;				
	private var stopRequested : bool;						
	private var isSitting : bool;							
	
	
	private var closeUIOnStop : bool;						
	private var cameraIsLeavingState : bool;				
	private var isEntryFunctionLocked : bool;				
	private var scheduledGoToWaiting : bool;				
	private var changedContext : bool;						
	
		default scheduledGoToWaiting = false;
	
	

	event OnEnterState( prevStateName : name )
	{
		parent.AddAnimEventCallback('OpenUI','OnAnimEvent_OpenUI');
		
		super.OnEnterState(prevStateName);
		
		meditationHeadingSet = false;
		cameraIsLeavingState = false;
		
		if(prevStateName != 'MeditationWaiting')
		{
			stopRequested = false;
			closeUIOnStop = false;
		}
		
		
		thePlayer.OnMeleeForceHolster( true );
		thePlayer.OnRangedForceHolster( true );
		
		InitState(prevStateName);
	}
	
	event OnLeaveState( nextStateName : name )
	{
		
		if(nextStateName != 'MeditationWaiting')
		{
			FactsAdd('MeditationWaitFinished', 1, 1);					
		}
			
		
		virtual_parent.UnblockAction(EIAB_DrawWeapon, 'Meditation');
		
		virtual_parent.SetBehaviorVariable( 'MeditateAbort', 0 );
		
		super.OnLeaveState(nextStateName);
		
		
	}
	
	entry function InitState(prevStateName : name)
	{
		var actionSuccess : bool;
		
		virtual_parent.LockEntryFunction( true );
		isEntryFunctionLocked = true;
		
		virtual_parent.SetBehaviorVariable('MeditateAbort', 0);		
		
		if(prevStateName != 'MeditationWaiting')
		{
			isSitting = false;
			
			
			virtual_parent.BlockAllActions('Meditation', true, ,false);
						
			
			while(!meditationHeadingSet)
			{
				Sleep(0.1);
			}
			
			
			virtual_parent.BlockAction(EIAB_DrawWeapon, 'Meditation', false);
			virtual_parent.OnMeleeForceHolster(true);
			virtual_parent.OnRangedForceHolster(true);
			
			
			virtual_parent.BlockAllActions('Meditation', false);
			virtual_parent.BlockAction(EIAB_DrawWeapon, 'Meditation', false);
			
			if(!theGame.GetGuiManager().IsAnyMenu())
			{
				changedContext = true;
				theInput.StoreContext( 'Meditation' );
			}
			else
			{
				changedContext = false;
			}
			
			if( !((W3WitcherBed)theGame.GetEntityByTag( 'witcherBed' )).GetWasUsed() )
			{
				
				virtual_parent.SetBehaviorVariable('MeditateWithIgnite', 0);
				actionSuccess = virtual_parent.PlayerStartAction(PEA_Meditation);
			}
			else
			{
				actionSuccess = true;
			}
		}
		else
		{
			actionSuccess = true;
			
			if(!stopRequested)
			{
				
				
			}
		}
		
		virtual_parent.LockEntryFunction( false );
		isEntryFunctionLocked = false;
		
		
		if(!actionSuccess)
		{
			StopRequested(true);
		}
		
		
		if(scheduledGoToWaiting)
		{
			scheduledGoToWaiting = false;
			virtual_parent.PushState('MeditationWaiting');
		}
		else
		{
			Loop();
		}
	}
	
	public function SetMeditationPointHeading(head : float)
	{
		meditationPointHeading = head;
		meditationHeadingSet = true;
	}
	
	public function IsSitting() : bool
	{
		return isSitting;
	}
	
	event OnAnimEvent_OpenUI( animEventName : name, animEventType : EAnimationEventType, animInfo : SAnimationEventAnimInfo )
	{
		var mutagen : CBaseGameplayEffect;
		
		if( !stopRequested )	
		{
			isSitting = true;
			cameraIsLeavingState = false;
						
			
			if(thePlayer.HasBuff(EET_Mutagen06))
			{
				mutagen = thePlayer.GetBuff(EET_Mutagen06);
				thePlayer.RemoveAbilityAll(mutagen.GetAbilityName());
			}
			
			
			
			theGame.RequestMenuWithBackground( 'MeditationClockMenu', 'CommonMenu' );
		}
	}
	
	
	
	public function StopRequested(optional closeUI : bool)
	{
		stopRequested = true;
		closeUIOnStop = closeUI;
		virtual_parent.SetBehaviorVariable('MeditateAbort', 1);
	}
	
	private entry function Loop()
	{
		while(!stopRequested)
		{
			Sleep(0.2);
		}
		StopMeditation();
	}
	
	
	public latent function StopMeditation()
	{
		var commonMenuRef 	: CR4CommonMenu;
		var l_bed			: W3WitcherBed;
	
		cameraIsLeavingState = true;
		
		
		if(closeUIOnStop)
		{
			commonMenuRef = theGame.GetGuiManager().GetCommonMenu();
			if (commonMenuRef)
			{
				commonMenuRef.CloseMenu();
			}
		}		
	
		virtual_parent.SetBehaviorVariable('HasCampfire', 0);
		
		l_bed = (W3WitcherBed)theGame.GetEntityByTag( 'witcherBed' );
		
		if( !l_bed.GetWasUsed() )
		{
			virtual_parent.PlayerStopAction(PEA_Meditation);
		}
		else
		{
			virtual_parent.PlayerStopAction( PEA_GoToSleep );
		}
		
		if( l_bed.GetWasUsed() )
		{
			l_bed.SetWasUsed( false );
		}
		
		
		thePlayer.abilityManager.SetStatPointCurrent(BCS_Air, thePlayer.GetStatMax(BCS_Air));
		thePlayer.RemoveAllBuffsOfType(EET_AutoAirRegen);
		thePlayer.AddEffectDefault(EET_AutoAirRegen, thePlayer, "meditation_reset", false);
		
		
		
		if(changedContext)
		{
			theInput.RestoreContext('Meditation', false);
		}
								
		
		virtual_parent.WaitForBehaviorNodeDeactivation( 'PlayerActionEnd', 10);
		
		if(virtual_parent.GetCurrentStateName() == 'Meditation')
			virtual_parent.PopState(true);		
	}
	
	
	public function MeditationWait(targetHour : int)
	{
		LogChannel( 'CLOCK', "MeditationWait, targetHour "+targetHour);
		virtual_parent.SetWaitTargetHour(targetHour);
		
		
		if(!isEntryFunctionLocked)
			virtual_parent.PushState('MeditationWaiting');
		else
			scheduledGoToWaiting = true;
	}
		
	
	
	event OnGameCameraTick( out moveData : SCameraMovementData, dt : float )
	{
		var rotation : EulerAngles = parent.GetWorldRotation();
		
		
		if(parent.GetExplCamera())
		{	
			return true;
		}
		
		
		theGame.GetGameCamera().ChangePivotRotationController( 'Exploration' );
		theGame.GetGameCamera().ChangePivotDistanceController( 'Default' );
		theGame.GetGameCamera().ChangePivotPositionController( 'Default' );
		
		moveData.pivotDistanceController = theGame.GetGameCamera().GetActivePivotDistanceController();
		moveData.pivotPositionController = theGame.GetGameCamera().GetActivePivotPositionController();
		moveData.pivotRotationController = theGame.GetGameCamera().GetActivePivotRotationController();		
		
		if(!cameraIsLeavingState)
		{
			moveData.pivotRotationController.SetDesiredHeading( rotation.Yaw + 180.f, 0.1f );
			moveData.pivotRotationController.SetDesiredPitch(-15, 0.3);
			moveData.pivotPositionController.offsetZ = 0.5;
			moveData.pivotDistanceController.SetDesiredDistance( 3.8f );
			
			super.OnGameCameraTick(moveData, dt);

			return true;
		}
		
		return false;
	}
	
	event OnGameCameraPostTick( out moveData : SCameraMovementData, dt : float )
	{
		var rotation : EulerAngles = parent.GetWorldRotation();
		
		
		if(parent.GetExplCamera())
		{	
			moveData.pivotPositionController.SetDesiredPosition( parent.GetWorldPosition(), 15.f );
			moveData.pivotDistanceController.SetDesiredDistance( 1.5f );
		
			moveData.pivotPositionController.offsetZ = 1.3f;
			DampVectorSpring( moveData.cameraLocalSpaceOffset, moveData.cameraLocalSpaceOffsetVel, Vector( 0.5f, -0.3f, 0.25f ), 1.5f, dt );
			return true;
		}
		
		
		if( cameraIsLeavingState )
		{
			moveData.pivotRotationController.SetDesiredHeading( rotation.Yaw, 0.1f );
		}
	}
}
