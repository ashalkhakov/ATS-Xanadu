(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Postiats - Unleashing the Potential of Types!
** Copyright (C) 2018 Hongwei Xi, ATS Trustful Software, Inc.
** All rights reserved
**
** ATS is free software;  you can  redistribute it and/or modify it under
** the terms of  the GNU GENERAL PUBLIC LICENSE (GPL) as published by the
** Free Software Foundation; either version 3, or (at  your  option)  any
** later version.
** 
** ATS is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without  even  the  implied  warranty  of MERCHANTABILITY or
** FITNESS FOR A PARTICULAR PURPOSE.  See the  GNU General Public License
** for more details.
** 
** You  should  have  received  a  copy of the GNU General Public License
** along  with  ATS;  see the  file COPYING.  If not, please write to the
** Free Software Foundation,  51 Franklin Street, Fifth Floor, Boston, MA
** 02110-1301, USA.
*)

(* ****** ****** *)
//
// Author: Hongwei Xi
// Start Time: August, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#staload
SYM="./../SATS/symbol.sats"
#staload
FIX="./../SATS/fixity.sats"
//
#staload
ENV = "./../SATS/symenv.sats"
//
(* ****** ****** *)

#staload
LOC = "./../SATS/location.sats"
overload + with $LOC.location_combine
overload print with $LOC.print_location

(* ****** ****** *)
//
#staload "./../SATS/basics.sats"
//
#staload "./../SATS/lexing.sats"
//
#staload "./../SATS/staexp0.sats"
#staload "./../SATS/dynexp0.sats"
//
#staload "./../SATS/staexp1.sats"
#staload "./../SATS/dynexp1.sats"
//
#staload "./../SATS/trans01.sats"
//
(* ****** ****** *)
//
stadef
prcdv = $FIX.prcdv
macdef
int2prcdv = $FIX.int2prcdv
//
(* ****** ****** *)
//
macdef
ASSOCnon = $FIX.ASSOCnon()
macdef
ASSOClft = $FIX.ASSOClft()
macdef
ASSOCrgt = $FIX.ASSOCrgt()
//
(* ****** ****** *)

stadef
fxitm = $FIX.fxitm
//
typedef
d1pitm = fxitm(d1pat)
typedef
d1pitmlst = List0(d1pitm)
//
typedef
d1eitm = fxitm(d1exp)
typedef
d1eitmlst = List0(d1eitm)
//
macdef
FXITMatm
(x) = $FIX.FXITMatm(,(x))
macdef
FXITMopr
(x, a) = $FIX.FXITMopr(,(x), ,(a))
//
(* ****** ****** *)

fun
fxitmlst_resolve_d1pat
( loc0: loc_t
, itms: d1pitmlst): d1pat =
(
$FIX.fxitmlst_resolve<d1pat>(loc0, itms)
) where
{
//
implement
$FIX.fxitm_infix<d1pat>
(
x0, f1, x2
) = let
  val loc =
  x0.loc() + x2.loc()
  val d1p_node =
  (
    case+
    f1.node() of
    | D1Papp() =>
      D1Papps(x0, list_sing(x2))
    | _(*non-D1Papp*) =>
      D1Papps(f1, list_pair(x0, x2))
  ) : d1pat_node // end of [val]
in
  FXITMatm(d1pat_make_node(loc, d1p_node))
end // end of [$FIX.fxitm_infix]
//
implement
$FIX.fxitm_prefix<d1pat>
  (f0, x1) = let
in
//
case+
f0.node() of
| D1Pbs0() => let
    val d1p =
    d1pat_make_node
    (x1.loc(), D1Pbs1(x1))
  in
    FXITMopr(d1p, $FIX.infixtemp_fixty)
  end // end of [D1Pbs0]
| _(*non-D1Pbs0*) => let
   val loc =
   f0.loc() + x1.loc()
  in
    FXITMatm
    (
      d1pat_make_node(loc, d1p_node)
    ) where
    {
      val
      d1p_node = D1Papps(f0, list_sing(x1))
    }
  end // end of [non-D1Pbs0]
//
end // end of [$FIX.fxitm_prefix]
//
implement
$FIX.fxitm_postfix<d1pat>
  (x0, f1) = let
  val loc =
  x0.loc() + f1.loc()
in
  FXITMatm
  (
  d1pat_make_node(loc, D1Papps(f1, list_sing(x0)))
  )
end // end of [$FIX.fxitm_postfix]
//
implement
$FIX.fxatm_none<d1pat>
  (loc) =
  d1pat_none(loc)
implement
$FIX.fxopr_get_loc<d1pat>
  (opr) = opr.loc()
//
implement
$FIX.fxitm_get_loc<d1pat>
  (itm) =
(
case+ itm of
| $FIX.FXITMatm(x0) => x0.loc()
| $FIX.FXITMopr(x0, _) => x0.loc()
) (* end of [$FIX.fxitm_get_loc] *)
//
implement
$FIX.fxopr_make_app<d1pat>
  (itm) = let
//
val loc =
$FIX.fxitm_get_loc<d1pat>(itm)
//
val d1p =
d1pat_make_node(loc, D1Papp(*void*))
//
in
  $FIX.FXITMopr(d1p, $FIX.app_fixty)
end // end of [$FIX.fxopr_make_app]
//
} // end of [fxitmlst_resolve_d1pat]

