/*
% NomicMUD: A MUD server written in Prolog
% Maintainer: Douglas Miles
% Dec 13, 2035
%
% Bits and pieces:
%
% LogicMOO, Inform7, FROLOG, Guncho, PrologMUD and Marty's Prolog Adventure Prototype
% 
% Copyright (C) 2004 Marty White under the GNU GPL 
% Sept 20,1999 - Douglas Miles
% July 10,1996 - John Eikenberry 
%
% Logicmoo Project changes:
%
% Main file.
%
*/
*/

:- ensure_loaded(adv_axiom).

:- dynamic(adv:agent_last_action/3).

time_since_last_action(Agent,When):- 
 (adv:agent_last_action(Agent,_Action,Last),clock_time(T),When is T - Last) *-> true; clock_time(When).

set_last_action(Agent,Action):- 
 clock_time(T),
 retractall(adv:agent_last_action(Agent,_,_)),
 assertz(adv:agent_last_action(Agent,Action,T)).



cmd_workarround(VerbObj, VerbObj2):-
 VerbObj=..VerbObjL,
 notrace(cmd_workarround_l(VerbObjL, VerbObjL2)),
 VerbObj2=..VerbObjL2.

cmd_workarround_l([Verb|ObjS], [Verb|ObjS2]):-
 append(ObjS2, ['.'], ObjS).
cmd_workarround_l([Verb|ObjS], [Verb|ObjS2]):- fail,
 append(Left, [L, R|More], ObjS), atom(L), atom(R),
 current_atom(Atom), atom_concat(L, RR, Atom), RR=R,
 append(Left, [Atom|More], ObjS2).
% look at screendoor
cmd_workarround_l([Verb, Relation|ObjS], [Verb|ObjS]):- is_ignorable(Relation), !.
% look(Agent, Spatial) at screen door
cmd_workarround_l([Verb1|ObjS], [Verb2|ObjS]):- verb_alias(Verb1, Verb2), !.

is_ignorable(Var):- var(Var),!,fail.
is_ignorable(at). is_ignorable(in). is_ignorable(to). is_ignorable(the). is_ignorable(a). is_ignorable(spatial).

verb_alias(look, examine) :- fail.



% drop -> move -> touch
subsetof(touch, touch).
subsetof(move, touch).
subsetof(drop, move).
subsetof(eat, touch).
subsetof(hit, touch).
subsetof(put, drop).
subsetof(give, drop).
subsetof(take, move).
subsetof(throw, drop).
subsetof(open, touch).
subsetof(close, touch).
subsetof(lock, touch).
subsetof(unlock, touch).
subsetof(switch, touch).

subsetof(walk, goto).

% feel <- taste <- smell <- look <- listen (by distance)
subsetof(examine, examine).
subsetof(listen, examine).
subsetof(look, examine).
% in order to smell it you have to at least be in sight distance
subsetof(smell, look).
subsetof(eat, taste).
subsetof(taste, smell).
subsetof(taste, feel).
subsetof(feel, examine).
subsetof(feel, touch).
subsetof(X,Y):- ground(subsetof(X,Y)),X=Y.

subsetof(SpatialVerb1, SpatialVerb2):- compound(SpatialVerb1), compound(SpatialVerb2), !,
 SpatialVerb1=..[Verb1,Arg1|_],
 SpatialVerb2=..[Verb2,Arg2|_],
 subsetof(Verb1, Verb2),
 subsetof(Arg1, Arg2).

subsetof(SpatialVerb, Verb2):- compound(SpatialVerb), functor(SpatialVerb, Verb, _), !,
 subsetof(Verb, Verb2).

subsetof(Verb, SpatialVerb2):- compound(SpatialVerb2), functor(SpatialVerb2, Verb2, _), !,
 subsetof(Verb, Verb2).

% proper subset - C may not be a subset of itself.
psubsetof(A, B):- A==B, !, fail.
psubsetof(A, B) :- subsetof(A, B).
psubsetof(A, C) :-
 subsetof(A, B),
 subsetof(B, C).


