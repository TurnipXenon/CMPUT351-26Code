% 1
isIn(_, []) :- false.
isIn(A, [A|_]) :- !, true.
isIn(A, [_|L]) :- isIn(A, L).

setIntersect([], _, []).
setIntersect([A|L], R, [A|S]) :- !, isIn(A,R), setIntersect(L, R, S).
setIntersect([_|L], R, S) :- setIntersect(L, R, S).

% 2
swap([], []).
swap([A], [A]).
swap([A,B|L], [B,A|R]) :- swap(L, R).

% 3

doOperation('equal', A, B) :- !, A =:= B.
doOperation('greaterThan', A, B) :- !, A > B.
doOperation('lessThan', A, B) :- !, A < B.
doOperation(_, _, _) :- false.

append([], L, L).
append([A|L1], B, [A|L2]) :- append(L1, B, L2).

filter([], _, _, []).
filter([A|L], OP, N, [A|L1]) :- number(A), doOperation(OP, A, N), !, filter(L, OP, N, L1).
filter([A|L], OP, N, L1) :- number(A), !, filter(L, OP, N, L1).
filter([A|L], OP, N, L3) :- filter(A, OP, N, L1), filter(L, OP, N, L2), append(L1, L2, L3).