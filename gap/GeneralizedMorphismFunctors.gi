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
        
        Error( " cannot coarse this two morphisms\n" );
        
        return fail;
        
    fi;
    
    embedding := PreDivide( old_morphism_aid, coarse_morphism );
    
    new_morphism := PreCompose( AssociatedMorphism( morphism ), embedding );
    
    return GeneralizedMorphism( new_morphism, coarse_morphism );
    
end );

InstallValue( functor_Coarse_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "Coarse" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "Coarse" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgMorphism ] ] ],
                [ "OnObjects", _Functor_Coarse_ForGeneralizedMorphisms ]
                )
        );

functor_Coarse_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

######################
#
# Precompose
#
######################

InstallGlobalFunction( _Functor_PreCompose,
  
  function( psi, phi )
    local phi_aid, K_as_product, phi_K, phi_coarsed, L_as_projection, psi_L, psi_coarsed;
    
    phi_aid := MorphismAid( phi );
    
    K_as_product := CoproductMorphism( phi_aid, KernelEmbedding( AssociatedMorphism( psi ) ) );
    
    phi_K := CokernelEpi( K_as_product );
    
    phi_coarsed := Coarse( phi, phi_K );
    
    L_as_projection := PreCompose( AssociatedMorphism( psi ), K_as_product );
    
    psi_coarsed := Coarse( psi, L_as_projection );
    
    return GeneralizedMorphism( PreCompose( AssociatedMorphism( psi_coarsed ), AssociatedMorphism( phi_coarsed ) ), L_as_projection );
    
end );

InstallValue( functor_PreCompose_ForGeneralizedMorphisms,
        CreateHomalgFunctor(
                [ "name", "PreCompose" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "PreCompose" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsGeneralizedMorphism ] ] ],
                [ "OnObjects", _Functor_PreCompose_ForGeneralizedMorphisms ]
                )
        );

functor_PreCompose_ForGeneralizedMorphisms!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );
