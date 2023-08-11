:- multifile aa/1. % (ignore this)

:-dynamic state/2. % to represent state(x_is_at(2), 133223).

:-dynamic before/3. % represent before(x_is_at(2, 133223, 133250).

:-dynamic command/2. % to represent command(move_x_left, 213123).

:-dynamic goal/2.  % to represent goal(x_is_at(2), 33133). 

:-dynamic plan/2.

:-dynamic prolog/1.

:-dynamic wait/1.

:-dynamic failure/5. % to represent failure(1, 2, 3, 4, 5).

:-dynamic stored/1. % number of stored packages

:-dynamic inStock/1. % number of packages in stock

:-dynamic withdrawn/1. % number of packages withdrawn

:-dynamic saved_actuator_states/1.  % to represent saved_actuator_states(x, y, z, station_left, station_right).
