maybe_pause(Agent):- stdio_player(CP),(Agent==CP -> wait_for_input([user_input],_,0) ; true).

do_command(Agent, Action) -->
  {overwrote_prompt(Agent)},
  do_metacmd(Agent, Action),!.
do_command(Agent, Action) -->
  {set_last_action(Agent,Action)},
 do_action(Agent, Action), !.
do_command(Agent, Action) :-
 player_format(Agent, 'Failed or No Such Command: ~w~n', Action).

% --------

do_todo(Agent) -->
 sg(declared(memories(Agent, Mem0))),
 {member(todo([]),Mem0)},!.
do_todo(Agent, S0, S9) :- 
 undeclare(memories(Agent, Mem0), S0, S1),
 forget(todo(OldToDo), Mem0, Mem1),
 append([Action], NewToDo, OldToDo),
 memorize(todo(NewToDo), Mem1, Mem2),
 declare(memories(Agent, Mem2), S1, S2),
 set_last_action(Agent,Action),
 do_command(Agent, Action, S2, S9).
do_todo(_Agent, S0, S0).

%do_todo_while(Agent, S0, S9) :-
% declared(memories(Agent, Mem0), S0),
% thought(todo(ToDo), Mem0),
% append([Action], NewToDo, OldToDo),



% ---- apply_act( Action, S0, S9)
% where the states also contain Percepts.
% In Inform, actions work in the following order:
% game-wide preconditions
% Player preconditions
% objects-in-vicinity react_before conditions
% room before-conditions
% direct-object before-conditions
% verb
% objects-in-vicinity react_after conditions
% room after-conditions
% direct-object after-conditions
% game-wide after-conditions
% In TADS:
% "verification" methods perferm tests only


do_action(Agent, Action, S0, S3) :-
 quietly_must((
 undeclare(memories(Agent, Mem0), S0, S1),
 memorize_doing(Action, Mem0, Mem1),
 declare(memories(Agent, Mem1), S1, S2))),
 dmust_tracing(must_act( Action, S2, S3)), !.

memorize_doing(Action, Mem0, Mem0):- has_depth(Action),!.
memorize_doing(Action, Mem0, Mem2):- 
  copy_term(Action,ActionG),
  numbervars(ActionG,999,_),
  ( has_depth(Action) 
    -> Mem0 = Mem1 ; 
    (thought(timestamp(T0,_OldNow), Mem0), T1 is T0 + 1,clock_time(Now), memorize(timestamp(T1,Now), Mem0, Mem1))), 
  memorize(attempting(ActionG), Mem1, Mem2).

has_depth(Action):- compound(Action), functor(Action,_,A),arg(A,Action,E),compound(E),E=depth(_),!.

trival_act(V):- \+ callable(V), !, fail.
trival_act(sub__examine(_,_,_,_,_)).
trival_act(Action):- has_depth(Action).
trival_act(V):- \+ compound(V), !, fail.
trival_act(_):- !, fail.
trival_act(look(_)).
trival_act(wait(_)).

satisfy_each(_Ctxt,[]) --> [], !.
satisfy_each(Context,[Cond|CondList]) --> !,
  must_det(satisfy_each(Context,Cond)), !,
  ((sg(member(failed(_Why)))) ; satisfy_each(Context,CondList)),!.
satisfy_each(_Ctx,A \= B) --> {dif(A,B)},!.

satisfy_each(Context, believe(Beliver, Cond)) --> !, 
   undeclare(memories(Beliver,Memory)), !, 
   {satisfy_each(Context,Cond,Memory,NewMemory)},  
   declare(memories(Beliver,NewMemory)).

satisfy_each(postCond(_Action), event(Event), S0, S9) :-  must_act(Event, S0, S9).
   
