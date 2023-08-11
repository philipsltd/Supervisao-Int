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
