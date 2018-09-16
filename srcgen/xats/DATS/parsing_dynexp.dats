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
// Start Time: June, 2018
// Authoremail: gmhwxiATgmailDOTcom
//
(* ****** ****** *)
//
#staload
"./../SATS/location.sats"
//
(* ****** ****** *)

#staload "./../SATS/lexing.sats"
#staload "./../SATS/staexp0.sats"
#staload "./../SATS/dynexp0.sats"
#staload "./../SATS/parsing.sats"

(* ****** ****** *)
//
extern
fun
p_idint: parser(token)
extern
fun
p_idintseq: parser(tokenlst)
//
implement
p_idint
  (buf, err) = let
//
val tok = buf.get0()
val tnd = tok.node()
//
in
//
case+ tnd of
| T_INT1 _ =>
  (buf.incby1(); tok)
| T_IDENT_alp _ =>
  (buf.incby1(); tok)
| T_IDENT_sym _ =>
  (buf.incby1(); tok)
| T_LT() => tok where
  {
    val () = buf.incby1()
    val loc = tok.loc((*void*))
    val tnd = T_IDENT_sym( "<" )
    val tok = token_make_node(loc, tnd)
  }
| T_GT() => tok where
  {
    val () = buf.incby1()
    val loc = tok.loc((*void*))
    val tnd = T_IDENT_sym( ">" )
    val tok = token_make_node(loc, tnd)
  }
| _ (* non-IDENT *) =>
  (err := err + 1; tok)
//
end // end of [p_idint]
implement
p_idintseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{token}(buf, err, p_idint))
//
) (* end of [p_idintseq] *)
//
(* ****** ****** *)

implement
t_d0pid(tnd) =
(
case+ tnd of
| T_IDENT_alp _ => true
| T_IDENT_sym _ => true
| T_BACKSLASH() => true
| _ (* non-IDENT *) => false
)

implement
p_d0pid(buf, err) =
let
//
val tok = buf.get0()
//
in
  case+
  tok.node() of
  | T_IDENT_alp _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
  | T_IDENT_sym _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
//
  | T_BACKSLASH() =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
//
  | _ (* non-IDENT *) =>
    (err := err + 1; i0dnt_none(tok))
end // end of [p_d0pid]

(* ****** ****** *)

implement
t_d0eid(tnd) =
(
case+ tnd of
//
| T_IDENT_alp _ => true
| T_IDENT_sym _ => true
//
| T_IDENT_dlr _ => true
(*
| T_IDENT_srp _ => true
*)
//
| T_BACKSLASH() => true
//
| T_LT((*void*)) => true // "<"
| T_GT((*void*)) => true // ">"
//
| _ (* non-IDENT *) => false
//
) (* end of [t_d0eid] *)

implement
p_d0eid(buf, err) =
let
//
val tok = buf.get0()
//
in
  case+
  tok.node() of
  | T_IDENT_alp _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
  | T_IDENT_sym _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
//
  | T_IDENT_dlr _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
(*
  | T_IDENT_srp _ =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
*)
//
  | T_BACKSLASH() =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
    }
//
  | T_LT() =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
      val loc = tok.loc((*void*))
      val tnd = T_IDENT_sym( "<" )
      val tok = token_make_node(loc, tnd)
    }
  | T_GT() =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
      val loc = tok.loc((*void*))
      val tnd = T_IDENT_sym( ">" )
      val tok = token_make_node(loc, tnd)
    }
//
  | _ (* non-IDENT *) =>
    (err := err + 1; i0dnt_none(tok))
end // end of [p_d0eid]

(* ****** ****** *)

implement
p_i0dnt
  (buf, err) = let
//
val e0 = err
val tok = buf.get0()
//
in
//
case+
tok.node() of
| tnd
  when
  t_s0eid(tnd) =>
    p_s0eid(buf, err)
| tnd
  when
  t_d0eid(tnd) =>
    p_d0eid(buf, err)
(*
| T_MSGT() =>
    i0dnt_some(tok) where
    {
      val () = buf.incby1()
      val loc = tok.loc((*void*))
      val tnd = T_IDENT_sym( "->" )
      val tok = token_make_node(loc, tnd)
    }
*)
| _ (* non-i0dnt *) =>
    (err := e0 + 1; i0dnt_none(tok))
//
end // end of [p_i0dnt]

(* ****** ****** *)
//
extern
fun
p_i0dntseq: parser(i0dntlst)
//
implement
p_i0dntseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{i0dnt}(buf, err, p_i0dnt))
//
) (* end of [p_i0dntseq] *)
//
(* ****** ****** *)
//
extern
fun
p_q0arg: parser(q0arg)
extern
fun
p_q0argseq_SEMICOLON: parser(q0arglst)
//
(* ****** ****** *)
//
//
implement
p_q0arg
  (buf, err) = let
