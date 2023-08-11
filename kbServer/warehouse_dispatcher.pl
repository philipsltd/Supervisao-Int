:-ensure_loaded('RTXengine/RTXengine.pl').
:-ensure_loaded(warehouse_config).

assert_command(Command):-
    get_time(TimeStamp),
    assert(command(Command, TimeStamp)).

assert_goal(Goal):-
    get_time(TimeStamp),
    assert(goal(Goal, TimeStamp)).

retract_goal(Goal):-
    retract(goal(Goal, _TimeStamp)).

command(Command):- command(Command, _TimeStamp).
goal(Goal):-       goal(Goal, _TimeStamp).

consume_control_commands:-
    %silly way to produce a JSON array
    findall( Command,  command(Command, _TimeStamp), List),
    retractall(command(_,_)),
    findall( QuotedCmd,
             (   member(Cmd,List),
                 atom_concat('"', Cmd, Cmd1),
                 atom_concat(Cmd1,'"', QuotedCmd)
             ), ListQuoted),
    write(ListQuoted),
    nl.


%   goto X
defrule([name: gotox_right],
   if   state(x_is_at(Xi))           and
        goal(x_is_at(Xf))            and
        (Xi < Xf)                    and
        not(command(move_x_right))   and
        state(x_moving(0)) then
   (
     assert_command( move_x_right))
   ).

defrule([name: gotox_left],
   if  state(x_is_at(Xi))         and
       goal(x_is_at(Xf))          and
       (Xi > Xf)                  and
       not(command(move_x_left))  and
       state(x_moving(0)) then
   [
     assert_command( move_x_left)
   ]
).

defrule([name: stop_x],
   if  state(x_is_at(Xf))       and
       goal(x_is_at(Xf))        and
       not(command(stop_x))     and
       not(state(x_moving(0)))  then
   [
     assert_command(stop_x),
     retract_goal(x_is_at(Xf))
   ]
).


%   goto Y 
defrule([name: gotoy_in],
   if   state(y_is_at(Yi))           and
        goal(y_is_at(Yf))            and
        (Yi < Yf)                    and
        not(command(move_y_in))   and
        state(y_moving(0)) then
   (
     assert_command( move_y_in))
).

defrule([name: gotoy_out],
   if   state(y_is_at(Yi))           and
        goal(y_is_at(Yf))            and
        (Yi > Yf)                    and
        not(command(move_y_out))   and
        state(y_moving(0)) then
   (
     assert_command( move_y_out))
).

defrule([name: stop_y],
   if  state(y_is_at(Yf))       and
       goal(y_is_at(Yf))        and
       not(command(stop_y))     and
       not(state(y_moving(0)))  then
   [
     assert_command(stop_y),
     retract_goal(y_is_at(Yf))
   ]
).


%   goto Z 
defrule([name: gotoz_up],
   if   state(z_is_at(Zi))          and
        goal(z_is_at(Zf))           and
        (Zi < Zf)                   and
        not(command(move_z_up))     and
        state(z_moving(0)) then
   (
     assert_command( move_z_up))
).

defrule([name: gotoz_down],
   if   state(z_is_at(Zi))          and
        goal(z_is_at(Zf))           and
        (Zi > Zf)                   and
        not(command(move_z_down))   and
        state(z_moving(0)) then
   (
     assert_command( move_z_down))
).

defrule([name: stop_z],
   if  state(z_is_at(Zf))       and
       goal(z_is_at(Zf))        and
       not(command(stop_z))     and
       not(state(z_moving(0)))  then
   [
     assert_command(stop_z),
     retract_goal(z_is_at(Zf))
   ]
).


% ---------- PLAN RULES ----------
defrule([name: plan_with_goal_rule],
    if plan(Ref,[goal(Goal)|ListOfActions])
       then [         %get an action
       assert_goal(Goal),
       retract(plan(Ref,[goal(Goal)|ListOfActions])),
       assert(plan(Ref,ListOfActions)),
       log_format('goal____: ~w, plan: ~w~n',[Goal, Ref])
    ]
).

