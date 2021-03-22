%*****************************************************************************************
% Question 1
% setIntersect(+S1, +S2, -S3): set intersect S1 and S2 to get S3

setIntersect([], _, []).
setIntersect([A|L], R, [A|S]) :- isIn(A,R), !, setIntersect(L, R, S).
setIntersect([_|L], R, S) :- setIntersect(L, R, S).


% isIn(A, L): returns true is A is in L, otherwise false

isIn(_, []) :- false.
isIn(A, [A|_]) :- !, true.
isIn(A, [_|L]) :- isIn(A, L).



%*****************************************************************************************
% Question 2
% swap(+L, -R): where L is a list of elements, R is a list where the pair of elements
% are swapped, e.g. 1st and 2nd gets swapped, 3rd and 4th gets swapped, ...
% If the number of elements in L is odd, then the last elements is left as is

swap([], []).
swap([A], [A]) :- !. % prevent additional queries when odd length list
swap([A,B|L], [B,A|R]) :- swap(L, R).



%*****************************************************************************************
% Question 3
% filter(+L, +OP, +N, -L1): where L is apossible nested list of numbers; OP is one
% of the following words: equal, greaterThan, and lessThan; N is a number; and L1
% is a flat list containing all the numbers in L such that the condition specified
% by OP and N is satisfied

filter([], _, _, []).
filter([A|L], OP, N, [A|L1]) :- number(A), doOperation(OP, A, N), 
                                !, filter(L, OP, N, L1).
filter([A|L], OP, N, L1) :- number(A), !, filter(L, OP, N, L1).
filter([A|L], OP, N, L3) :- filter(A, OP, N, L1), filter(L, OP, N, L2), 
                            append(L1, L2, L3).


% doOperation(+OP, +A, +B): returns true if the prescribed operation via OP evaluates A
% and B to true, otherwise false.

doOperation(equal, A, B) :- !, A =:= B.
doOperation(greaterThan, A, B) :- !, A > B.
doOperation(lessThan, A, B) :- !, A < B.
doOperation(_, _, _) :- false.



%*****************************************************************************************
% Question 4
% countAll(+L, -N): where L is a flat list of atoms; N is a list of pairs [a,n]
% representing that atom a occurs in L n times. The pairs in N appear in an increasing order

countAll(L, N) :- xCountAll(L, L, [], N0), pairSort(N0, N).

countAll2(L, N) :- xCountAll(L, L, [], N).

% isIn(+X, +L): where X is an atom, and L is a list of pairs of atom, returns
% true if there's a pair [X, _] in L, otherwise false
isIn2(_, []) :- false.
isIn2(X, [[X,_]|_]) :- !.
isIn2(X, [_|L]) :- isIn2(X, L).


% xCountAll(+L, +Ref, +Acc, -N): where L is a flat list of atoms; Ref is a flat list of atoms;
% Acc is an accumulator of the list of pairs [a,n]; and N is a list of pairs [a,n]
% representing that atom a occurs in Ref n times. An atom in L will only be 
% counted when it is the final atom of its kind left

xCountAll([], _, Acc, Acc).
xCountAll([X|L], Ref, Acc, N) :- isIn2(X, Acc), !, xCountAll(L, Ref, Acc, N).
xCountAll([X|L], Ref, Acc, N) :- countOccurence(X, Ref, XN),
                                 append(Acc, [[X,XN]], Acc2),
                                 xCountAll(L, Ref, Acc2,  N).


% countOccurence(+X, +L, -N): where X is an atom; L is a list; and N is the number of times
% that X has appeared in L

countOccurence(_, [], 0) :- !. % needed to prevent further queries
countOccurence(X, [X|L], XN) :- !, countOccurence(X, L, XN0), XN is XN0 + 1.
countOccurence(X, [_|L], XN) :- countOccurence(X, L, XN).


% pairSort(+L, -S): where L is a list pairs [a,n]; S is a list of pairs [a,n] arranged
% in asscending order. This is based on insertion sort

pairSort([], []) :- !. % make it all stop here
pairSort(L, [Min|L1]) :- xFindMinPair(L, Min),  excludePair(Min, L, Rem), pairSort(Rem, L1).


% xFindMinPair(+L, -Min): where L is a list of pairs [a, n]; Min is the first occurence
% of the minimum n, in pairs [a, n]

xFindMinPair([], []) :- false.
xFindMinPair([A|[]], A) :- !.
xFindMinPair([A|L], MIN) :- xFindMinPair(L, CAND), getMinPair(A, CAND, MIN).


% getMinPair(+A, +B, -Min): where both A and B are [a,n] pairs, and Min is the smaller pair
% [a,n] from A and B based on their n. If both A and B are equal, Min is A. This
% gives preference to the first occurence

getMinPair([A, AN], [_, BN], [A, AN]) :- AN =< BN, !.
getMinPair(_, X, X).


% excludePair(+Ex, +L, -NL): NL is a list where the first occurence of Ex is removed
% from list L

excludePair(_, [], []) :- !. % make it all stop here
excludePair(Ex, [Ex|L], Rem) :- !, excludePair(Ex, L, Rem).
excludePair(Ex, [A|L], [A|Rem]) :- !, excludePair(Ex, L, Rem).



