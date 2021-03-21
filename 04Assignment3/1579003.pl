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

% 4
countOccurence(_, [], 0) :- !. % only one result :)
countOccurence(X, [X|L], XN) :- !, countOccurence(X, L, XN0), XN is XN0 + 1.
countOccurence(X, [_|L], XN) :- countOccurence(X, L, XN).

xCountAll([], _, []).
xCountAll([X|L], REF, L1) :- isIn(X, L), !, xCountAll(L, REF, L1).
xCountAll([X|L], REF, [[X,XN]|L1]) :- countOccurence(X, REF, XN), xCountAll(L, REF, L1).

getMinPair([A, AN], [_, BN], [A, AN]) :- AN < BN, !.
getMinPair(_, X, X).

xFindMinPair([], []) :- !.
xFindMinPair([A|[]], A) :- !.
xFindMinPair([A|L], MIN) :- xFindMinPair(L, CAND), getMinPair(A, CAND, MIN).

excludePair(_, [], []).
excludePair(EX, [EX|L], REM) :- !, excludePair(EX, L, REM).
excludePair(EX, [A|L], [A|REM]) :- !, excludePair(EX, L, REM).

findMinPair(L, MIN, REM) :- xFindMinPair(L, MIN), excludePair(MIN, L, REM).

% based on insertion sort
pairSort([], []).
pairSort(L, [MIN|L1]) :- findMinPair(L, MIN, REM), pairSort(REM, L1).

countAll(L, N) :- xCountAll(L, L, N0), pairSort(N0, N).