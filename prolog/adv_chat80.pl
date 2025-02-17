:-module(parser_chat80, [chat80/0,test_chat80_regressions/0,t80/0]).

% t10/0,t11/0,t12/0,t13/0,t14/0,satisfy/1,holds_truthvalue/2

%:- nop(ensure_loaded('adv_chat80')).
%:- ensure_loaded('./marty_white/adv_main').

%:- ensure_loaded('./nomic_mu').

%:- initialization(mu:adventure,main).


/** <module>
% Imperitive Sentence Parser (using DCG)
%
% Logicmoo Project PrologMUD: A MUD server written in Prolog
% Maintainer: Douglas Miles
% Dec 13, 2035
%
 _________________________________________________________________________
|	Copyright (C) 1982						  |
|									  |
|	David Warren,							  |
|		SRI International, 333 Ravenswood Ave., Menlo Park,	  |
|		California 94025, USA;					  |
|									  |
|	Fernando Pereira,						  |
|		Dept. of Architecture, University of Edinburgh,		  |
|		20 Chambers St., Edinburgh EH1 1JZ, Scotland		  |
|									  |
|	This program may be used, copied, altered or included in other	  |
|	programs only for academic purposes and provided that the	  |
|	authorship of the initial program is aknowledged.		  |
|	Use for commercial purposes without the previous written 	  |
|	agreement of the authors is forbidden.				  |
|_________________________________________________________________________|

*/
% :- include(logicmoo('vworld/moo_header.pl')).

% :- use_module(library(pfc_lib)).

%:- use_module(library(with_thread_local)).
%:- load_library_system(library(logicmoo_plarkc)).
%:- kb_shared(baseKB:que/2).
%:- '$set_source_module'(baseKB).
%:- '$set_typein_module'(baseKB).

:- thread_local(t_l:disable_px/0).
:- thread_local(t_l:usePlTalk/0).
:- thread_local(t_l:useAltPOS/0).
:- thread_local(t_l:tracing80/0).
:- thread_local(t_l:chat80_interactive/0).
:- thread_local(t_l:useOnlyExternalDBs).
:- dynamic(thglobal:use_cyc_database/0).

:- user:ensure_loaded((parser_sharing)).

% ================================================================================================
% PLDATA: LOAD ENGLISH CORE FILES
% ================================================================================================

% :- time(ignore((absolute_file_name(library(el_holds/'el_assertions.pl.qlf'),AFN),(exists_file(AFN)->true;qcompile(library(el_holds/'el_assertions.pl.hide')))))).

get_it:- 
 time(ignore((absolute_file_name(library(el_holds/'el_assertions.pl.qlf'),AFN),   
  (exists_file(AFN)->true;(
    (absolute_file_name(library(el_holds),AFND),sformat( S, 'curl --compressed http://prologmoo.com/devel/LogicmooDeveloperFramework/PrologMUD/pack/pldata_larkc/prolog/el_holds/el_assertions.pl.qlf > ~w/el_assertions.pl.qlf',[AFND]),
    shell(S))))))).


:- dmsg("Loading loading language data (This may take 10-15 seconds)").

% 
% gripe_time(warn(12.246577455>7),        user:time(pfc_lib:load_parser_interface(library(el_holds/'el_assertions.pl.qlf')))).
% OLD :- gripe_time(7,time(pfc_lib:load_parser_interface(library(el_holds/'el_assertions.pl.qlf')))).
%:- ensure_loaded(nldata/nldata_talk_db_pdat).


% 6.052 CPU on VMWare I7

% term_expansion(G,I,GG,O):- compound(I),source_location(File,_),prolog_load_context(module,Module),using_shared_parser_data(Module,File),importing_clause(G,GG) -> G \== GG, I=O.
:- ensure_loaded(nldata/clex_iface).

:- shared_parser_data(clex:clex_adj/3).
:- shared_parser_data(clex:clex_noun/5).

% :- set_prolog_flag(qcompile,false).

%:- include('marty_white/adv_util.pro').

:- module_transparent(cycQuery80/1).
cycQuery80(Q):- notrace(current_predicate(_,Q)),call(Q).

:- retractall(t_l:disable_px).
:- asserta(t_l:disable_px).

:- shared_parser_data(talk_db:talk_db/2).
:- shared_parser_data(talk_db:talk_db/3).
:- shared_parser_data(talk_db:talk_db/6).


%:- shared_parser_data(transitive_subclass/2).
%:- shared_parser_data(tSet/1).
%:- shared_parser_data(ttFormatType/1).
:- shared_parser_data(capitalized/5).
%:- shared_parser_data(isa/2).
%:- shared_parser_data(mpred_arity/2).
%:- shared_parser_data(posName/1).


:- shared_parser_data(parser_chat80:longitude80/2).
:- shared_parser_data(parser_chat80:latitude80/2).

%:- share_mp(term_depth/2).

:- share_mp(common_logic_kb_hooks:cyckb_t/1).
:- share_mp(common_logic_kb_hooks:cyckb_t/2).
:- share_mp(common_logic_kb_hooks:cyckb_t/3).
:- share_mp(common_logic_kb_hooks:cyckb_t/4).
:- share_mp(common_logic_kb_hooks:cyckb_t/5).
:- share_mp(common_logic_kb_hooks:cyckb_t/6).
:- share_mp(common_logic_kb_hooks:cyckb_t/7).
:- share_mp(common_logic_kb_hooks:cyckb_t/8).
:- share_mp(memoize_pos_to_db/4).
:- share_mp(must_test_801/3).

:- if(current_module(pfc)).
:- share_mp(mpred_core:call_u/1).
:- endif.

