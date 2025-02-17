
:- module(tense,
          [ tense/4,   % +Mood, +Index, +Att--Att, -Sem
            aspect/5   % +ArgMood, +Mood, +Index, +Att--Att, -Sem
          ]).

:- use_module(semlib(options),[option/2]).
:- use_module(library(lists),[member/2]).
:- use_module(boxer(categories),[att/3]).


/* =========================================================================
   Tense
========================================================================= */

tense(Mood,Index,Att-[sem:Tag|Att],Sem):-
   option('--tense',true), 
   member(Mood,[dcl,inv,wq,q]),
   att(Att,pos,PoS), 
   pos2tense(PoS,Index,Sem,Tag), !.

tense(com,_,Att-[sem:'MOR'|Att],Sem):- !,
   Sem = lam(S,lam(M,app(S,M))).

tense(adj,_,Att-[sem:'IST'|Att],Sem):- !,
   Sem = lam(S,lam(M,app(S,M))).

tense(ng,_,Att-[sem:'EXG'|Att],Sem):-
   Sem = lam(S,lam(M,app(S,M))).

tense(pt,_,Att-[sem:'EXT'|Att],Sem):-
   Sem = lam(S,lam(M,app(S,M))).

tense(pss,_,Att-[sem:'EXV'|Att],Sem):-
   Sem = lam(S,lam(M,app(S,M))).

tense(_,_,Att-[sem:'EXS'|Att],Sem):-
   Sem = lam(S,lam(M,app(S,M))).


/* -------------------------------------------------------------------------
   Past Tense
------------------------------------------------------------------------- */

pos2tense('VBD',Index,Sem,'PST'):- 
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:rel(E,T,temp_included,1),
                                               B2:[]:rel(T,N,temp_before,1)]),
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Present Tense
------------------------------------------------------------------------- */

pos2tense(Cat,Index,Sem,'NOW'):- 
   member(Cat,['VBP','VBZ']), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:rel(E,T,temp_included,1),
                                               B2:[]:eq(T,N)]),
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Future Tense
------------------------------------------------------------------------- */

pos2tense('MD',Index,Sem,'FUT'):- 
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:rel(E,T,temp_included,1),
                                               B2:[]:rel(N,T,temp_before,1)]),
                                       app(F,E)))))).


/* =========================================================================
   Aspect
========================================================================= */

/* -------------------------------------------------------------------------
   Present Perfect
------------------------------------------------------------------------- */
 
aspect(pt,_,Index,Att-[sem:'ENT'|Att],Sem):-
   option('--tense',true),
   att(Att,pos,PoS),
   member(PoS,['VBZ','VBP']), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T,B2:[]:St],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:eq(T,N),
                                               B2:[]:rel(St,T,temp_includes,1),
                                               B2:[]:rel(E,St,temp_abut,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Past Perfect
------------------------------------------------------------------------- */

aspect(pt,_,Index,Att-[sem:'EPT'|Att],Sem):-
   option('--tense',true),
   att(Att,pos,'VBD'),
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T,B2:[]:St],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:rel(T,N,temp_before,1),
                                               B2:[]:rel(St,T,temp_includes,1),
                                               B2:[]:rel(E,St,temp_abut,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).

/* -------------------------------------------------------------------------
   Other Perfect
------------------------------------------------------------------------- */

aspect(pt,Mood,Index,Att1-[sem:'EXT'|Att2],Sem):-
   option('--tense',true), !,
   tense(Mood,Index,Att1-Att2,Sem).


/* -------------------------------------------------------------------------
   Perfect Passive (incorrect?)
------------------------------------------------------------------------- */

aspect(pss,pt,Index,Att-[sem:'ETV'|Att],Sem):-
   option('--tense',true), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B2:Index:T,B2:[]:St],
                                              [B2:[]:rel(St,T,temp_includes,1),
                                               B2:[]:rel(E,St,temp_overlap,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Perfect Progressive 
------------------------------------------------------------------------- */

aspect(ng,pt,Index,Att-[sem:'ETG'|Att],Sem):-
   option('--tense',true), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B2:Index:T,B2:[]:St],
                                              [B2:[]:rel(St,T,temp_includes,1),
                                               B2:[]:rel(E,St,temp_overlap,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Present Progressive
------------------------------------------------------------------------- */

aspect(ng,_,Index,Att-[sem:'ENG'|Att],Sem):-
   option('--tense',true), 
   att(Att,pos,PoS),
   member(PoS,['VBZ','VBP']), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T,B2:[]:St],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:eq(T,N),
                                               B2:[]:rel(St,T,temp_includes,1),
                                               B2:[]:rel(E,St,temp_overlap,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).


/* -------------------------------------------------------------------------
   Past Progressive
------------------------------------------------------------------------- */

aspect(ng,_,Index,Att-[sem:'EPG'|Att],Sem):-
   att(Att,pos,'VBD'),
   option('--tense',true), !,
   Sem = lam(S,lam(F,app(S,lam(E,merge(B2:drs([B1:[]:N,B2:Index:T,B2:[]:St],
                                              [B1:[]:pred(N,now,a,1),
                                               B2:[]:rel(T,N,temp_before,1),
                                               B2:[]:rel(St,T,temp_included,1),
                                               B2:[]:rel(E,St,temp_overlap,1)]),
%                                      app(F,St)))))).
                                       app(F,E)))))).

/* -------------------------------------------------------------------------
   Other Progressive
------------------------------------------------------------------------- */

aspect(ng,Mood,Index,Att1-[sem:'EXG'|Att2],Sem):-
   option('--tense',true), !,
   tense(Mood,Index,Att1-Att2,Sem).


/* -------------------------------------------------------------------------
   Other cases
------------------------------------------------------------------------- */

aspect(_,Mood,Index,Att,Sem):-
   tense(Mood,Index,Att,Sem).
