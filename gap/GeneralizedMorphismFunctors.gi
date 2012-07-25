#############################################################################
##
##  GeneralizedMorphismFunctors.gi  homalg package            Mohamed Barakat
##                                                          Sebastian Gutsche
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for generalized morphisms of modules.
##
#############################################################################

######################
#
# Coarse
#
######################

##
InstallMethod( Coarse,
               "for a subobject",
               [ IsHomalgGeneralizedMorphism, IsHomalgObject ],
               
  function( generalized_morphism, subobject )
    
    ## FIXME: First question maybe can be made more general
    if not IsStaticFinitelyPresentedSubobjectRep( subobject ) and not IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        if not HasUnderlyingSubobject( subobject ) then  #Is this property immediate?
            
            Error( " cannot coarse objects without embedding" );
            
        fi;
        
        subobject := UnderlyingSubobject( subobject );
        
    elif IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        subobject := UnderlyingSubobject( subobject );
        
    fi;
    
    subobject := EmbeddingInSuperObject( subobject );
    
    return Coarse( generalized_morphism, CokernelEpi( subobject ) );
    
end );

##
## The second argument must be the projection
## on the factor.
InstallGlobalFunction( _Functor_Coarse_ForGeneralizedMorphisms,
  
  function( morphism, coarse_morphism )
    local old_morphism_aid, embedding, new_morphism;
    
    old_morphism_aid := MorphismAid( morphism );
    
    if not IsIdenticalObj( Source( old_morphism_aid ), Source( coarse_morphism ) ) then
        
        Error( "cannot coarse this two morphisms\n" );
        
        return fail;
        
    fi;
    
    if not IsZero( PreCompose( KernelEmb( old_morphism_aid ), coarse_morphism ) ) then
        
        Error( "cannot coarse those morphisms, new aid is not a superset of the old one\n" );
        
    fi;
    
    embedding := PreDivide( old_morphism_aid, coarse_morphism );
    
    new_morphism := PreCompose( AssociatedMorphism( morphism ), embedding );
    
    new_morphism := GeneralizedMorphism( new_morphism, coarse_morphism );
    
    SetIsCoarsedOf( new_morphism, [ morphism, coarse_morphism ] );
    
    return new_morphism;
    
end );

InstallValue( functor_Coarse_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "Coarse" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "Coarse" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgMorphism ] ] ],
                [ "OnObjects", _Functor_Coarse_ForGeneralizedMorphisms ]
                )
        );

functor_Coarse_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_Coarse_ForGeneralizedMorphisms );

######################
#
# CommonCoarsening
#
######################

InstallGlobalFunction( _Functor_CommonCoarsening_ForGeneralizedMorphisms,
                       
  function( phi, psi )
    local product_morphism, output_morphisms;
    
    if not IsIdenticalObj( Range( phi ), Range( psi ) ) then
        
        Error( "cannot compute common coarsening of morphisms with different ranges\n" );
        
    fi;
    
    product_morphism := CokernelEpi( CoproductMorphism( KernelEmb( MorphismAid( phi ) ), KernelEmb( MorphismAid( psi ) ) ) );
    
    output_morphisms := [ Coarse( phi, product_morphism ), Coarse( psi, product_morphism ) ];
    
    return output_morphisms;
    
end );

InstallValue( functor_CommonCoarsening_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "CommonCoarsening" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "CommonCoarsening" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_CommonCoarsening_ForGeneralizedMorphisms ]
                )
        );

functor_CommonCoarsening_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_CommonCoarsening_ForGeneralizedMorphisms );



######################
#
# IsEffectiveCoarsening
#
######################

##
InstallMethod( IsEffectiveCoarsening,
               "for a subobject",
               [ IsHomalgGeneralizedMorphism, IsHomalgObject ],
               
  function( generalized_morphism, subobject )
    
    ## FIXME: First question maybe can be made more general
    if not IsStaticFinitelyPresentedSubobjectRep( subobject ) and not IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        if not HasUnderlyingSubobject( subobject ) then  #Is this property immediate?
            
            Error( "cannot coarse objects without embedding\n" );
            
        fi;
        
        subobject := UnderlyingSubobject( subobject );
        
    elif IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        subobject := UnderlyingSubobject( subobject );
        
    fi;
    
    subobject := EmbeddingInSuperObject( subobject );
    
    return IsEffectiveCoarsening( generalized_morphism, CokernelEpi( subobject ) );
    
end );