(* ****** ****** *)

fun
fxitmlst_resolve_d1exp
( loc0: loc_t
, itms: d1eitmlst): d1exp =
(
$FIX.fxitmlst_resolve<d1exp>(loc0, itms)
) where
{
//
implement
$FIX.fxitm_infix<d1exp>
(
x0, f1, x2
) = let
  val loc =
  x0.loc() + x2.loc()
  val d1e_node =
  (
    case+
    f1.node() of
    | D1Eapp() =>
      D1Eapps(x0, list_sing(x2))
    | _(*non-D1Eapp*) =>
      D1Eapps(f1, list_pair(x0, x2))
  ) : d1exp_node // end of [val]
in
  FXITMatm(d1exp_make_node(loc, d1e_node))
end // end of [$FIX.fxitm_infix]
//
implement
$FIX.fxitm_prefix<d1exp>
  (f0, x1) = let
in
//
case+
f0.node() of
| D1Ebs0() => let
    val d1e =
    d1exp_make_node
    (x1.loc(), D1Ebs1(x1))
  in
    FXITMopr(d1e, $FIX.infixtemp_fixty)
  end // end of [D1Ebs0]
| _(*non-D1Ebs0*) => let
   val loc =
   f0.loc() + x1.loc()
  in
    FXITMatm
    (
      d1exp_make_node(loc, d1e_node)
    ) where
    {
      val
      d1e_node = D1Eapps(f0, list_sing(x1))
    }
  end // end of [non-D1Ebs0]
//
end // end of [$FIX.fxitm_prefix]
//
implement
$FIX.fxitm_postfix<d1exp>
  (x0, f1) = let
  val loc =
  x0.loc() + f1.loc()
in
  FXITMatm
  (
  d1exp_make_node(loc, D1Eapps(f1, list_sing(x0)))
  )
end // end of [$FIX.fxitm_postfix]
//
implement
$FIX.fxatm_none<d1exp>
  (loc) =
  d1exp_none(loc)
implement
$FIX.fxopr_get_loc<d1exp>
  (opr) = opr.loc()
//
implement
$FIX.fxitm_get_loc<d1exp>
  (itm) =
(
case+ itm of
| $FIX.FXITMatm(x0) => x0.loc()
| $FIX.FXITMopr(x0, _) => x0.loc()
) (* end of [$FIX.fxitm_get_loc] *)
//
implement
$FIX.fxopr_make_app<d1exp>
  (itm) = let
//
val loc =
$FIX.fxitm_get_loc<d1exp>(itm)
//
val d1e =
d1exp_make_node(loc, D1Eapp(*void*))
//
in
  $FIX.FXITMopr(d1e, $FIX.app_fixty)
end // end of [$FIX.fxopr_make_app]
//
} // end of [fxitmlst_resolve_d1exp]

(* ****** ****** *)
//
extern
fun
trans01_qarg: q0arg -> q1arg
and
trans01_qarglst: q0arglst -> q1arglst
//
extern
fun
trans01_atyp: a0typ -> a1typ
and
trans01_atyplst: a0typlst -> a1typlst
//
extern
fun
trans01_darg: d0arg -> d1arg
and
trans01_darglst: d0arglst -> d1arglst
//
extern
fun
trans01_tqarg: tq0arg -> tq1arg
and
trans01_tqarglst: tq0arglst -> tq1arglst
//
(* ****** ****** *)

implement
trans01_qarg
  (q0a0) = let
//
val
loc0 = q0a0.loc()
//
fun
auxids
( ids
: i0dntlst): tokenlst =
(
case+ ids of
| list_nil() =>
  list_nil()
| list_cons(id, ids) =>
  let
    val-
    I0DNTsome(tok) = id.node()
  in
    list_cons(tok, auxids(ids))
  end // end of [list_cons]
)
//
in
//
case+
q0a0.node() of
| Q0ARGsome
  (ids, _, s0t) => let
    val ids = auxids(ids)
    val s1t = trans01_sort(s0t)
  in
    q1arg_make_node(loc0, Q1ARGsome(ids, s1t))
  end // end of [Q0ARGsome]
//
end // end of [trans01_qarg]

