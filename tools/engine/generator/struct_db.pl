/* Simile's model database (Prolog/struct_db.c) in Prolog.

   The C original is a foreign library of the `database` module: tables of
   nodes and arcs indexed by the number in their id ("node00012" -> 12), each
   with linked lists of ids — children, arcs in, arcs out, continuations — new
   entries put at the front. A WebAssembly build of SWI-Prolog cannot load a
   foreign library of ours, so this is the same thing as clauses, predicate
   for predicate, with the C's quirks kept: deleting a node only clears its
   "exists" flag, re-creating one keeps its parent, an arc exists while it has
   a destination, removing an id from a list removes every copy.

   A list "pointer" (get_child_list_pointer & co.) is the rest of the list
   itself; the Prolog side only passes it back to get_*_and_next_ptr, which
   fail at the end, as the C does on NULL.

   Checked by generating the C++ of every catalogue model with this and with
   the C library: byte-identical (tools/engine/README.md, step 3).

   Loaded by headless.pl into module `database` (heads are qualified).
*/

:- dynamic
	database:sd_node/2,      % Num, IdAtom
	database:sd_exists/1,    % Num
	database:sd_hidden/1,    % Num
	database:sd_parent/2,    % Num, ParentAtom
	database:sd_class/2,     % Num, Class
	database:sd_list/2,      % Key, [Num...]: kids(root|node(N)|arc(N)), to(N), from(N), subs(N)
	database:sd_box/3,       % bbox|iext, Num, [L,T,R,B]
	database:sd_off/2,       % node(N)|arc(N), [X,Y]
	database:sd_cx/2,        % Num, X
	database:sd_cy/2,        % Num, Y
	database:sd_arc/2,       % Num, IdAtom
	database:sd_dest/2,      % Num, DestNum   (absent: no such arc)
	database:sd_source/2,    % Num, SourceNum
	database:sd_type/2,      % Num, Type
	database:sd_prev/2,      % Num, PrevNum
	database:sd_curve/2.     % Num, [XK,YB]

database:sd_reset :-
	forall(member(P, [sd_node/2, sd_exists/1, sd_hidden/1, sd_parent/2,
			  sd_class/2, sd_list/2, sd_box/3, sd_off/2, sd_cx/2,
			  sd_cy/2, sd_arc/2, sd_dest/2, sd_source/2, sd_type/2,
			  sd_prev/2, sd_curve/2]),
	       ( P = N/A, functor(H, N, A), retractall(database:H) )).

% -- ids and lists --

database:sd_num(Prefix, Id, N) :-
	atom_length(Prefix, L),
	sub_atom(Id, L, _, 0, Digits0),
	atom_codes(Digits0, Cs),
	sd_leading_digits(Cs, Ds),
	( Ds == [] -> N = 0 ; number_codes(N, Ds) ).    % atoi

sd_leading_digits([C | Cs], [C | Ds]) :- code_type(C, digit), !, sd_leading_digits(Cs, Ds).
sd_leading_digits(_, []).

database:sd_is_node(Id) :- atom(Id), sub_atom(Id, 0, 4, _, node).
database:sd_is_arc(Id) :- atom(Id), sub_atom(Id, 0, 3, _, arc).
database:sd_node_num(Id, N) :- database:sd_num(node, Id, N).
database:sd_arc_num(Id, N) :- database:sd_num(arc, Id, N).

database:sd_get(Key, L) :- ( database:sd_list(Key, L0) -> L = L0 ; L = [] ).
database:sd_set(Key, L) :- retractall(database:sd_list(Key, _)), assertz(database:sd_list(Key, L)).
database:sd_push(Key, N) :- database:sd_get(Key, L), database:sd_set(Key, [N | L]).
database:sd_drop(Key, N) :- database:sd_get(Key, L0), exclude(==(N), L0, L), database:sd_set(Key, L).

% The list a parent's children are in: roots, or a node's, or an arc's.
database:sd_kids_key(root, kids(root)) :- !.
database:sd_kids_key(P, kids(arc(N))) :- database:sd_is_arc(P), !, database:sd_arc_num(P, N).
database:sd_kids_key(P, kids(node(N))) :- database:sd_node_num(P, N).

database:sd_set1(F, N, V) :-
	G =.. [F, N, _], retractall(database:G),
	H =.. [F, N, V], assertz(database:H).
database:sd_unset1(F, N) :- G =.. [F, N, _], retractall(database:G).

