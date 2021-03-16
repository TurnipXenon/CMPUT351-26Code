% setIntersect([], _, []).
% setIntersect(L, R, S) :- .

swap([], []).
swap([A], [A]).
swap([A,B|L], [B,A|R]) :- swap(L, R).