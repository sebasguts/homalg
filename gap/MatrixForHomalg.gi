#############################################################################
##
##  MatrixForHomalg.gi          homalg package               Mohamed Barakat
##
##  Copyright 2007-2008 Lehrstuhl B für Mathematik, RWTH Aachen
##
##  Implementation stuff for homalg matrices.
##
#############################################################################

####################################
#
# representations:
#
####################################

# two new representations for the category IsMatrixForHomalg:
DeclareRepresentation( "IsHomalgInternalMatrixRep",
        IsMatrixForHomalg,
        [ ] );

DeclareRepresentation( "IsHomalgExternalMatrixRep",
        IsMatrixForHomalg,
        [ ] );

####################################
#
# families and types:
#
####################################

# a new family:
BindGlobal( "HomalgMatricesFamily",
        NewFamily( "HomalgMatricesFamily" ));

# two new types:
BindGlobal( "HomalgInternalMatrixType",
        NewType( HomalgMatricesFamily ,
                IsHomalgInternalMatrixRep ));

BindGlobal( "HomalgExternalMatrixType",
        NewType( HomalgMatricesFamily ,
                IsHomalgExternalMatrixRep ));

####################################
#
# methods for properties:
#
####################################

##
InstallMethod( IsEmptyMatrix,
        "for homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( M )
    
    if NrRows( M ) = 0 or NrColumns( M ) = 0 then
        return true;
    else
        return false;
    fi;
    
end );


####################################
#
# methods for operations:
#
####################################

##
InstallMethod( HomalgRing,
        "for homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( M )
    
    return M!.ring;
    
end );