database:sd_node_live(Id, N) :- database:sd_is_node(Id), database:sd_node_num(Id, N), database:sd_exists(N).
database:sd_arc_live(Id, N) :- database:sd_is_arc(Id), database:sd_arc_num(Id, N), database:sd_dest(N, _).

% -- the foreign predicates --

database:empty_tree(_Root, 56) :- database:sd_reset.   % sizeof(arc): unused

database:create_node(Id) :-
	database:sd_node_num(Id, N),
	database:sd_set1(sd_node, N, Id),
	database:sd_unset1(sd_class, N),
	database:sd_set(kids(node(N)), []),
	database:sd_set(to(N), []),
	database:sd_set(from(N), []),
	retractall(database:sd_box(_, N, _)),
	retractall(database:sd_hidden(N)),
	retractall(database:sd_exists(N)), assertz(database:sd_exists(N)),
	retractall(database:sd_off(node(N), _)),
	database:sd_unset1(sd_cx, N),
	database:sd_unset1(sd_cy, N).

database:add_to_tree(Parent, Child) :-
	database:sd_node_num(Child, C),
	database:sd_set1(sd_parent, C, Parent),
	database:sd_kids_key(Parent, Key),
	database:sd_push(Key, C).

database:set_class(Node, Class) :- database:sd_node_num(Node, N), database:sd_set1(sd_class, N, Class).

database:add_bbox(Node, L, T, R, B) :- database:sd_node_num(Node, N),
	retractall(database:sd_box(bbox, N, _)), assertz(database:sd_box(bbox, N, [L, T, R, B])).
database:add_iext(Node, L, T, R, B) :- database:sd_node_num(Node, N),
	retractall(database:sd_box(iext, N, _)), assertz(database:sd_box(iext, N, [L, T, R, B])).

database:add_capt_off(Comp, X, Y) :-
	( database:sd_is_arc(Comp) -> database:sd_arc_num(Comp, N), K = arc(N)
	; database:sd_node_num(Comp, N), K = node(N) ),
	retractall(database:sd_off(K, _)), assertz(database:sd_off(K, [X, Y])).

database:add_centre(Node, X, Y) :- database:sd_node_num(Node, N),
	database:sd_set1(sd_cx, N, X), database:sd_set1(sd_cy, N, Y).
database:add_along(Node, X) :- database:sd_node_num(Node, N),
	database:sd_set1(sd_cx, N, X), database:sd_unset1(sd_cy, N).

database:set_hidden(Node, W) :-
	database:sd_node_num(Node, N),
	retractall(database:sd_hidden(N)),
	( W =:= 0 -> true ; assertz(database:sd_hidden(N)) ).

database:create_arc(Id) :-
	database:sd_arc_num(Id, N),
	database:sd_set1(sd_arc, N, Id),
	database:sd_unset1(sd_type, N),
	database:sd_unset1(sd_prev, N),
	database:sd_set(subs(N), []),
	database:sd_set(kids(arc(N)), []),
	database:sd_unset1(sd_curve, N),
	retractall(database:sd_off(arc(N), _)).

database:add_link(Dest, Source, Link) :-
	database:sd_arc_num(Link, L),
	database:sd_node_num(Dest, D), database:sd_set1(sd_dest, L, D), database:sd_push(to(D), L),
	database:sd_node_num(Source, S), database:sd_set1(sd_source, L, S), database:sd_push(from(S), L).

database:add_continuation(Before, After) :-
	database:sd_arc_num(After, A), database:sd_arc_num(Before, B),
	database:sd_set1(sd_prev, A, B),
	database:sd_push(subs(B), A).

database:set_type(Arc, Type) :- database:sd_arc_num(Arc, N), database:sd_set1(sd_type, N, Type).
database:add_curve(Arc, XK, YB) :- database:sd_arc_num(Arc, N), database:sd_set1(sd_curve, N, [XK, YB]).

database:delete_node(Node) :- database:sd_node_num(Node, N),
	retractall(database:sd_exists(N)), retractall(database:sd_hidden(N)).

database:remove_from_tree(Parent, Child) :-
	database:sd_node_num(Child, C),
	database:sd_kids_key(Parent, Key),
	database:sd_drop(Key, C).