//
val e0 = err
val ids = auxids(buf, err)
val tok = p_COLON(buf, err)
val s0t = p_appsort0_NGT(buf, err)
//
val loc0 =
(
case+ ids of
| list_nil() => tok.loc()
| list_cons _ =>
  let
    val
    id0 = list_last(ids) in id0.loc()
  end // end of [list_cons]
) : loc_t // end of [val]
val loc_res = loc0 + s0t.loc()
//
in
  err := e0;
  q0arg_make_node
    (loc_res, Q0ARGsome(ids, tok, s0t))
  // q0arg_make_node
end where
{
  fun
  auxids
  ( buf: &tokbuf >> _
  , err: &int >> _): i0dntlst =
  list_vt2t
  (pstar_COMMA_fun{s0eid}(buf, err, p_s0aid))
} (* end of [p_q0arg] *)

(* ****** ****** *)
//
implement
p_q0argseq_SEMICOLON
  (buf, err) =
(
//
list_vt2t
(pstar_SEMICOLON_fun{q0arg}(buf, err, p_q0arg))
//
) (* end of [p_q0argseq_SEMICOLON] *)
//
(* ****** ****** *)
//
extern
fun
p_tq0arg: parser(tq0arg)
extern
fun
p_tq0argseq: parser(tq0arglst)
//
implement
p_tq0arg
  (buf, err) = let
//
val e0 = err
val tok = buf.get0()
//
(*
val () =
println! ("p_tq0arg: tok = ", tok)
*)
//
in
//
case+
tok.node() of
| T_LT() => let
    val () = buf.incby1()
    val q0as =
      p_q0argseq_SEMICOLON(buf, err)
    // end of [val]
    val tbeg = tok
    val tend = p_GT(buf, err)
    val loc_res = tbeg.loc() + tend.loc()
  in
    err := e0;
    tq0arg_make_node
    (loc_res, TQ0ARGsome(tbeg, q0as, tend))
  end
| T_LTGT() => let
    val () = buf.incby1()
    val q0as = list_nil(*void*)
    val tbeg = tok
    val tend = tok
    val loc_res = tok.loc()
  in
    tq0arg_make_node
    (loc_res, TQ0ARGsome(tbeg, q0as, tend))
  end
| _(* non-LT/GT *) =>
  ( err := e0 + 1;
    tq0arg_make_node(tok.loc(), TQ0ARGnone(tok))
  ) (* end of [non-LT] *)
//
end // end of [p_tq0arg]
//
implement
p_tq0argseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{tq0arg}(buf, err, p_tq0arg))
//
) (* end of [p_tq0argseq] *)
//
(* ****** ****** *)
(*
//
a0typ ::=
  | token
  | d0pid COLON s0exp
//
*)
extern
fun
p_a0typ: parser(a0typ)
extern
fun
p_a0typseq_COMMA: parser(a0typlst)
extern
fun
p_a0typseqopt_COMMA: parser(a0typlstopt)
//
(* ****** ****** *)
//
implement
p_a0typ
  (buf, err) = let
//
val e0 = err
//
val mark =
  buf.get_mark()
//
val tok0 = buf.get1()
val tok1 = buf.get0()
//
in
//
case+
tok1.node() of
| T_COLON() => let
    val () =
    buf.clear_mark(mark)
    val () = buf.incby1()
    val s0e = p_s0exp(buf, err)
    val loc_res = tok0.loc() + s0e.loc()
  in
    err := e0;
    a0typ_make_node
    (loc_res, A0TYPsome(s0e, Some(tok0)))
  end // end of [COLON]
| _(*non-COLON*) => let
    val () =
      buf.set_mark(mark)
    // end of [val]
    val s0e = p_s0exp(buf, err)
  in
    err := e0;
    a0typ_make_node
    (s0e.loc(), A0TYPsome(s0e, None(*void*)))
  end // end of [non-COLON]
//
end // end of [p_a0typ]

(* ****** ****** *)
//
implement
p_a0typseq_COMMA
  (buf, err) =
(
//
list_vt2t
(pstar_COMMA_fun
 {a0typ}(buf, err, p_a0typ))
//
)
implement
p_a0typseqopt_COMMA
  (buf, err) = let
//
val tok = buf.get0()
//
in (* in-of-let *)
//
case+
tok.node() of
| T_BAR() => let
    val () = buf.incby1()
  in
    Some(p_a0typseq_COMMA(buf, err))
  end // end of [T_BAR]
