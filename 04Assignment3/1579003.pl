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

filter([], _, _, []).
filter([A|L], OP, N, [A|L1]) :- number(A), doOperation(OP, A, N), 
                                !, filter(L, OP, N, L1).
filter([A|L], OP, N, L1) :- number(A), !, filter(L, OP, N, L1).
filter([A|L], OP, N, L3) :- filter(A, OP, N, L1), filter(L, OP, N, L2), 
                            append(L1, L2, L3).

% 4
countOccurence(_, [], 0) :- !. % only one result :)
countOccurence(X, [X|L], XN) :- !, countOccurence(X, L, XN0), XN is XN0 + 1.
countOccurence(X, [_|L], XN) :- countOccurence(X, L, XN).

xCountAll([], _, []).
xCountAll([X|L], REF, L1) :- isIn(X, L), !, xCountAll(L, REF, L1).
xCountAll([X|L], REF, [[X,XN]|L1]) :- countOccurence(X, REF, XN), 
                                      xCountAll(L, REF, L1).

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

% 5
sub([], _, []).
sub([X|L], S, [X2|L1]) :- atomic(X), !, subReplace(X, S, X2), sub(L, S, L1).
sub([X|L], S, [L1|L2]) :- sub(X, S, L1), sub(L, S, L2).

subReplace(X, [], X) :- !.
subReplace(X, [[X,Y]|_], Y) :- !.
subReplace(X, [_|L], Y) :- subReplace(X, L, Y).

% 6
clique(L) :- findall(X, node(X), Nodes),
             subset(L, Nodes), allConnected(L).

subset([], _).
subset([X|Xs], Set) :- append(_, [X|Set1], Set), subset(Xs, Set1).

allConnected([]).
allConnected([_|[]]) :- !.
allConnected([A|L]) :- isConnectedToAll(A, L), allConnected(L).

isConnectedToAll(_, []) :- !.
isConnectedToAll(A, [B|L]) :- isConnected(A, B), isConnectedToAll(A, L).

isConnected(A, B) :- edge(A, B), !.
isConnected(A, B) :- edge(B, A).

% todo: delete
node(a).
node(b).
node(c).
node(d).

edge(a,b).
edge(b,c).
edge(c,a).
edge(c,d).
edge(a,d).

% 7
% convert(+Term,-Result)
convert(Term, Result) :- findAllQ(Term, Borders), xConvert(Term, Borders, Result, 0).

xConvert([], _, [], _).
xConvert([q|L], B, [q|L1], I) :- !, J is I + 1, xConvert(L, B, L1, J).
xConvert([X|L], B, [X|L1], I) :- inBorder(I, B), !, J is I + 1, xConvert(L, B, L1, J).
xConvert([e|L], B, L1, I) :- !, J is I + 1, xConvert(L, B, L1, J).
xConvert([_|L], B, [c|L1], I) :- J is I + 1, xConvert(L, B, L1, J).
% q
% in border
% out border e
% out border letter

inBorder(_, []) :- false.
inBorder(I, [[L, H]|_]) :- L =< I, I =< H, !.
inBorder(I, [_|B]) :- inBorder(I, B).

findAllQ(L, QL) :- xFindAllQ(L, QL0, 0), pairUp(QL0, QL).

xFindAllQ([], [], _).
xFindAllQ([q|L], [X|LX], X) :- !, X1 is X + 1, xFindAllQ(L, LX, X1).
xFindAllQ([_|L], LX, X) :- X1 is X + 1, xFindAllQ(L, LX, X1).

pairUp([], []) :- !.
pairUp([_|[]], []) :- !.
pairUp([A, B|L], [[A, B]|L1]) :- pairUp(L, L1).