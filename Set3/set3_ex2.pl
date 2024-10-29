:- use_module(library(readutil)).

% minbases/2: βρίσκει τις ελάχιστες βάσεις για μια λίστα από αριθμούς
minbases([], []).
minbases([N|Ns], [B|Bs]) :-
    min_base_for_number(N, B),
    minbases(Ns, Bs).

% min_base_for_number/2: βρίσκει την ελάχιστη βάση για έναν αριθμό
min_base_for_number(N, B) :-
    find_base(N, 2, B).

% find_base/3: βρίσκει τη βάση ξεκινώντας από μια δοκιμαστική βάση
find_base(N, B, B) :-
    write_in_base(N, B, Digits),
    all_same(Digits), !.
find_base(N, B, R) :-
    B1 is B + 1,
    find_base(N, B1, R).

% write_in_base/3: γράφει τον αριθμό στη βάση και επιστρέφει τα ψηφία
write_in_base(0, _, []) :- !.
write_in_base(N, B, [D|Ds]) :-
    D is N mod B,
    N1 is N // B,
    write_in_base(N1, B, Ds).

% all_same/1: ελέγχει αν όλα τα στοιχεία της λίστας είναι ίδια
all_same([]).
all_same([_]).
all_same([X, X | Xs]) :-
    all_same([X | Xs]).

% main/0: κύρια συνάρτηση
main :-
    % Διαβάστε τους αριθμούς από το f1.txt
    read_numbers('f1.txt', Numbers),
    % Βρείτε τις ελάχιστες βάσεις
    minbases(Numbers, Bases),
    % Γράψτε τα αποτελέσματα στο f2.txt
    write_bases('f2.txt', Bases),
    halt.

% read_numbers/2: διαβάζει αριθμούς από ένα αρχείο
read_numbers(File, Numbers) :-
    open(File, read, Stream),
    read_lines(Stream, Lines),
    close(Stream),
    maplist(atom_number, Lines, Numbers).

% read_lines/2: διαβάζει όλες τις γραμμές από ένα ρεύμα
read_lines(Stream, Lines) :-
    read_line_to_string(Stream, Line),
    ( Line == end_of_file ->
        Lines = []
    ; read_lines(Stream, RestLines),
      Lines = [Line | RestLines]
    ).

% write_bases/2: γράφει τις βάσεις σε ένα αρχείο
write_bases(File, Bases) :-
    open(File, write, Stream),
    maplist(write_line(Stream), Bases),
    close(Stream).

% write_line/2: γράφει μια γραμμή σε ένα ρεύμα
write_line(Stream, Base) :-
    writeln(Stream, Base).

:- initialization(main).