implement
trans01_qarglst
  (q0as) =
list_vt2t(q1as) where
{
  val
  q1as =
  list_map<q0arg><q1arg>
    (q0as) where
  {
    implement
    list_map$fopr<q0arg><q1arg> = trans01_qarg
  }
} (* end of [trans01_qarglst] *)

(* ****** ****** *)

implement
trans01_tqarg
  (tq0a) = let
//
val
loc0 = tq0a.loc()
//
in
//
case-
tq0a.node() of
| TQ0ARGsome
  (_, q0as, _) => let
    val q1as = trans01_qarglst(q0as)
  in
    tq1arg_make_node(loc0, TQ1ARGsome(q1as))
  end // end of [TQ0ARGsome]
//
end // end of [trans01_tqarg]

implement
trans01_tqarglst
  (tq0as) =
list_vt2t(tq1as) where
{
  val
  tq1as =
  list_map<tq0arg><tq1arg>
    (tq0as) where
  {
    implement
    list_map$fopr<tq0arg><tq1arg> = trans01_tqarg
  }
} (* end of [trans01_tqarglst] *)

(* ****** ****** *)

implement
trans01_atyp
  (a0t0) = let
//
val
loc0 = a0t0.loc()
//
in
//
case+
a0t0.node() of
| A0TYPsome(s0e, opt) =>
  a1typ_make_node
  ( loc0
  , A1TYPsome(trans01_sexp(s0e), opt))
//
end // end of [trans01_atyp]

implement
trans01_atyplst
  (a0ts) =
list_vt2t(d1as) where
{
  val
  d1as =
  list_map<a0typ><a1typ>
    (a0ts) where
  {
    implement
    list_map$fopr<a0typ><a1typ> = trans01_atyp
  }
} (* end of [trans01_atyplst] *)

(* ****** ****** *)

implement
trans01_darg
  (d0a0) = let
//
val
loc0 = d0a0.loc()
//
in
//
case-
d0a0.node() of
//
| D0ARGsome_sta
  (_, s0qs, _) => let
    val
    s1qs =
    trans01_squalst(s0qs)
  in
    d1arg_make_node(loc0, D1ARGsome_sta(s1qs))
  end // end of [D0ARGsome_sta]
//
| D0ARGsome_dyn1
  (sid) => let
    val-
    I0DNTsome(tok) = sid.node()
  in
    d1arg_make_node(loc0, D1ARGsome_dyn1(tok))
  end // end of [D0ARGsome_dyn1]
| D0ARGsome_dyn2
  (_, arg0, opt1, _) => let
//
    val arg0 =
    trans01_atyplst(arg0)
//
    val opt1 =
    (
    case+ opt1 of
    | None() => None()
    | Some(a0ts) => Some(trans01_atyplst(a0ts))
    ) : a1typlstopt // end of [val]
//
  in
    d1arg_make_node(loc0, D1ARGsome_dyn2(arg0, opt1))
  end // end of [D0ARGsome_dyn2]
//
end // end of [trans01_darg]

datatype
d0arg_node =
| D0ARGnone of token
| D0ARGsome_sta of
  (token, s0qualst, token)
| D0ARGsome_dyn of
  (token, a0typlst, a0typlstopt, token)

implement
trans01_darglst
  (d0as) =
list_vt2t(d1as) where
{
  val
  d1as =
  list_map<d0arg><d1arg>
    (d0as) where
  {
    implement
    list_map$fopr<d0arg><d1arg> = trans01_darg
  }
} (* end of [trans01_darglst] *)

(* ****** ****** *)

local

fun
auxid0
( id0
: d0pid)
: d1pitm = let
//
val loc = id0.loc()
val-
I0DNTsome
  (tok) = id0.node()
//
val tnd = tok.node()
//
in
  case- tnd of
//
  | T_IDENT_alp(nam) => auxid0_IDENT(tok, nam)
  | T_IDENT_sym(nam) => auxid0_IDENT(tok, nam)
//
(*
  | T_IDENT_dlr(nam) => auxid0_IDENT(tok, nam)
  | T_IDENT_srp(nam) => auxid0_IDENT(tok, nam)
*)
//
  | T_BACKSLASH((*void*)) => auxid0_BACKSLASH(tok)
//
end // end of [auxid0]

and
auxid0_IDENT
( tok: token
, nam: string): d1pitm = let
//
val loc = tok.loc()
//
val sym =
$SYM.symbol_make(nam)
val opt =
the_fixtyenv_search(sym)
val d1p0 =
d1pat_make_node(loc, D1Pid(tok))
//
in
case+ opt of
| ~None_vt() =>
   FXITMatm(d1p0)
| ~Some_vt(fxty) =>
  (case+ fxty of
   | $FIX.FIXTYnon() => FXITMatm(d1p0)
   | _(*non-FIXTYnon*) => FXITMopr(d1p0, fxty)
  ) (* end of [Some_vt] *)