| _(* non-BAR *) => None(*void*)
//
end // end of [p_a0typseqopt]
//
(* ****** ****** *)

implement
p_d0arg
  (buf, err) = let
//
val e0 = err
val tok = buf.get0()
val tnd = tok.node()
//
in
//
case+ tnd of
//
| T_LPAREN() => let
    val () = buf.incby1()
    val arg0 =
      p_a0typseq_COMMA(buf, err)
    val opt1 =
      p_a0typseqopt_COMMA(buf, err)
    val tbeg = tok
    val tend = p_RPAREN(buf, err)
    val loc_res = tbeg.loc() + tend.loc()
  in
    err := 0;
    d0arg_make_node
    ( loc_res
    , D0ARGsome_dyn2(tbeg, arg0, opt1, tend))
  end
//
| T_LBRACE() => let
    val () = buf.incby1()
    val s0qs =
      p_s0quaseq_BARSEMI(buf, err)
    val tbeg = tok
    val tend = p_RBRACE(buf, err)
    val loc_res = tbeg.loc() + tend.loc()
  in
    err := e0;
    d0arg_make_node
    (loc_res, D0ARGsome_sta(tbeg, s0qs, tend))
  end // end of [T_LBRACE]
//
| _ when
    t_s0eid(tnd) => let
    val sid =
      p_s0eid(buf, err)
    // end of [val]
    val loc = sid.loc()
  in
    err := e0;
    d0arg_make_node(loc, D0ARGsome_dyn1(sid))
  end
//
| _ (* error *) =>
  (
    err := e0 + 1;
    d0arg_make_node(tok.loc(), D0ARGnone(tok))
  )
//
end // end of [p_d0arg]

(* ****** ****** *)

extern
fun
p_d0argseq: parser(d0arglst)
implement
p_d0argseq
  (buf, err) =
(
  list_vt2t
  (pstar_fun{d0arg}(buf, err, p_d0arg))
) (* end of [p_d0argseq] *)

(* ****** ****** *)
(*
atmd0pat::
//
  | d0pid
//
  | t0int // int
  | t0chr // char
  | t0flt // float
  | t0str // string
//
*)
(* ****** ****** *)

extern
fun
p_atmd0pat : parser(d0pat)
extern
fun
p_atmd0patseq : parser(d0patlst)

(* ****** ****** *)
//
extern
fun
p_d0patseq_COMMA: parser(d0patlst)
extern
fun
p_labd0patseq_COMMA: parser(labd0patlst)
//
(* ****** ****** *)

local

static
fun
p_napps: parser(d0pat)
implement
p_napps(buf, err) = let
//
  val e0 = err
  val tok = buf.get0()
  val tnd = tok.node()
//
in
//
case+ tnd of
| _ (* error *) =>
  ( err := e0 + 1;
    d0pat_make_node(tok.loc(), D0Pnone(tok))
  ) (* end-of-error *)
//
end // end of [p_napps]

in (* in-of-local *)

implement
p_d0pat(buf, err) =
let
  val e0 = err
  val d0ps0 =
  p_atmd0patseq(buf, err)
in
//
case+ d0ps0 of
| list_nil
    ((*void*)) => p_napps(buf, err)
  // end of [list_nil]
| list_cons
    (d0p0, d0ps1) =>
  (
    case+ d0ps1 of
    | list_nil() => d0p0
    | list_cons _ => let
        val d0p1 = list_last(d0ps1)
      in
        d0pat_make_node
        (d0p0.loc()+d0p1.loc(), D0Papps(d0ps0))
      end // end of [list_cons]
  ) (* end of [list_cons] *)
//
end // end of [p_d0pat]

end // end of [local]

(* ****** ****** *)
//
implement
p_d0patseq_COMMA
  (buf, err) =
(
  list_vt2t
  (pstar_COMMA_fun{d0pat}(buf, err, p_d0pat))
) (* end of [p_d0patseq_COMMA] *)

implement
p_labd0patseq_COMMA
  (buf, err) =
(
  list_vt2t
  (pstar_COMMA_fun{labd0pat}(buf, err, p_labd0pat))
) (* end of [p_labd0patseq_COMMA] *)
//
(* ****** ****** *)