/*
:- meta_predicate holds_truthvalue(*,*). %  0,* = breaks it
:- meta_predicate satisfy(*). %  0 = breaks it

%:- meta_predicate theTextL(*,*,0,*,*,*,*).
:- meta_predicate call_with_limits0(0).
:- meta_predicate exception(0).
:- meta_predicate call_in_banner(*,0).
:- meta_predicate if_try(0,0).
:- meta_predicate safely_call(0).
:- meta_predicate control80(4,*).
:- meta_predicate process_run_real(4,*,*,*,*).


%:- meta_predicate no_repeats_must(0).
%:- meta_predicate call_with_limits(0).
:- meta_predicate loop_check_chat80(0).
:- meta_predicate loop_check_chat80(0,0).

:- meta_predicate hi80(4,*).
:- meta_predicate plt_call(*,*,0).
:- meta_predicate plt2_call(*,*,0).
:- meta_predicate process_run(4,*,*,*).
:- meta_predicate process_run_diff(4,*,*,*).
*/
                                
:- op(600,xfy,--).
% :- op(450,xfy,((:))).

:- if( \+ current_op(_,_,(user:'&'))).
:- op(400,xfy,((user:'&'))).
:- endif.

:- op(300,fx,(('`'))).
:- op(200,xfx,((--))).

% :- baseKB:setup_mpred_ops.
% :- register_module_type(utility).


:- shared_parser_data(parser_chat80:(contains0/2,country/8,city/3,borders/2,in_continent/2)).
:- shared_parser_data(parser_chat80:contains/2).
:- shared_parser_data(parser_chat80:trans/9).
:- shared_parser_data(parser_chat80:sentence80/5).
%:- shared_parser_data(parser_chat80:noun/6).
%:- shared_parser_data(parser_chat80:det/7).

chat80_t(UIn):- chat80_t(UIn,O1,_O2),wdmsg(O1).
chat80_t(UIn,O1,O2):-
   convert_to_sel_string(fail,a,=,UIn,Mid),!,
   process_run_real(_Callback,_StartParse,Mid,O1,O2),
   flush_output_safe,!.

process_run_real(Callback,StartParse,Mid,O1,O2):- chat80:process(Callback,StartParse,Mid,O1,O2).


:- style_check(+discontiguous).  
:- asserta((t_l:enable_src_loop_checking)).

numbervars80(Term,Start,End):- numbervars(Term,Start,End,[attvar(bind),functor_name('$VAR'),singletons(false)]).

copy_term80(Term,Copy):- copy_term(Term,Copy),!.

% ran on server start
must_test_80_sanity([what, rivers, are, there, ?], [sent([what, rivers, are, there, ?]), parse(whq(feature&river-B, s(np(3+plu, np_head(int_det(feature&river-B), [], river), []), verb(be, active, pres+fin, [], pos), [void], []))), sem((answer([A]):-river(A), A^true)), qplan((answer([B]):-river(B), B^true)), answers([amazon, amu_darya, amur, brahmaputra, colorado, congo_river, cubango, danube, don, elbe, euphrates, ganges, hwang_ho, indus, irrawaddy, lena, limpopo, mackenzie, mekong, mississippi, murray, niger_river, nile, ob, oder, orange, orinoco, parana, rhine, rhone, rio_grande, salween, senegal_river, tagus, vistula, volga, volta, yangtze, yenisei, yukon, zambesi])],[time(0.0)]).
must_test_80_sanity([what, countries, are, there, in, europe, ?], [sent([what, countries, are, there, in, europe, ?]), parse(whq(feature&place&country-B, s(np(3+plu, np_head(int_det(feature&place&country-B), [], country), []), verb(be, active, pres+fin, [], pos), [void], [pp(prep(in), np(3+sin, name(europe), []))]))), sem((answer([A]):-country(A), in(A, europe))), qplan((answer([A]):-in(A, europe), {country(A)})), answers([albania, andorra, austria, belgium, bulgaria, cyprus, czechoslovakia, denmark, east_germany, eire, finland, france, greece, hungary, iceland, italy, liechtenstein, luxembourg, malta, monaco, netherlands, norway, poland, portugal, romania, san_marino, spain, sweden, switzerland, united_kingdom, west_germany, yugoslavia])],[time(0.0010000000000000009)]).
must_test_80_sanity([which, country, '\'', s, capital, is, london, ?], [sent([which, country, '\'', s, capital, is, london, ?]), parse(whq(feature&place&country-B, s(np(3+sin, np_head(det(the(sin)), [], capital), [pp(poss, np(3+sin, np_head(int_det(feature&place&country-B), [], country), []))]), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, name(london), []))], []))), sem((answer([A]):-country(A), capital(A, london))), qplan((answer([A]):-capital(A, london), {country(A)})), answers([united_kingdom])],[time(0.0010000000000000009)]).
must_test_80_sanity([what, is, the, total, area, of, countries, south, of, the, equator, and, not, in, australasia, ?], [sent([what, is, the, total, area, of, countries, south, of, the, equator, and, not, in, australasia, ?]), parse(whq(A-B, s(np(3+sin, wh(A-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [adj(total)], area), [pp(prep(of), np(3+plu, np_head(generic, [], country), [conj(and, reduced_rel(feature&place&country-F, s(np(3+plu, wh(feature&place&country-F), []), verb(be, active, pres+fin, [], pos), [arg(pred, pp(prep(southof), np(3+sin, name(equator), [])))], [])), reduced_rel(feature&place&country-F, s(np(3+plu, wh(feature&place&country-F), []), verb(be, active, pres+fin, [], neg), [arg(pred, pp(prep(in), np(3+sin, name(australasia), [])))], [])))]))]))], []))), sem((answer([A]):-B^ (setof(C:[D], (area(D, C), country(D), southof(D, equator), \+in(D, australasia)), B), aggregate(total, B, A)))), qplan((answer([E]):-D^ (setof(C:[B], (southof(B, equator), area(B, C), {country(B)}, {\+in(B, australasia)}), D), aggregate(total, D, E)))), answers([10239--ksqmiles])],[time(0.0010000000000000009)]).

