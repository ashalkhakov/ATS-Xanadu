(***********************************************************************)
(*                                                                     *)
(*                         Applied Type System                         *)
(*                                                                     *)
(***********************************************************************)

(*
** ATS/Xanadu - Unleashing the Potential of Types!
** Copyright (C) 2020 Hongwei Xi, ATS Trustful Software, Inc.
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

#extern
fun
<a0:vt>
mytest_arg(): a0
#extern
fun
<f0:t0>
<r0:vt>
mytest_fun(fx: f0): r0

(* ****** ****** *)

impltmp
<a0:vt>
mytest_arg = rand<a0>

(* ****** ****** *)

impltmp
<r0:vt>
mytest_fun
<()-<fnp>r0>(f0) = f0()
impltmp
<r0:vt>
mytest_fun
<()-<cfr>r0>(f0) = f0()

(* ****** ****** *)
//
impltmp
<a1:vt>
<r0:vt>
mytest_fun
<(a1)-<fnp>r0>(f0) =
let
val x1 = mytest_arg<a1>() in f0(x1)
end
impltmp
<a1:vt>
<r0:vt>
mytest_fun
<(a1)-<cfr>r0>(f0) =
let
val x1 = mytest_arg<a1>() in f0(x1)
end
//
(* ****** ****** *)

(* end of [mytest.dats] *)