end // end of [auxid0_IDENT]

and
auxid0_BACKSLASH
  (tok:token): d1pitm = let
//
val loc = tok.loc()
//
val d1p0 =
  d1pat_make_node(loc, D1Pbs0())
//
in
  FXITMopr(d1p0, $FIX.backslash_fixty)
end // end of [auxid0_BACKSLASH]

(* ****** ****** *)

fun
auxitm
( d0p0
: d0pat)
: d1pitm = let
//
val
loc0 = d0p0.loc()
//
val () =
println!("trans01_dpat:")
val () =
println!("auxitm: loc0 = ", loc0)
val () =
println!("auxitm: d0p0 = ", d0p0)
//
in
//
case-
d0p0.node() of
//
| D0Pid(id0) =>
  (
    auxid0(id0)
  )
//
(*
| D0Pstr(str) => auxstr(str)
*)
//
| D0Papps(d0ps) =>
  FXITMatm(d1p0) where
  {
    val d1ps =
    auxitmlst(d0ps)
    val d1p0 =
    fxitmlst_resolve_d1pat(loc0, d1ps)
  }
//
| D0Pparen _ => auxparen(d0p0)
//
| D0Pnone(_(*tok*)) =>
  FXITMatm(d1p0) where
  {
    val d1p0 = d1pat_make_node(loc0, D1Pnone())
  } (* end of [D0Pnone] *)
//
end // end of [auxitm]

and
auxitmlst
( xs
: d0patlst)
: d1pitmlst =
list_vt2t(ys) where
{
  val ys =
  list_map<d0pat><d1pitm>
    (xs) where
  {
    implement
    list_map$fopr<d0pat><d1pitm>(x) = auxitm(x)
  }
} (* end of [auxitmlst] *)

(* ****** ****** *)

and
auxparen
( d0p0
: d0pat): d1pitm = let
//
val-
D0Pparen
( _
, d0ps1, rparen) = d0p0.node()
//
val
d1p0_node =
(
case+ rparen of
| d0pat_RPAREN_cons0(_) =>
  D1Plist(d1ps1) where
  {
    val d1ps1 = trans01_dpatlst(d0ps1)
  }
| d0pat_RPAREN_cons1(_, d0ps2, _) =>
  D1Plist(d1ps1, d1ps2) where
  {
    val d1ps1 = trans01_dpatlst(d0ps1)
    val d1ps2 = trans01_dpatlst(d0ps2)
  }
) : d1pat_node // end of [val]
//
in
  FXITMatm
  (d1pat_make_node(d0p0.loc(), d1p0_node))
end // end of [auxparen]

(* ****** ****** *)

in (* in-of-local *)

implement
trans01_dpat
  (d0p0) = let
//
(*
val () =
println!
("trans01_dpat: d0p0 = ", d0p0)
*)
//
in
//
case+
auxitm(d0p0) of
| $FIX.FXITMatm(d1p0) => d1p0
| $FIX.FXITMopr(d1p0, fxty) => d1p0
//
end (* end of [trans01_dpat] *)

end // end of [local]

(* ****** ****** *)

local

fun
auxid0
( id0
: d0eid)
: d1eitm = let
//
val loc = id0.loc()
val-
I0DNTsome
  (tok) = id0.node()
//
val tnd = tok.node()
//
in
  case- tnd of
//
  | T_IDENT_alp(nam) => auxid0_IDENT(tok, nam)
  | T_IDENT_sym(nam) => auxid0_IDENT(tok, nam)
//
  | T_IDENT_dlr(nam) => auxid0_IDENT(tok, nam)
(*
  | T_IDENT_srp(nam) => auxid0_IDENT(tok, nam)
*)
//
  | T_BACKSLASH((*void*)) => auxid0_BACKSLASH(tok)
//
end // end of [auxid0]

and
auxid0_IDENT
( tok: token
, nam: string): d1eitm = let
//
val loc = tok.loc()
//
val sym =
$SYM.symbol_make(nam)
val opt =
the_fixtyenv_search(sym)
val d1e0 =
d1exp_make_node(loc, D1Eid(tok))
//
in
case+ opt of
| ~None_vt() =>
   FXITMatm(d1e0)
| ~Some_vt(fxty) =>
  (case+ fxty of
   | $FIX.FIXTYnon() => FXITMatm(d1e0)
   | _(*non-FIXTYnon*) => FXITMopr(d1e0, fxty)
  ) (* end of [Some_vt] *)
end // end of [auxid0_IDENT]

and
auxid0_BACKSLASH
  (tok:token): d1eitm = let
//
val loc = tok.loc()
//
val d1e0 =
  d1exp_make_node(loc, D1Ebs0())