% ran on regression testing
must_test_80(U,R,O):-must_test_80_sanity(U,R,O).
must_test_80([does, afghanistan, border, china, ?], [sent([does, afghanistan, border, china, ?]), parse(q(s(np(3+sin, name(afghanistan), []), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+sin, name(china), []))], []))), sem((answer([]):-borders(afghanistan, china))), qplan((answer([]):-{borders(afghanistan, china)})), answers([true])],[time(0.0)]).
must_test_80([what, is, the, capital, of, upper_volta, ?], [sent([what, is, the, capital, of, upper_volta, ?]), parse(whq(feature&city-B, s(np(3+sin, wh(feature&city-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [], capital), [pp(prep(of), np(3+sin, name(upper_volta), []))]))], []))), sem((answer([A]):-capital(upper_volta, A))), qplan((answer([A]):-capital(upper_volta, A))), answers([ouagadougou])],[time(0.0010000000000000009)]).
must_test_80([where, is, the, largest, country, ?], [sent([where, is, the, largest, country, ?]), parse(whq(feature&place&A-B, s(np(3+sin, np_head(det(the(sin)), [sup(most, adj(large))], country), []), verb(be, active, pres+fin, [], pos), [arg(pred, pp(prep(in), np(_, np_head(int_det(feature&place&A-B), [], place), [])))], []))), sem((answer([A]):-B^ (C^ (setof(D:E, (country(E), area(E, D)), C), aggregate(max, C, B)), place(A), in(B, A)))), qplan((answer([F]):-E^D^ (setof(C:B, (country(B), area(B, C)), D), aggregate(max, D, E), in(E, F), {place(F)}))), answers([asia, northern_asia])],[time(0.0009999999999999731)]).
must_test_80([which, countries, are, european, ?], [sent([which, countries, are, european, ?]), parse(whq(feature&place&country-B, s(np(3+plu, np_head(int_det(feature&place&country-B), [], country), []), verb(be, active, pres+fin, [], pos), [arg(pred, adj(european))], []))), sem((answer([A]):-country(A), european(A))), qplan((answer([A]):-european(A), {country(A)})), answers([albania, andorra, austria, belgium, bulgaria, cyprus, czechoslovakia, denmark, east_germany, eire, finland, france, greece, hungary, iceland, italy, liechtenstein, luxembourg, malta, monaco, netherlands, norway, poland, portugal, romania, san_marino, spain, sweden, switzerland, united_kingdom, west_germany, yugoslavia])],[time(0.0)]).
must_test_80([which, is, the, largest, african, country, ?], [sent([which, is, the, largest, african, country, ?]), parse(whq(feature&place&country-B, s(np(3+sin, wh(feature&place&country-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [sup(most, adj(large)), adj(african)], country), []))], []))), sem((answer([A]):-B^ (setof(C:D, (country(D), area(D, C), african(D)), B), aggregate(max, B, A)))), qplan((answer([D]):-C^ (setof(B:A, (african(A), {country(A)}, area(A, B)), C), aggregate(max, C, D)))), answers([sudan])],[time(0.0)]).
must_test_80([how, large, is, the, smallest, american, country, ?], [sent([how, large, is, the, smallest, american, country, ?]), parse(whq(measure&area-B, s(np(3+sin, np_head(det(the(sin)), [sup(most, adj(small)), adj(american)], country), []), verb(be, active, pres+fin, [], pos), [arg(pred, value(adj(large), wh(measure&area-B)))], []))), sem((answer([A]):-B^ (C^ (setof(D:E, (country(E), area(E, D), american(E)), C), aggregate(min, C, B)), area(B, A)))), qplan((answer([E]):-D^C^ (setof(B:A, (american(A), {country(A)}, area(A, B)), C), aggregate(min, C, D), area(D, E)))), answers([0--ksqmiles])],[time(0.0)]).
must_test_80([what, is, the, ocean, that, borders, african, countries, and, that, borders, asian, countries, ?], [sent([what, is, the, ocean, that, borders, african, countries, and, that, borders, asian, countries, ?]), parse(whq(feature&place&seamass-B, s(np(3+sin, wh(feature&place&seamass-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [], ocean), [conj(and, rel(feature&place&seamass-C, s(np(3+sin, wh(feature&place&seamass-C), []), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(generic, [adj(african)], country), []))], [])), rel(feature&place&seamass-C, s(np(3+sin, wh(feature&place&seamass-C), []), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(generic, [adj(asian)], country), []))], [])))]))], []))), sem((answer([A]):-ocean(A), B^ (country(B), african(B), borders(A, B)), C^ (country(C), asian(C), borders(A, C)))), qplan((answer([A]):-B^C^ (ocean(A), {borders(A, B), {african(B)}, {country(B)}}, {borders(A, C), {asian(C)}, {country(C)}}))), answers([indian_ocean])],[time(0.0020000000000000018)]).
must_test_80([what, are, the, capitals, of, the, countries, bordering, the, baltic, ?], [sent([what, are, the, capitals, of, the, countries, bordering, the, baltic, ?]), parse(whq(feature&city-B, s(np(3+plu, wh(feature&city-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(det(the(plu)), [], capital), [pp(prep(of), np(3+plu, np_head(det(the(plu)), [], country), [reduced_rel(feature&place&country-D, s(np(3+plu, wh(feature&place&country-D), []), verb(border, active, inf, [prog], pos), [arg(dir, np(3+sin, name(baltic), []))], []))]))]))], []))), sem((answer([D]):-setof([A]:C, (country(A), borders(A, baltic), setof(B, capital(A, B), C)), D))), qplan((answer([H]):-setof([E]:G, (country(E), borders(E, baltic), setof(F, capital(E, F), G)), H))), answers([[[denmark]:[copenhagen], [east_germany]:[east_berlin], [finland]:[helsinki], [poland]:[warsaw], [soviet_union]:[moscow], [sweden]:[stockholm], [west_germany]:[bonn]]])],[time(0.0010000000000000009)]).
must_test_80([which, countries, are, bordered, by, two, seas, ?], [sent([which, countries, are, bordered, by, two, seas, ?]), parse(whq(feature&place&country-B, s(np(3+plu, np_head(int_det(feature&place&country-B), [], country), []), verb(border, passive, pres+fin, [], pos), [], [pp(prep(by), np(3+plu, np_head(quant(same, nquant(2)), [], sea), []))]))), sem((answer([A]):-country(A), numberof(B, (sea(B), borders(B, A)), 2))), qplan((answer([B]):-numberof(A, (sea(A), borders(A, B)), 2), {country(B)})), answers([egypt, iran, israel, saudi_arabia, turkey])],[time(0.0)]).
must_test_80([how, many, countries, does, the, danube, flow, through, ?], [sent([how, many, countries, does, the, danube, flow, through, ?]), parse(whq(feature&place&country-B, s(np(3+sin, name(danube), []), verb(flow, active, pres+fin, [], pos), [], [pp(prep(through), np(3+plu, np_head(quant(same, wh(feature&place&country-B)), [], country), []))]))), sem((answer([A]):-numberof(B, (country(B), flows(danube, B)), A))), qplan((answer([B]):-numberof(A, (flows(danube, A), {country(A)}), B))), answers([6])],[time(0.0010000000000000009)]).
must_test_80([what, is, the, average, area, of, the, countries, in, each, continent, ?], [sent([what, is, the, average, area, of, the, countries, in, each, continent, ?]), parse(whq(A-C, s(np(3+sin, wh(A-C), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [adj(average)], area), [pp(prep(of), np(3+plu, np_head(det(the(plu)), [], country), [pp(prep(in), np(3+sin, np_head(det(each), [], continent), []))]))]))], []))), sem((answer([B, E]):-continent(B), [ (0--ksqmiles):[andorra], (0--ksqmiles):[liechtenstein], (0--ksqmiles):[malta], (0--ksqmiles):[monaco], (0--ksqmiles):[san_marino], (1--ksqmiles):[luxembourg], (4--ksqmiles):[cyprus], (11--ksqmiles):[albania], (12--ksqmiles):[belgium], (14--ksqmiles):[netherlands], (16--ksqmiles):[switzerland], (17--ksqmiles):[denmark], (27--ksqmiles):[eire], (32--ksqmiles):[austria], (35--ksqmiles):[portugal], (36--ksqmiles):[hungary], (40--ksqmiles):[iceland], (41--ksqmiles):[east_germany], (43--ksqmiles):[bulgaria], (49--ksqmiles):[czechoslovakia], (51--ksqmiles):[greece], (92--ksqmiles):[romania], (94--ksqmiles):[united_kingdom], (96--ksqmiles):[west_germany], (99--ksqmiles):[yugoslavia], (116--ksqmiles):[italy], (120--ksqmiles):[poland], (125--ksqmiles):[norway], (130--ksqmiles):[finland], (174--ksqmiles):[sweden], (195--ksqmiles):[spain], (213--ksqmiles):[france]] ^  (setof(D:[C], (area(C, D), country(C), in(C, B)), [ (0--ksqmiles):[andorra], (0--ksqmiles):[liechtenstein], (0--ksqmiles):[malta], (0--ksqmiles):[monaco], (0--ksqmiles):[san_marino], (1--ksqmiles):[luxembourg], (4--ksqmiles):[cyprus], (11--ksqmiles):[albania], (12--ksqmiles):[belgium], (14--ksqmiles):[netherlands], (16--ksqmiles):[switzerland], (17--ksqmiles):[denmark], (27--ksqmiles):[eire], (32--ksqmiles):[austria], (35--ksqmiles):[portugal], (36--ksqmiles):[hungary], (40--ksqmiles):[iceland], (41--ksqmiles):[east_germany], (43--ksqmiles):[bulgaria], (49--ksqmiles):[czechoslovakia], (51--ksqmiles):[greece], (92--ksqmiles):[romania], (94--ksqmiles):[united_kingdom], (96--ksqmiles):[west_germany], (99--ksqmiles):[yugoslavia], (116--ksqmiles):[italy], (120--ksqmiles):[poland], (125--ksqmiles):[norway], (130--ksqmiles):[finland], (174--ksqmiles):[sweden], (195--ksqmiles):[spain], (213--ksqmiles):[france]]), aggregate(average, [ (0--ksqmiles):[andorra], (0--ksqmiles):[liechtenstein], (0--ksqmiles):[malta], (0--ksqmiles):[monaco], (0--ksqmiles):[san_marino], (1--ksqmiles):[luxembourg], (4--ksqmiles):[cyprus], (11--ksqmiles):[albania], (12--ksqmiles):[belgium], (14--ksqmiles):[netherlands], (16--ksqmiles):[switzerland], (17--ksqmiles):[denmark], (27--ksqmiles):[eire], (32--ksqmiles):[austria], (35--ksqmiles):[portugal], (36--ksqmiles):[hungary], (40--ksqmiles):[iceland], (41--ksqmiles):[east_germany], (43--ksqmiles):[bulgaria], (49--ksqmiles):[czechoslovakia], (51--ksqmiles):[greece], (92--ksqmiles):[romania], (94--ksqmiles):[united_kingdom], (96--ksqmiles):[west_germany], (99--ksqmiles):[yugoslavia], (116--ksqmiles):[italy], (120--ksqmiles):[poland], (125--ksqmiles):[norway], (130--ksqmiles):[finland], (174--ksqmiles):[sweden], (195--ksqmiles):[spain], (213--ksqmiles):[france]], E)))), qplan((answer([F, J]):-continent(F), I^ (setof(H:[G], (area(G, H), country(G), in(G, F)), I), aggregate(average, I, J)))), answers([[europe, 58.84375--ksqmiles]])],[time(0.0040000000000000036)]).
must_test_80([is, there, more, than, one, country, in, each, continent, ?], [sent([is, there, more, than, one, country, in, each, continent, ?]), parse(q(s(there, verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(quant(more, nquant(1)), [], country), [pp(prep(in), np(3+sin, np_head(det(each), [], continent), []))]))], []))), sem((answer([]):- \+A^ (continent(A), \+C^ (numberof(B, (country(B), in(B, A)), C), C>1)))), qplan((answer([]):- \+D^ (continent(D), \+F^ (numberof(E, (country(E), in(E, D)), F), F>1)))), answers([false])],[time(0.0010000000000000009)]).
must_test_80([is, there, some, ocean, that, does, not, border, any, country, ?], [sent([is, there, some, ocean, that, does, not, border, any, country, ?]), parse(q(s(there, verb(be, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(some), [], ocean), [rel(feature&place&seamass-B, s(np(3+sin, wh(feature&place&seamass-B), []), verb(border, active, pres+fin, [], neg), [arg(dir, np(3+sin, np_head(det(any), [], country), []))], []))]))], []))), sem((answer([]):-A^ (ocean(A), \+B^ (country(B), borders(A, B))))), qplan((answer([]):-A^{ocean(A), {\+B^ (borders(A, B), {country(B)})}})), answers([true])],[time(0.0010000000000000009)]).
must_test_80([what, are, the, countries, from, which, a, river, flows, into, the, black_sea, ?], [sent([what, are, the, countries, from, which, a, river, flows, into, the, black_sea, ?]), parse(whq(feature&place&country-B, s(np(3+plu, wh(feature&place&country-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(det(the(plu)), [], country), [rel(feature&place&country-D, s(np(3+sin, np_head(det(a), [], river), []), verb(flow, active, pres+fin, [], pos), [], [pp(prep(from), np(3+plu, wh(feature&place&country-D), [])), pp(prep(into), np(3+sin, name(black_sea), []))]))]))], []))), sem((answer([A]):-setof(B, (country(B), C^ (river(C), flows(C, B, black_sea))), A))), qplan((answer([C]):-setof(B, A^ (flows(A, B, black_sea), {country(B)}, {river(A)}), C))), answers([[romania]])],[time(0.0010000000000000009)]).
must_test_80([what, are, the, continents, no, country, in, which, contains, more, than, two, cities, whose, population, exceeds, nquant(1), million, ?], [sent([what, are, the, continents, no, country, in, which, contains, more, than, two, cities, whose, population, exceeds, nquant(1), million, ?]), parse(whq(feature&place&continent-B, s(np(3+plu, wh(feature&place&continent-B), []), verb(be, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(det(the(plu)), [], continent), [rel(feature&place&continent-D, s(np(3+sin, np_head(det(no), [], country), [pp(prep(in), np(3+plu, wh(feature&place&continent-D), []))]), verb(contain, active, pres+fin, [], pos), [arg(dir, np(3+plu, np_head(quant(more, nquant(2)), [], city), [rel(feature&city-G, s(np(3+sin, np_head(det(the(sin)), [], population), [pp(poss, np(3+plu, wh(feature&city-G), []))]), verb(exceed, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(quant(same, nquant(1)), [], million), []))], []))]))], []))]))], []))), sem((answer([F]):-setof(A, (continent(A), \+B^ (country(B), in(B, A), E^ (numberof(C, (city(C), D^ (population(C, D), exceeds(D, 1--million)), in(C, B)), E), E>2))), F))), qplan((answer([L]):-setof(G, (continent(G), \+H^ (country(H), in(H, G), K^ (numberof(I, (city(I), J^ (population(I, J), exceeds(J, 1--million)), in(I, H)), K), K>2))), L))), answers([[africa, america, antarctica, asia, australasia, europe]])],[time(0.05499999999999999)]).
must_test_80([which, country, bordering, the, mediterranean, borders, a, country, that, is, bordered, by, a, country, whose, population, exceeds, the, population, of, india, ?], [sent([which, country, bordering, the, mediterranean, borders, a, country, that, is, bordered, by, a, country, whose, population, exceeds, the, population, of, india, ?]), parse(whq(feature&place&country-B, s(np(3+sin, np_head(int_det(feature&place&country-B), [], country), [reduced_rel(feature&place&country-B, s(np(3+sin, wh(feature&place&country-B), []), verb(border, active, inf, [prog], pos), [arg(dir, np(3+sin, name(mediterranean), []))], []))]), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(a), [], country), [rel(feature&place&country-C, s(np(3+sin, wh(feature&place&country-C), []), verb(border, passive, pres+fin, [], pos), [], [pp(prep(by), np(3+sin, np_head(det(a), [], country), [rel(feature&place&country-D, s(np(3+sin, np_head(det(the(sin)), [], population), [pp(poss, np(3+sin, wh(feature&place&country-D), []))]), verb(exceed, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(the(sin)), [], population), [pp(prep(of), np(3+sin, name(india), []))]))], []))]))]))]))], []))), sem((answer([A]):-country(A), borders(A, mediterranean), B^ (country(B), C^ (country(C), D^ (population(C, D), E^ (population(india, E), exceeds(D, E))), borders(C, B)), borders(A, B)))), qplan((answer([B]):-C^D^E^A^ (population(india, A), borders(B, mediterranean), {country(B)}, {borders(B, C), {country(C)}, {borders(D, C), {country(D)}, {population(D, E), {exceeds(E, A)}}}}))), answers([turkey])],[time(0.0020000000000000018)]).
must_test_80([which, countries, have, a, population, exceeding, nquant(10), million, ?], [sent([which, countries, have, a, population, exceeding, nquant(10), million, ?]), parse(whq(feature&place&country-B, s(np(3+plu, np_head(int_det(feature&place&country-B), [], country), []), verb(have, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(a), [], population), [reduced_rel(measure&heads-C, s(np(3+sin, wh(measure&heads-C), []), verb(exceed, active, inf, [prog], pos), [arg(dir, np(3+plu, np_head(quant(same, nquant(10)), [], million), []))], []))]))], []))), sem((answer([A]):-country(A), B^ (exceeds(B, 10--million), population(A, B)))), qplan((answer([A]):-B^ (country(A), {population(A, B), {exceeds(B, 10--million)}}))), answers([malaysia, uganda])],[time(0.0010000000000000009)]).
must_test_80([which, countries, with, a, population, exceeding, nquant(10), million, border, the, atlantic, ?], [sent([which, countries, with, a, population, exceeding, nquant(10), million, border, the, atlantic, ?]), parse(whq(feature&place&country-B, s(np(3+plu, np_head(int_det(feature&place&country-B), [], country), [pp(prep(with), np(3+sin, np_head(det(a), [], population), [reduced_rel(measure&heads-C, s(np(3+sin, wh(measure&heads-C), []), verb(exceed, active, inf, [prog], pos), [arg(dir, np(3+plu, np_head(quant(same, nquant(10)), [], million), []))], []))]))]), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+sin, name(atlantic), []))], []))), sem((answer([A]):-B^ (population(A, B), exceeds(B, 10--million), country(A)), borders(A, atlantic))), qplan((answer([A]):-B^ (borders(A, atlantic), {population(A, B), {exceeds(B, 10--million)}}, {country(A)}))), answers([venezuela])],[time(0.0010000000000000009)]).
must_test_80([what, percentage, of, countries, border, each, ocean, ?], [sent([what, percentage, of, countries, border, each, ocean, ?]), parse(whq(A-C, s(np(3+plu, np_head(int_det(A-C), [], percentage), [pp(prep(of), np(3+plu, np_head(generic, [], country), []))]), verb(border, active, pres+fin, [], pos), [arg(dir, np(3+sin, np_head(det(each), [], ocean), []))], []))), sem((answer([B, E]):-ocean(B), [afghanistan, albania, algeria, andorra, angola, argentina, australia, austria, bahamas, bahrain, bangladesh, barbados, belgium, belize, bhutan, bolivia, botswana, brazil, bulgaria, burma, burundi, cambodia, cameroon, canada, central_african_republic, chad, chile, china, colombia, congo, costa_rica, cuba, cyprus, czechoslovakia, dahomey, denmark, djibouti, dominican_republic, east_germany, ecuador, egypt, eire, el_salvador, equatorial_guinea, ethiopia, fiji, finland, france, french_guiana, gabon, gambia, ghana, greece, grenada, guatemala, guinea, guinea_bissau, guyana, haiti, honduras, hungary, iceland, india, indonesia, iran, iraq, israel, italy, ivory_coast, jamaica, japan, jordan, kenya, kuwait, laos, lebanon, lesotho, liberia, libya, liechtenstein, luxembourg, malagasy, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, monaco, mongolia, morocco, mozambique, nepal, netherlands, new_zealand, nicaragua, niger, nigeria, north_korea, norway, oman, pakistan, panama, papua_new_guinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, san_marino, saudi_arabia, senegal, seychelles, sierra_leone, singapore, somalia, south_africa, south_korea, south_yemen, soviet_union, spain, sri_lanka, sudan, surinam, swaziland, sweden, switzerland, syria, taiwan, tanzania, thailand, togo, tonga, trinidad_and_tobago, tunisia, turkey, uganda, united_arab_emirates, united_kingdom, united_states, upper_volta, uruguay, venezuela, vietnam, west_germany, western_samoa, yemen, yugoslavia, zaire, zambia, zimbabwe]^ (setof(C, country(C), [afghanistan, albania, algeria, andorra, angola, argentina, australia, austria, bahamas, bahrain, bangladesh, barbados, belgium, belize, bhutan, bolivia, botswana, brazil, bulgaria, burma, burundi, cambodia, cameroon, canada, central_african_republic, chad, chile, china, colombia, congo, costa_rica, cuba, cyprus, czechoslovakia, dahomey, denmark, djibouti, dominican_republic, east_germany, ecuador, egypt, eire, el_salvador, equatorial_guinea, ethiopia, fiji, finland, france, french_guiana, gabon, gambia, ghana, greece, grenada, guatemala, guinea, guinea_bissau, guyana, haiti, honduras, hungary, iceland, india, indonesia, iran, iraq, israel, italy, ivory_coast, jamaica, japan, jordan, kenya, kuwait, laos, lebanon, lesotho, liberia, libya, liechtenstein, luxembourg, malagasy, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, monaco, mongolia, morocco, mozambique, nepal, netherlands, new_zealand, nicaragua, niger, nigeria, north_korea, norway, oman, pakistan, panama, papua_new_guinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, san_marino, saudi_arabia, senegal, seychelles, sierra_leone, singapore, somalia, south_africa, south_korea, south_yemen, soviet_union, spain, sri_lanka, sudan, surinam, swaziland, sweden, switzerland, syria, taiwan, tanzania, thailand, togo, tonga, trinidad_and_tobago, tunisia, turkey, uganda, united_arab_emirates, united_kingdom, united_states, upper_volta, uruguay, venezuela, vietnam, west_germany, western_samoa, yemen, yugoslavia, zaire, zambia, zimbabwe]), 4^ (numberof(D, (one_of([afghanistan, albania, algeria, andorra, angola, argentina, australia, austria, bahamas, bahrain, bangladesh, barbados, belgium, belize, bhutan, bolivia, botswana, brazil, bulgaria, burma, burundi, cambodia, cameroon, canada, central_african_republic, chad, chile, china, colombia, congo, costa_rica, cuba, cyprus, czechoslovakia, dahomey, denmark, djibouti, dominican_republic, east_germany, ecuador, egypt, eire, el_salvador, equatorial_guinea, ethiopia, fiji, finland, france, french_guiana, gabon, gambia, ghana, greece, grenada, guatemala, guinea, guinea_bissau, guyana, haiti, honduras, hungary, iceland, india, indonesia, iran, iraq, israel, italy, ivory_coast, jamaica, japan, jordan, kenya, kuwait, laos, lebanon, lesotho, liberia, libya, liechtenstein, luxembourg, malagasy, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, monaco, mongolia, morocco, mozambique, nepal, netherlands, new_zealand, nicaragua, niger, nigeria, north_korea, norway, oman, pakistan, panama, papua_new_guinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, san_marino, saudi_arabia, senegal, seychelles, sierra_leone, singapore, somalia, south_africa, south_korea, south_yemen, soviet_union, spain, sri_lanka, sudan, surinam, swaziland, sweden, switzerland, syria, taiwan, tanzania, thailand, togo, tonga, trinidad_and_tobago, tunisia, turkey, uganda, united_arab_emirates, united_kingdom, united_states, upper_volta, uruguay, venezuela, vietnam, west_germany, western_samoa, yemen, yugoslavia, zaire, zambia, zimbabwe], D), borders(D, B)), 4), 156^ (card([afghanistan, albania, algeria, andorra, angola, argentina, australia, austria, bahamas, bahrain, bangladesh, barbados, belgium, belize, bhutan, bolivia, botswana, brazil, bulgaria, burma, burundi, cambodia, cameroon, canada, central_african_republic, chad, chile, china, colombia, congo, costa_rica, cuba, cyprus, czechoslovakia, dahomey, denmark, djibouti, dominican_republic, east_germany, ecuador, egypt, eire, el_salvador, equatorial_guinea, ethiopia, fiji, finland, france, french_guiana, gabon, gambia, ghana, greece, grenada, guatemala, guinea, guinea_bissau, guyana, haiti, honduras, hungary, iceland, india, indonesia, iran, iraq, israel, italy, ivory_coast, jamaica, japan, jordan, kenya, kuwait, laos, lebanon, lesotho, liberia, libya, liechtenstein, luxembourg, malagasy, malawi, malaysia, maldives, mali, malta, mauritania, mauritius, mexico, monaco, mongolia, morocco, mozambique, nepal, netherlands, new_zealand, nicaragua, niger, nigeria, north_korea, norway, oman, pakistan, panama, papua_new_guinea, paraguay, peru, philippines, poland, portugal, qatar, romania, rwanda, san_marino, saudi_arabia, senegal, seychelles, sierra_leone, singapore, somalia, south_africa, south_korea, south_yemen, soviet_union, spain, sri_lanka, sudan, surinam, swaziland, sweden, switzerland, syria, taiwan, tanzania, thailand, togo, tonga, trinidad_and_tobago, tunisia, turkey, uganda, united_arab_emirates, united_kingdom, united_states, upper_volta, uruguay, venezuela, vietnam, west_germany, western_samoa, yemen, yugoslavia, zaire, zambia, zimbabwe], 156), ratio(4, 156, E)))))), qplan((answer([F, L]):-ocean(F), H^ (setof(G, country(G), H), J^ (numberof(I, (one_of(H, I), borders(I, F)), J), K^ (card(H, K), ratio(J, K, L)))))), answers([[arctic_ocean, 2.5641025641025643]])],[time(0.0020000000000000018)]).

