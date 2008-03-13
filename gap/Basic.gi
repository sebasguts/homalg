#############################################################################
##
##  Basic.gi                    homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementations of homalg basic procedures.
##
#############################################################################

####################################
#
# methods for operations:
#
####################################

##
InstallMethod( BasisOfRowsCoeff,		### defines: BasisOfRowsCoeff (BasisCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfRowsCoeff) then
        return RP!.BasisOfRowsCoeff( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return BasisOfRows( AddRhs( M ) );
    
end );

##
InstallMethod( BasisOfColumnsCoeff,		### defines: BasisOfRowsCoeff (BasisCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BasisOfColumnsCoeff) then
        return RP!.BasisOfColumnsCoeff( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    return BasisOfColumns( AddBts( M ) );
    
end );

##
InstallMethod( EffectivelyDecideZeroRows,	### defines: EffectivelyDecideZeroRows (ReduceCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( A, B )
    local R, RP, zz, A_zz;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroRows) then
        return RP!.EffectivelyDecideZeroRows( A, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    zz := HomalgMatrix( "zero", NrRows( A ), NrRows( B ), R );
    
    A_zz := AddRhs( A, zz );
    
    return DecideZeroRows( A_zz, AddRhs( B ) );
    
end );

##
InstallMethod( EffectivelyDecideZeroColumns,	### defines: EffectivelyDecideZeroColumns (ReduceCoeff)
        "for a homalg matrix",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( A, B )
    local R, RP, zz, A_zz;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.EffectivelyDecideZeroColumns) then
        return RP!.EffectivelyDecideZeroColumns( A, B );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    zz := HomalgMatrix( "zero", NrColumns( B ), NrColumns( A ), R );
    
    A_zz := AddBts( A, zz );
    
    return DecideZeroColumns( A_zz, AddBts( B ) );
    
end );

##
InstallMethod( SyzygiesBasisOfRows,		### defines: SyzygiesBasisOfRows (SyzygiesBasis)
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP, S;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfRows) then
        return RP!.SyzygiesBasisOfRows( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfRows( M, [ ] );
    
    return BasisOfRows( S );
    
end );

##
InstallMethod( SyzygiesBasisOfRows,		### defines: SyzygiesBasisOfRows (SyzygiesBasis)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP, S;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfRows) then
        return RP!.SyzygiesBasisOfRows( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfRows( M1, M2 );
    
    return BasisOfRows( S );
    
end );

##
InstallMethod( SyzygiesBasisOfColumns,		### defines: SyzygiesBasisOfColumns (SyzygiesBasis)
        "for homalg matrices",
	[ IsHomalgMatrix ],
        
  function( M )
    local R, RP, S;
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfColumns) then
        return RP!.SyzygiesBasisOfColumns( M );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfColumns( M, [ ] );
    
    return BasisOfColumns( S );
    
end );

##
InstallMethod( SyzygiesBasisOfColumns,		### defines: SyzygiesBasisOfColumns (SyzygiesBasis)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( M1, M2 )
    local R, RP, S;
    
    R := HomalgRing( M1 );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.SyzygiesBasisOfColumns) then
        return RP!.SyzygiesBasisOfColumns( M1, M2 );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    S := SyzygiesGeneratorsOfColumns( M1, M2 );
    
    return BasisOfColumns( S );
    
end );

##
InstallMethod( RightDivide,			### defines: RightDivide (RightDivideF)
        "for homalg matrices",
	[ IsHomalgMatrix, IsHomalgMatrix ],
        
  function( B, A )				## CAUTION: Do not use lazy evaluation here!!!
    local R, RP, IA, CA, NF, CB;
    
    R := HomalgRing( B );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.RightDivide) then
        return RP!.RightDivide( B, A );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    ## CA * A = IA
    IA := BasisOfRowsCoeff( A );
    
    CA := RightHandSide( IA );
    
    ## NF = B + CB * IA
    NF := EffectivelyDecideZeroRows( B, IA );
    
    CB := RightHandSide( NF );
    
    ## NF <> 0
    if not IsZeroMatrix( NF ) then
        Error( "The second argument is not a right factor of the first, i.e. the second argument is not a generating set!\n" );
    fi;
    
    ## CD = -CB * CA => CD * A = B
    return -CB * CA;
    
end );