(*
atmd0exp ::
//
  | d0eid
//
  | t0int // int
  | t0chr // char
  | t0flt // float
  | t0str // string
//
  | qualid atm0exp
//
  | { d0eclseq }
  | LET d0eclseq IN d0expseq END
//
  | ( d0expseq_COMMA )
  | ( d0expseq_COMMA | d0expseq_COMMA )
//
  | { labd0expseq_COMMA }
  | { labd0expseq_COMMA | labd0expseq_COMMA }
//
*)
extern
fun
p_atmd0exp : parser(d0exp)
//
extern
fun
p_appd0exp : parser(d0exp)
//
extern
fun
p_atmd0expseq : parser(d0explst)
//
(* ****** ****** *)
//
extern
fun
p_d0expseq: parser(d0explst)
//
extern
fun
p_d0expseq_COMMA : parser(d0explst)
extern
fun
p_labd0expseq_COMMA : parser(labd0explst)
//
(* ****** ****** *)
//
(*
d0exp_RPAREN ::=
  | RPAREN
  | BAR d0expseq_COMMA RPAREN
labd0exp_RBRACE ::=
  | RPAREN
  | BAR labd0expseq_COMMA RBRACE
*)
extern
fun
p_d0exp_RPAREN : parser(d0exp_RPAREN)
extern
fun
p_labd0exp_RBRACE : parser(labd0exp_RBRACE)
//
(* ****** ****** *)

local

static
fun
p_napps: parser(d0exp)
implement
p_napps(buf, err) = let
//
  val e0 = err
  val tok = buf.get0()
  val tnd = tok.node()
//
in
//
case+ tnd of
| _ (* error *) =>
  ( err := e0 + 1;
    d0exp_make_node(tok.loc(), D0Enone(tok))
  ) (* end-of-error *)
//
end // end of [p_napps]

in (* in-of-local *)

implement
p_d0exp(buf, err) =
let
  val e0 = err
  val d0es0 =
  p_atmd0expseq(buf, err)
in
//
case+ d0es0 of
| list_nil
    ((*void*)) => p_napps(buf, err)
  // end of [list_nil]
| list_cons
    (d0e0, d0es1) =>
  (
    case+ d0es1 of
    | list_nil() => d0e0
    | list_cons _ => let
        val d0e1 = list_last(d0es1)
      in
        d0exp_make_node
        (d0e0.loc()+d0e1.loc(), D0Eapps(d0es0))
      end // end of [list_cons]
  ) (* end of [list_cons] *)
//
end // end of [p_d0exp]

end // end of [local]

(* ****** ****** *)

implement
p_labd0exp
  (buf, err) = let
//
val e0 = err
//
val l0 =
(
  p_l0abl(buf, err)
)
val tok = p_EQ(buf, err)
val d0e = p_d0exp(buf, err)
//
(*
val ((*void*)) =
println! ("p_labd0exp: l0 = ", l0)
val ((*void*)) =
println! ("p_labd0exp: tok = ", tok)
val ((*void*)) =
println! ("p_labd0exp: d0e = ", d0e)
*)
//
in
  err := e0; DL0ABELED(l0, tok, d0e)
end // end of [p_labd0exp]

(* ****** ****** *)

implement
p_d0expseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{d0exp}(buf, err, p_d0exp))
//
) (* end of [p_d0expseq] *)

(* ****** ****** *)

implement
p_atmd0exp
(buf, err) = let
//
val e0 = err
val tok = buf.get0()
val tnd = tok.node()
//
in
//
case+ tnd of
//
| _ when t_d0eid(tnd) =>
  let
    val id = p_d0eid(buf, err)
  in
    err := e0;
    d0exp_make_node(id.loc(), D0Eid(id))
  end // end of [t_d0eid]
//
| _ when t_t0int(tnd) =>
  let
    val i0 = p_t0int(buf, err)
  in
    err := e0;
    d0exp_make_node(i0.loc(), D0Eint(i0))
  end // end of [t_t0int]
| _ when t_t0chr(tnd) =>
  let
    val c0 = p_t0chr(buf, err)
  in
    err := e0;
    d0exp_make_node(c0.loc(), D0Echr(c0))
  end // end of [t_t0chr]
| _ when t_t0flt(tnd) =>
  let
    val c0 = p_t0flt(buf, err)
  in
    err := e0;
    d0exp_make_node(c0.loc(), D0Eflt(c0))
  end // end of [t_t0flt]
| _ when t_t0str(tnd) =>
  let
    val c0 = p_t0str(buf, err)
  in
    err := e0;
    d0exp_make_node(c0.loc(), D0Estr(c0))
  end // end of [t_t0str]
//
| T_LPAREN() => let
    val () = buf.incby1()
    val d0es =
      p_d0expseq_COMMA(buf, err)
    // end of [val]
    val tbeg = tok
    val tend = p_d0exp_RPAREN(buf, err)
  in
    err := e0;
    d0exp_make_node
    ( loc_res
    , D0Eparen(tbeg, d0es, tend)) where
    {
      val loc_res =
        tbeg.loc()+d0exp_RPAREN_loc(tend)
      // end of [val]
    }
  end // end of [T_LPAREN]
