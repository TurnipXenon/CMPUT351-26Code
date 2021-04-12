% a, b, c :- .
% b :- a.
% c :- a.
% a :- not a.

% not grounded
num(1..3).
add(A, B, Sum) :- num(A), num(B), num(Sum), Sum = A + B.
foo(N), bar(N) :- num(N).
foo(N) :- num(N), not bar (N).

% grounded
% num(1).
% num(2).
% num(3).
% bar(1);foo(1).
% bar(2);foo(2).
% bar(3);foo(3).
% foo(1):-not bar(1).
% foo(2):-not bar(2).
% foo(3):-not bar(3).
% add(1,1,2).
% add(2,1,3).
% add(1,2,3).