##
InstallMethod( Eval,				### defines: LeftInverse (LeftinverseF)
        "for homalg matrices",
	[ IsHomalgMatrix and HasEvalLeftInverse ],
        
  function( LI )
    local R, RP, RI, Id, left_inv;
    
    R := HomalgRing( LI );
    
    RP := HomalgTable( R );
    
    RI := EvalLeftInverse( LI );
    
    if IsBound(RP!.LeftInverse) then
        left_inv := RP!.LeftInverse( RI );
        SetIsLeftInvertibleMatrix( RI, true );
        
        if HasIsInvertibleMatrix( RI ) and IsInvertibleMatrix( RI ) then
            SetIsInvertibleMatrix( LI, true );
        else
            SetIsRightInvertibleMatrix( LI, true );
        fi;
        
        return left_inv;
    fi;
    
    #=====# begin of the core procedure #=====#
    
    Id := HomalgMatrix( "identity", NrColumns( RI ), R );
    
    left_inv := RightDivide( Id, RI );
    
    ## CAUTION: for the following SetXXX RightDivide is assumed not to be lazy evaluated!!!
    
    SetIsLeftInvertibleMatrix( RI, true );
    
    if HasIsInvertibleMatrix( RI ) and IsInvertibleMatrix( RI ) then
        SetIsInvertibleMatrix( LI, true );
    else
        SetIsRightInvertibleMatrix( LI, true );
    fi;
    
    return Eval( left_inv );
    
end );

##
InstallGlobalFunction( BestBasis,		### defines: BestBasis ( )
  function( arg )
    local M, R, RP, nargs, B, U, V;
    
    if not IsHomalgMatrix( arg[1] ) then
        Error( "expecting a homalg matrix as a first argument, but received ", arg[1], "\n" );
    fi;
    
    M := arg[1];
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
    
    if IsBound(RP!.BestBasis) then
        
        return CallFuncList( RP!.BestBasis, arg );
        
    elif IsBound(RP!.TriangularBasisOfRows) then
        
        nargs := Length( arg );
        
        if nargs > 1 and IsHomalgMatrix( arg[2] ) then ## not BestBasis( M, "", V )
            B := TriangularBasisOfRows( M, arg[2] );
        else
            B := TriangularBasisOfRows( M );
        fi;
        
        if nargs > 2 and IsHomalgMatrix( arg[3] ) then ## not BestBasis( M, U, "" )
            B := TriangularBasisOfColumns( B, arg[3] );
        else
            B := TriangularBasisOfColumns( B );
        fi;
        
        return B;
        
    fi;
    
    TryNextMethod( );
    
end );

