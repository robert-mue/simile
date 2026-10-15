/* Simile's code generator with no Tcl: a model's Simile Prolog in, its C++
   out.

   Simile's Prolog is the whole of desktop Simile, and talks to its Tcl/Tk
   side over a pipe: Tcl calls Prolog goals, Prolog sends Tcl commands and
   waits for the answer (Prolog/tcltk.pl, Run/prolog.tcl). Here the one
   predicate that sends a command, tcltk:any_tcl_eval/3, is replaced by
   answers made in Prolog: files are handled directly, drawing and progress
   are ignored, and the two file choices are settings. Then the goals Tcl
   would call to open a model and export its C++ are called directly — the
   sequence recorded from a real session (tools/engine/README.md, step 3).

   Nothing in Simile's source is changed. Answering in Prolog itself rather
   than over a pipe is what lets the same run in the browser.

     swipl -q headless.pl -g "generate('<simile source>', '<in .pl>', '<out .cpp>')" -t halt
*/

:- dynamic hl_setting/2, hl_var/2, hl_keep/2.

%% The Simile Prolog, as the SWI build loads it, without starting its loop.
%% With the setting structdb(prolog), the model database is struct_db.pl
%% here rather than Simile's C library (needed where there is no loading
%% foreign libraries, as in the browser).
load_simile(SimileDir) :-
	atom_concat(SimileDir, '/Prolog/smain', Main),
	load_files([Main], [silent(true)]),
	abolish(tcltk:any_tcl_eval/3),
	assertz((tcltk:any_tcl_eval(Cmd, _Except, Result) :- hl_tcl(Cmd, Result))),
	(   hl_setting(structdb, prolog)
	->  hl_here(Here),
	    atom_concat(Here, '/struct_db.pl', Db),
	    load_files([Db], [silent(true)]),
	    abolish(database:empty_tree/1),
	    assertz((database:empty_tree(_) :-
			database:empty_tree(root, U),
			asserta(database:node_id_for_root_is(U))))
	;   true
	).

%% The folder this file is in.
:- dynamic hl_dir/1.
:- prolog_load_context(directory, D), assertz(hl_dir(D)).
hl_here(D) :- hl_dir(D).

%% generate(+SimileDir, +InPl, +OutCpp)
generate(SimileDir, In, Out) :-
	settings(SimileDir, In, Out),
	load_simile(SimileDir),
	start_simile(SimileDir),
	export_cpp.

settings(SimileDir, In, Out) :-
	forall(retract(hl_setting(K, V)), (K == structdb -> assertz(hl_keep(K, V)) ; true)),
	forall(retract(hl_keep(K, V)), assertz(hl_setting(K, V))),
	assertz(hl_setting(simile, SimileDir)),
	assertz(hl_setting(input, In)),
	assertz(hl_setting(output, Out)),
	tmp_file(sim, Tmp),
	make_directory(Tmp),
	assertz(hl_setting(tmpdir, Tmp)),
	simile_version(SimileDir, Version),
	assertz(hl_setting(version, Version)).

%% What Tcl calls to open a model and export its C++ (recorded, README).
export_cpp :-
	user:tk_make_desktop_node(0),
	hl_var("fromProlog", Made),
	split_string(Made, " ", "", [NodeS, CanvasS]),
	atom_string(Node, NodeS),
	atom_string(Canvas, CanvasS),
	user:tk_menu(Canvas, file, open),
	user:tk_code(Node, build_c, dummy),
	hl_var("fromProlog", "1").

%% Simile's version, as its Makefile says (MAJREL.MINREL): what Tcl passes.
simile_version(SimileDir, V) :-
	atom_concat(SimileDir, '/Makefile', Mk),
	read_file_to_string(Mk, Text, []),
	split_string(Text, "\n", " \t", Lines),
	member(L1, Lines), split_string(L1, "=", " ", ["MAJREL", Maj]), !,
	member(L2, Lines), split_string(L2, "=", " ", ["MINREL", Min]), !,
	format(atom(V), "~w.~w", [Maj, Min]).

%% What smain.pl's main does before its loop.
start_simile(SimileDir) :-
	prompt(_, ''),
	set_prolog_flag(float_format, '%#.12g'),
	atom_concat(SimileDir, '/System/lib/struct_db', Db),
	database:empty_tree(Db),
	state:retractall(model_in(_, _)),
	prolog_flag(version, FullVnum),
	name(FullVnum, FullVnumStr),
	append(VnumStr, [32, 40 | _], FullVnumStr), !,
	name(Vnum, VnumStr),
	state:kickoff(Vnum).

