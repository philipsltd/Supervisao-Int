:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded(warehouse_config).

     assert_state(NewState):-
          get_time(TimeStamp),
          assert_before_state(NewState),
          assert(state(NewState, TimeStamp)).

state(State):-     state(State, _TimeStamp).

assert_before_state(NewState):-
     make_most_generic_term(NewState, GenericState),
     state(GenericState, _),
     retract_state(GenericState),
     !;
     true.

retract_state(State):-
     state(State, TimeStamp_ini),
     make_most_generic_term(State, GenericState),
     retractall(state(GenericState, _)),
     retractall(before(GenericState, _,_)),
     get_time(TimeStamp_end),
     assert(before(State, TimeStamp_ini, TimeStamp_end)),
     !
     ; % or
     true.
     
provide_warehouse_states:-
% output as JSON object
    writeln('{'),
    get_state_value(part_in_cage, VCage, 1, 0), format('"cage"    :"~w",~n' , [VCage]),
    get_state_value(x_is_at(X), X, X, '-1'), format('"x"       :"~w",~n' , [X]),
    get_state_value(x_moving(XMov), XMov, XMov, 0), format('"x_moving":"~w",~n', [XMov]),
    get_state_value(y_is_at(Y), Y, Y, '-1'), format('"y"       :"~w",~n' , [Y]),
    get_state_value(y_moving(YMov), YMov, YMov, 0), format('"y_moving":"~w",~n', [YMov]),
    get_state_value(z_is_at(Z), Z, Z, '-1'), format('"z"       :"~w",~n', [Z]),
    get_state_value(z_moving(Z), ZMov, ZMov, 0), format('"z_moving":"~w" ~n', [ZMov]),
    % TO BE COMPLETED
    % don't put final comma at the last one......
    writeln('}').
    


get_state_value(Term, Variable, ValueOn, _ValueOff):-
     state(Term),
     Variable = ValueOn,
     !.

get_state_value(_Term, Variable, _ValueOn, ValueOff):-
     Variable = ValueOff.

time_on(State, TimeStamp):-
     state(State, TimeStamp).

timeOff(State, TimeStamp):-
     before(State,_Ti,TimeStamp).


% ----- BETWEEN X -----

defrule([name: x_between_rule_on],
     if not(state(x_between(_, _)))     and
     not(state(x_is_at(_)))             and
     before(x_is_at(XBefore), _Ti, _Tf) and
     state(x_moving(Dir))               and
     (Dir \= 0)
     then [
          XNext is XBefore + Dir,
          assert_state(x_between(XBefore, XNext))
     ]
).

defrule([name: x_between_rule_off],
     if state(x_between(_, _))          and
     state(x_is_at(_))
     then [
          retract_state(x_between(_, _))
     ]
).


% ----- BETWEEN Y -----

defrule([name: y_between_rule_on],
     if not(state(y_between(_, _)))     and
     not(state(y_is_at(_)))             and
     before(y_is_at(YBefore), _Ti, _Tf) and
     state(y_moving(Dir))               and
     (Dir \= 0)
     then [
          YNext is YBefore + Dir,
          assert_state(y_between(YBefore, YNext))
     ]
).

defrule([name: y_between_rule_off],
     if state(y_between(_, _))          and
     state(y_is_at(_))
     then [
          retract_state(y_between(_, _))
     ]
).


% ----- BETWEEN Z -----

defrule([name: z_between_rule_on],
     if not(state(z_between(_, _)))     and
     not(state(z_is_at(_)))             and
     before(z_is_at(ZBefore), _Ti, _Tf) and
     state(z_moving(Dir))               and
     (Dir \= 0)
     
     then [
          ZNext is ZBefore + Dir,
          assert_state(z_between(ZBefore, ZNext))
     ]
).

defrule([name: z_between_rule_off],
     if state(z_between(_, _))          and
     state(z_is_at(_))
     then [
          retract_state(z_between(_, _))
     ]
).