##
InstallGlobalFunction( _Functor_IsEffectiveCoarsening_ForGeneralizedMorphisms,
  
  function( morphism, coarse_morphism )
    local old_morphism_aid, morphism_aid_embedding, coarsed_morphism, combined_image_embedding, pullback,
          pullback_morphism, pullback_morphism_to_common_target, cokernel_pullback;
    
    old_morphism_aid := MorphismAid( morphism );
    
    if not IsIdenticalObj( Source( old_morphism_aid ), Source( coarse_morphism ) ) then
        
        Error( "cannot coarse this two morphisms\n" );
        
        return fail;
        
    fi;
    
    if not IsZero( PreCompose( KernelEmb( old_morphism_aid ), coarse_morphism ) ) then
        
        Error( "cannot coarse those morphisms, new aid is not a superset of the old one\n" );
        
    fi;
    
    morphism_aid_embedding := KernelEmb( coarse_morphism );
    
    coarsed_morphism := Coarse( morphism, coarse_morphism );
    
    combined_image_embedding := EmbeddingInSuperObject( UnderlyingSubobject( CombinedImage( coarsed_morphism ) ) );
    
    pullback := Pullback( morphism_aid_embedding, combined_image_embedding );
    
    pullback_morphism := PullbackPairOfMorphisms( pullback )[ 1 ];
    
    pullback_morphism_to_common_target:= PreCompose( pullback_morphism, morphism_aid_embedding );
    
    if IsZero( PreCompose( pullback_morphism_to_common_target, old_morphism_aid ) ) then
        
        cokernel_pullback := CokernelEpi( pullback_morphism_to_common_target );
        
        if IsZero( PreCompose( KernelEmb( old_morphism_aid ), cokernel_pullback ) ) then
            
            return true;
            
        fi;
        
    fi;
    
    return false;
    
end );

InstallValue( functor_IsEffectiveCoarsening_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "IsEffectiveCoarsening" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "IsEffectiveCoarsening" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgMorphism ] ] ],
                [ "OnObjects", _Functor_IsEffectiveCoarsening_ForGeneralizedMorphisms ]
                )
        );

functor_IsEffectiveCoarsening_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_IsEffectiveCoarsening_ForGeneralizedMorphisms );

######################
#
# IsEffectiveCommonCoarsening
#
######################

##
InstallGlobalFunction( _Functor_IsEffectiveCommonCoarsening_ForGeneralizedMorphisms,
                       
  function( phi, psi )
    local product_morphism, output_morphisms;
    
    if not IsIdenticalObj( Range( phi ), Range( psi ) ) then
        
        Error( "cannot compute common coarsening of morphisms with different ranges\n" );
        
    fi;
    
    product_morphism := CokernelEpi( CoproductMorphism( KernelEmb( MorphismAid( phi ) ), KernelEmb( MorphismAid( psi ) ) ) );
    
    output_morphisms := [ IsEffectiveCoarsening( phi, product_morphism ), IsEffectiveCoarsening( psi, product_morphism ) ];
    
    return output_morphisms;
    
end );

##
InstallValue( functor_IsEffectiveCommonCoarsening_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "IsEffectiveCommonCoarsening" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "IsEffectiveCommonCoarsening" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_IsEffectiveCommonCoarsening_ForGeneralizedMorphisms ]
                )
        );

functor_IsEffectiveCommonCoarsening_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_IsEffectiveCommonCoarsening_ForGeneralizedMorphisms );

######################
#
# Precompose
#
######################

##
InstallGlobalFunction( _Functor_PreCompose_ForGeneralizedMorphisms,
  
  function( phi, psi )
    local phi_aid, K_as_product, phi_K, phi_coarsed, L_as_projection, psi_L, psi_coarsed;
    
    if not IsIdenticalObj( Range( phi ), Source( psi ) ) then
        
        Error( "cannot compose these morphisms\n" );
        
    fi;
    
    phi_aid := MorphismAid( phi );
    
    K_as_product := CoproductMorphism( KernelEmb( phi_aid ), KernelEmb( AssociatedMorphism( psi ) ) );
    
    phi_K := CokernelEpi( K_as_product );
    
    phi_coarsed := Coarse( phi, phi_K );
    
    L_as_projection := CokernelEpi( PreCompose( AssociatedMorphism( psi ), K_as_product ) );
    
    psi_coarsed := Coarse( psi, L_as_projection );
    
    return GeneralizedMorphism( PreCompose( AssociatedMorphism( psi_coarsed ), AssociatedMorphism( phi_coarsed ) ), L_as_projection );
    
end );

##
InstallValue( functor_PreCompose_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "PreCompose" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "PreCompose" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_PreCompose_ForGeneralizedMorphisms ]
                )
        );

functor_PreCompose_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_PreCompose_ForGeneralizedMorphisms );

######################
#
# QuasiEqual
#
######################

