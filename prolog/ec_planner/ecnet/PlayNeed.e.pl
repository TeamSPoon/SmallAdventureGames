:-include(library('ec_planner/ec_test_incl')).
:-expects_dialect(pfc).
 %  loading(always,'ecnet/PlayNeed.e').
%;
%; Copyright (c) 2005 IBM Corporation and others.
%; All rights reserved. This program and the accompanying materials
%; are made available under the terms of the Common Public License v1.0
%; which accompanies this distribution, and is available at
%; http://www.eclipse.org/legal/cpl-v10.html
%;
%; Contributors:
%; IBM - Initial implementation
%;
%; A complete story understanding program will require representations
%; of common human needs \fullcite{SchankAbelson:1977}.
%;
%; @book{SchankAbelson:1977,
%;   author = "Schank, Roger C. and Abelson, Robert P.",
%;   year = "1977",
%;   title = "Scripts, Plans, Goals, and Understanding: An Inquiry into Human Knowledge Structures",
%;   address = "Hillsdale, NJ",
%;   publisher = "Lawrence Erlbaum",
%; }
%;
%; The PlayNeed representation deals with one type of need, the need
%; to play.
%; Our underlying theory of human needs consists of the following sequence:
%; (1) A need is unsatisfied.
%; (2) Given certain stimuli and an unsatisfied need, an intention
%; to satisfy the need is activated.
%; (3) The intention is acted upon.
%; (4) The need is satisfied.
%; agent has an unsatisfied need to play.

% fluent HungryToPlay(agent)
 %  fluent(hungryToPlay(agent)).
==> mpred_prop(hungryToPlay(agent),fluent).
==> meta_argtypes(hungryToPlay(agent)).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:33
%; agent has the intention to play outside.

% fluent IntentionToPlay(agent,outside)
 %  fluent(intentionToPlay(agent,outside)).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:35
==> mpred_prop(intentionToPlay(agent,outside),fluent).
==> meta_argtypes(intentionToPlay(agent,outside)).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:35
%; agent has a satisfied need to play.

% fluent SatiatedFromPlay(agent)
 %  fluent(satiatedFromPlay(agent)).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:37
==> mpred_prop(satiatedFromPlay(agent),fluent).
==> meta_argtypes(satiatedFromPlay(agent)).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:38
%; At any time, an agent is in one of three states with respect
%; to the need to play:

% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:40
% xor HungryToPlay, IntentionToPlay, SatiatedFromPlay
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:41
xor([hungryToPlay,intentionToPlay,satiatedFromPlay]).
%; agent intends to play at location outside.

% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:43
% event IntendToPlay(agent,outside)
 %  event(intendToPlay(agent,outside)).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:44
==> mpred_prop(intendToPlay(agent,outside),event).
==> meta_argtypes(intendToPlay(agent,outside)).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:44
%; agent plays at location outside.

% event Play(agent,outside)
 %  event(play(agent,outside)).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:46
==> mpred_prop(play(agent,outside),event).
==> meta_argtypes(play(agent,outside)).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:47
%; agent acts on the intention to play outside.

% fluent ActOnIntentionToPlay(agent,outside)
 %  fluent(actOnIntentionToPlay(agent,outside)).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:49
==> mpred_prop(actOnIntentionToPlay(agent,outside),fluent).
==> meta_argtypes(actOnIntentionToPlay(agent,outside)).

% noninertial ActOnIntentionToPlay
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:50
==> noninertial(actOnIntentionToPlay).
%; A trigger axiom activates an intention for an agent to play when
%; the agent has an unsatisfied need for play, the agent likes snow,
%; the agent is awake, and
%; the agent is in a room that looks out onto an outside area where it
%; is snowing:
% [agent,room,outside,time]
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:57
% HoldsAt(HungryToPlay(agent),time) &
% HoldsAt(LikeSnow(agent),time) &
% HoldsAt(At(agent,room),time) &
% LookOutOnto(room)=outside &
% HoldsAt(Awake(agent),time) &
% HoldsAt(Snowing(outside),time) ->
% Happens(IntendToPlay(agent,outside),time).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:63
axiom(happens(intendToPlay(Agent, Outside), Time),
   
    [ holds_at(hungryToPlay(Agent), Time),
      holds_at(likeSnow(Agent), Time),
      holds_at(at(Agent, Room), Time),
      equals(lookOutOnto(Room), Outside),
      holds_at(awake(Agent), Time),
      holds_at(snowing(Outside), Time)
    ]).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:65
