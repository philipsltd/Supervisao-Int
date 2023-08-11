:-ensure_loaded('RTXengine/RTXstrips_planner.pl').
:-ensure_loaded('warehouse_config.pl').


% ---------- X ACTIONS ----------

strips([
    act [move_x_right],
    pre [x_moving(0)],
    add [x_moving(1)],
    del [x_moving(0)]
]).

strips([
    act [move_x_left],
    pre [x_moving(0)],
    add [x_moving(-1)],
    del [x_moving(0)]
]).

strips([
    act [stop_x],
    pre [x_moving(1)],
    add [x_moving(0)],
    del [x_moving(1)]
]).

strips([
    act [(stop_x)],
    pre [x_moving(-1)],
    add [x_moving(0)],
    del [x_moving(-1)]
]).


/* ----- GOTOX SEQUENTIAL PLAN ----- */
strips([
    act[],
    pre[seq(x_is_at(Xi), x_moving(Direction), wait_for_state(x_is_at(Xf)), x_moving(0))],
    add[x_is_at(Xf)],
    del[x_is_at(Xi), wait_for_state(x_is_at(Xf))]
]):-
    world(Wi, _Wf),
    member(x_is_at(Xi), Wi),
    (Xi \= Xf),
    Direction is (Xf-Xi)/abs(Xi-Xf).
/* --------------------------------- */

% ---------- BASIC Y ACTIONS ----------

strips([
    act [move_y_in],
    pre [y_moving(0)],
    add [y_moving(1)],
    del [y_moving(0)]
]).

strips([
    act [move_y_out],
    pre [y_moving(0)],
    add [y_moving(-1)],
    del [y_moving(0)]
]).

strips([
    act [stop_y],
    pre [y_moving(1)],
    add [y_moving(0)],
    del [y_moving(1)]
]).

strips([
    act [stop_y],
    pre [y_moving(-1)],
    add [y_moving(0)],
    del [y_moving(-1)]
]).


/* ----- GOTOY SEQUENTIAL PLAN ----- */
strips([
    act[],
    pre[seq(y_is_at(Yi), y_moving(Direction), wait_for_state(y_is_at(Yf)), y_moving(0))],
    add[y_is_at(Yf)],
    del[y_is_at(Yi), wait_for_state(y_is_at(Yf))]
]):-
    world(Wi, _Wf),
    member(y_is_at(Yi), Wi),
    Yi \= Yf,
    Direction is (Yf-Yi)/abs(Yi-Yf).
/* --------------------------------- */

% ---------- BASIC Z ACTIONS ----------

strips([
    act [move_z_up],
    pre [z_moving(0)],
    add [z_moving(1)],
    del [z_moving(0)]
]).

strips([
    act [move_z_down],
    pre [z_moving(0)],
    add [z_moving(-1)],
    del [z_moving(0)]
]).

strips([
    act [stop_z],
    pre [z_moving(1)],
    add [z_moving(0)],
    del [z_moving(1)]
]).

strips([
    act [(stop_z)],
    pre [z_moving(-1)],
    add [z_moving(0)],
    del [z_moving(-1)]
]).


/* ----- GOTOY SEQUENTIAL PLAN ----- */
strips([
    act[],
    pre[seq(z_is_at(Zi), z_moving(Direction), wait_for_state(z_is_at(Zf)), z_moving(0))],
    add[z_is_at(Zf)],
    del[z_is_at(Zi), wait_for_state(z_is_at(Zf))]
]):-
    world(Wi, _Wf),
    member(z_is_at(Zi), Wi),
    Zi \= Zf,
    Direction is integer((Zf-Zi)/abs(Zi-Zf)).
/* --------------------------------- */

% ---------- BASIC STATIONS ACTIONS -----------

% ------- LEFT STATION -------
strips([
    act [move_left_in],
    pre [left_moving(0)],
    add [left_moving(1)],
    del [left_moving(0)]
]).

