#############################################################################
##
##  HomalgGeneralizedMorphism.gd  homalg package             Mohamed Barakat
##                                                         Sebastian Gutsche
##
##  Copyright 2007-2010, Mohamed Barakat, University of Kaiserslautern
##
##  Declarations for generalized morphisms of modules.
##
#############################################################################

DeclareGlobalVariable( "GENERALIZED_MORPHISMS" );

##  <#GAPDoc Label="IsHomalgMorphism">
##  <ManSection>
##    <Filt Type="Category" Arg="phi" Name="IsHomalgMorphism"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      This is the &GAP;-category of generalized morphisms.
##      A generalized morphism phi: A -> B is a tuple (psi, pi) with
##      an epimorphism pi: B -> C and a morphism psi: A -> C. Normally,
##      C is assumed to be a quotient of B.
##    <Listing Type="Code"><![CDATA[
DeclareCategory( "IsHomalgGeneralizedMorphism",
                 IsObject );
##  ]]></Listing>
##    </Description>
##  </ManSection>
##  <#/GAPDoc>

DeclareCategory( "IsHomalgCategoryOfGeneralizedMorphisms",
                 IsHomalgCategory );

####################################
#
# properties:
#
####################################

DeclareProperty( "twitter",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="IsGeneralizedMorphism">
##  <ManSection>
##    <Prop Arg="phi" Name="IsGeneralizedMorphism"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Check if <A>phi</A> is a generalized morphism.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty( "IsGeneralizedMorphism",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="IsGeneralizedEpimorphism">
##  <ManSection>
##    <Prop Arg="phi" Name="IsGeneralizedEpimorphism"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Check if <A>phi</A> is a generalized epimorphism.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty( "IsGeneralizedEpimorphism",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="IsGeneralizedMonomorphism">
##  <ManSection>
##    <Prop Arg="phi" Name="IsGeneralizedMonomorphism"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Check if <A>phi</A> is a generalized monomorphism.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty( "IsGeneralizedMonomorphism",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="IsGeneralizedIsomorphism">
##  <ManSection>
##    <Prop Arg="phi" Name="IsGeneralizedIsomorphism"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Check if <A>phi</A> is a generalized isomorphism.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty( "IsGeneralizedIsomorphism",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="IsOne">
##  <ManSection>
##    <Prop Arg="phi" Name="IsOne"/>
##    <Returns><C>true</C> or <C>false</C></Returns>
##    <Description>
##      Check if the &homalg; morphism <A>phi</A> is the identity morphism.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareProperty( "IsOne",
        IsHomalgGeneralizedMorphism );

##FIXME: Make a PullProperty from this.
DeclareProperty( "MorphismAidIsMonomorphism",
        IsHomalgGeneralizedMorphism );

####################################
#
# attributes:
#
####################################

DeclareAttribute( "Genesis",
        IsHomalgGeneralizedMorphism, "mutable" );

##  <#GAPDoc Label="Source">
##  <ManSection>
##    <Attr Arg="phi" Name="Source"/>
##    <Returns>a &homalg; object</Returns>
##    <Description>
##      The source of the &homalg; morphism <A>phi</A>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "Source",
        IsHomalgGeneralizedMorphism );

##  <#GAPDoc Label="Range">
##  <ManSection>
##    <Attr Arg="phi" Name="Range"/>
##    <Returns>a &homalg; object</Returns>
##    <Description>
##      The target (range) of the &homalg; morphism <A>phi</A>.
##    </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareAttribute( "Range",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "AssociatedMorphism",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "MorphismAid",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "MorphismAidSubobject",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "GeneralizedInverse",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "KernelSubobject",
        IsHomalgGeneralizedMorphism );

DeclareAttribute( "CombinedImage",
        IsHomalgGeneralizedMorphism );

####################################
#
# methods:
#
####################################

DeclareOperation( "Coarse",
       [ IsHomalgGeneralizedMorphism, IsHomalgObjectOrMorphism ] );

DeclareOperation( "IsEffectiveCoarsening",
       [ IsHomalgGeneralizedMorphism, IsHomalgObjectOrMorphism ] );

DeclareOperation( "CommonCoarsening",
       [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ] );

DeclareOperation( "IsEffectiveCommonCoarsening",
       [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ] );

DeclareOperation( "QuasiEqual",
       [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ] );

DeclareOperation( "Divides",
       [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ] );

DeclareOperation( "PostDivide",
       [ IsHomalgGeneralizedMorphism, IsHomalgGeneralizedMorphism ] );

DeclareOperation( "TheGeneralizedIdentityMorphism",
       [ IsHomalgObject ] );

DeclareOperation( "HomalgMorphism",
       [ IsHomalgGeneralizedMorphism ] );

####################################
#
# Constructors
#
####################################

DeclareOperation( "GeneralizedMorphism",
       [ IsHomalgMorphism, IsHomalgObjectOrMorphism ] );

##TODO: Hey, I just recognize,
##      The aid is mono
##      so change my type to
##      morphism maybe?

##     Implement a method to change type to morphism if needed.