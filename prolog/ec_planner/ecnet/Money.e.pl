:-include(library('ec_planner/ec_test_incl')).
:-expects_dialect(pfc).
 %  loading(always,'ecnet/Money.e').
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

% event Pay(agent,agent)
 %  event(pay(agent,agent)).
==> mpred_prop(pay(agent,agent),event).
==> meta_argtypes(pay(agent,agent)).

% event Tip(agent,agent)
 %  event(tip(agent,agent)).
==> mpred_prop(tip(agent,agent),event).
==> meta_argtypes(tip(agent,agent)).
