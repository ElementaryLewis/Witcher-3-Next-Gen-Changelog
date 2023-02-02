/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/



class W3PlayerTutorialInput extends CPlayerInput
{
	public function Initialize(isFromLoad : bool, optional previousInput : CPlayerInput)
	{
		var exceptions : array<EInputActionBlock>;
	
		super.Initialize(isFromLoad,previousInput);
		
		
		if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialMovement'))
		{
			theInput.RegisterListener( this, 'OnMovement', 'GI_AxisLeftY' );
			theInput.RegisterListener( this, 'OnMovement', 'GI_AxisLeftX' );
		}
		
		
		if(!theGame.GetTutorialSystem().HasSeenTutorial('TutorialCamera'))
		{
			theInput.RegisterListener( this, 'OnCameraMovement', 'GI_AxisRightX' );
			theInput.RegisterListener( this, 'OnCameraMovement', 'GI_AxisRightY' );
			theInput.RegisterListener( this, 'OnCameraMovement', 'GI_MouseDampX' );
			theInput.RegisterListener( this, 'OnCameraMovement', 'GI_MouseDampY' );
		}
		
		
		if(!isFromLoad)
		{
			exceptions.PushBack(EIAB_RunAndSprint);
			exceptions.PushBack(EIAB_Movement);
			exceptions.PushBack(EIAB_Interactions);
			exceptions.PushBack(EIAB_DismountVehicle);
			exceptions.PushBack(EIAB_InteractionAction);			
			
		}
	}
	
	event OnCbtThrowItem( action : SInputAction )
	{
		var ret : bool;
		
		ret = super.OnCbtThrowItem(action);
		
		if(ret)
		{
			if(thePlayer.inv.IsItemCrossbow(thePlayer.GetSelectedItemId()))
				FactsAdd("tut_crossbow_shot", 1, 1);
			else if(thePlayer.inv.IsItemBomb(thePlayer.GetSelectedItemId()))
				FactsAdd("tut_bomb_shot", 1, 1);
		}
		
		return ret;
	}
	
	event OnCbtThrowItemHold( action : SInputAction )
	{
		var ret : bool;
		
		ret = super.OnCbtThrowItemHold(action);
		
		if(ret)
		{
			if(thePlayer.inv.IsItemCrossbow(thePlayer.GetSelectedItemId()))
				FactsAdd("tut_crossbow_shot", 1, 1);
			else if(thePlayer.inv.IsItemBomb(thePlayer.GetSelectedItemId()))
				FactsAdd("tut_bomb_shot", 1, 1);
		}
		
		return ret;
	}
	
	event OnMovement( action : SInputAction )
	{
		FactsAdd("tutorial_player_moved");
			
		theInput.UnregisterListener( this, 'GI_AxisLeftY' );
		theInput.UnregisterListener( this, 'GI_AxisLeftX' );
	}
	
	event OnCameraMovement( action : SInputAction )
	{
		FactsAdd("tutorial_camera_moved");
		
		theInput.UnregisterListener(this, 'GI_AxisRightX');
		theInput.UnregisterListener(this, 'GI_AxisRightY');
		theInput.UnregisterListener(this, 'GI_MouseDampX');
		theInput.UnregisterListener(this, 'GI_MouseDampY');
	}
	
	event OnCastSign( action : SInputAction )
	{
		super.OnCastSign(action);
		
		SignStaminaTest();
	}
	
	private final function SignStaminaTest()
	{
		var signSkill : ESkill;
		if(ShouldProcessTutorial('TutorialStaminaSigns'))
		{
			signSkill = SignEnumToSkillEnum( thePlayer.GetEquippedSign() );
			if( signSkill != S_SUndefined && !thePlayer.HasStaminaToUseSkill( signSkill, false ) )
			{
				FactsSet( "tut_stamina_sign", 1 );
			}
		}
	}
}