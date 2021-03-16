foo(1).
foo(2) :- bar(2).


countdown(0).
countdown(X) :- Y is X - 1, countdown(Y).