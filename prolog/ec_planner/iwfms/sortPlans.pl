%:-prolog_flag(compiling,_,profiledcode).

%We seperate this to a call so we can cut without affecting the main algorithm
matchHappens(A,F,X, Plan) :- member( happens(A,F,X), Plan),!.	


sortPlan(Plan, SortedPlan) :- breakup(Plan,SortedPlan), 

	% Cut required when generating multiple solutions to avoid
	% backtrack possible sorting paths
	!.

breakup([ Plan, Ordering], CorrectlyOrderedPlan) :- 
	writeln('plan:'),writeNoln(Plan),
	writeln('orderings:'),writeNoln(Ordering),
	!,sortTimepoints(Plan,Ordering, BackwardsPlan, t, 0),!,
	
	%The plan will be backwards as it starts at t the goal timepoint
	reverse(BackwardsPlan, CorrectlyOrderedPlan).

	
	
% Current only caters for totally ordered plans
% Add a forall statement when finding members

%If the Before list is not empty then a node has been missed implying the plan is not totally ordered

sortTimepoints(Plan, Ordering, [] , Timepoint, Accum):-
	length(Plan, PlanLength),
	Accum = PlanLength.

sortTimepoints(Plan, Ordering, [ happens(A,F,X) | OrderPlan] , Timepoint, Accum):-

	%we want to rematch here
	member( before(X, Timepoint), Ordering),
	
	%we never want to rematch here
	matchHappens(A,F,X,Plan),
		
	AccumFresh is Accum+1,
	
	sortTimepoints(Plan, Ordering, OrderPlan, X, AccumFresh).
	
	
	
% --------------Tests ----------------------
	
%test1_sortPlan(SortedPlan) :- sortPlan([[happens(createFormelemen(restrictedDrugs,radiobtn,[size=2]),t177,t177),happens(formEntry(form1,jw99),t32,t32),happens(edgeProgression(form2,formElement(test2,value)),t160,t160),happens(formSubmission(form2),t142,t142),happens(createFormelement(textboxform1,textbox,[multline,numlines(4)]),t123,t123),happens(formEntry(form2,jw99),t138,t138),happens(formInput(house),t34,t34),happens(formSubmission(form1),t35,t35),happens(edgeProgression(form1,formElement(correctDrugs,off)),t116,t116)],[before(t177,t142),before(t138,t177),before(t123,t35),before(t32,t123),before(t35,t116),before(t142,t160),before(t160,t),before(t138,t),before(t116,t138),before(t123,t34),before(t123,t35),before(t32,t123),before(t35,t116),before(t34,t35)]], SortedPlan).