:-export(test_chat80_regressions/0).
test_chat80_regressions:- locally(tracing80,locally_hide(lmconf:use_cyc_database,forall(must_test_80(U,R,O),process_run_diff(report,U,R,O)))).

:-export(test_chat80_sanity/0).
test_chat80_sanity:- locally(tracing80,locally_hide(lmconf:use_cyc_database,forall(must_test_80_sanity(U,R,O),process_run_diff(report,U,R,O)))).

baseKB:regression_test:- test_chat80_regressions.
baseKB:sanity_test:- test_chat80_sanity.


% ===========================================================
% CHAT80 command
% ===========================================================

:- if(current_module(pfc)).
==>(type_action_info(human_player,chat80(list(term)),"Development test CHAT-80 Text for a human.  Usage: CHAT80 Cant i see the blue backpack?")).

==>((agent_call_command(_Gent,chat80([])):- chat80)).
==>((agent_call_command(_Gent,chat80(StringM)):- chat80(StringM))).

:- endif.


% ===========================================================
% CHAT80 REPL
% ===========================================================
:-thread_local t_l:chat80_interactive/0.
:-export(chat80/0).
chat80 :- locally(tracing80,
           locally(t_l:chat80_interactive,
            locally_hide(t_l:useOnlyExternalDBs,
             locally_hide(lmconf:use_cyc_database,
                  locally(usePlTalk, (told, repeat, 
                     prompt_read('CHAT80> ',U),  
                            to_word_list(U,WL),((WL==[bye];WL==[end,'_',of,'_',file];control80(WL))))))))).

