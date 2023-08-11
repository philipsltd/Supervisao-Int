:-ensure_loaded('RTXengine/RTXstrips_planner.pl').
:-ensure_loaded('warehouse_config.pl').


delete_all_failures(ID):-
    writeln(failures_deletes),
    retractall( failure(_,ID,_,_,_)).

resolve_all_failures(ID):-
    findall(_,
            (  failure(Type, ID, Description,  Plan, false),
               retract(failure(Type, ID, Description,  Plan, false)),
               assert(failure(Type,ID,  Description, Plan, true))
            ),_).

find_plan(ID):-
    failure(Type, ID, Descr, Plan, Resolved),
    find_plan_for_failure(  failure(Type, ID, Descr, Plan, Resolved)        ).

% X
find_plan_for_failure(  failure(x_sensor, ID, Description, Plan, Resolved)        ):-
    % automatic plans
    findall(S, state(S), States),
    member( x_is_at(X), States),
    (   X > 5, Direction = -1; /* OR */    X =< 5, Direction = 1),
    X2 is X + Direction,
    solve([x_is_at(X2)], States, _W2, PlanRecovery),
    retractall(failure(x_sensor, ID, Description, Plan, Resolved)),
    assert(failure(x_sensor, ID, Description, plan(xRecover,PlanRecovery), Resolved)),
    !.

% Y
find_plan_for_failure(  failure(y_sensor, ID, Description, Plan, Resolved)        ):-
    % automatic plans
    findall(S, state(S), States),
    member( y_is_at(Y), States),
    (   Y > 2, Direction = -1; /* OR */    Y =< 2, Direction = 1),
    Y2 is Y + Direction,
    solve([y_is_at(Y2)], States, _W2, PlanRecovery),
    retractall(failure(y_sensor, ID, Description, Plan, Resolved)),
    assert(failure(y_sensor, ID, Description, plan(yRecover,PlanRecovery), Resolved)),
    !.
    
% Z
find_plan_for_failure(  failure(z_sensor, ID, Description, Plan, Resolved)        ):-
    % automatic plans
    findall(S, state(S), States),
    member( z_is_at(Z), States),
    (   Z > 3, Direction = -1; /* OR */    Z =< 3, Direction = 1),
    Z2 is Z + Direction,
    solve([z_is_at(Z2)], States, _W2, PlanRecovery),
    retractall(failure(z_sensor, ID, Description, Plan, Resolved)),
    assert(failure(z_sensor, ID, Description, plan(zRecover,PlanRecovery), Resolved)),
    !.

execute_plan(ID):-
    failure(_Type, ID, _Descr, Plan, _Resolved),
    assert(Plan).