defrule([name: plan_with_command_rule],
    if plan(Ref,[command(Command)|ListOfActions])
       then [         %get an action
       assert_command(Command),
       retract(plan(Ref,[command(Command)|ListOfActions]) ),
       assert(plan(Ref,ListOfActions) ),
       log_format('command: ~w, plan: ~w~n',[Command, Ref])
    ]
).

defrule([name: empty_plan_rule],
    if plan(Ref,[])  then [                          %retract finished/empty
       retract(plan(Ref,[])),                        %plans
       log_format('finished: plan ~w~n',[Ref])
    ]
).


% ---------- WAIT RULES ----------
defrule([name: wait_rule_check_state],    
  if plan(Ref,[wait(Condition)|ListOfActions])  
    and state(Condition, _)  then[ 
    retract(plan(Ref,[wait(Condition)|ListOfActions])), 
    assert(plan(Ref,ListOfActions)),       
    log_format('wait____: ~w, plan: ~w~n',[Condition, Ref])    
  ]
).

defrule([name: wait_rule_check_state_1],
    if plan(Ref,[wait(Condition)|ListOfActions])
            and state(Condition, _) then [
       retract(plan(Ref,[wait(Condition)|ListOfActions])),
       assert(plan(Ref,ListOfActions)),
       log_format('wait____: ~w, plan: ~w~n',[Condition, Ref])
    ]
).

defrule([name: wait_rule_check_state_2],
    if plan(Ref,[wait(state(Condition))|ListOfActions])
            and state(Condition, _) then [
       retract(plan(Ref,[wait(state(Condition))|ListOfActions])),
       assert(plan(Ref,ListOfActions)),
       log_format('wait____: ~w, plan: ~w~n',[Condition, Ref])
    ]
).

defrule([name: wait_rule_check_state_3],
    if  plan(Ref,[wait([])|ListOfActions]) then [
       retract( plan(Ref,[wait([])|ListOfActions])),
       assert( plan(Ref,ListOfActions))
    ]
).

defrule([name: wait_rule_check_state_4],
    if  plan(Ref,[wait( [Condition|ConditionsList])|ListOfActions])
            and  state(Condition)  then [
       retract(plan(Ref,[wait( [Condition|ConditionsList])|ListOfActions])),
       assert(plan(Ref,[wait( ConditionsList)|ListOfActions])),
       log_format('wait____: ~w, plan: ~w~n',[Condition, Ref])
    ]
).

defrule([name: wait_rule_check_state_5],
    if  plan(Ref,[wait( [state(Condition)|ConditionsList])|ListOfActions])
            and state(Condition)  then [
       retract(plan(Ref,[wait( [Condition|ConditionsList])|ListOfActions])),
       assert(plan(Ref,[wait( ConditionsList)|ListOfActions])),
       log_format('wait____: ~w, plan: ~w~n',[Condition, Ref])
    ]
).

% ---------- PROLOG RULES ----------
defrule([name: prolog_rule],    
  if plan(Ref,[prolog(Statement)|ListOfActions])    
  and (Statement)    then[  
    retract(plan(Ref,[prolog(Condition)|ListOfActions])),    
    assert(plan(Ref,ListOfActions)),      
    log_format('prolog: ~w, plan: ~w~n',[Condition, Ref])    
  ]
).

defrule([name: prolog_rule_1],
    if plan(Ref,[prolog(Statement)|ListOfActions]) and not(is_list(Statement))
    and (Statement)
    then[
       retract(plan(Ref,[prolog(Statement)|ListOfActions])),
       assert(plan(Ref,ListOfActions)),
       log_format('prolog: ~w, plan: ~w~n',[Statement, Ref])
    ]
).


defrule([name: prolog_rule_2],
    if plan(Ref,[prolog([])|ListOfActions])
    then[
       retract( plan(Ref,[prolog([])|ListOfActions])),
       assert( plan(Ref,ListOfActions))
    ]
).

