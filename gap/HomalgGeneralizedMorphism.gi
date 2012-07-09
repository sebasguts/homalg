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

######################################
#
# Methods
#
######################################

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
        
        morphism_aid := CokernelEmb( morphism_aid );
        
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
  