database:unset_class(Node) :- database:sd_node_num(Node, N), database:sd_unset1(sd_class, N).
database:remove_bbox(Node) :- database:sd_node_num(Node, N), retractall(database:sd_box(bbox, N, _)).
database:remove_iext(Node) :- database:sd_node_num(Node, N), retractall(database:sd_box(iext, N, _)).
database:remove_centre(Node) :- database:sd_node_num(Node, N), database:sd_unset1(sd_cx, N), database:sd_unset1(sd_cy, N).
database:remove_along(Node) :- database:remove_centre(Node).
database:remove_capt_off(Comp) :-
	( database:sd_is_arc(Comp) -> database:sd_arc_num(Comp, N), K = arc(N)
	; database:sd_node_num(Comp, N), K = node(N) ),
	retractall(database:sd_off(K, _)).

database:delete_arc(Link) :- database:sd_arc_num(Link, N), database:sd_unset1(sd_dest, N).

database:remove_link(Dest, Source, Link) :-
	database:sd_arc_num(Link, L),
	database:sd_node_num(Dest, D), database:sd_drop(to(D), L),
	database:sd_node_num(Source, S), database:sd_drop(from(S), L).

database:unset_type(Arc) :- database:sd_arc_num(Arc, N), database:sd_unset1(sd_type, N).

database:remove_continuation(Before, After) :-
	database:sd_arc_num(After, A), database:sd_unset1(sd_prev, A),
	database:sd_arc_num(Before, B), database:sd_drop(subs(B), A).

database:remove_curve(Arc) :- database:sd_arc_num(Arc, N), database:sd_unset1(sd_curve, N).

database:find_parent(Child, Parent) :- database:sd_node_live(Child, N), database:sd_parent(N, Parent).
database:find_bbox(Node, Box) :- database:sd_node_live(Node, N), database:sd_box(bbox, N, Box).
database:find_iext(Node, Box) :- database:sd_node_live(Node, N), database:sd_box(iext, N, Box).
database:find_capt_off(Comp, Off) :-
	(   database:sd_arc_live(Comp, N) -> database:sd_off(arc(N), Off)
	;   database:sd_node_live(Comp, N) -> database:sd_off(node(N), Off)
	).
database:find_centre(Node, [X, Y]) :- database:sd_node_live(Node, N), database:sd_cy(N, Y), database:sd_cx(N, X).
database:find_along(Node, X) :- database:sd_node_live(Node, N), database:sd_cx(N, X), \+ database:sd_cy(N, _).
database:is_hidden(Node) :- database:sd_node_live(Node, N), database:sd_hidden(N).
database:find_curve(Arc, C) :- database:sd_arc_live(Arc, N), database:sd_curve(N, C).

database:get_child_list_pointer(Parent, Ptr) :-
	(   Parent == root -> database:sd_get(kids(root), Ptr)
	;   database:sd_is_node(Parent) -> database:sd_node_num(Parent, N), database:sd_get(kids(node(N)), Ptr)
	;   database:sd_is_arc(Parent) -> database:sd_arc_num(Parent, N), database:sd_get(kids(arc(N)), Ptr)
	;   Ptr = []
	).
database:get_node_and_next_ptr([N | Next], Id, Next) :- database:sd_node(N, Id).
database:get_arc_and_next_ptr([N | Next], Id, Next) :- database:sd_arc(N, Id).

database:find_ends(Arc, Source, Dest) :-
	database:sd_arc_live(Arc, N),
	database:sd_source(N, S), database:sd_node(S, Source),
	database:sd_dest(N, D), database:sd_node(D, Dest).

database:find_prev(Arc, Prev) :-
	database:sd_arc_live(Arc, N), database:sd_prev(N, P), database:sd_arc(P, Prev).

database:get_in_list_pointer(Dest, Ptr) :-
	( database:sd_is_node(Dest) -> database:sd_node_num(Dest, N), database:sd_get(to(N), Ptr) ; Ptr = [] ).
database:get_out_list_pointer(Src, Ptr) :-
	( database:sd_is_node(Src) -> database:sd_node_num(Src, N), database:sd_get(from(N), Ptr) ; Ptr = [] ).
database:get_next_list_pointer(Link, Ptr) :-
	( database:sd_arc_live(Link, N) -> database:sd_get(subs(N), Ptr) ; Ptr = [] ).

database:get_class(Node, Class) :- database:sd_node_live(Node, N), database:sd_class(N, Class).
database:get_type(Arc, Type) :- database:sd_arc_live(Arc, N), database:sd_type(N, Type).

database:get_mdl_exec_vers(7.05).   % MDL_OBJ_VERS, Run/dllcalls.h
