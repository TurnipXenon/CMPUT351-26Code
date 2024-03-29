same([], []).

same([H1|R1], [H2|R2]):-
    H1 = H2,
    same(R1, R2).



:- begin_tests(test).

% Q1

test(setIntersect) :- setIntersect([a,b,c,d,e,g],[b,a,c,e,f,q],S), S = [a,b,c,e].
test(setIntersect) :- setIntersect([],[b,a,c,e,f,q],S), S = [].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[],S), S = [].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[a,b,c,d,e,g],S), S = [a,b,c,d,e,g].
test(setIntersect) :- setIntersect([a,b,c,d,e,g],[h,i,j,k,l,m],S), S = [].
test(setIntersect) :- setIntersect([],[],S), S = [].



% Q2

test(swap) :- swap([a,1,b,2], W), W = [1,a,2,b].
test(swap) :- swap([a,1,b], W), W = [1,a,b].
test(swap) :- swap([], W), W = [].
test(swap) :- swap([1], W), W = [1].



% Q3

test(filter) :- filter([3,4,[5,2],[1,7,3]],greaterThan,3,W), W = [4,5,7].
test(filter) :- filter([3,4,[5,2],[1,7,3]],equal,3,W), W = [3,3].
test(filter) :- filter([3,4,[5,2],[1,7,3]],lessThan,3,W), W = [2,1].
test(filter) :- filter([],lessThan,3,W), W = [].
test(filter) :- filter([5,4,[5,8],[9,7,4]],greaterThan,3,W), W = [5,4,5,8,9,7,4].



% Q4

test(countAll) :- countAll([a,b,e,c,c,b],N), N = [[a,1],[e,1],[b,2],[c,2]].
test(countAll) :- countAll([],N), N = [].
test(countAll) :- countAll([a],N), N = [[a,1]].
test(countAll) :- countAll([a,b],N), N = [[a,1],[b,1]].
test(countAll) :- countAll([a,a],N), N = [[a,2]].
test(countAll) :- countAll([a,b,c,d],N), N = [[a,1],[b,1],[c,1],[d,1]].



% Q5

test(sub) :- sub([a,[a,d],[e,a]],[[a,2]],L), L = [2,[2,d],[e,2]].
test(sub) :- sub([a,[a,d],[e,a]],[],L), L = [a,[a,d],[e,a]].
test(sub) :- sub([a,b,c], [[a,d], [b, c]], O), O = [d,c,c].
test(sub) :- sub([a,b,c], [], O), O = [a,b,c].
test(sub) :- sub([], [[a,d], [b, c]], O), O = [].
test(sub) :- sub([], [], O), O = [].
test(sub) :- sub([a,[a,d],[e,a]],[[a,2], [d,g], [e,f]],L), L = [2,[2,g],[f,2]].



% Q6: just manually test lol



% Q7

test(convert) :- convert([e,e,a,e,b,e],R), R = [c,c].
test(convert) :- convert([e,q,a,b,e,e],R), R = [q,c,c].
test(convert) :- convert([e,a,e,e],R), R = [c].
test(convert) :- convert([e,q,a,e,b,q,e,a,e],R), R = [q,a,e,b,q,c].
test(convert) :- convert([a,q,e,l,q,r,e,q,b,e],R), R = [c,q,e,l,q,c,q,c].
test(convert) :- convert([q,e,q,b,q,e,l,q,a,e],R), R = [q,e,q,c,q,e,l,q,c].
test(convert) :- convert([],R), R = [].
test(convert) :- convert([e,e,e,e,e,e],R), R = [].
test(convert) :- convert([q,e,e,e,e,e,e,q],R), R = [q,e,e,e,e,e,e,q].
test(convert) :- convert([q,a,a,q],R), R = [q,a,a,q].
test(convert) :- convert([a,b,c,d,f,g],R), R = [c,c,c,c,c,c].
test(convert) :- convert([q,a,b,c,d,q,e,q,e,f,q,q,g],R), R = [q,a,b,c,d,q,q,e,f,q,q,c].



:- end_tests(test).

% Others

% NOTE: Starting definitions for a graph to prevent warning

node(a).
node(b).
node(c).
node(d).

edge(a,b).
edge(b,c).
edge(c,a).
edge(a,d).