##
InstallGlobalFunction( _Functor_QuasiEqual_ForGeneralizedMorphisms,
  
  function( phi, psi )
    local common_coarsening, phi_coarsed, psi_coarsed;
    
    if not IsIdenticalObj( Source( phi ), Source( psi ) ) then
        
        return false;
        
    elif not IsIdenticalObj( Range( phi ), Range( psi ) ) then
        
        return false;
        
    fi;
    
    common_coarsening := IsEffectiveCommonCoarsening( phi, psi );
    
    if not ForAll( common_coarsening, IdFunc ) then
        
        return false;
        
    fi;
    
    common_coarsening := CommonCoarsening( phi, psi );
    
    phi_coarsed := common_coarsening[ 1 ];
    
    psi_coarsed := common_coarsening[ 2 ];
    
    return AssociatedMorphism( phi_coarsed ) = AssociatedMorphism( psi_coarsed );
    
end );

InstallValue( functor_QuasiEqual_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "QuasiEqual" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "QuasiEqual" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_QuasiEqual_ForGeneralizedMorphisms ]
                )
        );

functor_QuasiEqual_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_QuasiEqual_ForGeneralizedMorphisms );

######################
#
# Divides
#
######################

##
InstallGlobalFunction( _Functor_Divides_ForGeneralizedMorphisms,
  
  function( beta, gamma )
    local common_coarsening, image_beta, image_gamma, gamma_coarsed;
    
    common_coarsening := CommonCoarsening( beta, gamma );
    
    image_beta := CombinedImage( common_coarsening[ 1 ] );
    
    image_gamma := CombinedImage( common_coarsening[ 2 ] );
    
    image_beta := CokernelEpi( EmbeddingInSuperObject( UnderlyingSubobject( image_beta ) ) );
    
    image_gamma := EmbeddingInSuperObject( UnderlyingSubobject( image_gamma ) );
    
    if not IsZero( PreCompose( image_gamma, image_beta ) ) then
        
        return false;
        
    fi;
    
    return WasCoarsedEffective( common_coarsening[ 2 ] );
    
end );

InstallValue( functor_Divides_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "Divides" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "Divides" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_Divides_ForGeneralizedMorphisms ]
                )
        );

functor_Divides_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_Divides_ForGeneralizedMorphisms );

######################
#
# Divides
#
######################

##
InstallGlobalFunction( _Functor_Lift_ForGeneralizedMorphisms,
                       
  function( beta, gamma )
    local beta_associated_morphism, beta_help, gamma_help, coarsed_gamma_help, projection_coarsed_help_to_beta_factor,
          beta_from_factor, alpha_aid_object, common_coarsening, alpha_associated;
    
    if not Divides( beta, gamma ) then
        
        Error( "cannot lift this morphisms\n" );
        
        return false;
        
    fi;
    
    beta_associated_morphism := AssociatedMorphism( beta );
    
    beta_help := MorphismAid( beta );
    
    gamma_help := MorphismAid( gamma );
    
    coarsed_gamma_help := CoproductMorphism( KernelEmb( beta_help ), KernelEmb( gamma_help ) );
    
    projection_coarsed_help_to_beta_factor := PreCompose( coarsed_gamma_help, beta_help );
    
    alpha_aid_object := PostDivide( projection_coarsed_help_to_beta_factor, beta_associated_morphism );
    
    alpha_aid_object := CokernelEpi( ImageObjectEmb( alpha_aid_object ) );
    
    beta_from_factor := PreDivide( alpha_aid_object, beta_associated_morphism );
    
    beta_from_factor := GeneralizedMorphism( beta_from_factor, beta_help );
    
    common_coarsening := CommonCoarsening( beta_from_factor, gamma );
    
    alpha_associated := PostDivide( AssociatedMorphism( gamma ), AssociatedMorphism( beta_from_factor ) );
    
    return GeneralizedMorphism( alpha_associated, alpha_aid_object );
    
end );

InstallValue( functor_Lift_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "Lift" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "Lift" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_Lift_ForGeneralizedMorphisms ]
                )
        );

functor_Lift_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_Lift_ForGeneralizedMorphisms );

######################
#
# TheGeneralizedIdentityMorphism
#
######################

##
InstallGlobalFunction( _Functor_IdentityMorphism_ForGeneralizedMorphisms,
                       
  function( M )
    local identity_of_module;
    
    identity_of_module := TheIdentityMorphism( M );
    
    return GeneralizedMorphism( identity_of_module, identity_of_module );
    
end );

InstallValue( functor_IdentityMorphism_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "TheGeneralizedIdentityMorphism" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "TheGeneralizedIdentityMorphism" ],
                [ "number_of_arguments", 1 ],
                [ "1", [ [ "covariant" ], [ IsHomalgObject ] ] ],
                [ "OnObjects", _Functor_IdentityMorphism_ForGeneralizedMorphisms ]
                )
        );

functor_IdentityMorphism_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

InstallFunctor( functor_IdentityMorphism_ForGeneralizedMorphisms );
