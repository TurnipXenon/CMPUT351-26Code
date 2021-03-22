same([], []).

same([H1|R1], [H2|R2]):-
    H1 = H2,
    same(R1, R2).


% NOTE: Starting definitions for a graph to prevent warning

node(zzz).

edge(zzz,xxx).

:- begin_tests(test).

% Q1

test(setIntersect) :- setIntersect([a,b,c,d,e,g],[b,a,c,e,f,q],S), S = [a,b,c,e].
test(setIntersect) :- setIntersect([],[b,a,c,e,f,q],S), S = [].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[],S), S = [].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[a,b,c,d,e,g],S), S = [a,b,c,d,e,g].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[h,i,j,k,l,m],S), S = [].



% Q2

test(swap) :- swap([a,1,b,2], W), W = [1,a,2,b].
test(swap) :- swap([a,1,b], W), W = [1,a,b].
test(swap) :- swap([], W), W = [].
test(swap) :- swap([1], W), W = [1].



% Q3

test(filter) :- filter([3,4,[5,2],[1,7,3]],greaterThan,3,W), W = [4,5,7].
test(filter) :- filter([3,4,[5,2],[1,7,3]],equal,3,W), W = [3,3].
test(filter) :- filter([3,4,[5,2],[1,7,3]],lessThan,3,W), W = [2,1].



% Q4

test(countAll) :- countAll([a,b,e,c,c,b],N), N = [[a,1],[e,1],[b,2],[c,2]].



% Q5

test(sub) :- sub([a,[a,d],[e,a]],[[a,2]],L), L = [2,[2,d],[e,2]].


:- end_tests(test).