satisfy_each(Context, foreach(Cond,Event), S0, S9) :- findall(Event, phrase(Cond,S0,_), TODO), satisfy_each(Context, TODO, S0, S9).
satisfy_each(_,precept_local(Where,Event)) --> !, queue_local_event([Event],[Where]).
satisfy_each(_,precept(Agent,Event)) --> !, send_precept(Agent,Event).
satisfy_each(postCond(_Action), ~(Cond)) --> !, undeclare_always(Cond).
satisfy_each(postCond(_Action),  Cond) --> !, declare(Cond).
satisfy_each(Context, ~(Cond)) --> !, (( \+ satisfy_each(Context, Cond)) ; [failed(Cond)] ).
satisfy_each(_, Cond) --> declared(Cond).
satisfy_each(_, Cond) --> [failed(Cond)].


oper_splitk(Agent,Action,Preconds,Postconds):-
  oper(Agent,Action,PrecondsK,PostcondsK),
  split_k(Agent,PrecondsK,Preconds),
  split_k(Agent,PostcondsK,Postconds).

split_k(_Agent,[],[]) :- !.

split_k(Agent,[b(P,[V|VS])|PrecondsK],Preconds):- !,
  split_k(Agent,[b(P,V),b(P,VS)|PrecondsK],Preconds).

split_k(Agent,[~(k(P,X,Y))|PrecondsK],[believe(Agent,~(h(P,X,Y))),~(h(P,X,Y))|Preconds]):- !,
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[k(P,X,Y)|PrecondsK],[believe(Agent,h(P,X,Y)),h(P,X,Y)|Preconds]):- !,
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[~(b(P,X,Y))|PrecondsK],[believe(Agent,~(h(P,X,Y)))|Preconds]):- !, 
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[b(P,X,Y)|PrecondsK],[believe(Agent,h(P,X,Y))|Preconds]):- !, 
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[isa(X,Y)|PrecondsK],[getprop(X,inherited(Y))|Preconds]):- 
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[in(X,Y)|PrecondsK],[h(in,X,Y)|Preconds]):- 
  split_k(Agent,PrecondsK,Preconds).
split_k(Agent,[Cond|PrecondsK],[Cond|Preconds]):- 
  split_k(Agent,PrecondsK,Preconds).


apply_act( Action) --> 
 action_doer(Action, Agent), 
 do_introspect(Agent,Action, Answer),
 send_precept(Agent, [answer(Answer), Answer]), !.

apply_act(print_(Agent, Msg)) -->
  h(descended, Agent, Here),
  queue_local_event(msg_from(Agent, Msg), [Here]).

apply_act(wait(Agent)) -->
 from_loc(Agent, Here),
 queue_local_event(time_passes(Agent),Here).

apply_act(Action) --> 
 {implications(_DoesEvent,(Action), Preconds, Postconds), action_doer(Action,Agent) },
 must_det(satisfy_each(preCond(_),Preconds)),
 (((sg(member(failed(Why))),send_precept(Agent, failed(Action,Why))))
    ; (satisfy_each(postCond(_),Postconds),send_precept(Agent, (Action)))),!.

apply_act( Action) --> 
 {oper_splitk(Agent,Action,Preconds,Postconds)}, !, 
 must_det(satisfy_each(preCond(_),Preconds)),
 (((sg(member(failed(Why))),send_precept(Agent, failed(Action,Why))))
    ; (satisfy_each(postCond(_),Postconds),send_precept(Agent, success(Action)))),!.

apply_act( Action) --> aXiom(Action), !.

/*
apply_act( Action) --> fail, 
  action_doer(Action, Agent),
  copy_term(Action,ActionG),
  from_loc(Agent, Here, S0),  
  % queue_local_event(spatial, [attempting(Agent, Action)], [Here], S0, S1),
  act( Action), !,
  queue_local_event([emoted(Agent, aXiom, '*'(Here), ActionG)], [Here], S0, S9).
*/

apply_act( Act, S0, S9) :- ((cmd_workarround(Act, NewAct) -> Act\==NewAct)), !, apply_act( NewAct, S0, S9).
apply_act( Action, S0, S0):- notrace((bugout3(failed_act( Action), general))),!, \+ tracing.

