%*****************************************************************************************
% Question 1



%*****************************************************************************************
% Question 2
% encrypt(+W1, +W2, +W3): addition of values W1 and W2 equals that of W3. Assume that W1 and
% W2 are of the same length.

% encrypt(E, D, 2).

encrypt(W1,W2,W3) :- 
   length(W1,N), % if you need to know the lengths of words
   length(W3,N1),   
   append(W1,W2,W),
   append(W,W3,L),
   list_to_set(L,Letters), % remove duplicates, a predicate in list library
   [LeadLetter1|_] = W1, % identify the leading letter to be set to non-zero
   [LeadLetter2|_] = W2,
   [LeadLetter3|_] = W3,
   !. % never need to redo the above
%    Letters ins 0..9.

:- use_module(library(clpfd)).