defrule([name: prolog_rule_3],
    if plan(Ref,[prolog([Statement|ListProlog])|ListOfActions]) and writeln(sss(Statement))
    and (Statement)
    then[
       retract(plan(Ref,[prolog([Statement|ListProlog])|ListOfActions])) ,
       assert( plan(Ref,[prolog(ListProlog)|ListOfActions])),
       log_format('prolog: ~w, plan: ~w~n',[Statement, Ref])
    ]
).

actuator_list([   move_x_left, move_x_right, stop_x,
                  move_z_up, move_z_down, stop_z,
                  move_y_in, move_y_out, stop_y,
                  move_left_in, move_left_out, stop_left,
                  move_right_in, move_right_out, stop_right,

                  goto_x, goto_y, goto_z,

                  take_part_from_ls, take_part_from_rs,
                  place_part_ls, place_part_rs,
                  place_part_in_cell, take_part_from_cell
              ]). % IMPORTANT
              

defrule([name: any_other_Statement_rule_1],
    if plan(Ref,[Actuator|ListOfActions])
        and actuator_list(List)
        and member(Actuator,List)
    then[
       %% it is a command
       assert_command(Actuator),
       retract( plan(Ref,[Statement|ListOfActions])),
       assert(  plan(Ref,ListOfActions)),
       log_format('open_action1: ~w, plan: ~w~n',[Statement, Ref])
    ]
).



defrule([name: any_other_Statement_rule_2],
    if plan(Ref,[Statement|ListOfActions])
        and (Statement \= wait(_)  )
        and (Statement \= prolog(_))
        and (Statement \= goal(_)  )
        and (Statement \= command(_)  )
        and (Statement)
    then[
       retract( plan(Ref,[Statement|ListOfActions])),
       assert(  plan(Ref,ListOfActions)),
       log_format('open_action2: ~w, plan: ~w~n',[Statement, Ref])
    ]
).




% X Rule
defrule([name:move_right_rule],
  if goal(move_x_right) then  [
    assert_command(move_x_right),
    retract_goal(move_x_right)
]).

defrule([name:move_left_rule],
  if goal(move_x_left) then [
    assert_command(move_x_left),
    retract_goal(move_x_left)
]).

defrule([name:stop_x_rule],
  if goal(stop_x) then  (
    assert_command(stop_x),
    retract_goal(stop_x)
)).


% Z Rule
defrule([name:move_up_rule],
  if goal(move_z_up) then  [
    assert_command(move_z_up),
    retract_goal(move_z_up)
]).

defrule([name:move_down_rule],
  if goal(move_z_down) then [
    assert_command(move_z_down),
    retract_goal(move_z_down)
]).

defrule([name:stop_z_rule],
  if goal(stop_z) then  (
    assert_command(stop_z),
    retract_goal(stop_z)
)).


% Left Station
defrule([name:move_left_in_rule],
  if goal(move_left_in) then [
      assert_command(move_left_in),
      retract_goal(move_left_in)
  ]).

defrule([name:move_left_out_rule],
  if goal(move_left_out) then [
      assert_command(move_left_out),
      retract_goal(move_left_out)
  ]).

defrule([name:stop_left_rule],
  if goal(stop_left) then [
      assert_command(stop_left),
      retract_goal(stop_left)
  ]).


% Right Station
defrule([name:move_right_in_rule],
  if goal(move_right_in) then [
      assert_command(move_right_in),
      retract_goal(move_right_in)
  ]).

defrule([name:move_right_out_rule],
  if goal(move_right_out) then [
      assert_command(move_right_out),
      retract_goal(move_right_out)
  ]).

defrule([name:stop_right_rule],
  if goal(stop_right) then [
      assert_command(stop_right),
      retract_goal(stop_right)
  ]).


defrule([name:plan_goto_xz_rule],
  if goto_xz(X,Z)
  then [
      retract( goto_xz(X,Z)   ),
      start_goto_xz_plan_parallel(X, Z)
]).
