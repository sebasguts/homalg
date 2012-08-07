#############################################################################
##
##  HomalgGeneralizedMorphism.gi  homalg package             Mohamed Barakat
##                                                         Sebastian Gutsche
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Implementations for generalized morphisms of modules.
##
#############################################################################

##
InstallValue( GENERALIZED_MORPHISMS,
        rec(
            category := rec(
                            description := "generalized morphisms",
                            short_description := "generalized morphisms"
                            )
            )
);

#################################
##
## Representations, families and types
##
#################################

DeclareRepresentation( "IsGeneralizedMorphismOfFinitelyGeneratedObjectsRep",
         IsHomalgGeneralizedMorphism and IsAttributeStoringRep,
         [ ] );

DeclareRepresentation( "IsHomalgCategoryOfGeneralizedMorphismsRep",
         IsHomalgCategoryOfGeneralizedMorphisms,
         [ ] );

####################################
#
# properties:
#
####################################

# a new family
BindGlobal( "TheFamilyOfHomalgGeneralizedMorphism",
        NewFamily( "TheFamilyOfHomalgGeneralizedMorphism" ) );

# a new types:
BindGlobal( "TheTypeHomalgGeneralizedMorphism",
        NewType( TheFamilyOfHomalgGeneralizedMorphism,
                IsGeneralizedMorphismOfFinitelyGeneratedObjectsRep ) );

BindGlobal( "TheTypeCategoryOfHomalgGeneralizedMorphisms",
        NewType( TheFamilyOfHomalgCategories,
                IsHomalgCategoryOfGeneralizedMorphismsRep ) );

####################################
#
# properties
#
####################################

##
InstallMethod( IsGeneralizedEpimorphism,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return IsEpimorphism( AssociatedMorphism( phi ) );
    
end );

##
InstallMethod( IsGeneralizedMonomorphism,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return IsMonomorphism( AssociatedMorphism( phi ) );
    
end );

##
InstallMethod( IsGeneralizedIsomorphism,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return IsIsomorphism( AssociatedMorphism( phi ) );
    
end );

##
InstallMethod( WasCoarsedEffective,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    local coarsed_from;
    
    coarsed_from := IsCoarsedOf( phi );
    
    if coarsed_from <> fail then
        
        return IsEffectiveCoarsening( coarsed_from[ 1 ], coarsed_from[ 2 ] );
        
    fi;
        
    return false;
    
end );

##
InstallMethod( MorphismAidIsMonomorphism,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return IsMonomorphism( MorphismAid( phi ) );
    
end );

####################################
#
# attributes:
#
####################################

##
InstallMethod( MorphismAidSubobject,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return KernelSubobject( MorphismAid( phi ) );
    
end );

##
InstallMethod( Kernel,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return Kernel( AssociatedMorphism( phi ) );
    
end );

##
InstallMethod( KernelSubobject,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return KernelSubobject( AssociatedMorphism( phi ) );
    
end );

##
InstallMethod( HomalgCategory,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return HomalgCategory( Source( phi ) );
    
end );

##
InstallMethod( CombinedImage,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    local image_morphism, image_projection, combination_of_morphisms;
    
    image_morphism := ImageObjectEmb( AssociatedMorphism( phi ) );
    
    image_projection := CokernelEpi( image_morphism );
    
    combination_of_morphisms := PreCompose( MorphismAid( phi ), image_projection );
    
    return UnderlyingObject( KernelSubobject( combination_of_morphisms ) );
    
end );

##
InstallMethod( IsCoarsedOf,
               "the fallback method for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    
    return fail;
    
end );

##
InstallMethod( GeneralizedInverse,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],
               
  function( phi )
    local range_object;
    
    if not IsGeneralizedEpimorphism( phi ) then
        
        Error( "cannot compute generalized inverse, map is no epimorphism\n" );
        
    fi;
    
    range_object := Range( phi );
    
    return PostDivide( phi, TheGeneralizedIdentityMorphism( range_object ) );
    
end );

######################################
#
# Methods
#
######################################

##
InstallMethod( EQ,
               "for generalized morphism, this is not quasi-equal",
               [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ],
               
  function( phi, psi )
    
    return IsIdenticalObj( phi, psi );
    
end );

######################################
#
# Constructors
#
######################################

##
InstallMethod( GeneralizedMorphism,
               "for a morphism and a projection",
               [ IsHomalgMorphism, IsHomalgMorphism ],
               
  function( associated_morphism, morphism_aid )
    local morphism;
    
    if not IsIdenticalObj( Range( associated_morphism ), Range( morphism_aid ) ) then
        
        morphism_aid := CokernelEpi( morphism_aid );
        
        if not IsIdenticalObj( Range( associated_morphism ), Range( morphism_aid ) ) then
            
            Error( " the maps are not compatible\n" );
            
        fi;
        
    fi;
    
    morphism := rec( );
    
    ObjectifyWithAttributes( morphism, TheTypeHomalgGeneralizedMorphism,
                             Range, Source( morphism_aid ),
                             Source, Source( associated_morphism ),
                             AssociatedMorphism, associated_morphism,
                             MorphismAid, morphism_aid
                            );
    
    return morphism;
    
end );

#########################################
#
# Display
#
#########################################

##
InstallMethod( ViewObj,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],

  function( phi )

    Print( "<A generalized mophism>" );

end );

##
InstallMethod( Display,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism ],

  function( phi )

    Print( "A generalized morphism.\n" );

end );