//
in
  FXITMopr(d1e0, $FIX.backslash_fixty)
end // end of [auxid0_BACKSLASH]

fun
auxint
( int
: t0int)
: d1eitm = let
//
val loc = int.loc()
//
val-
T0INTsome(tok) = int.node()
//
in
  FXITMatm
  (d1exp_make_node(loc, D1Eint(tok)))
end // end of [auxint]
and
auxchr
( chr
: t0chr)
: d1eitm = let
//
val loc = chr.loc()
//
val-
T0CHRsome(tok) = chr.node()
//
in
  FXITMatm
  (d1exp_make_node(loc, D1Echr(tok)))
end // end of [auxchr]
and
auxflt
( flt
: t0flt)
: d1eitm = let
//
val loc = flt.loc()
//
val-
T0FLTsome(tok) = flt.node()
//
in
  FXITMatm
  (d1exp_make_node(loc, D1Eflt(tok)))
end // end of [auxflt]
and
auxstr
( str
: t0str)
: d1eitm = let
//
val loc = str.loc()
//
val-
T0STRsome(tok) = str.node()
//
in
  FXITMatm
  (d1exp_make_node(loc, D1Estr(tok)))
end // end of [auxstr]

fun
auxitm
( d0e0
: d0exp)
: d1eitm = let
//
val
loc0 = d0e0.loc()
//
val () =
println!("trans01_dexp:")
val () =
println!("auxitm: loc0 = ", loc0)
val () =
println!("auxitm: d0e0 = ", d0e0)
//
in
//
case-
d0e0.node() of
//
| D0Eid(id0) =>
  (
    auxid0(id0)
  )
//
| D0Eint(int) => auxint(int)
| D0Echr(chr) => auxchr(chr)
| D0Eflt(flt) => auxflt(flt)
| D0Estr(str) => auxstr(str)
//
| D0Eapps(d0es) =>
  FXITMatm(d1e0) where
  {
    val d1es =
    auxitmlst(d0es)
    val d1e0 =
    fxitmlst_resolve_d1exp(loc0, d1es)
  }
//
| D0Eparen _ => auxparen(d0e0)
//
| D0Enone(_(*tok*)) =>
  FXITMatm(d1e0) where
  {
    val d1e0 = d1exp_make_node(loc0, D1Enone())
  } (* end of [D0Enone] *)
//
end // end of [auxitm]

and
auxitmlst
( xs
: d0explst)
: d1eitmlst =
list_vt2t(ys) where
{
  val ys =
  list_map<d0exp><d1eitm>
    (xs) where
  {
    implement
    list_map$fopr<d0exp><d1eitm>(x) = auxitm(x)
  }
} (* end of [auxitmlst] *)

(* ****** ****** *)

and
auxparen
( d0e0
: d0exp): d1eitm = let
//
val-
D0Eparen
( _
, d0es1, rparen) = d0e0.node()
//
val
d1e0_node =
(
case+ rparen of
| d0exp_RPAREN_cons0(_) =>
  D1Elist(d1es1) where
  {
    val d1es1 = trans01_dexplst(d0es1)
  }
| d0exp_RPAREN_cons1(_, d0es2, _) =>
  D1Elist(d1es1, d1es2) where
  {
    val d1es1 = trans01_dexplst(d0es1)
    val d1es2 = trans01_dexplst(d0es2)
  }
) : d1exp_node // end of [val]
//
in
  FXITMatm
  (d1exp_make_node(d0e0.loc(), d1e0_node))
end // end of [auxparen]

(* ****** ****** *)

in (* in-of-local *)

implement
trans01_dexp
  (d0e0) = let
//
(*
val () =
println!
("trans01_dexp: d0e0 = ", d0e0)
*)
//
in
//
case+
auxitm(d0e0) of
| $FIX.FXITMatm(d1e0) => d1e0
| $FIX.FXITMopr(d1e0, fxty) => d1e0
//
end (* end of [trans01_dexp] *)

end // end of [local]

implement
trans01_dexpopt
  (opt) =
(
case+ opt of
| None() => None()
| Some(d0e) => Some(trans01_dexp(d0e))
) (* end of [trans01_dexpopt] *)

implement
trans01_dexplst
  (d0es) =
list_vt2t(d1es) where
{
  val
  d1es =
  list_map<d0exp><d1exp>
    (d0es) where
  {
    implement
    list_map$fopr<d0exp><d1exp> = trans01_dexp
  }
} (* end of [trans01_dexplst] *)

(* ****** ****** *)

extern
fun
trans01_dcstdec: d0cstdec -> d1cstdec
and
trans01_dcstdeclst: d0cstdeclst -> d1cstdeclst

(* ****** ****** *)

local