%% hl_tcl(+Cmd, -ResultCodes): answer one Tcl command.
hl_tcl(Cmd, Result) :-
	tcltk:decode_command(Cmd, Codes),
	string_codes(S, Codes),
	tcl_words(S, Words),
	(   Words = [Name | Args], answer(Name, Args, R)
	->  true
	;   format(user_error, "headless: no answer for: ~s~n", [Codes]),
	    R = ""
	),
	(   hl_setting(trace, true)
	->  format(user_error, "tcl> ~s~n  <= ~s~n", [Codes, R])
	;   true
	),
	string_codes(R, Result).

% -- what the generator asks Tcl, and what it is told --

% Start-up (state:kickoff): the version, the temporary and preferences
% folders, a model to open on start (none), and the edition.
answer("ControlDraw", _, R) :-
	hl_setting(version, V),
	hl_setting(tmpdir, T),
	format(string(R), "~w ~w ~w {} free", [V, T, T]).

% A message key, as Run/messages.tcl expands it (only these two reach C++).
answer("ExpandMessage", [M | _], R) :- message(M, R0) -> R = R0 ; R = M.
% A new model window: Tcl draws it and answers with its canvas.
answer("MainWindowDraw", [_Node, Win | _], C) :- string_concat(Win, ".canvas", C).
answer("format", [F | _], F).
answer("CanvasDefBG", _, "#ffffffffffff").
answer("ChooseFile", [_, Prompt | _], F) :-
	(   sub_string(Prompt, 0, _, _, "Open")
	->  hl_setting(input, F0)
	;   hl_setting(output, F0)
	),
	atom_string(F0, F).
answer("LoadFile", _, "MIME part is a leaf").
answer("EatNumber", [Str], R) :- eat_number(Str, R).   % a plain .pl: Prolog reads it
answer("AttackGlobalVariable", [Name, _, Value], "") :-
	retractall(hl_var(Name, _)),
	assertz(hl_var(Name, Value)).
answer("llength", [Ref], N) :-
	var_ref(Ref, V), tcl_words(V, L), length(L, Len), number_string(Len, N).
answer("lindex", [Ref, I], E) :-
	var_ref(Ref, V), tcl_words(V, L), number_string(Ix, I), nth0(Ix, L, E).
answer("file", ["exists", F], R) :- (exists_file(F) ; exists_directory(F)) -> R = "1" ; R = "0".
answer("file", ["delete", "-force", F], "") :- catch(delete_file(F), _, true).
answer("file", ["delete", F], "") :- catch(delete_file(F), _, true).
answer("file", ["mkdir", D], "") :- make_directory_path(D).
answer("file", ["copy", "-force", From, To], "") :- copy_file(From, To).
answer("file", ["join" | Parts], J) :- atomic_list_concat(Parts, '/', A), atom_string(A, J).
answer("glob", ["-nocomplain", Pattern], R) :-
	expand_file_name(Pattern, Fs0),
	include(exists_file, Fs0, Fs),
	tcl_list(Fs, R).
% At start-up, as Simile's own scripting mode answers: no window. The canvas
% called "dummy" is how kickoff knows it has none.
answer("MakeDesktopNode", [], "none dummy").
answer("clock", ["seconds"], S) :- get_time(T), N is floor(T), number_string(N, S).
answer("set", ["::SIMILE_PATH"], P) :- hl_setting(simile, D), atom_string(D, P).
% The C++ is written; Tcl would compile it, renaming model.cpp to model1.cpp
% as it does (Run/toolbox.tcl compile_c). Only the rename is needed.
answer("compile_c", [Dir | _], "1") :-
	atomic_list_concat([Dir, '/model.cpp'], From),
	atomic_list_concat([Dir, '/model1.cpp'], To),
	rename_file(From, To).