%*****************************************************************************************
% Question 5
% sub(+L, +S, -L1): where L is a possibly nested list of numbers; S is alist of pairs
% in the form [[x1,e1],...,[xn.en]], and L1 is the same as L except that any occurence
% of xi is replaced by ei

sub([], _, []).
sub([X|L], S, [X2|L1]) :- atomic(X), !, subReplace(X, S, X2), sub(L, S, L1).
sub([X|L], S, [L1|L2]) :- sub(X, S, L1), sub(L, S, L2).


% subReplace(+X, +S, -NX): where X is an atom; S is a list of pairs in the form 
% [[x1,e1],...,[xn,en]]; and NX could be en where X is identical with xn, otherwise,
% NX is identical to X

subReplace(X, [], X) :- !.
subReplace(X, [[X,Y]|_], Y) :- !.
subReplace(X, [_|L], Y) :- subReplace(X, L, Y).



%*****************************************************************************************
% Question 6
% clique(-L): finds all cliques in a graph defined using node(X), and edge(X,Y)

clique(L) :- findall(X, node(X), Nodes),
             subset(L, Nodes), allConnected(L).


% subset(-Subset, +Set): Subset is a subset of Set

subset([], _).
subset([X|Xs], Set) :- append(_, [X|Set1], Set), subset(Xs, Set1).


% allConnected(+L): returns true if all the nodes in L are connected to each other, 
% otherwise false

allConnected([]).
allConnected([_|[]]) :- !.
allConnected([A|L]) :- isConnectedToAll(A, L), allConnected(L).


% isConnectedToAll(Node, L): returns true if all nodes in L is connected to node Node,
% otherwise false

isConnectedToAll(_, []) :- !.
isConnectedToAll(A, [B|L]) :- isConnected(A, B), isConnectedToAll(A, L).


% isConnected(A, B): returns true if A and B is connected, otherwise false

isConnected(A, B) :- edge(A, B), !.
isConnected(A, B) :- edge(B, A).



%*****************************************************************************************
% Question 7
% convert(+Term,-Result): where Term is a list of single letters representing a string
% with the convention: e represents an empty space, and q represents a single quote;
% Result should hold the same Term except that (1) anything between two matching q's
% are not changed; (2) any e's outside of a pair of matching q's are removed;
% (3) any letter outside a pair of matching q's is changed to letter x; and 
% (4) an unmatched q will be left as is
%
% Matching q's are: any string with an odd number of occurences of q has the last occurence
% of q unmatched; all the preceding ones are mastched as: the first and second form a
% pair, the 3rd and the 4th form the next pair, and so on...

convert(Term, Result) :- findAllQ(Term, Borders), xConvert(Term, Borders, 0, Result).


% findAllQ(+Term, -Borders): where Term represents a string; and QL is a list of pairs
% [low, high] where each pair represents a matching q in Term where low is the first
% occurence of q and high is the second occurence of q

findAllQ(Term, Borders) :- xFindAllQ(Term, 0, QList), pairUp(QList, Borders).


% xFindAllQ(+Term, +Index, -QList): where Term represents a string; Index is which
% parrt of the string we start; QList is a list indices where q appears in Term starting
% from Index

xFindAllQ([], _, []).
xFindAllQ([q|L], X, [X|LX]) :- !, X1 is X + 1, xFindAllQ(L, X1, LX).
xFindAllQ([_|L], X, LX) :- X1 is X + 1, xFindAllQ(L, X1, LX).


% pairUp(+QL, -Borders): where QL is a list of atoms; and Borders is a list of pairs of atom
% where the ith odd indexed element is paired up with the ith even indexed element.
% if an element cannot be paired, it is not included in Borders

pairUp([], []) :- !.
pairUp([_|[]], []) :- !.
pairUp([A, B|L], [[A, B]|L1]) :- pairUp(L, L1).


% xConvert(+Term, +Borders, +Index, -Result): where Term represents a string; Borders is
% a list of pairs of numbers; Index is the starting index in Term; and Result
% is a string where all the characters in Term, starting from index, follows the following
% rules (1) all q remains; (2) if the current index is within any pair in Border, the
% the character is retained; (3) if an e is outside the border, they disappear; and
% (4) any other character outside the border is turned into a c

xConvert([], _, _, []).
xConvert([q|L], B, I, [q|L1]) :- !, J is I + 1, xConvert(L, B, J, L1).
xConvert([X|L], B, I, [X|L1]) :- inBorder(I, B), !, J is I + 1, xConvert(L, B, J, L1).
xConvert([e|L], B, I, L1) :- !, J is I + 1, xConvert(L, B, J, L1).
xConvert([_|L], B, I, [c|L1]) :- J is I + 1, xConvert(L, B, J, L1).


% inBorder(+Index, +Border): where Index is a number and Border is a list of pairs of numbers
% in ascending order, returns true if Index is within the range of any pair of numbers
% within border, otherwise false

inBorder(_, []) :- false.
inBorder(I, [[L, H]|_]) :- L =< I, I =< H, !.
inBorder(I, [_|B]) :- inBorder(I, B).