#############################################################################
##
##  LIGMOR.gi                    LIGMOR subpackage            Mohamed Barakat
##
##         LIGMOR = Logical Implications for homalg Generalized MORphisms
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implications for generalized Morphisms
##
#############################################################################

##
InstallImmediateMethod( MorphismAidSubobject,
                        [ IsHomalgGeneralizedMorphism and HasMorphismAid ],
                        0,
                          
  function( phi )
    local morphismaid;
    
    morphismaid := MorphismAid( phi );
    
    if HasKernel( morphismaid ) or HasKernelSubobject( morphismaid ) then
        
        return KernelSubobject( morphismaid );
        
    fi;
    
    TryNextMethod();
    
end );

##
InstallImmediateMethod( Kernel,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism and HasAssociatedMorphism ],
               0,
               
  function( phi )
    local associated_morphism;
    
    associated_morphism := AssociatedMorphism( phi );
    
    if HasKernel( associated_morphism )  then
        
        return Kernel( associated_morphism );
        
    fi;
    
    TryNextMethod();
    
end );

##
InstallImmediateMethod( KernelSubobject,
               "for generalized morphisms",
               [ IsHomalgGeneralizedMorphism and HasAssociatedMorphism ],
               0,
               
  function( phi )
    local associated_morphism;
    
    associated_morphism := AssociatedMorphism( phi );
    
    if HasKernelSubobject( associated_morphism )  then
        
        return KernelSubobject( associated_morphism );
        
    fi;
    
    TryNextMethod();
    
end );