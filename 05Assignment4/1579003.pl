%*****************************************************************************************
% Question 1



%*****************************************************************************************
% Question 2
% encrypt(+W1, +W2, +W3): addition of values W1 and W2 equals that of W3. Assume that W1 and
% W2 are of the same length.

% encrypt(E, D, 2).

:- use_module(library(clpfd)).

% encrypt([S, E, N, D], [M, O, R, E], [M, O, N, E, Y]).
encrypt(W1,W2,W3) :- 
   length(W1,N), % if you need to know the lengths of words
   length(W3,N1),   
   append(W1,W2,W),
   append(W,W3,L),
   list_to_set(L, Letters), % remove duplicates, a predicate in list library
   [LeadLetter1|_] = W1, % identify the leading letter to be set to non-zero
   [LeadLetter2|_] = W2,
   [LeadLetter3|_] = W3,
   !, % never need to redo the above
   all_diff(Letters),
   sum_constraint(LeadLetter3, N, N1),
   Sum4 #= Sum3,
   LeadLetter1 #\= 0,
   LeadLetter2 #\= 0,
   LeadLetter3 #\= 0,
   get_sum(W1, Sum1),
   get_sum(W2, Sum2),
   Sum3 #= Sum1 + Sum2,
   get_sum(W3, Sum4),
   Letters ins 0..9,
   label(Letters).

sum_constraint(_, A, A) :- !.
sum_constraint(Letter, _, _) :- Letter #= 1.

get_sum([], 0).
get_sum([A|L], Sum) :-
   length([A|L], Len),
   Exp is Len - 1,
   power(10, Exp, P),
   Sum1 #= A*P,
   get_sum(L, Sum2),
   Sum #= Sum1 + Sum2.

power(_, 0, 1) :- !.
power(Base, Exp, Result) :-
   Exp1 is Exp - 1,
   power(Base, Exp1, Result1),
   Result is Result1 * Base.

all_diff([_]).
all_diff([A|L]) :-
   diff(A, L),
   all_diff(L).

diff(_, []).
diff(A, [B|L]) :-
   A #\= B,
   diff(A,L).