% Any caption being typed on the canvas: none.
answer("string", ["trim", "[GetText" | _], "/no_caption/").
% Preferences: the GUI's defaults. Only flowRouting is asked, and it is on.
answer("PrefValue", _, "1").
% As Simile with no window says (Run/shapes.tcl).
answer("ColourExists", _, "1").
answer("NeedNewExec", _, "1").
answer("CheckFnsFresh", _, "0").
answer("CheckCompilerPresent", _, "1").
answer("ReuseSourceCode", _, "0").
answer("AlterModel", _, "1").
answer("DestroyHelpers", _, "0").
answer("ClearWindow", _, "1").
answer("OpenProgressBox", _, "1").
answer("CloseProgressBox", _, "0").
% drawing, progress and window housekeeping: nothing to do
answer(N, _, "") :- sub_string(N, 0, 3, _, "Put").
answer(N, _, "") :- sub_string(N, 0, 1, _, ".").      % to a canvas itself
answer(N, _, "") :-
	memberchk(N, ["UpdateAbility", "update", "StartGroup",
		      "EndGroup", "PutText", "PutCrossedCirc", "PutCloud",
		      "PutRectangle", "ChangeRegion", "FillProgressBox",
		      "ChangeParentTitle", "CeaseRun", "Undisturb",
	      "UpdateCursors", "ColorSymbol", "DebugMess", "Query"]).

%% eat_number(+String, -Answer): Run/toolbox.tcl's EatNumber. The number at
%% the start of String ("Value Length"): an int if it reads as one (and is
%% below 2^28), else the float printed as Tcl's expr prints it, with a point.
eat_number(Str, R) :-
	string_codes(Str, Cs),
	phrase(spaces(NS), Cs, Rest),
	phrase(float_text(F), Rest, _), F \== [],
	length(F, LF), FSize is NS + LF,
	(   phrase(int_text(I), Rest, _), I \== [],
	    length(I, LI), NS + LI =:= FSize,
	    number_codes(IV, I), abs(IV) < 268435456
	->  format(string(R), "~d ~d", [IV, FSize])
	;   readable_float(F, RF), number_codes(FV, RF)
	),
	(   nonvar(R) -> true
	;   FV1 is float(FV), tcl_float(FV1, T), format(string(R), "~w ~d", [T, FSize])
	).

