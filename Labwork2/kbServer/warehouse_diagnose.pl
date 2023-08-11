:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded(warehouse_config).

% to be used later

provide_failures_json(Status):-
% output as JSON object
    %writeln('['),

    findall((ID,failure(Type, ID, Msg, RecoveryPlan, Resolved)), failure(Type, ID, Msg, RecoveryPlan, Resolved), L),
    sort(1, @=<, L, Sorted),
    findall( Sentence, (
      member(  (ID,failure(Type, ID, Msg, RecoveryPlan, Resolved)), Sorted),
      Status = Resolved,
      swritef(Sentence,'{"type" : "%w", "id" : "%w", "msg" : "%w", "plan": "%w", "resolved" : "%w"}',
                         [Type,          ID,          Msg,  RecoveryPlan ,        Resolved])
    ), List),

    %write_list(List),
    write_term(List,[]).

provide_failures_statistics_json:-
% output as JSON object
    %writeln('['),

    findall(1,  failure(_, _, _, _, _    ), Resolved),
    sum_list(Resolved, TotalFailures),
    findall(1,  failure(_, _, _, _, false), Pending ),
    sum_list(Pending, TotalPending),
    writeln('{'),
    writef(     ' "totalFailures":"%w", "totalPending":"%w"\n', 
           [TotalFailures, TotalPending] ),
    writeln('}').

provide_packages_statistics_json:-
% output as JSON object
    %writeln('['),
    state(stored(NumStored)),
    state(inStock(NuminStock)),
    state(withdrawn(NumWithdrawn)),
    writeln('{'),
    writef(     ' "stored":"%w", "inStock":"%w", "withdrawn":"%w"\n', 
           [NumStored, NuminStock, NumWithdrawn] ),
    writeln('}').


load_knowledge_base(FileName):-
    consult(FileName).

% ? Possibly somethings missing
save_knowledge_base(FileName):-
    tell(FileName),
    %save what you need
    listing(state/2),
    listing(before/3),
    listing(command/2),
    listing(goal/2),
    listing(plan/2),
    listing(prolog/1),
    listing(wait/1),
    listing(failure/5),   
    told.

% ----- FAILURE SENSOR X -----

defrule([name: failure_sensor_x],
    if not(failure(x_sensor, _, _, _, false))   and
        state(x_is_at(XNow))                and
        before(x_is_at(XBefore), _, _)      and
        (Diff is abs(XNow - XBefore))       and
        (Diff  > 1)
    then[
        new_id(ID),
        swritef(Message, 'Missing sensor between %w and %w', [XBefore, XNow]),
        assert(failure(x_sensor, ID, Message, [], false)),
        writeln(failure(x_sensor, ID, Message, [], false))
    ]
).


% ----- FAILURE SENSOR Y -----

defrule([name: failure_sensor_y],
    if not(failure(y_sensor, _, _, _, false))   and
        state(y_is_at(YNow))                and
        before(y_is_at(YBefore), _, _)      and
        (Diff is abs(YNow - YBefore))       and
        (Diff  > 1)
    then[
        new_id(ID),
        swritef(Message, 'Missing sensor between %w and %w', [YBefore, YNow]),
        assert(failure(y_sensor, ID, Message, [], false)),
        writeln(failure(y_sensor, ID, Message, [], false))
    ]
).


% ----- FAILURE SENSOR Z -----

defrule([name: failure_sensor_z],
    if not(failure(z_sensor, _, _, _, false))   and
        state(z_is_at(ZNow))                and
        before(z_is_at(ZBefore), _, _)      and
        (Diff is abs(ZNow - ZBefore))       and
        (Diff  > 0.5)
    then[
        new_id(ID),
        swritef(Message, 'Missing sensor between %w and %w', [ZBefore, ZNow]),
        assert(failure(z_sensor, ID, Message, [], false)),
        writeln(failure(z_sensor, ID, Message, [], false))
    ]
).
/*
find_plan_for_failure( failure( z_sensor, ID, Description, Plan, Resolved) ):-
    %programmed plan
    findall(S, state(S), States),
    member( z_is_at(Z), States),
    (Z > 2.5, Direction = -1 ; Z =< 2.5, Direction = 1),
    (Z > 2.5, Command=move_z_down ; Z =< 2.5, Command=move_z_up),
    PlanRecovery = [
        Command,
        state(z_is_at(Z2)),
        stop_z
    ],
    retractall(failure(z_sensor, ID, Description, Plan, Resolved)),
    assert(failure(z_sensor, ID, Description, plan(zRecover, PlanRecovery), Resolved)),
    !.
*/
start_emergency_stop:-
    state(x_moving(X)),
    state(y_moving(Y)),
    state(z_moving(Z)),

    assert_state(x_was_moving(X)),
    assert_state(y_was_moving(Y)),
    assert_state(z_was_moving(Z)),

    assert(plan(stop_all,[stop_x, stop_y, stop_z])).

resume_emergency_stop:-
    (state(x_was_moving(X)),
    state(y_was_moving(Y)),
    state(z_was_moving(Z))
    ->
    (
        (X =:= -1
        ->  assert(plan(resume_x, [move_x_left]));   
        X =:= 1
        ->  assert(plan(resume_x, [move_x_right]));
        true
        ),

        (Y =:= -1
        ->  assert(plan(resume_y, [move_y_out]));   
        Y =:= 1
        ->  assert(plan(resume_y, [move_y_in]));
        true
        ),
        
        (Z =:= -1
        ->  assert(plan(resume_z, [move_z_down]));   
        Z =:= 1
        ->  assert(plan(resume_z, [move_z_up]));
        true
        )
    )),

    retractall(plan(stop_all,[stop_x, stop_y, stop_z])).

testingAllSensors:-
    assert(plan(testAllSensors,[x_is_at(1)])).