fun
aux_effs0expopt
( opt
: effs0expopt): effs1expopt =
(
case+ opt of
| EFFS0EXPnone() =>
  EFFS1EXPnone()
| EFFS0EXPsome(s0f, s0e) =>
  EFFS1EXPsome(s1f, s1e) where
  {
    val s1f = trans01_seff(s0f)
    val s1e = trans01_sexp(s0e)
  }
)

fun
aux_teqd0expopt
( opt
: teqd0expopt): teqd1expopt =
(
case+ opt of
| TEQD0EXPnone() =>
  TEQD1EXPnone()
| TEQD0EXPsome(tok, d0e) =>
  TEQD1EXPsome(tok, trans01_dexp(d0e))
)

in (* in-of-local *)

implement
trans01_dcstdec
  (d0c0) = let
//
val
D0CSTDEC(rcd) = d0c0
//
val
loc = rcd.loc
val
nam = rcd.nam
val-
I0DNTsome(tok) = nam.node()
val
arg = trans01_darglst(rcd.arg)
val
res = aux_effs0expopt(rcd.res)
val
def = aux_teqd0expopt(rcd.def)
//
(*
val () =
println!("trans01_dcstdec: nam = ", nam)
val () =
println!("trans01_dcstdec: arg = ", arg)
val () =
println!("trans01_dcstdec: res = ", res)
val () =
println!("trans01_dcstdec: def = ", def)
*)
//
in
  D1CSTDEC
  (@{loc=loc,nam=tok,arg=arg,res=res,def=def})
end // end of [trans01_dcstdec]

end // end of [local]

implement
trans01_dcstdeclst
  (d0cs) =
list_vt2t(d1cs) where
{
  val
  d1cs =
  list_map<d0cstdec><d1cstdec>
    (d0cs) where
  {
    implement
    list_map$fopr<d0cstdec><d1cstdec> = trans01_dcstdec
  }
} (* end of [trans01_dcstdeclst] *)

(* ****** ****** *)

local

(* ****** ****** *)

fun
aux_precopt
(opt: precopt): prcdv =
(
case+ opt of
| PRECOPTnil() =>
  int2prcdv(0)
| PRECOPTsing(tok) => let
    val-
    T_INT1(rep) = tok.node()
  in
    int2prcdv(g0string2int(rep))
  end // end of [PRECOPTsing]
//
| PRECOPTlist(_, toks, _) => int2prcdv(0) // FIXME!!!
//
) (* end of [aux_precopt] *)

(* ****** ****** *)