##
InstallGlobalFunction( BetterEquivalentMatrix,	### defines: BetterEquivalentMatrix (BetterGenerators) (incomplete)
  function( arg )
    local M, R, RP, nargs, U, V, UI, VI, compute_U, compute_V, compute_UI, compute_VI,
        nar_U, nar_V, nar_UI, nar_VI, m, n, finished, barg, A, CM;
    
    if not IsHomalgMatrix( arg[1] ) then
        Error( "expecting a homalg matrix as a first argument, but received ", arg[1], "\n" );
    fi;
    
    M := arg[1];
    
    R := HomalgRing( M );
    
    RP := HomalgTable( R );
  
    if IsBound(RP!.BetterEquivalentMatrix) then
        return RP!.BetterEquivalentMatrix( arg );
    fi;
    
    nargs := Length( arg );
    
    if nargs = 1 then
        ## BetterEquivalentMatrix(M)
        compute_U := false;
        compute_V := false;
        compute_UI := false;
        compute_VI := false;
    elif nargs = 2 and IsHomalgMatrix( arg[2] ) then
        ## BetterEquivalentMatrix(M,V)
        compute_U := false;
        compute_V := true;
        compute_UI := false;
        compute_VI := false;
        nar_V := 2;
    elif nargs > 2 and IsHomalgMatrix( arg[2] ) and IsString( arg[3] ) then
        ## BetterEquivalentMatrix(M,VI,"")
        compute_U := false;
        compute_V := false;
        compute_UI := false;
        compute_VI := true;
        nar_VI := 2;
    elif nargs > 4 and IsHomalgMatrix( arg[2] ) and IsHomalgMatrix( arg[3] )
      and IsString( arg[4] ) and IsString( arg[5] ) then
        ## BetterEquivalentMatrix(M,V,VI,"","")
        compute_U := false;
        compute_V := true;
        compute_UI := false;
        compute_VI := true;
        nar_V := 2;
        nar_VI := 3;
    elif nargs > 5 and IsHomalgMatrix( arg[2] ) and IsHomalgMatrix( arg[3] )
      and IsString( arg[4] ) and IsString( arg[5] ) and IsString( arg[6] ) then
        ## BetterEquivalentMatrix(M,U,UI,"","","")
        compute_U := true;
        compute_V := false;
        compute_UI := true;
        compute_VI := false;
        nar_U := 2;
        nar_UI := 3;
    elif nargs > 3 and IsHomalgMatrix( arg[2] ) and IsHomalgMatrix( arg[3] )
      and IsString( arg[5] ) then
        ## BetterEquivalentMatrix(M,UI,VI,"")
        compute_U := false;
        compute_V := false;
        compute_UI := true;
        compute_VI := true;
        nar_UI := 2;
        nar_VI := 3;
    elif nargs > 4 and IsHomalgMatrix( arg[2] ) and IsHomalgMatrix( arg[3] )
      and IsHomalgMatrix( arg[4] ) and IsHomalgMatrix( arg[5] ) then
        ## BetterEquivalentMatrix(M,U,V,UI,VI)
        compute_U := true;
        compute_V := true;
        compute_UI := true;
        compute_VI := true;
        nar_U := 2;
        nar_V := 3;
        nar_UI := 4;
        nar_VI := 5;
    elif IsHomalgMatrix( arg[2] ) and IsHomalgMatrix( arg[3] ) then
        ## BetterEquivalentMatrix(M,U,V)
        compute_U := true;
        compute_V := true;
        compute_UI := false;
        compute_VI := false;
        nar_U := 2;
        nar_V := 3;
    else
        Error( "Wrong input!\n" );
    fi;
    
    m := NrColumns( M );
    n := NrRows( M );
    
    finished := false;
    
    if compute_U or compute_UI then
        U := HomalgMatrix( "void", R );
    fi;
        
    if compute_V or compute_VI then
        V := HomalgMatrix( "void", R );
    fi;
    
    #=====# begin of the core procedure #=====#
    
    if IsZeroMatrix( M ) then
        
        if compute_U then
            U := HomalgMatrix( "identity", NrRows( M ), R );
        fi;
        
        if compute_V then
            V := HomalgMatrix( "identity", NrColumns( M ), R );
        fi;
        
        if compute_UI then
            UI := HomalgMatrix( "identity", NrRows( M ), R );
        fi;
        
        if compute_VI then
            VI := HomalgMatrix( "identity", NrColumns( M ), R );
        fi;
        
        finished := true;
        
    fi;
    
    if not finished
       and ( IsBound( RP!.BestBasis )
             or IsBound( RP!.TriangularBasisOfRows )
             or IsBound( RP!.TriangularBasisOfColumns ) ) then
        
        if not ( compute_U or compute_UI or compute_V or compute_VI ) then
            barg := [ M ];
        elif ( compute_U or compute_UI ) and not ( compute_V or compute_VI ) then
            barg := [ M, U ];
        elif ( compute_V or compute_VI ) and not ( compute_U or compute_UI ) then
            barg := [ M, "", V ];
        else
            barg := [ M, U, V ];
        fi;
        
        M := CallFuncList( BestBasis, barg );
        
        ## FIXME:
        #if ( compute_V or compute_VI ) then
        #    if IsList( V ) and V <> [] and IsString( V[1] ) then
        #        if LowercaseString( V[1]{[1..3]} ) = "inv" then
        #            VI := V[2];
        #            if compute_V then
        #                V := LeftInverse( VI, arg[1], "NO_CHECK");
        #            fi;
        #        else
        #            Error( "Cannot interpret the first string in V ", V[1], "\n" );
        #        fi;
        #    fi;
        #fi;
        
        if compute_UI then
            if IsString( U ) then
                UI := U;
            else
                UI := LeftInverse( U );
            fi;
        fi;
        
        if compute_VI and not IsBound( VI ) then
            VI := LeftInverse( V );
        fi;
    
        A := BasisOfRowsCoeff( M );
        
        CM := RightHandSide( A );
        
        if compute_U and not IsString( U ) then
            U := CM * U;
        fi;
        
        if compute_UI and not IsString( UI ) then
            RightDivide( M, A );
            UI := UI * last;
        fi;
        
        M := A;
	
    fi;
    
    if compute_U then
        SetPreEval( arg[nar_U], U );
    fi;
    
    if compute_V then
        SetPreEval( arg[nar_V], V );
    fi;
    
    if compute_UI then
        SetPreEval( arg[nar_UI], UI );
    fi;
    
    if compute_VI then
        SetPreEval( arg[nar_VI], VI );
    fi;
    
    return M;
    
end );