//
| T_LET() => let
    val () = buf.incby1()
    val d0cs =
      p_d0eclseq(buf, err)
    val tok1 = p_IN(buf, err)
    val d0es =
      p_d0expseq(buf, err)
    val tok2 = p_ENDLET(buf, err)
    val loc_res = tok.loc() + tok2.loc()
  in
    err := e0;
    d0exp_make_node
    (loc_res, D0Elet(tok, d0cs, tok1, d0es, tok2))
  end // end of [T_LET]
//
| T_IDENT_qual _ => let
    val () = buf.incby1()
    val d0e0 = p_atmd0exp(buf, err)
  in
    err := e0;
    d0exp_make_node
    (loc_res, D0Equal(tok, d0e0)) where
    {
      val loc_res = tok.loc()+d0e0.loc()
    }
  end // end of [T_IDENT_qual]
//
| _ (* error *) => let
    val () = (err := e0 + 1)
  in
    d0exp_make_node(tok.loc(), D0Enone(tok))
  end // HX: indicating a parsing error
//
end // end of [p_atmd0exp]

(* ****** ****** *)

implement
p_appd0exp
  (buf, err) = let
//
val
d0e0 = p_atmd0exp(buf, err)
val
d0es = p_atmd0expseq(buf, err)
//
in
//
case+ d0es of
| list_nil() => d0e0
| list_cons _ => let
    val d0e1 = list_last(d0es)
    val loc0 = d0e0.loc() + d0e1.loc()
  in
    d0exp_make_node
      (loc0, D0Eapps(list_cons(d0e0, d0es)))
    // d0exp_make_node
  end // end of [list_cons]
//
end // end of [p_appd0exp]

(* ****** ****** *)

implement
p_atmd0expseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{d0exp}(buf, err, p_atmd0exp))
//
) (* end of [p_atmd0expseq] *)

(* ****** ****** *)

implement
p_d0expseq_COMMA
  (buf, err) =
(
//
list_vt2t
(pstar_COMMA_fun{d0exp}(buf, err, p_d0exp))
//
) (* end of [p_d0expseq_COMMA] *)

implement
p_labd0expseq_COMMA
  (buf, err) =
(
//
list_vt2t
(pstar_COMMA_fun
 {labd0exp}(buf, err, p_labd0exp))
//
) (* end of [p_labd0expseq_COMMA] *)

(* ****** ****** *)

implement
p_d0exp_RPAREN
  (buf, err) = let
  val e0 = err
  val tok1 = buf.get0()
  val tnd1 = tok1.node()
in
//
case+ tnd1 of
| T_BAR() => let
    val () = buf.incby1()
    val d0es =
      p_d0expseq_COMMA(buf, err)
    val tok2 = p_RPAREN(buf, err)
  in
    err := e0;
    d0exp_RPAREN_cons1(tok1, d0es, tok2)
  end // end of [T_BAR]