fun
aux_fixity
(d0c0: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cfixity
( tok0
, opt1
, i0ds) = d0c0.node()
//
val-
T_SRP_FIXITY(knd) = tok0.node()
//
val pval = aux_precopt(opt1)
//
val fxty =
(
ifcase
//
| knd=INFIX =>
  $FIX.FIXTYinf(pval, ASSOCnon)
| knd=INFIXL =>
  $FIX.FIXTYinf(pval, ASSOClft)
| knd=INFIXR =>
  $FIX.FIXTYinf(pval, ASSOCrgt)
//
| knd=PREFIX => $FIX.FIXTYpre(pval)
| knd=POSTFIX => $FIX.FIXTYpos(pval)
//
| _(*deadcode*) => $FIX.FIXTYnon((*void*))
//
) : fixty // end of [val]
//
fun
loop
(xs: i0dntlst): void =
(
case+ xs of
| list_nil() => ()
| list_cons (x0, xs) => let
    val-
    I0DNTsome(tok) = x0.node()
    val nam =
    (
    case- tok.node() of
    | T_IDENT_alp(nam) => nam
    | T_IDENT_sym(nam) => nam
    ) : string // end of [val]
    val sym = $SYM.symbol_make(nam)
  in
    loop(xs) where
    {
      val () =
      the_fixtyenv_insert(sym, fxty)
    }
  end
) (* end of [loop] *)
//
in
  let
    val () = loop(i0ds)
  in
    d1ecl_make_node(loc0, D1Cnone(d0c0))
  end
end // end of [aux_fixity]

fun
aux_nonfix
(d0c0: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cnonfix
(tok0, i0ds) = d0c0.node()
//
fun
loop
(xs: i0dntlst): void =
(
case+ xs of
| list_nil() => ()
| list_cons (x0, xs) => let
    val-
    I0DNTsome(tok) = x0.node()
    val nam =
    (
    case- tok.node() of
    | T_IDENT_alp(nam) => nam
    | T_IDENT_sym(nam) => nam
    ) : string // end of [val]
    val sym = $SYM.symbol_make(nam)
  in
    loop(xs) where
    {
      val () =
      the_fixtyenv_insert(sym, $FIX.FIXTYnon)
    }
  end
) (* end of [loop] *)
//
in
  let
    val () = loop(i0ds)
  in
    d1ecl_make_node(loc0, D1Cnone(d0c0))
  end
end // end of [aux_nonfix]

(* ****** ****** *)

fun
aux_static
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cstatic
(tok, d0c) = d0c0.node()
//
val d1c = trans01_decl(d0c)
//
in
  d1ecl_make_node(loc0, D1Cstatic(tok, d1c))
end // end of [aux_static]
fun
aux_extern
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cextern
(tok, d0c) = d0c0.node()
//
val d1c = trans01_decl(d0c)
//
in
  d1ecl_make_node(loc0, D1Cextern(tok, d1c))
end // end of [aux_extern]

(* ****** ****** *)

fun
aux_include
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cinclude
(tok, d0e) = d0c0.node()
//
val d1e = trans01_dexp(d0e)
//
in
  d1ecl_make_node(loc0, D1Cinclude(tok, d1e))
end // end of [aux_include]

(* ****** ****** *)

fun
aux_staload
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cstaload
(tok, d0e) = d0c0.node()
//
val d1e = trans01_dexp(d0e)
//
in
  d1ecl_make_node(loc0, D1Cstaload(tok, d1e))
end // end of [aux_staload]

(* ****** ****** *)

fun
aux_sortdef
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Csortdef
(knd, tid, _, def0) = d0c0.node()
//
val def1 =
(
case+
def0.node() of
| S0RTDEFsort(s0t) =>
  s1rtdef_make_node
  ( def0.loc()
  , S1RTDEFsort(trans01_sort(s0t)))
| S0RTDEFsubset
  (_, s0a, _, s0es, _) => let
    val s1a = trans01_sarg(s0a)
    val s1es = trans01_sexplst(s0es)
  in
    s1rtdef_make_node
    (def0.loc(), S1RTDEFsubset(s1a, s1es))
  end // end of [S0RTDEFsubset]
) : s1rtdef // end of [val]
//
val-I0DNTsome(tok) = tid.node((*void*))
//
(*
val () =
println!("trans01_decl: ")
val () =
println!("aux_sortdef: tok = ", tok)
val () =
println!("aux_sortdef: def1 = ", def1)
*)
//
in
  d1ecl_make_node(loc0, D1Csortdef(knd, tok, def1))
end // end of [aux_sortdef]

(* ****** ****** *)

fun
aux_sexpdef
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Csexpdef
( knd
, seid
, arg0
, opt0, _, def0) = d0c0.node()
//
val def1 = trans01_sexp(def0)
val opt1 = trans01_sortopt(opt0)
val arg1 = trans01_smarglst(arg0)
val-I0DNTsome(tok) = seid.node((*void*))
//
(*
val () =
println!("trans01_decl:")
val () =
println!("aux_sexpdef: tok = ", tok)
val () =
println!("aux_sexpdef: arg1 = ", arg1)
val () =
println!("aux_sexpdef: opt1 = ", opt1)
val () =
println!("aux_sexpdef: def1 = ", def1)
*)
//
in
  d1ecl_make_node
    (loc0, D1Csexpdef(knd, tok, arg1, opt1, def1))
  // d1ecl_make_node
end // end of [aux_sexpdef]

(* ****** ****** *)

fun
aux_abstype
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cabstype
( knd
, seid, arg0, def0) = d0c0.node()
//
val def1 = aux_abstdef(def0)
val arg1 = trans01_tmarglst(arg0)
val-I0DNTsome(tok) = seid.node((*void*))
//
(*
val () =
println!("trans01_d0ecl: ")
val () =
println!("aux_abstype: tok = ", tok)
val () =
println!("aux_abstype: arg1 = ", arg1)
val () =
println!("aux_abstype: def1 = ", def1)
*)
//
in
  d1ecl_make_node
    (loc0, D1Cabstype(knd, tok, arg1, def1))
  // d1ecl_make_node
end // end of [aux_abstype]

and
aux_abstdef
( def0
: abstdf0): abstdf1 =
(
  case+ def0 of
  | ABSTDF0nil() =>
    ABSTDF1nil()
  | ABSTDF0lteq(tok, s0e) =>
    ABSTDF1lteq(trans01_sexp(s0e))
  | ABSTDF0eqeq(tok, s0e) =>
    ABSTDF1eqeq(trans01_sexp(s0e))
) (* end of [aux_abstdef] *)

(* ****** ****** *)

fun
aux_datasort
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cdatasort
(knd, d0ts) = d0c0.node()
//
val
d1ts =
list_map<d0tsort><d1tsort>
  (d0ts) where
{
  implement
  list_map$fopr<d0tsort><d1tsort>(x) = aux_d0tsort(x)
} (* end of [val] *)
//
val d1ts = list_vt2t{d1tsort}(d1ts)
//
in
  d1ecl_make_node(loc0, D1Cdatasort(knd, d1ts))
end // end of [aux_datasort]

and
aux_d0tsort
( d0t0
: d0tsort): d1tsort =
(
case+
d0t0.node() of
| D0TSORT
  (tid, _, s0cs) => let
    val-
    I0DNTsome(tok) = tid.node()
    val s1cs = trans01_srtconlst(s0cs)
  in
    d1tsort_make_node(d0t0.loc(), D1TSORT(tok, s1cs))
  end
)

(* ****** ****** *)

fun
aux_datatype
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cdatatype
  (knd, d0ts, wd0cs) = d0c0.node()
//
val
d1ts =
list_map<d0atype><d1atype>
  (d0ts) where
{
  implement
  list_map$fopr<d0atype><d1atype>(x) = aux_d0atype(x)
}
val d1ts = list_vt2t(d1ts)
//
val
wd1cs =
(
case+ wd0cs of
| WD0CSnone() => WD1CSnone()
| WD0CSsome(_, _, d0cs, _) =>
  WD1CSsome(trans01_declist(d0cs))
) : wd1eclseq // end of [val]
//
val () =
println!("trans01_decl:")
val () =
println!("aux_datatype: d1ts = ", d1ts)
val () =
println!("aux_datatype: wd1cs = ", wd1cs)
//
in
  d1ecl_make_node(loc0, D1Cdatatype(knd, d1ts, wd1cs))
end // end of [aux_datatype]

and
aux_d0atype
( d0t0
: d0atype): d1atype = let
//
val loc0 = d0t0.loc()
//
in
//
case+
d0t0.node() of
| D0ATYPE
  (deid, arg0, _, d0cs) => let
    val-
    I0DNTsome(tok) = deid.node()
    val arg1 = trans01_tmarglst(arg0)
    val d1cs = trans01_datconlst(d0cs)
  in
    d1atype_make_node(loc0, D1ATYPE(tok, arg1, d1cs))
  end // end of [D0ATYPE]
//
end // end of [aux_d0atype]

(* ****** ****** *)

fun
aux_dynconst
( d0c0
: d0ecl): d1ecl = let
//
val loc0 = d0c0.loc()
//
val-
D0Cdynconst
(knd, tqas, d0cs) = d0c0.node()
//
val tqas = trans01_tqarglst(tqas)
val d1cs = trans01_dcstdeclst(d0cs)
//
in
  d1ecl_make_node
    (loc0, D1Cdynconst(knd, tqas, d1cs))
  // d1ecl_make_node
end // end of [aux_dynconst]

(* ****** ****** *)

in (* in-of-local *)

(* ****** ****** *)

implement
trans01_decl
  (d0c0) = let
//
val
loc0 = d0c0.loc()
//
(*
val () =
println!
("trans01_decl: d0c0 = ", d0c0)
*)
//
in
//
case-
d0c0.node() of
//
| D0Cnone _ => d1ecl_none(d0c0)
//
| D0Cfixity _ => aux_fixity(d0c0)
| D0Cnonfix _ => aux_nonfix(d0c0)
//
| D0Cstatic _ => aux_static(d0c0)
| D0Cextern _ => aux_extern(d0c0)
//
| D0Cinclude _ => aux_include(d0c0)
//
| D0Cstaload _ => aux_staload(d0c0)
//
| D0Csortdef _ => aux_sortdef(d0c0)
//
| D0Csexpdef _ => aux_sexpdef(d0c0)
//
| D0Cabstype _ => aux_abstype(d0c0)
//
| D0Cdatasort _ => aux_datasort(d0c0)
//
| D0Cdatatype _ => aux_datatype(d0c0)
//
| D0Cdynconst _ => aux_dynconst(d0c0)
//
| D0Clocal
  (_, d0cs1, _, d0cs2, _) =>
  let
    val d1cs1 = trans01_declist(d0cs1)
    val d1cs2 = trans01_declist(d0cs2)
  in
    d1ecl_make_node(loc0, D1Clocal(d1cs1, d1cs2))
  end // end of [D0Clocal]
//
| _ (*rest-of-d0ecl*) =>
  (
    println! ("trans01_decl: d0c0 = ", d0c0); exit(1)
  )
    
//
end // end of [trans01_decl]

(* ****** ****** *)

implement
trans01_declist
  (d0cs) =
list_vt2t(d1cs) where
{
  val
  d1cs =
  list_map<d0ecl><d1ecl>
    (d0cs) where
  {
    implement
    list_map$fopr<d0ecl><d1ecl> = trans01_decl
  }
} (* end of [trans01_declist] *)

end // end of [local]

(* ****** ****** *)

(* end of [xats_trans01_dynexp.dats] *)