:- multifile(t_l:into_form_code/0).
:- asserta(t_l:into_form_code).


prompt_read(Prompt,Atom):- prompt_read(current_input,current_output,Prompt,Atom).

prompt_read(In,Out,Prompt,Atom):-
     with_output_to(Out,ansi_format([reset,hfg(white),bold],'~w',[Prompt])),flush_output(Out),
     repeat,read_code_list_or_next_command_with_prefix(In,Atom),!.

local_to_words_list(Atom,Words):-var(Atom),!,Words = Atom.
local_to_words_list(end_of_file,end_of_file):-!.
local_to_words_list([],[]):-!.
local_to_words_list(Atom,Words):-to_word_list(Atom,Words),!.

maybe_prepend_prefix(Words,Words).

read_code_list_or_next_command_with_prefix(In,Words):- read_code_list_or_next_command(In,Atom),
  add_history(Atom),
  %ignore(prolog:history(In, Atom);prolog:history(user_input, Atom);thread_signal(main,ignore(prolog:history(user_input, Atom)))),
  show_call(local_to_words_list(Atom,WordsM)),!,maybe_prepend_prefix(WordsM,Words).


read_code_list_or_next_command(Atom):-current_input(In),read_code_list_or_next_command(In,Atom),!.

read_code_list_or_next_command(In,end_of_file):- at_end_of_stream(In),!.
read_code_list_or_next_command(In,Atom):-
 (var(In)->current_input(In);true), catch(wait_for_input([In], Ready, 1),_,fail),!,  member(In,Ready),
  read_pending_input(In,CodesL,[]),!,is_list(CodesL),CodesL\==[],
   ((last(CodesL,EOL),member(EOL,[10,13])) -> code_list_to_next_command(CodesL,Atom);
    (read_line_to_codes(In,CodesR), (is_list(CodesR)-> (append(CodesL,CodesR,NewCodes),code_list_to_next_command(NewCodes,Atom)); Atom=CodesR))),!.

