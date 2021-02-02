#| QUESTION 1 function xmember

The function xmember returns T if argument X is a member of the argument list Y. Otherwise, 
it's NIL. Both the argument X and the list Y may be NIL or lists containing NIL.

Test cases:
> (xmember '1 '(1)) => T
> (xmember '1 '( (1) 2 3)) => NIL
> (xmember '(1) '((1) 2 3)) => T
> (xmember nil nil) => NIL
> (xmember nil '(nil)) => T
> (xmember nil '((nil))) => NIL
> (xmember '(nil) '(1 2 3 (nil))) => T
> (xmember '(nil) '(nil)) => NIL

|#

(defun xmember (X Y)
    (cond 
        ((or (null Y) (atom Y)) nil)
        ((equal X (car Y)) t)
        (t (xmember X (cdr Y)))
    )
)




#| QUESTION 2 function flatten

The function flatten returns a list of atoms with the property that all the atoms
appearing in the argument list X also appear.
This function assumes that neither NIL and () will not appear in the given list X.

Test cases:
> (flatten '(a (b c) d)) => (a b c d)
> (flatten '((((a))))) => (a)
> (flatten '(a (b c) (d ((e)) f))) => (a b c d e f)

|#

(defun flatten (X)
    (cond
        ((null X) nil)
        (
            (atom (car X)) 
            (cons (car X) (flatten (cdr X)))
        )
        (
            t 
            (append (flatten (car X)) (flatten (cdr X)))
        )
    )
)




#| QUESTION 3 function remove-duplicate

The function remove-duplicate takes the list argument X as a list of atoms and returns 
a list with the same sequence of atoms with duplicate atoms removed.
The function evaluates whether the elements are equal using lisp's equal function.
That is, two elements are equal if both elements are structurally similar (isomorphic).

Test cases:
> (remove-duplicate '(a b c a d b)) => (c a d b)
> (remove-duplicate '((b a) b c (a b) d b)) => ((b a) c (a b) d b)
> (remove-duplicate '((b a) b c (b a) d b)) => (c (b a) d b)

|#

(defun remove-duplicate (X)
    (cond
        ((null X) nil)
        ((null (cdr X)) X)
        (
            (xmember (car X) (cdr X)) 
            (remove-duplicate (cdr X))
        )
        (
            t 
            (cons (car X) (remove-duplicate (cdr X)))
        )
    )
)




#| QUESTION 4 function mix

The function mix returns a list that mixes the elements of the list arguments L1 and L2.
It does so by choosing elements from L1 and L2 alternatingly. If one list is shorter than
the other, then append all remaining elements from the longer list at the end.

Test cases:
> (mix '(a b c) '(d e f)) => (a d b e c f)
> (mix '(1 2 3) '(a)) => (1 a 2 3)
> (mix '((a) (b c)) '(d e f g h)) => ((a) d (b c) e f g h)
> (mix '(1 2 3) nil) => (1 2 3)
> (mix '(1 2 3) '(nil)) => (1 nil 2 3)

|#

(defun mix (L1 L2)
    (cond
        ((null L1) L2)
        ((null L2) L1)
        (
            t 
            (append
                (cons (car L1) (cons(car L2) nil))
                (mix (cdr L1) (cdr L2))
            )
        )
    )
)




#| QUESTION 5 |#

#| Helper function multi-append

The function multi-appends returns a list where all elements the argument list S
has the argument E appended in them. Every element in the argument list S should
be a list or nil.

If the argument list S is empty, then we return a list which contains a list with
the argument E as the element.

This is a helper function for gen-subsets.

Test cases:
> (multi-append 'a '() => ((a))
> (multi-append 'a '(())) => ((a))
> (multi-append 'a '(() (b))) => ((a) (a b))

|#

(defun multi-append (E S)
    (cond 
        (
            (null S) 
            (cons (cons E nil) nil))
        (
            (null (car S)) 
            (multi-append E (cdr S))
        )
        (
            t 
            (cons 
                (cons E (car S))
                (multi-append E (cdr S))
            )
        )
    )
)


#| Helper function gen-subsets

The function gen-subsets returns a list of all subsets of the set union of the argument 
list L, and a list with the atom argument E as a sole element. This function produces repeated
subsets. The argument R is an accumulator and should be nil during the first call.

The function gen-subsets is a helper function for allsubsets by serving as an accumulator.

Test cases:
> (gen-subsets '(nil) nil nil) => (nil)
> (gen-subsets '(nil) 'a nil) => (nil nil (a))
> (gen-subsets '(b) 'a nil) => (nil nil (a) (b a) (b) nil (b) (a b) (a))
> (gen-subsets '(b c) 'a nil) => (nil nil (a) (b a) (b) (c a) (c b a) (c b) (c) nil (a) (c a) (c) (b a) (b c a) (b c) (b) nil (c) (b c) (b) (a c) (a b c) (a b) (a))

|#

(defun gen-subsets (L E R)
    (if (null E)
        (cons nil nil)
        (append 
            (gen-subsets (cdr L) (car L) (cons E R))
            ; I cannot put the expression below in another helper function
            ; because it uses gen-subsets. The helper function would be
            ; dependent on gen-subsets; gen-subsets would be dependent of
            ; the helper function. This explains the deep nesting below.
            (let 
                ((
                    P ; powerset
                    (let 
                        ((S (append L R)))
                        (gen-subsets (cdr S) (car S) nil) ; powerset of set without E
                    )
                ))
                (append P (multi-append E P)) ; expand powerset with E
            )
        )
    )
)


#| Helper function xset-subset

The function xset-subset returns T if set argument list X is a subset of 
argument list L. Otherwise, it returns nil.

This is a helper function for xset-equal.

Test cases:
> (xset-subset nil nil) => T
> (xset-subset nil '(a)) => T
> (xset-subset '(a) '(a)) => T
> (xset-subset '(b) '(c a)) => NIL
> (xset-subset '(a) '(b a)) => T
> (xset-subset '(a) '(c b a)) => T
> (xset-subset '(a b) '(c b a)) => T

|#

(defun xset-subset (X L)
    (cond
        ((null X) t)
        ((xmember (car X) L) (xset-subset (cdr X) L))
        (t nil)
    )
)


#| Helper function xset-equal

The function xset-equal returns T if the two subsets are equal. Otherwise, it returns nil.
Otherwise, it returns nil. Two subsets are equal if both list contains the same elements, 
even if the orders different.

This is a helper function for set-contains.

Test cases:
> (xset-equal nil nil) => T
> (xset-equal nil '(a)) => NIL
> (xset-equal '(a) '(a)) => T
> (xset-equal nil '(a)) => NIL
> (xset-equal '(a b) '(b a)) => T

|#
(defun xset-equal (X Y)
    (if (and (xset-subset X Y) (xset-subset Y X))
        t
        nil
    )
)


#| Helper function set-contains

The function set-contains returns T if argument list L contains the subset argument list X.
Otherwise, it returns nil. Two subsets are equal if both list contains the same elements, 
even if the orders different. All elements in list L is assumed to be a list or nil.

This function is a helper function for set-cleanup by determining whether a subset is
already in a given set.

Test cases:
> (set-contains nil '(nil)) => T
> (set-contains nil '((A))) => NIL
> (set-contains '(A) '((A))) => T
> (set-contains '(A B) '((B A))) => T

|#

(defun set-contains (X L)
    (cond
        ((null L) nil)
        ((xset-equal X (car L)) t)
        (t (set-contains X (cdr L)))
    )
)


#| Helper function set-cleanup

The function set-cleanup removes duplicate subsets in list X and accumulates non-duplicated
elements int list argument AC. Subsets are considered to be duplicates or equal 
if they have the same elements, and the ordering in them do not matter. 
When initially using set-cleanup, AC should be NIL.
All the elements in X are lists.

This function is a helper function for allsubsets by removing duplicate subsets
in the list returned by gen-subsets.

Test cases:
> (set-cleanup '(nil) nil) => (nil)
> (set-cleanup '((A) (A)) nil) => ((A))
> (set-cleanup '((B A) (A B)) nil) => ((A B))
> (set-cleanup '((B A C) (A B C) (C A B)) nil) => ((C A B))

|#

(defun set-cleanup (X AC)
    (if (null X)
        nil
        (if (set-contains (car X) (cdr X))
            (set-cleanup (cdr X) AC)
            (cons (car X) (set-cleanup (cdr X) AC))
        )
    )
)


#| QUESTION 5 function allsubsets

The function allsubsets returns a list of all subsets of L. No subsets are repeated.

Test cases:
> (allsubsets nil) => (nil)
> (allsubsets '(a)) => (nil (a)) 
> (allsubsets '(a b)) => (nil (b) (a b) (a))
> (allsubsets '(a b c)) => (nil (c) (b c) (b) (a c) (a b c) (a b) (a))

|#

(defun allsubsets (L)
    (set-cleanup
        (cons
            nil
            (gen-subsets (cdr L) (car L) nil) 
        )
        nil
    )
)




#| QUESTION 6 |#

#| Helper function neighbors-helper

This is a helper function for neighbors. The additional list argument AC is an
accumulator, and should be nil during first use.

|#
(defun neighbors-helper (x L AC)
    (cond
        ((null L) AC)
        ((eq x (caar L)) (neighbors-helper x (cdr L) (cons (cadar L) AC)))
        (t (neighbors-helper x (cdr L) AC))
    )
)


#| Helper function neighbors:

The function neighbors returns a list of websites, from argument list L of pair links, 
directly reachable from argument x website. This does not filter entries listed twice
or self-linking websites.

This is a helper function for reached-helper.

Test cases:
> (neighbors 'google '((google shopify) (google aircanada) (amazon aircanada))) => (AIRCANADA SHOPIFY)
> (neighbors 'google '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))) => (GOOGLE AIRCANADA SHOPIFY) 
> (neighbors 'google '((google shopify) (shopify amazon) (amazon indigo))) => (SHOPIFY)

|#

(defun neighbors (x L)
    (neighbors-helper x L nil)
)


#| Helper function node-filter

The function returns a list of elements in the argument list L that is not already in
the argument list F.

This is a helper function for reached-helper.

Test cases:
> (node-filter '(a b c d e f) '(a c)) => (b d e f)
> (node-filter '(a b c d e f a) '(a c)) => (b d e f)

|#

(defun node-filter (L F)
    (cond
        ((null L) nil)
        ((xmember (car L) F) (node-filter (cdr L) F))
        (t (cons (car L) (node-filter (cdr L) F)))
    )
)


#| Helper function reached-helper

This is a helper function for reached. The additional argument V is an accumulator
which is a list of all websites already visited. The additional argument Q is an
accumulator which is a list of all websites that are reachable by previously visited
websites. Take note that we filter argument list Q using node-filter to prevent
visiting websites we already visited.

|#

(defun reached-helper (x L V Q)
    (if (null Q)
        V
        (reached-helper 
            (car Q) ; pop the queue
            L
            (cons (car Q) V) ; put the top of the queue to visited
            (node-filter (append (cdr Q) (neighbors x L)) V) ; remove all visited nodes
        )
    )
)


#| Helper function remove-element

The function returns a list with all the elements in the argument list L, without
the atomic element x.

Test cases:
> (remove-element 'a '(a b a c)) => (b c)

|#

(defun remove-element (x L)
    (cond
        ((null L) nil)
        ((eq (car L) x) (remove-element x (cdr L)))
        (t (cons (car L) (remove-element x (cdr L))))
    )
)


#| QUESTION 6 function reached

The function returns a list of atoms naming all websites raechable from argument x website
based on the argument list L which is a list of pairs representing linkage.

Test cases:
> (reached 'google '((google shopify) (google aircanada) (amazon aircanada))) => (AIRCANADA SHOPIFY)
> (reached 'google '((google shopify) (shopify amazon) (amazon google))) => (AMAZON SHOPIFY)
> (reached 'google '((google shopify) (shopify amazon) (amazon indigo))) => (INDIGO AMAZON SHOPIFY)
> (reached 'google '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))) => (DELTA SHOPIFY AIRCANADA)

|#

(defun reached (x L)
    (remove-element X
        (remove-duplicate 
            (reached-helper x L nil (cons x nil))
        )
    )
)


#| Helper function linkers-helper

This is a helper function for linkers. It uses an accumulator AC, additionally. AC should be
nil when initially used. This function also returns duplicates, unlike linkers.

Test cases:
> (linkers-helper 'aircanada '((google shopify) (aircanada aircanada)) nil) => NIL
> (linkers-helper 'aircanada '((google shopify) (google aircanada) (amazon aircanada) (google aircanada)) nil) => (GOOGLE AMAZON GOOGLE)

|#

(defun linkers-helper (x L AC)
    (cond
        ((null L) AC)
        (
            (and (not (eq x (caar L))) (eq x (cadar L)))
            (linkers-helper x (cdr L) (cons (caar L) AC))
        )
        (t (linkers-helper x (cdr L) AC))
    )
)


#| Helper function linkers

The function linkers returns a list of atoms naming the webpages in pair elements of the 
argument list L which have a direct link to the argument x webpage.

This is a helper function for rank-individually.

Test cases:
> (linkers 'aircanada '((google shopify) (aircanada aircanada))) => NIL
> (linkers 'aircanada '((google shopify) (google aircanada) (amazon aircanada) (google aircanada))) => (AMAZON GOOGLE)

|#

(defun linkers (x L)
    (remove-duplicate (linkers-helper x L nil))
)


#| Helper function count-elements

The function count-elements returns a numerical value representing the count of elements
in the argument list L.

This is a helper function for rank-individually.

Test cases:
> (count-elements '()) => 0
> (count-elements '(A B C)) => 3

|#

(defun count-elements (L)
    (if (null L)
        0
        (+ 1 (count-elements (cdr L)))
    )
)


#| Helper function rank-individually

The function rank-individually returns a list representing (A B), where A is the argument x,
and B is the count of all references for A in the argument list L, which is a list of pairs
representing linkage. References to the page are not counted if it references itself, 
and duplicate references are ignored.

This is a helper function for rank-helper.

Test cases:
> (rank-individually 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
> (rank-individually 'shopify '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
> (rank-individually 'amazon '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
> (rank-individually 'aircanada '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
> (rank-individually 'delta '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))

|#
(defun rank-individually (x L)
    (cons x (cons (count-elements (linkers x L)) nil))
)


#| Helper function rank-helper

The function rank-helper returns a list of element pairs (X Y) that maps to each element in the 
list argument S. X is the element in the argument list S, and Y is the count of references
to the page based the argument list L, which contains pairs representing linkage. 
References to the page are not counted if it references itself, and duplicate
references are ignored.

This is a helper function for rank.

Test cases:
> (rank-helper '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada))) => ((GOOGLE 0) (SHOPIFY 1) (AIRCANADA 2) (AMAZON 0))
> (rank-helper '(google shopify amazon) '((google shopify) (shopify amazon) (amazon google))) => ((GOOGLE 1) (SHOPIFY 1) (AMAZON 1))
> (rank-helper '(google shopify amazon indigo) '((google shopify) (shopify amazon) (amazon indigo))) => ((GOOGLE 0) (SHOPIFY 1) (AMAZON 1) (INDIGO 1))
> (rank-helper '(google shopify aircanada amazon delta) '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))) => ((GOOGLE 0) (SHOPIFY 1) (AIRCANADA 2) (AMAZON 0) (DELTA 1))

|#
(defun rank-helper (S L)
    (if (null S)
        nil
        (cons (rank-individually (car S) L) (rank-helper (cdr S) L))
    )
)


#| Helper function rank-greater-than

The function rank-greater returns T if the second element of the argument list L1 is less
than the second element of the argument list L2. Otherwise, it returns nil.

This is used by rank-sorter as an argument.

Test cases:
> (rank-greater-than '(a 0) '(b 1)) => NIL
> (rank-greater-than '(a 1) '(b 0)) => T

|#

(defun rank-greater-than (L1 L2)
    (> (cadr L1) (cadr L2))
)

#| Helper function rank-sorter

The function rank-sorter sorts the elements in L based on the numerical value of their
second element.

This is a helper function for rank.

Test cases:
> (rank-sorter '()) => NIL
> (rank-sorter '((C 1) (B 0) (A 2))) => ((A 2) (C 1) (B 0))

|#

(defun rank-sorter (L)
    (sort L 'rank-greater-than)
)


#| Helper function rank-flattener

The function rank-flattener returns a list of the first element in each list element within
the argument list L. It is assumed that each element in L has at least one element.

This is a helper function for rank.

Test cases:
> (rank-flattener ((aircanada 2) (shopify 1) (google 0) (amazon 0))) => (aircanada shopify google amazon)
> (rank-flattener ((google 1) (shopify 1) (amazon 1))) => (google shopify amazon)
> (rank-flattener ((shopify 1) (amazon 1) (indigo 1) (google 0))) => (shopify amazon indigo google)
> (rank-flattener ((aircanada 2) (shopify 1) (delta 1) (google 0) (amazon 0))) => (aircanada shopify delta google amazon)

|#

(defun rank-flattener (L)
    (if (null L)
        nil
        (cons (caar L) (rank-flattener (cdr L)))
    )
)


#| QUESTION 6 function rank

The function rank returns a list of atoms naming pages that are in S,
which are arranged according based on how many pages refer to them, based on argument list L
containing pairs representing linkage.

Test cases:
> (rank '(google shopify aircanada amazon) '((google shopify) (google aircanada) (amazon aircanada))) => (AIRCANADA SHOPIFY GOOGLE AMAZON)
> (rank '(google shopify amazon) '((google shopify) (shopify amazon) (amazon google))) => (GOOGLE SHOPIFY AMAZON)
> (rank '(google shopify amazon indigo) '((google shopify) (shopify amazon) (amazon indigo))) => (SHOPIFY AMAZON INDIGO GOOGLE)
> (rank '(google shopify aircanada amazon delta) '((google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google))) => (AIRCANADA SHOPIFY DELTA GOOGLE AMAZON)

|#

(defun rank (S L)
    (rank-flattener (rank-sorter (rank-helper S L)))
)