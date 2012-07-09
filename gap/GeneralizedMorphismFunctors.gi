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
    
    if not IsHomalgSubobject( subobject ) and not IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        if not HasUnderlyingSubobject( subobject ) then  #Is this property immediate?
            
            Error( " cannot coarse objects without embedding" );
            
        fi;
        
        subobject := UnderlyingSubobject( subobject );
        
    elif IsIdenticalObj( Source( generalized_morphism ), subobject ) then
        
        subobject := UnderlyingSubobject( subobject );
        
    fi;
    
    subobject := EmbeddingInSuperobject( subobject );
    
    return Coarse( generalized_morphism, CokernelEpi( subobject ) );
    
end );

##
## The second argument must be the projection
## on the factor.
InstallGlobalFunction( _Functor_Coarse,
  
  function( morphism, coarse_morphism )
    local old_morphism_aid, embedding, new_morphism;
    
    old_morphism_aid := MorphismAid( morphism );
    
    if not IsIdenticalObj( Source( old_morphism_aid ), Source( coarse_morphism ) ) then
        
        Error( " cannot coarse this two morphisms\n" );
        
        return fail;
        
    fi;
    
    embedding := Predivide( old_morphism_aid, coarse_morphism );
    
    new_morphism := Precompose( AssociatedMorphism( morphism ), embedding );
    
    return GeneralizedMorphism( new_morphism, coarse_morphism );
    
end );

InstallValue( functor_Coarse,
        CreateHomalgFunctor(
                [ "name", "Coarse" ],
                [ "category", GENERALIZED_MORPHISMS.category ],
                [ "operation", "Coarse" ],
                [ "number_of_arguments", 2 ],
                [ "1", [ [ "covariant" ], [ IsGeneralizedMorphism ] ] ],
                [ "2", [ [ "covariant" ], [ IsHomalgMorphism ] ] ],
                [ "OnObjects", _Functor_Coarse ]
                )
        );

functor_Coarse!.ContainerForWeakPointersOnComputedBasicObjects :=
  ContainerForWeakPointers( TheTypeContainerForWeakPointersOnComputedValuesOfFunctor );

######################
#
# Precompose
#
######################

InstallGlobalFunction( _Functor_PreCompose,
  
  function( psi, phi )
    
    