must_act( Action , S0, S9) :- dmust_tracing(apply_act( Action, S0, S9)) *-> ! ; fail.
% must_act( Action) --> rtrace(apply_act( Action, S0, S1)), !.
must_act( Action) --> 
 action_doer(Action,Agent), 
 send_precept(Agent, [failure(Action, unknown_to(Agent,Action))]).


act_required_posses('lock','key',$agent).
act_required_posses('unlock','key',$agent).

act_change_opposite('lock','unlock').
act_change_opposite('open','close').

act_change_state('lock','locked',t).
act_change_state('open','opened',t).
act_change_state(Unlock,Locked,f):- act_change_state(Lock,Locked,t),act_change_opposite(Lock,Unlock).
act_change_state(switch(on),'powered',t).
act_change_state(switch(off),'powered',f).

act_change_state(switch(Open),Opened,TF):- nonvar(Open), act_change_state(Open,Opened,TF).

% act_prevented_by(Open,Opened,TF):- act_change_state(Open,Opened,TF).
act_prevented_by('open','locked',t).
act_prevented_by('close','locked',t).


:- meta_predicate maybe_when(0,0).
maybe_when(If,Then):- If -> Then ; true.

:- meta_predicate unless_reason(*,'//',*,?,?).
unless_reason(_Agent, Then,_Msg) --> Then,!.
unless_reason(Agent,_Then,Msg) --> {player_format(Agent,'~N~p~n',[Msg])},!,{fail}.

:- meta_predicate unless(*,'//','//',?,?). 
unless(_Agent, Required, Then) --> Required,!, Then.
unless(Agent, Required, _Then) --> {simplify_reason(Required,CUZ), player_format(Agent,'~N~p~n',cant( cuz(\+ CUZ)))},!.

:- meta_predicate required_reason(*,0).
required_reason(_Agent, Required):- Required,!.
required_reason(Agent, Required):- simplify_reason(Required,CUZ), player_format(Agent,'~N~p~n',cant( cuz(CUZ))),!,fail.

simplify_reason(_:Required, CUZ):- !, simplify_dbug(Required, CUZ).
simplify_reason(Required, CUZ):- simplify_dbug(Required, CUZ).

reverse_dir(north,south,_).
reverse_dir(reverse(ExitName), ExitName,_) :- nonvar(ExitName),!.
reverse_dir(Dir,RDir,S0):-
 h(exit(Dir), Here, There, S0),
 h(exit(RDir), There, Here, S0),!.
reverse_dir(Dir,RDir,S0):- 
 h(Dir, Here, There, S0),
 h(RDir, There, Here, S0),!.
reverse_dir(Dir,reverse(Dir),_).

add_agent_todo(Agent, Action, S0, S9) :- 
  undeclare(memories(Agent, Mem0), S0, S1),
  add_todo(Action, Mem0, Mem1),
  declare(memories(Agent, Mem1), S1, S9).

add_agent_goal(Agent, Action, S0, S9) :- 
  undeclare(memories(Agent, Mem0), S0, S1),
  add_goal(Action, Mem0, Mem1),
  declare(memories(Agent, Mem1), S1, S9).

add_look(Agent) -->
  h(inside, Agent, _Somewhere),
  add_agent_todo(Agent, look(Agent)).


:- defn_state_none(action_doer(action,-agent)).
action_doer(Action,Agent):- \+ compound(Action),!, must_det(current_agent(Agent)),!.
action_doer(Action,Agent):- functor(Action,Verb,_),verbatum_anon(Verb),current_agent(Agent),!.
action_doer(Action,Agent):- arg(1,Action,Agent), nonvar(Agent), \+ preposition(_,Agent),!.
action_doer(Action,Agent):- trace,throw(missing(action_doer(Action,Agent))).

action_verb_agent_thing(Action, Verb, Agent, Thing):-
  notrace((compound(Action),Action=..[Verb,Agent|Args], \+ verbatum_anon(Verb))), !,
  (Args=[Thing]->true;Thing=_),!.