%% What scan %g reads, in a form number_codes/2 takes: digits both sides of
%% the point (".5", "5.", "5.e3" are all numbers to Tcl).
readable_float(F, R) :-
	( F = [S | T], (S == 0'- ; S == 0'+) -> Sign = [S] ; Sign = [], T = F ),
	( T = [0'. | _] -> T1 = [0'0 | T] ; T1 = T ),
	(   append(Pre, [0'. | Post], T1)
	->  ( (Post == [] ; Post = [E | _], (E == 0'e ; E == 0'E)) -> append([Pre, `.0`, Post], T2) ; T2 = T1 )
	;   append(Pre, [E | Post], T1), (E == 0'e ; E == 0'E)
	->  append([Pre, `.0e`, Post], T2)
	;   append(T1, `.0`, T2)
	),
	append(Sign, T2, R).

spaces(N) --> [C], { code_type(C, space) }, !, spaces(N0), { N is N0 + 1 }.
spaces(0) --> [].
sign([C]) --> [C], { C == 0'+ ; C == 0'- }, !.
sign([]) --> [].
digits([D | Ds]) --> [D], { code_type(D, digit) }, !, digits(Ds).
digits([]) --> [].
int_text(T) --> sign(S), digits(D), { D \== [], append(S, D, T) }.
float_text(T) --> sign(S), digits(D1),
	( ".", digits(D2) -> { Frac = [0'. | D2] } ; { D2 = [], Frac = [] } ),
	{ append(D1, D2, Ds), Ds \== [] },
	( exponent(E) -> [] ; { E = [] } ),
	{ append([S, D1, Frac, E], T) }.
exponent([0'e | T]) --> [C], { C == 0'e ; C == 0'E }, sign(S), digits(D), { D \== [], append(S, D, T) }.

%% tcl_float(+Float, -Text): as Tcl 8.6 prints a double — the shortest digits
%% that read back the same; fixed for exponents -4..16, else d.ddde+X (the
%% exponent unpadded); and,
%% as EatNumber insists, always with a point.
tcl_float(F, T) :-
	shortest_digits(F, Neg, Digits, Exp),
	length(Digits, N),
	(   Exp >= -4, Exp < 17
	->  (   Exp >= N - 1
	    ->  Pad is Exp - N + 1, length(Zs, Pad), maplist(=(0'0), Zs),
		append([Digits, Zs, `.0`], Body)
	    ;   Exp >= 0
	    ->  Int is Exp + 1, length(IP, Int), append(IP, FP, Digits),
		append([IP, `.`, FP], Body)
	    ;   Lead is -Exp - 1, length(Zs, Lead), maplist(=(0'0), Zs),
		append([`0.`, Zs, Digits], Body)
	    )
	;   Digits = [D1 | More],
	    ( More == [] -> Mant = [D1, 0'., 0'0] ; append([[D1], `.`, More], Mant) ),
	    ( Exp < 0 -> ES = 0'- ; ES = 0'+ ),
	    AE is abs(Exp), number_codes(AE, EC),
	    append([Mant, [0'e, ES], EC], Body)
	),
	( Neg == true -> Out = [0'- | Body] ; Out = Body ),
	string_codes(T, Out).

%% Shortest round-trip digits of a float, as SWI writes it, and its exponent.
shortest_digits(F, Neg, Digits, Exp) :-
	( F < 0 -> Neg = true, A is -F ; Neg = false, A = F ),
	(   A =:= 0
	->  Digits = `0`, Exp = 0
	;   format(codes(Cs), "~w", [A]),
	    (   append(M, [0'e | ECs], Cs) -> number_codes(E0, ECs) ; M = Cs, E0 = 0 ),
	    ( append(IP, [0'. | FP], M) -> true ; IP = M, FP = [] ),
	    append(IP, FP, All0),
	    strip_leading_zeros(All0, All, Dropped),
	    length(IP, LI),
	    Exp is E0 + LI - 1 - Dropped,
	    strip_trailing_zeros(All, Digits)
	).

strip_leading_zeros([0'0 | T], R, N) :- T \== [], !, strip_leading_zeros(T, R, N0), N is N0 + 1.
strip_leading_zeros(L, L, 0).
strip_trailing_zeros(L, R) :- append(R, Zs, L), R \== [], maplist(==(0'0), Zs), !.

%% tcl_list(+Items, -String): a Tcl list; an item with a space is braced.
tcl_list(Items, S) :-
	maplist(tcl_item, Items, Parts),
	atomic_list_concat(Parts, ' ', A),
	atom_string(A, S).
tcl_item(I, P) :-
	(   ( sub_atom(I, _, _, _, ' ') ; I == '' )
	->  format(atom(P), "{~w}", [I])
	;   P = I
	).

message("desktop_abbrev", "Desktop").
message("unsaved", "unsaved").

var_ref(Ref, Value) :-
	sub_string(Ref, 0, 3, _, "$::"),
	sub_string(Ref, 3, _, 0, Name),
	hl_var(Name, Value).

%% tcl_words(+String, -Words): a Tcl command's words; braces group, and are
%% removed from the outside of a word. Enough for what Simile sends.
tcl_words(S, Words) :-
	string_codes(S, Cs),
	phrase(words(Words), Cs).

words(Ws) --> blanks, ( word(W) -> { Ws = [W | Rest] }, words(Rest) ; { Ws = [] } ).
blanks --> [C], { code_type(C, space) }, !, blanks.
blanks --> [].
word(W) --> "{", !, braced(0, Cs), { string_codes(W, Cs) }.
word(W) --> plain(Cs), { Cs \== [], string_codes(W, Cs) }.
braced(0, []) --> "}", !.
braced(D, [0'} | Cs]) --> "}", !, { D1 is D - 1 }, braced(D1, Cs).
braced(D, [0'{ | Cs]) --> "{", !, { D1 is D + 1 }, braced(D1, Cs).
braced(D, [C | Cs]) --> [C], braced(D, Cs).
plain([C | Cs]) --> [C], { \+ code_type(C, space) }, !, plain(Cs).
plain([]) --> [].

%% From the command line:
%%   swipl headless.pl <simile source> <in .pl> <out .cpp>
%% Exit status 0 when the C++ was written.
:- initialization(cli, main).

cli :-
	current_prolog_flag(argv, Argv),
	(   select('--structdb=prolog', Argv, [Src, In, Out])
	->  assertz(hl_setting(structdb, prolog))
	;   Argv = [Src, In, Out]
	), !,
	(   catch(generate(Src, In, Out), E, (print_message(error, E), fail))
	->  halt(0)
	;   format(user_error, "headless: no C++ written for ~w~n", [In]),
	    halt(1)
	).
cli :-
	current_prolog_flag(argv, []), !.          % loaded as a library
cli :-
	format(user_error, "usage: swipl headless.pl [--structdb=prolog] <simile source> <in .pl> <out .cpp>~n", []),
	halt(2).
