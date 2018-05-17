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
// Start Time: May, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)

%{#
#include "CATS/location.cats"
%} // end of [%{#]

(* ****** ****** *)

abstbox location_type
typedef loc_t = location_type
typedef location = location_type

(* ****** ****** *)
//
(*
HX: atstflat = atst@ype
*)
abstflat
position_t0ype =
$extype"xats_position_struct"
  typedef pos_t = position_t0ype
  typedef position = position_t0ype
//
(* ****** ****** *)
//
#staload
FIL = "./filepath.sats"
  typedef fil_t = $FIL.filepath
  typedef filepath = $FIL.filepath
//
(* ****** ****** *)

(* end of [xats_location.sats] *)