strips([
    act [move_left_out],
    pre [left_moving(0)],
    add [left_moving(-1)],
    del [left_moving(0)]
]).

strips([
    act [stop_left],
    pre [left_moving(1)],
    add [left_moving(0)],
    del [left_moving(1)]
]).

strips([
    act [stop_left],
    pre [left_moving(-1)],
    add [left_moving(0)],
    del [left_moving(-1)]
]).

% ------- RIGHT STATION -------
strips([
    act [move_right_in],
    pre [right_moving(0)],
    add [right_moving(1)],
    del [right_moving(0)]
]).

strips([
    act [move_right_out],
    pre [right_moving(0)],
    add [right_moving(-1)],
    del [right_moving(0)]
]).

strips([
    act [stop_right],
    pre [right_moving(1)],
    add [right_moving(0)],
    del [right_moving(1)]
]).

strips([
    act [stop_right],
    pre [right_moving(-1)],
    add [right_moving(0)],
    del [right_moving(-1)]
]).

% ------- RETRIEVE LEFT STATION -------

strips([
    act [],
    pre [seq(left_moving(0), left_moving(1), wait_for_state(part_at_left_station(1)), left_moving(0))],
    add [part_at_left],
    del []
]).

strips([
    act[], %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pre[seq(part_at_left, y_is_at(2), z_is_at(1.0), x_is_at(1), y_is_at(1), z_is_at(1.5), y_is_at(2), z_is_at(1.0))],
    add[retrieve_from_ls],
    del[part_at_left_station]
]).

% * solve([retrieve_from_ls],[part_at_left_station(1), x_is_at(3), y_is_at(2),z_is_at(3),x_moving(0),y_moving(0),z_moving(0),left_moving(0)], Wf, Plan), write_list(Plan).


% ------- RETRIEVE RIGHT STATION -------

strips([
    act [],
    pre [seq(right_moving(0), right_moving(1), wait_for_state(part_at_right_station), right_moving(0))],
    add [part_at_right_station],
    del []
]).

strips([
    act[], %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pre[seq(part_at_right_station, y_is_at(2), z_is_at(1.0), x_is_at(10), y_is_at(1), z_is_at(1.5), y_is_at(2), z_is_at(1))],
    add[retrieve_from_rs], 
    del[part_at_right_station]
]).


% ------- PLACE LEFT STATION -------

strips([
    act[], %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pre[seq(cage_status(1), y_is_at(2), z_is_at(1.5), x_is_at(1), y_is_at(1), z_is_at(1.0), y_is_at(2))],
    add[part_at_left_station],
    del[cage_status]
]).

% * solve([part_at_right_station],[cage_status, x_is_at(3), y_is_at(2),z_is_at(3),x_moving(0),y_moving(0),z_moving(0),left_station_moving(0)], Wf, Plan), write_list(Plan).


% ------- PLACE RIGHT STATION -------

strips([
    act[], %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    pre[seq(y_is_at(2), z_is_at(1.5), x_is_at(10), y_is_at(1), z_is_at(1.0), y_is_at(2))],
    add[place_at_right_station],
    del[]
]).

% * solve([part_at_right_station],[cage_status, x_is_at(3), y_is_at(2), z_is_at(3), x_moving(0), y_moving(0), z_moving(0), right_station_moving(0)], Wf, Plan), write_list(Plan).

/*strips([
    act [],
    pre [seq(part_at_right_station, right_station_moving(0), right_station_moving(-1), wait_for_state(not(part_at_right_station)), right_station_moving(0))],
    add [part_delivered],
    del [part_at_right_station]

% * solve([part_delivered],[part_at_right_station, x_is_at(3), y_is_at(2),z_is_at(3),x_moving(0),y_moving(0),z_moving(0),right_station_moving(0)], Wf, Plan), write_list(Plan).

]).*/


% ------- PLACE IN CELL -------