| _ (* non-BAR *) =>
  (
    case+ tnd1 of
    | T_RPAREN() => let
        val () = buf.incby1()
      in
        err := e0; d0exp_RPAREN_cons0(tok1)
      end // end of [RPAREN]
    | _(*non-RPAREN*) =>
      (
        err := e0 + 1; d0exp_RPAREN_cons0(tok1)
      ) (* end of [non-RPAREN *)
  )
//
end // end of [p_d0exp_RPAREN]

implement
p_labd0exp_RBRACE
  (buf, err) = let
  val e0 = err
  val tok1 = buf.get0()
  val tnd1 = tok1.node()
in
//
case+ tnd1 of
| T_BAR() => let
    val () = buf.incby1()
    val ld0es =
    p_labd0expseq_COMMA(buf, err)
    val tok2 = p_RBRACE(buf, err)
  in
    err := e0;
    labd0exp_RBRACE_cons1(tok1, ld0es, tok2)
  end // end of [T_BAR]
| _ (* non-BAR *) =>
  (
    case+ tnd1 of
    | T_RBRACE() => let
        val () = buf.incby1()
      in
        err := e0; labd0exp_RBRACE_cons0(tok1)
      end // end of [RBRACE]
    | _(*non-RPAREN*) =>
      (
        err := e0 + 1; labd0exp_RBRACE_cons0(tok1)
      ) (* end of [non-RPAREN] *)
  )
//
end // end of [p_labd0exp_RBRACE]

(* ****** ****** *)

(*
stadef::
| si0de s0margseq colons0rtopt EQ s0exp
abstype::
| si0de s0margseq colons0rtopt [EQ/EQEQ s0exp]
*)

(* ****** ****** *)

local

static
fun
t_dctkind
 : tnode -> bool
implement
t_dctkind
  (tnd) =
(
case+ tnd of
| T_FUN _ => true
| T_VAL _ => true | _ => false
)

static
fun
p_precopt
 : parser(precopt)
implement
p_precopt
  (buf, err) = let
//
val tok = buf.get0()
val tnd = tok.node()
//
in
//
case+ tnd of
| T_INT1 _ =>
  PRECOPTsing(tok) where
  {
    val () = buf.incby1()
  }
| T_LPAREN() => let
    val () = buf.incby1()
    val toks =
      p_idintseq(buf, err)
    // end of [val]
    val tok2 = p_RPAREN(buf, err)
  in
    PRECOPTlist(tok, toks, tok2)
  end
//
| _(*non-INT1-LPAREN*) => PRECOPTnil()
//
end // end of [p_precopt]

static
fun
p_abstdf0
 : parser(abstdf0)
implement
p_abstdf0
  (buf, err) = let
//
val tok = buf.get0()
val tnd = tok.node()
//
in
//
case+ tnd of
| T_IDENT_sym("<=") => let
    val () = buf.incby1()
  in
    ABSTDF0lteq
    (tok, p_s0exp(buf, err))
  end
| T_IDENT_sym("==") => let
    val () = buf.incby1()
  in
    ABSTDF0eqeq
    (tok, p_s0exp(buf, err))    
  end
| _(*non-eq-eqeq*) => ABSTDF0nil()
//
end // end of [p_abstdf0]

(* ****** ****** *)
//
static
fun
p_d0cstdec
 : parser(d0cstdec)
and
p_d0cstdecseq_AND
 : parser(d0cstdeclst)
and
p_effs0expopt
 : parser(effs0expopt)
and
p_teqd0expopt
 : parser(teqd0expopt)
//
implement
p_d0cstdec
  (buf, err) = let
//
val e0 = err
//
val
nam = p_d0pid(buf, err)
val
arg = p_d0argseq(buf, err)
val
res = p_effs0expopt(buf, err)
val
def = p_teqd0expopt(buf, err)
//
val
loc = nam.loc()
val
loc =
(
case+ def of
| TEQD0EXPnone() =>
  (
  case+ res of
  | EFFS0EXPnone() =>
    (case+ arg of
     | list_nil() => loc
     | list_cons
       (tqa, _) => loc+tqa.loc()
    )
  | EFFS0EXPsome
      (sfe, s0e) => loc+s0e.loc()
    // EFFS0EXPsome
  )
| TEQD0EXPsome(_, d0e) => loc+d0e.loc()
) : loc_t // end of [val]
//
in
  err := e0;
  D0CSTDEC(@{loc=loc,nam=nam,arg=arg,res=res,def=def})
end // end of [p_d0cstdec]

(* ****** ****** *)

implement
p_effs0expopt
  (buf, err) = let
//
val tok = buf.get0()
//
in
//
case+
tok.node() of
| T_COLON() => let
    val () = buf.incby1()
    val s0e_res =
      p_apps0exp_NEQ(buf, err)
    // end of [val]
  in
    EFFS0EXPsome
      (S0EFFnone(tok), s0e_res)
  end // end of [T_COLON]
| T_COLONLT() => let
    val () = buf.incby1()
    val s0es =
    list_vt2t
    (
      pstar_COMMA_fun
      {s0exp}(buf, err, p_apps0exp_NGT)
    )
    val tbeg = tok
    val tend = p_GT(buf, err)
    val s0e_res =
      p_apps0exp_NEQ(buf, err)
    // end of [val]
    val loc_res = tbeg.loc() + tend.loc()
  in
    EFFS0EXPsome
      (S0EFFsome(tbeg, s0es, tend), s0e_res)
    // EFFS0EXPsome
  end // end of [T_COLONLT]
| _(*non-COLON/LT*) => EFFS0EXPnone()
//
end // end of [p_effs0expopt]

implement
p_teqd0expopt
  (buf, err) = let
//
val tok = buf.get0()
//
in
//
case+
tok.node() of
| T_EQ() =>
  TEQD0EXPsome
    (tok, d0e) where
  {
    val () = buf.incby1()
    val d0e = p_d0exp(buf, err)
  }
| _(*non-EQ*) => TEQD0EXPnone(*void*)
//
end // end of [p_teqd0expopt]

(* ****** ****** *)
//
implement
p_d0cstdecseq_AND
  (buf, err) =
(
//
list_vt2t
(pstar_AND_fun
 {d0cstdec}(buf, err, p_d0cstdec))
//
) (* end of [p_d0cstdecseq_AND] *)
//
(* ****** ****** *)

in (* in-of-local *)

implement
p_d0ecl
  (buf, err) = let
//
val e0 = err
val tok = buf.get0()
//
val loc = tok.loc()
val tnd = tok.node()
//
in
//
case+ tnd of
//
| T_LOCAL() => let
    val () = buf.incby1()
    val tbeg = tok
    val head =
      p_d0eclseq(buf, err)
    val tmid = p_IN(buf, err)
    val body =
      p_d0eclseq(buf, err)
    val tend = p_ENDLOCAL(buf, err)
    val loc_res = tbeg.loc() + tend.loc()
  in
    err := e0;
    d0ecl_make_node
    (loc_res, D0Clocal(tbeg, head, tmid, body, tend))
  end // end of [T_LOCAL]
//
| T_SORTDEF() => let
//
    val () = buf.incby1()
//
    val tid =
      p_s0tid(buf, err)
    val tok1 = p_EQ(buf, err)
    val def2 = p_s0rtdef(buf, err)
    val loc_res = loc+def2.loc()
  in
    err := e0;
    d0ecl_make_node
    ( loc_res
    , D0Csortdef(tok, tid, tok1, def2)
    ) (* d0ecl_make_node *)
  end
//
| T_SEXPDEF(k0) => let
//
    val () = buf.incby1()
//
    val sid =
      p_s0eid(buf, err)
    val s0mas =
      p_s0margseq(buf, err)
    // end of [val]
    val anno =
      popt_sort0_anno(buf, err)
    // end of [val]
    val tok1 = p_EQ(buf, err)
    val s0e0 = p_s0exp(buf, err)
    val loc_res = loc + s0e0.loc()
  in
    err := e0;
    d0ecl_make_node
    ( loc_res
    , D0Csexpdef
      (tok, sid, s0mas, anno, tok1, s0e0)
    ) (* d0ecl_make_node *)
  end
//
| T_ABSTYPE(k0) => let
//
    val () = buf.incby1()
//
    val sid =
      p_s0eid(buf, err)
    val t0mas =
      p_t0margseq(buf, err)
    // end of [val]
    val tdef0 = p_abstdf0(buf, err)
    val loc_res =
    (
    case+ tdef0 of
    | ABSTDF0nil() =>
      (
      case+ t0mas of
      | list_nil() => loc+sid.loc()
      | list_cons _ => let
        val t0ma =
        list_last(t0mas) in loc+t0ma.loc()
        end // end of [list_cons]
      ) (* ABSTDF0nil *)
    | ABSTDF0lteq(_, s0e) => loc+s0e.loc()
    | ABSTDF0eqeq(_, s0e) => loc+s0e.loc()
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node
    ( loc_res
    , D0Cabstype(tok, sid, t0mas, tdef0))
  end
//
| T_DATASORT() => let
//
    val () = buf.incby1()
//
    val d0cs =
      p_d0tsortseq_AND(buf, err)
    // end of [val]
    val loc_res =
    (
      case+ d0cs of
      | list_nil() => loc
      | list_cons _ =>
        let
        val d0c =
        list_last(d0cs) in loc+d0c.loc()
        end
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node
      ( loc_res, D0Cdatasort(tok, d0cs) )
    // d0ecl_make_node
  end
//
| T_DATATYPE(k0) => let
    val () = buf.incby1()
    val d0cs =
      p_d0atypeseq_AND(buf, err)
    val tok1 = buf.get0()
    val wopt =
    (
    case+
    tok1.node() of
    | T_WHERE() => let
        val () = buf.incby1()
        val topt =
        popt_LBRACE(buf, err)
        val wdcs =
          p_d0eclseq(buf, err)
        val tok2 = buf.get0()
        val ((*void*)) =
        (
        case+
        tok2.node() of
        | T_END() => buf.incby1()
        | T_RBRACE() => buf.incby1()
        | T_ENDWHERE() => buf.incby1()
        | _(*non-closing*) => (err := err+1)
        ) : void // end of [val]
      in
        WD0CSsome(tok1, topt, wdcs, tok2)
      end // end of [T_WHERE]
    | _(*non-WHERE*) => WD0CSnone(*void*)
    ) : wd0eclseq // end of [val]
    val loc_res =
    (
      case+ wopt of
      | WD0CSnone() =>
        (
        case+ d0cs of
        | list_nil() => loc
        | list_cons _ =>
          let
          val d0c =
          list_last(d0cs) in loc+d0c.loc()
          end
        )
      | WD0CSsome(_, _, _, tok) => loc+tok.loc()
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node
      ( loc_res, D0Cdatatype(tok, d0cs, wopt) )
    // d0ecl_make_node
  end
//
| tnd when
  t_dctkind(tnd) => let
    val () = buf.incby1()
    val tqas =
      p_tq0argseq(buf, err)
    val d0cs =
      p_d0cstdecseq_AND(buf, err)
    val loc_res =
    (
      case+ d0cs of
      | list_nil() =>
        (case+ tqas of
         | list_nil() => loc
         | list_cons
             (tqa, _) => loc + tqa.loc()
           // list_cons
        )
      | list_cons(d0c, _) => loc+d0c.loc()
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node
      ( loc_res, D0Cdynconst(tok, tqas, d0cs) )
    // d0ecl_make_node
  end
//
| T_SRP_INCLUDE() => let
//
    val () = buf.incby1()
//
    val d0e =
      p_appd0exp(buf, err)
    // end of [val]
    val loc_res = loc+d0e.loc()
  in
    err := e0;
    d0ecl_make_node(loc_res, D0Cinclude(tok, d0e))
  end // end of [#INCLUDE(...)]
//
| T_SRP_STALOAD() => let
//
    val () = buf.incby1()
//
    val d0e =
      p_appd0exp(buf, err)
    // end of [val]
    val loc_res = loc+d0e.loc()
  in
    err := e0;
    d0ecl_make_node(loc_res, D0Cstaload(tok, d0e))
  end // end of [#STALOAD(...)]
//
| T_SRP_NONFIX () => let
//
    val () = buf.incby1()
//
    val ids =
      p_i0dntseq(buf, err)
    // end of [val]
    val loc_res =
    (
      case+ ids of
      | list_nil() => loc
      | list_cons _ =>
        let
        val id1 = list_last(ids) in loc+id1.loc()
        end // end of [list_cons]
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node(loc_res, D0Cnonfix(tok, ids))
  end // end of [NONFIX]
//
| T_SRP_FIXITY(knd) => let
//
    val () = buf.incby1()
//
    val opt =
      p_precopt(buf, err)
    val ids =
      p_i0dntseq(buf, err)
//
    val loc_res =
    (
      case+ ids of
      | list_nil() => loc
      | list_cons _ =>
        let
        val id1 = list_last(ids) in loc + id1.loc()
        end // end of [list_cons]
    ) : loc_t // end of [val]
  in
    err := e0;
    d0ecl_make_node(loc_res, D0Cfixity(tok, opt, ids))
  end // end of [FIXITY(knd)]
//
| _ (* errorcase *) =>
  let
    val () = (err := e0 + 1) in d0ecl_make_node(loc, D0Cnone(tok))
  end // end of [let]
//
end // end of [p_d0ecl]

end // end of [local]

(* ****** ****** *)

implement
p_d0eclseq
  (buf, err) =
(
//
list_vt2t
(pstar_fun{d0ecl}(buf, err, p_d0ecl))
//
) (* end of [p_d0eclseq] *)

(* ****** ****** *)

implement
p_d0eclseq_top
  (buf, err) = let
//
fnx
loop1
( buf: &tokbuf >> _
, err: &int >> _
, res: d0eclist_vt): d0eclist_vt =
let
  val d0c = p_d0ecl(buf, err)
in
  case+
  d0c.node() of
  | D0Cnone(tok) =>
    (
      case+
      tok.node() of
      | T_EOF() => res
      | _(*non-EOF*) => let
          val loc = tok.loc()
          val n0r = loc.beg_nrow()
        in
          loop2(buf, err, n0r, res)
        end
    )
  | _ (*non-none*) =>
    loop1(buf, err, list_vt_cons(d0c, res))
end // end of [loop]
//
and
loop2
( buf: &tokbuf >> _
, err: &int >> _, n0r: int
, res: d0eclist_vt): d0eclist_vt =
let
  val tok =
  tokbuf_getok0(buf)
  val tnd = tok.node()
in
//
case+ tnd of
| T_EOF() => res
| _(*non-EOF*) => let
    val loc = tok.loc()
    val n1r = loc.beg_nrow()
(*
    val (_) = println! ("n0r = ", n0r)
    val (_) = println! ("n1r = ", n1r)
*)
  in
//
  if
  (n1r <= n0r)
  then let
    val () = buf.incby1()
    val () = err := err + 1
    val d0c =
      d0ecl_make_node(loc, D0Ctkerr(tok))
    // end of [val]
  in
    loop2(buf, err, n0r, list_vt_cons(d0c, res))
  end // end of [then]
  else loop1(buf, err, res) // end of [else]
//
  end // end of [let]
//
end // end of [loop2]
//
in
//
list_vt2t
(list_vt_reverse(loop1(buf, err, list_vt_nil)))
//
end // end of [p_d0eclseq_top]

(* ****** ****** *)

(* end of [xats_parsing_dynexp.dats] *)