##
InstallMethod( CertainRows,
        "for homalg matrices",
        [ IsMatrixForHomalg, IsList ],
        
  function( M, plist )
    local R, C;
    
    if not IsSubset( [ 1 .. NrRows( M ) ], plist ) then
        Error( "the list of row positions ", plist, " must be in the range [ 1 .. ", NrRows( M ), " ]\n" );
    fi;
    
    if NrRows( M ) = 0 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    if IsHomalgInternalMatrixRep( M ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalCertainRows( C, [ M, plist ] );
    
    SetNrRows( C, Length( plist ) );
    SetNrColumns( C, NrColumns( M ) );
    
    return C;
    
end );

##
InstallMethod( Involution,
        "for homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( M )
    local R, C;
    
    R := HomalgRing( M );
    
    if IsHomalgInternalMatrixRep( M ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalInvolution( C, M );
    
    SetNrRows( C, NrColumns( M ) );
    SetNrColumns( C, NrRows( M ) );
    
    if HasIsFullColumnRankMatrix( M ) then
        if IsFullColumnRankMatrix( M ) then
            SetIsFullRowRankMatrix( C, true );
        else
            SetIsFullRowRankMatrix( C, false );
        fi;
    fi;
    
    if HasIsFullRowRankMatrix( M ) then
        if IsFullRowRankMatrix( M ) then
            SetIsFullColumnRankMatrix( C, true );
        else
            SetIsFullColumnRankMatrix( C, false );
        fi;
    fi;
    
    if HasRowRankOfMatrix( M ) then
        SetColumnRankOfMatrix( C, RowRankOfMatrix( M ) );
    fi;
    
    if HasColumnRankOfMatrix( M ) then
        SetRowRankOfMatrix( C, ColumnRankOfMatrix( M ) );
    fi;
    
    return C;
    
end );

##
InstallMethod( CertainColumns,
        "for homalg matrices",
        [ IsMatrixForHomalg, IsList ],
        
  function( M, plist )
    local R, C;
    
    if not IsSubset( [ 1 .. NrColumns( M ) ], plist ) then
        Error( "the list of column positions ", plist, " must be in the range [ 1 .. ", NrColumns( M ), " ]\n" );
    fi;
    
    if NrColumns( M ) = 0 then
        return M;
    fi;
    
    R := HomalgRing( M );
    
    if IsHomalgInternalMatrixRep( M ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalCertainColumns( C, [ M, plist ] );
    
    SetNrRows( C, NrRows( M ) );
    SetNrColumns( C, Length( plist ) );
    
    return C;
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalUnionOfRows( C, [ A, B ] );
    
    SetNrRows( C, NrRows( A ) + NrRows( B ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsEmptyMatrix ],
        
  function( A, B )
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return A;
    
end );

##
InstallMethod( UnionOfRows,
        "of two homalg matrices",
        [ IsEmptyMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return B;
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalUnionOfColumns( C, [ A, B ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) + NrColumns( B ) );
    
    return C;
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsEmptyMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    return B;
    
end );

##
InstallMethod( UnionOfColumns,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsEmptyMatrix ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    return A;
    
end );

##
InstallMethod( DiagMat,
        "of two homalg matrices",
        [ IsHomogeneousList ],
        
  function( l )
    local R, C;
    
    if l = [] then
        Error( "recieved an empty list\n" );
    fi;
    
    if not ForAll( l, IsMatrixForHomalg ) then
        Error( "at least one of the matrices in the list is not a homalg matrix\n" );
    fi;
    
    R := HomalgRing( l[1] );
    
    if ForAll( l, IsHomalgInternalMatrixRep ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalDiagMat( C, l );
    
    SetNrRows( C, Sum( List( l, NrRows ) ) );
    SetNrColumns( C, Sum( List( l, NrColumns ) ) );
    
    return C;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsRingElement, IsMatrixForHomalg ],
        
  function( a, A )
    local R, C;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalMulMat( C, [ a, A ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( \*,
        "of homalg matrices with ring elements",
        [ IsRingElement and IsZero, IsMatrixForHomalg ],
        
  function( a, A )
    local R;
    
    R := HomalgRing( A );
    
    return MatrixForHomalg( "zero", NrRows( A ), NrColumns( A ), R );
    
end );

##
InstallMethod( \*,
        "of homalg matrices with ring elements",
        [ IsRingElement and IsOne, IsMatrixForHomalg ],
        
  function( a, A )
    
    return A;
    
end );

##
InstallMethod( \*,
        "of homalg matrices",
        [ IsRingElement, IsMatrixForHomalg and IsZeroMatrix ],
        
  function( a, A )
    
    return A;
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalAddMat( C, [ A, B ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsMatrixForHomalg and IsZeroMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return B;
    
end );

##
InstallMethod( \+,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg and IsZeroMatrix ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return A;
    
end );

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseSameMutability,
        "of homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( A )
    local R;
    
    R := HomalgRing( A );
    
    return MinusOne( R ) * A;
    
end );

## a synonym of `-<elm>':
InstallMethod( AdditiveInverseSameMutability,
        "of homalg matrices",
        [ IsMatrixForHomalg and IsZeroMatrix ],
        
  function( A )
    
    return A;
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not substractable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not substractable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalSubMat( C, [ A, B ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsMatrixForHomalg and IsZeroMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return -B;
    
end );

##
InstallMethod( \-,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg and IsZeroMatrix ],
        
  function( A, B )
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), "\n" );
    fi;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the two matrices are not summable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), "\n" );
    fi;
    
    return A;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalCompose( C, [ A, B ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( B ) );
    
    return C;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsMatrixForHomalg and IsZeroMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    local R;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    R := HomalgRing( A );
    
    return MatrixForHomalg( "zero", NrRows( A ), NrColumns( B ), R );
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg and IsZeroMatrix ],
        
  function( A, B )
    local R;
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    R := HomalgRing( B );
    
    return MatrixForHomalg( "zero", NrRows( A ), NrColumns( B ), R );
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsIdentityMatrix, IsMatrixForHomalg ],
        
  function( A, B )
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    return B;
    
end );

##
InstallMethod( \*,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsIdentityMatrix ],
        
  function( A, B )
    
    if NrColumns( A ) <> NrRows( B ) then
        Error( "the two matrices are not composable, since the first one has ", NrColumns( A ), " column(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    return A;
    
end );

##
InstallMethod( AddRhs,
        "of homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( A )
    local R, C;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalAddRhs( C, A );
    SetRightHandSide( C, MatrixForHomalg( "identity", NrRows( A ), R ) );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( AddRhs,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrRows( A ) <> NrRows( B ) then
        Error( "the second matrix cannot become a right hand side of the first, since the first one has ", NrRows( A ), " row(s), while the second ", NrRows( B ), " row(s)\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalAddRhs( C, A );
    SetRightHandSide( C, B );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( AddBts,
        "of homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( A )
    local R, C;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalAddBts( C, A );
    SetBottomSide( C, MatrixForHomalg( "identity", NrColumns( A ), R ) );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( AddBts,
        "of two homalg matrices",
        [ IsMatrixForHomalg, IsMatrixForHomalg ],
        
  function( A, B )
    local R, C;
    
    if NrColumns( A ) <> NrColumns( B ) then
        Error( "the second matrix cannot become a bottom side of the first, since the first one has ", NrColumns( A ), " column(s), while the second ", NrColumns( B ), " column(s)\n" );
    fi;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) and IsHomalgInternalMatrixRep( B ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalAddBts( C, A );
    SetBottomSide( C, B );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

##
InstallMethod( GetSide,
        "of homalg matrices",
        [ IsString, IsMatrixForHomalg ],
        
  function( side, A )
    local R, C;
    
    R := HomalgRing( A );
    
    if IsHomalgInternalMatrixRep( A ) then
        C := MatrixForHomalg( "internal", R );
    else
        C := MatrixForHomalg( "external", R );
    fi;
    
    SetEvalGetSide( C, [ side, A ] );
    
    SetNrRows( C, NrRows( A ) );
    SetNrColumns( C, NrColumns( A ) );
    
    return C;
    
end );

####################################
#
# constructor functions and methods:
#
####################################

InstallGlobalFunction( MatrixForHomalg,
  function( arg )
    local nar, R, matrix, M;
    
    nar := Length( arg );
    
    R := arg[nar];
    
    if not IsRingForHomalg( R ) then
        Error( "the last argument must be an IsRingForHomalg" );
    fi;
    
    matrix := rec( ring := R );
    
    ## an empty matrix:
    if IsString( arg[1] ) and Length( arg[1] ) > 2 then
        if LowercaseString( arg[1]{[1..3]} ) = "int" then
            
            ## Objectify:
            Objectify( HomalgInternalMatrixType, matrix );
            
            return matrix;
            
        elif LowercaseString( arg[1]{[1..3]} ) = "ext" then
            ## Objectify:
            Objectify( HomalgExternalMatrixType, matrix );
            
            return matrix;
            
        fi;
    fi;
    
    ## the identity matrix:
    if IsString( arg[1] ) and Length( arg[1] ) > 1 and  LowercaseString( arg[1]{[1..2]} ) = "id" then
        
        ## Objectify:
        ObjectifyWithAttributes(
                matrix, HomalgInternalMatrixType,
                IsIdentityMatrix, true,
                IsFullRowRankMatrix, true,
                IsFullColumnRankMatrix, true );
        
        if Length( arg ) > 2 and IsPosInt( arg[2] ) then
            SetNrRows( matrix, arg[2] );
            SetNrColumns( matrix, arg[2] );
            SetRowRankOfMatrix( matrix, arg[2] );
            SetColumnRankOfMatrix( matrix, arg[2] );
        fi;
        
        return matrix;
        
    fi;
    
    ## the zero matrix:
    if IsString( arg[1] ) and Length( arg[1] ) > 3 and LowercaseString( arg[1]{[1..4]} ) = "zero" then
        
        ## Objectify:
        ObjectifyWithAttributes(
                matrix, HomalgInternalMatrixType,
                IsZeroMatrix, true );
        
        if Length( arg ) > 2 and IsInt( arg[2] ) and arg[2] >= 0 then
            SetNrRows( matrix, arg[2] );
            if arg[2] = 0 then
                SetIsFullRowRankMatrix( matrix, true );
                SetIsEmptyMatrix( matrix, true );
            fi;
	    if Length( arg ) > 3 and IsInt( arg[3] ) and arg[3] >=0 then
                SetNrColumns( matrix, arg[3] );
                if arg[3] = 0 then
                    SetIsFullColumnRankMatrix( matrix, true );
                    SetIsEmptyMatrix( matrix, true );
                fi;
            fi;
            SetRowRankOfMatrix( matrix, 0 );
            SetColumnRankOfMatrix( matrix, 0 );
        fi;
        
        return matrix;
        
    fi;
        
    if IsList( arg[1] ) and Length( arg[1] ) <> 0 and not IsList( arg[1][1] ) then
        M := List( arg[1], a -> [a] ); ## NormalizeInput
    else
        M := arg[1];
    fi;
    
    if IsList( arg[1] ) then ## HomalgInternalMatrixType
        
        ## Objectify:
        ObjectifyWithAttributes(
                matrix, HomalgInternalMatrixType,
                Eval, M );
        
        if Length( arg[1] ) = 0 then
            SetNrRows( matrix, 0 );
            SetNrColumns( matrix, 0 );
            SetIsZeroMatrix( matrix, true );
        elif arg[1][1] = [] then
            SetNrRows( matrix, Length( arg[1] ) );
            SetNrColumns( matrix, 0 );
            SetIsZeroMatrix( matrix, true );
        elif not IsList( arg[1][1] ) then
            SetNrRows( matrix, Length( arg[1] ) );
            SetNrColumns( matrix, 1 );
        elif IsMatrix( arg[1] ) then
            SetNrRows( matrix, Length( arg[1] ) );
            SetNrColumns( matrix, Length( arg[1][1] ) );
        fi;
    else ## HomalgExternalMatrixType
        
        ## Objectify:
        ObjectifyWithAttributes(
                matrix, HomalgExternalMatrixType,
                Eval, M );
        
    fi;
    
    return matrix;
    
end );
  
####################################
#
# View, Print, and Display methods:
#
####################################

InstallMethod( ViewObj,
        "for homalg matrices",
        [ IsMatrixForHomalg and IsZeroMatrix ],
        
  function( o )
    
    Print( "<A homalg " );
    
    if IsHomalgInternalMatrixRep( o ) then
        Print( "internal " );
    else
        Print( "external " );
    fi;
    
    if HasNrRows( o ) then
        Print( NrRows( o ), " " );
    fi;
    
    if HasNrColumns( o ) then
        Print( "by ", NrColumns( o ), " " );
    fi;
    
    Print( "zero matrix>" );
    
end );

InstallMethod( ViewObj,
        "for homalg matrices",
        [ IsMatrixForHomalg and IsIdentityMatrix ],
        
  function( o )
    
    Print( "<A homalg " );
    
    if IsHomalgInternalMatrixRep( o ) then
        Print( "internal " );
    else
        Print( "external " );
    fi;
    
    if HasNrRows( o ) then
        Print( NrRows( o ), " " );
    fi;
    
    if HasNrColumns( o ) then
        Print( "by ", NrColumns( o ), " " );
    fi;
    
    Print( "identity matrix>" );
    
end );

InstallMethod( ViewObj,
        "for homalg matrices",
        [ IsMatrixForHomalg ],
        
  function( o )
    
    Print( "<A homalg " );
    
    if IsHomalgInternalMatrixRep( o ) then
        Print( "internal " );
    else
        Print( "external " );
    fi;
    
    if HasNrRows( o ) then
        Print( NrRows( o ), " " );
    fi;
    
    if HasNrColumns( o ) then
        Print( "by ", NrColumns( o ), " " );
    fi;
    
    Print( "matrix>" );
    
end );

InstallMethod( Display,
        "for homalg matrices",
        [ IsHomalgInternalMatrixRep ],
        
  function( o )
    
    Print( Eval( o ), "\n" );
    
end);