strips([
    act[],
    pre[seq(y_is_at(2), x_is_at(Xf), z_is_at(Zf), z_is_at(Zu), y_is_at(3), z_is_at(Zf), y_is_at(2))],
    add[place_in_cell(Xf, Zf)],
    del[]
]):-
    Zu is Zf + 0.5.

% * solve([place_in_cell(3,3)], [y_is_at(2),x_is_at(1),z_is_at(1), x_moving(0), y_moving(0), z_moving(0) ],Wfinal, Plan), write_list(Plan).

% ------- RETRIEVE FROM CELL -------

strips([
    act[],
    pre[seq(z_is_at(Zf), x_is_at(Xf), y_is_at(3), z_is_at(Zu), y_is_at(2), z_is_at(Zf))],
    add[retrieve_from_cell(Xf, Zf)],
    del[place_in_cell(Xf, Zf)]
]):-
    Zu is Zf + 0.5.

% * solve([retrieve_from_cell(3,3)], [y_is_at(2),x_is_at(1),z_is_at(1), x_moving(0), y_moving(0), z_moving(0) ],Wfinal, Plan), write_list(Plan).

% ---------- WAIT COMMANDS -----------

strips([
    act[wait(state(Condition))],
    pre[],
    add[wait_for_state(Condition)],
    del[]
]).


% ------- GO TO ? HIERARCHICAL PLANS -------

% ------- x PLAN -------
strips([
    act[Plan],
    pre[x_is_at(Xi)],
    add[x_is_at(Xf)],
    del[x_is_at(Xi)]
]):-
    world(W1, _),
    member(x_is_at(Xi), W1),
    Xi \= Xf,
    Direction is (Xf-Xi) / abs(Xf-Xi),
        solve([x_moving(Direction)], W1, W2, Plan1),
        solve([wait_for_state(x_is_at(Xf))], W2, W3, Plan2),
        solve([x_moving(0)], W3, _W4, Plan3),
    flatten([Plan1, Plan2, Plan3], Plan).

% ------- Y PLAN -------

strips([
    act[Plan],
    pre[y_is_at(Yi)],
    add[y_is_at(Yf)],
    del[y_is_at(Yi)]
]):-
    world(W1, _),
    member(y_is_at(Yi), W1),
    Yi \= Yf,
    Direction is (Yf-Yi) / abs(Yf-Yi),
        solve([y_moving(Direction)], W1, W2, Plan1),
        solve([wait_for_state(y_is_at(Yf))], W2, W3, Plan2),
        solve([y_moving(0)], W3, _W4, Plan3),
    flatten([Plan1, Plan2, Plan3], Plan).

% ------- Z PLAN -------

strips([
    act[Plan],
    pre[z_is_at(Zi)],
    add[z_is_at(Zf)],
    del[z_is_at(Zi)]
]):-
    world(W1, _),
    member(z_is_at(Zi), W1),
    Zi \= Zf,
    Direction is (Zf-Zi) / abs(Zf-Zi),
        solve([z_moving(Direction)], W1, W2, Plan1),
        solve([wait_for_state(z_is_at(Zf))], W2, W3, Plan2),
        solve([z_moving(0)], W3, _W4, Plan3),
    flatten([Plan1, Plan2, Plan3], Plan).

% ------- GOTO XZ -------
strips([
    act[goto_xz],
    pre[seq(x_is_at(Xi), z_is_at(Zi), x_moving(DirectionX), wait_for_state(x_is_at(Xf)), x_moving(0), z_moving(DirectionZ), wait_for_state(z_is_at(Zf)), z_moving(0))],
    add[xz_is_at(Xf,Zf)],
    del[x_is_at(Xi), wait_for_state(x_is_at(Xf)), z_is_at(Zi), wait_for_state(z_is_at(Zf))]
]):-
    world(Wi, _Wf),

    member(x_is_at(Xi), Wi),
    (Xi \= Xf),
    DirectionX is (Xf-Xi)/abs(Xi-Xf),

    member(z_is_at(Zi), Wi),
    (Zi \= Zf),
    DirectionZ is (Zf-Zi)/abs(Zi-Zf).