read_code_list_or_next_command(In,Atom):-
  read_pending_input(In,CodesL,[]),is_list(CodesL),CodesL\==[],
   ((last(CodesL,EOL),member(EOL,[10,13])) -> code_list_to_next_command(CodesL,Atom);
    (read_line_to_codes(In,CodesR), (is_list(CodesR)-> (append(CodesL,CodesR,NewCodes),code_list_to_next_command(NewCodes,Atom)); Atom=CodesR))),!.

code_list_to_next_command(end_of_file,end_of_file).
code_list_to_next_command(NewCodes,Atom):-append(Left,[EOL],NewCodes),EOL<33,!,code_list_to_next_command(Left,Atom).
code_list_to_next_command( [EOL|NewCodes],Atom):-EOL<33,!,code_list_to_next_command(NewCodes,Atom).
code_list_to_next_command( [],"how many rivers are there?").
code_list_to_next_command( [91|REST],TERM):- on_x_fail((atom_codes(A,[91|REST]),atom_to_term(A,TERM,[]))),!.
code_list_to_next_command(NewCodes,Atom):-atom_codes(Atom,NewCodes),!.

:-export(prompt_read/2).
:-export(prompt_read/4).

:- use_module(chat80).	% XG generator

%:- include((chat80/xgproc)).	% XG generator
/*

:- context_module(CM),load_plus_xg_file(CM,(chat80/'clone.xg')).
:- context_module(CM),load_plus_xg_file(CM,(chat80/'lex.xg')).

:- compile_xg_clauses.
% :- xg_listing('newg.pl').

% :- decl_mpred_hybrid(person/1).    

% :- list('newg.pl').
:- include((chat80/xgrun)).	% XG runtimes
% :- include((chat80/newg)).		% clone + lex

% :- retract(t_l:into_form_code).

:- include((chat80/clotab)).	% attachment tables
:- include((chat80/newdic)).	% syntactic dictionary
:- include((chat80/slots)).	% fits arguments into predicates
:- include((chat80/scopes)).	% quantification and scoping
% :- include((chat80/templa)).	% semantic dictionary
:- include((chat80/qplan)).	% query planning
:- include((chat80/talkr)).	% query evaluation
% :- include((chat80/ndtabl)).	% relation info.
:- use_module((chat80/readin)).	% sentence80 input
:- include((chat80/ptree)).	% print trees
:- include((chat80/aggreg)).	% aggregation operators


:- include((chat80/world0)).     	% data base
% :- ensure_loaded((chat80/world0)).     	% data base
*/
/*
:- include((chat80/rivers)).
:- include((chat80/cities)).
:- include((chat80/countries)).
:- include((chat80/contain)).
:- include((chat80/borders)).
*/

% testing
%:- include((chat80/newtop)).	% top level


:- retract(t_l:into_form_code).

:- retractall(t_l:enable_src_loop_checking).

baseKB:mud_test(chat80_regressions,test_chat80_regressions).

%:- context_module(CM),module_predicates_are_exported(CM).
%:- context_module(CM),all_module_predicates_are_transparent(CM).

:- fixup_exports.

% :- context_module(CM),module_property(CM, exports(List)),moo_hide_show_childs(List).

% :- include(logicmoo('vworld/moo_footer.pl')).


t80:- baseKB:hi80(demo).


