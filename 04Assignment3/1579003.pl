isIn(_, []) :- false.
isIn(A, [A|_]) :- true.
isIn(A, [_|L]) :- isIn(A, L).

setIntersect([], _, []).
setIntersect([A|L], R, [A|S]) :- isIn(A,R), setIntersect(L, R, S).
setIntersect([_|L], R, S) :- setIntersect(L, R, S).

swap([], []).
swap([A], [A]).
swap([A,B|L], [B,A|R]) :- swap(L, R).