%; A story understanding program will need a detailed representation
%; of intention \fullcite{CohenLevesque:1990}.
%;
%; @article{CohenLevesque:1990,
%;   author = "Philip R. Cohen and Hector J. Levesque",
%;   year = "1990",
%;   title = "Intention is choice with commitment",
%;   journal = "Artificial Intelligence",
%;   volume = "42",
%;   pages = "213--261",
%; }
%;
%; In our simplified representation, once an intention to
%; perform $e$ is activated, it persists until it is acted
%; upon. Intentions are represented by inertial fluents.
%; If an intention to perform $e$ is active at time point $t$,
%; the agent may or may not perform $e$ at time point $t$.
%; That is, we do not know exactly when the agent will act on the
%; intention.
%; This is a case of nondeterminism,
%; which we handle by introducing a noninertial fluent corresponding
%; to each intention fluent that
%; indicates whether the agent does or does not in fact act
%; on an intention at a given time.
%; Since each ground term of the new noninertial fluent multiplies the
%; number of models by $2^{n}$ where $n$ is the number of time points,
%; in practice we may constrain the truth value of the fluent
%; at various time points.
%; In the case of the need to play,
%; HoldsAt(ActOnIntentionToPlay(agent, outside), time)
%; represents that
%; HoldsAt(IntentionToPlay(agent, outside), time) is acted
%; upon at time.
%; Effect axioms state that
%; if an agent intends to play in an outside area,
%; the agent will have an intention to play in the outside area
%; and will no longer be in the hungry-to-play state:
% [agent,outside,time]
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:104
% Initiates(IntendToPlay(agent,outside),IntentionToPlay(agent,outside),time).
axiom(initiates(intendToPlay(Agent, Outside), intentionToPlay(Agent, Outside), Time),
    []).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:106
% [agent,outside,time]
% Terminates(IntendToPlay(agent,outside),HungryToPlay(agent),time).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:107
axiom(terminates(intendToPlay(Agent, Outside), hungryToPlay(Agent), Time),
    []).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:109
%; A trigger axiom states that if an agent has the intention
%; to play in an outside area,
%; the agent acts on the intention to play in the outside area, and
%; the agent is at the outside area,
%; the agent plays in the outside area:
% [agent,outside,time]
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:115
% HoldsAt(IntentionToPlay(agent,outside),time) &
% HoldsAt(ActOnIntentionToPlay(agent,outside),time) &
% HoldsAt(At(agent,outside),time) ->
% Happens(Play(agent,outside),time).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:118
axiom(happens(play(Agent, Outside), Time),
   
    [ holds_at(intentionToPlay(Agent, Outside), Time),
      holds_at(actOnIntentionToPlay(Agent, Outside), Time),
      holds_at(at(Agent, Outside), Time)
    ]).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:120
%; Effect axioms state that if an agent plays in an
%; outside area, the agent will be satiated from play
%; and will no longer have an intention to play in
%; the outside area:
% [agent,outside,time]
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:125
% Initiates(Play(agent,outside),SatiatedFromPlay(agent),time).
axiom(initiates(play(Agent, Outside), satiatedFromPlay(Agent), Time),
    []).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:127
% [agent,outside,time]
% Terminates(Play(agent,outside),IntentionToPlay(agent,outside),time).
% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:128
axiom(terminates(play(Agent, Outside), intentionToPlay(Agent, Outside), Time),
    []).


% From /opt/logicmoo_workspace/packs_sys/small_adventure_games/prolog/ec_planner/ecnet/PlayNeed.e:130
%; End of file.