% ----------- CONDITIONS -----------

play_with_conditions:-
  WaitConditions = [
      writeln( move_to_z_2),
      wait(     z_is_at(2)                  ),
      writeln( move_to_z_3),
      wait(     z_is_at(3)                  ),
      writeln(move_to_x1_and_z1),
      wait([    x_is_at(1), z_is_at(1)     ]), %List of wait
      writeln('the end')
  ],
  assert(plan( play , WaitConditions )).

prepare_goto_xz_plan_sequential(X, Z, Plan):-
  findall( State, state(State), World),
  solve([x_is_at(X), z_is_at(Z)], World, _WorldFinal, Plan).

start_goto_xz_plan_sequential(X, Z):-
  prepare_goto_xz_plan_sequential(X, Z, Plan),
  assert(plan(goto_xz(X,Z), Plan)).

prepare_goto_xz_plan_parallel(X, Z, (PlanX,PlanZ)):-
  findall( State, state(State), World),
  solve([x_is_at(X)], World, WorldFinalX, PlanX),
  %% careful! sometimes we may need to use the initial World again
  %% for the subsequent solve calling
  solve([z_is_at(Z)], WorldFinalX, _WorldFinalZ, PlanZ).

start_goto_xz_plan_parallel(X, Z):-
  prepare_goto_xz_plan_parallel(X, Z, (PlanX,PlanZ)),
  assert(plan(goto_x(X), PlanX)),
  assert(plan(goto_z(Z), PlanZ)).

start_goto_xz_plan_delayed(X, Z):-
  prepare_goto_xz_plan_parallel(X, Z, (PlanX,PlanZ)),
    WaitPlan = [
        ( % executes once
                 writeln('Plan will start in 5 seconds'),
                 get_time(Tstart)
        ),
        ( % keeps trying until Duration > 5 is true
                 get_time(Tnow),
                 Duration is Tnow -Tstart,
                 Duration > 5
        ),
        writeln(wakening)
    ],
    append( WaitPlan, PlanX, DelayedPlanX),
    append( WaitPlan, PlanZ, DelayedPlanZ),
    assert(plan(goto_x, [writeln(plan_goto_x(X))|DelayedPlanX])),
    assert(plan(goto_z, [writeln(plan_goto_z(Z))|DelayedPlanZ])).


start_goto_xz_plan_after_part_in_ls(X, Z):-
    prepare_goto_xz_plan_parallel(X, Z, (PlanX,PlanZ)),
    WaitPlan = [
        ( % executes once
            writeln('Plan will start when part is at left station')

        ),
        ( % keeps trying until Duration > 5 is true
            state(part_at_left_station(1))
        ),
        writeln(wakening)
    ],
    append( WaitPlan, PlanX, DelayedPlanX),
    append( WaitPlan, PlanZ, DelayedPlanZ),
    assert(plan(goto_x, [writeln(plan_goto_x(X))|DelayedPlanX])),
    assert(plan(goto_z, [writeln(plan_goto_z(Z))|DelayedPlanZ])).


prepare_retrieve_place_cell_sequential_plan(X, Z, Plan):-
    findall( State, state(State), World),
    solve([retrieve_from_ls, place_in_cell(X, Z)], World, _Wf, Plan), write_list(Plan).

start_retrieve_place_cell_sequential_plan(X, Z):-
    prepare_retrieve_place_cell_sequential_plan(X, Z, Plan),
    assert(plan(retrieve_place(X, Z), Plan)).


prepare_retrieve_place_right_sequential_plan(X, Z, Plan):-
    findall( State, state(State), World),
    solve([retrieve_from_cell(X, Z), place_at_right_station], World, _Wf, Plan), write_list(Plan).

start_retrieve_place_right_sequential_plan(X, Z):-
    prepare_retrieve_place_right_sequential_plan(X, Z, Plan),
    assert(plan(retrieve_place_right(X, Z), Plan)).

