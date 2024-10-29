:- use_module(library(readutil)).
:- use_module(library(lists)).
:- use_module(library(heaps)).

% moves/2: Βρίσκει τη μικρότερη διαδρομή από το αρχείο
moves(File, Moves) :-
    read_grid(File, Grid),
    length(Grid, N),
    initial_state(Grid, N, Start),
    final_state(N, Goal),
    ( solve(Start, Goal, Grid, [N, N], MovesPath) ->
        reverse(MovesPath, Moves)
    ; Moves = 'IMPOSSIBLE'
    ).

% Διαβάζει το πλέγμα από το αρχείο
read_grid(File, Grid) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    atom_number(Line, N),
    read_lines(Stream, N, Grid),
    close(Stream).

read_lines(_, 0, []) :- !.
read_lines(Stream, N, [Row|Rows]) :-
    read_line_to_string(Stream, Line),
    split_string(Line, " ", "", StrNumbers),
    maplist(atom_number, StrNumbers, Row),
    N1 is N - 1,
    read_lines(Stream, N1, Rows).

% Αρχικό και τελικό κατηγόρημα
initial_state(_, _, state(1, 1)).
final_state(N, state(N, N)).

% Αναζήτηση με βέλτιστη πρώτη (A* ή BFS)
solve(Start, Goal, Grid, Dimensions, Moves) :-
    bfs([state(Start, [])], Goal, Grid, Dimensions, [], Moves).

bfs([state(State, Path)|_], Goal, _, _, _, Path) :-
    State = Goal, !.

bfs([state(State, Path)|Rest], Goal, Grid, Dimensions, Visited, Moves) :-
    findall(state(NextState, [Move|Path]),
            (valid_move(State, NextState, Move, Grid, Dimensions, Visited),
             \+ member(NextState, Visited)),
            NextStates),
    append(Rest, NextStates, NewStates),
    bfs(NewStates, Goal, Grid, Dimensions, [State|Visited], Moves).

% Εύρεση έγκυρων κινήσεων
valid_move(state(X, Y), state(X1, Y1), Move, Grid, [N, N], _) :-
    move_direction(Move, DX, DY),
    X1 is X + DX,
    Y1 is Y + DY,
    X1 > 0, X1 =< N, Y1 > 0, Y1 =< N,
    get_value(Grid, X, Y, Val),
    get_value(Grid, X1, Y1, Val1),
    Val1 < Val.

% Κατευθύνσεις κινήσεων
move_direction(n, -1, 0).
move_direction(s, 1, 0).
move_direction(e, 0, 1).
move_direction(w, 0, -1).
move_direction(ne, -1, 1).
move_direction(nw, -1, -1).
move_direction(se, 1, 1).
move_direction(sw, 1, -1).

% Λήψη της τιμής από το πλέγμα
get_value(Grid, X, Y, Val) :-
    nth1(X, Grid, Row),
    nth1(Y, Row, Val).

% Εκκίνηση του προγράμματος
:- initialization(main).

main :-
    moves('grid1.txt', Moves1),
    writeln(Moves1),
    moves('grid2.txt', Moves2),
    writeln(Moves2),
    moves('grid3.txt', Moves3),
    writeln(Moves3),
    halt.