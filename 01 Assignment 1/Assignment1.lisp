#| QUESTION 1

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

#| QUESTION 1 function xmember |#
(defun xmember (X Y)
    (cond 
        ((or (null Y) (atom Y)) nil)
        ((equal X (car Y)) t)
        (t (xmember X (cdr Y)))
    )
)




#| QUESTION 2

The function flatten returns a list of atoms with the property that all the atoms
appearing in the argument list X also appear.
This function assumes that neither NIL and () will not appear in the given list X.

Test cases:
> (flatten '(a (b c) d)) => (a b c d)
> (flatten '((((a))))) => (a)
> (flatten '(a (b c) (d ((e)) f))) => (a b c d e f)

|#

#| QUESTION 2 function flatten |#
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




#| QUESTION 3

The function remove-duplicate takes the list argument X as a list of atoms and returns 
a list with the same sequence of atoms with duplicate atoms removed.
The function evaluates whether the elements are equal using lisp's equal function.
That is, two elements are equal if both elements are structurally similar (isomorphic).

Test cases:
> (remove-duplicate '(a b c a d b)) => (c a d b)
> (remove-duplicate '((b a) b c (a b) d b)) => ((b a) c (a b) d b)
> (remove-duplicate '((b a) b c (b a) d b)) => (c (b a) d b)

|#

#| QUESTION 3 function remove-duplicate |#
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




#| QUESTION 4

The function mix returns a list that mixes the elements of the list arguments L1 and L2.
It does so by choosing elements from L1 and L2 alternatingly. If one list is shorter than
the other, then append all remaining elements from the longer list at the end.

Test cases:
> (mix '(a b c) '(d e f)) => (a b c d e f)
> (mix '(1 2 3) '(a)) => (1 a 2 3)
> (mix '((a) (b c)) '(d e f g h)) => ((a) d (b c) e f g h)
> (mix '(1 2 3) nil) => (1 2 3)
> (mix '(1 2 3) '(nil)) => (1 nil 2 3)

|#

#| QUESTION 4 function mix |#
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




#| QUESTION 5

The function allsubsets returns a list of all subsets of L. No subsets are repeated.

Test cases:
> (allsubsets nil) => (nil)
> (allsubsets '(a)) => (nil (a)) 
> (allsubsets '(a b)) => (nil (b) (a b) (a))
> (allsubsets '(a b c)) => (nil (c) (b c) (b) (a c) (a b c) (a b) (a))

|#

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
                    P 
                    (let 
                        ((S (append L R)))
                        (gen-subsets (cdr S) (car S) nil)
                    )
                ))
                (append P (multi-append E P))
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


#| QUESTION 5 function allsubsets |#

(defun allsubsets (L)
    (set-cleanup
        (cons
            nil
            (gen-subsets (cdr L) (car L) nil) 
        )
        nil
    )
)




#| QUESTION 6

The function mix returns a list that mixes the elements of the list arguments L1 and L2.
It does so by choosing elements from L1 and L2 alternatingly. If one list is shorter than
the other, then append all remaining elements from the longer list at the end.

Test cases:
> (mix '(a b c) '(d e f)) => (a b c d e f)
> (mix '(1 2 3) '(a)) => (1 a 2 3)
> (mix '((a) (b c)) '(d e f g h)) => ((a) d (b c) e f g h)
> (mix '(1 2 3) nil) => (1 2 3)
> (mix '(1 2 3) '(nil)) => (1 nil 2 3)

|#

#| QUESTION 6 function mix |#
;QUESTION 6
;todo: documentation
;graph: ()
;strategy: get all websites
;check if reachable

;assume ((x y)) structure
(defun neighbors-helper (x L AC)
    (if (null L)
        AC
        (if (eq x (caar L))
            (neighbors-helper x (cdr L) (cons (cadar L) AC))
            (neighbors-helper x (cdr L) AC)
        )
    )
)

(defun neighbors (x L)
    (neighbors-helper x L nil)
)
;(neighbors 'google '( (google shopify) (google aircanada) (amazon aircanada)))
;(neighbors 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) )) 
;(neighbors 'google '( (google shopify) (shopify amazon) (amazon indigo)  ))

(defun node-union (L R)
    (append L R)
)

(defun node-filter-helper (L F AC)
    (if (null L)
        AC
        (if (xmember (car L) F)
            (node-filter-helper (cdr L) F AC)
            (node-filter-helper (cdr L) F (cons (car L) AC))
        )
    )
)

(defun node-filter (L F)
    (node-filter-helper L F nil)
)

(defun reached-helper (x L V Q)
    (if (or (null Q) nil)
        V
        ; get all neighbors
        (reached-helper (car Q)
            L
            (cons (car Q) V)
            (node-filter (cons (car Q) (neighbors x L)) V)
        )
    )
)

(defun reached (x L)
    (remove-duplicate (reached-helper x L nil (cons x nil)))
)
; (reached 'google '( (google shopify) (google aircanada) (amazon aircanada)))


(defun linkers-helper (x L AC)
    (if (null L)
        AC
        (if (and (not (eq x (caar L))) (eq x (cadar L)))
            (linkers-helper x (cdr L) (cons (caar L) AC))
            (linkers-helper x (cdr L) AC)
        )
    )
)

(defun linkers (x L)
    (remove-duplicate (linkers-helper x L nil))
)
;; (linkers 'aircanada '( (google shopify) (google aircanada) (amazon aircanada) (google aircanada)))

(defun count-elements (L)
    (if (null L)
        0
        (+ 1 (count-elements (cdr L)))
    )
)

(defun rank-individually (x L)
    (cons x (cons (count-elements (linkers x L)) nil))
)
;; (rank-individually 'google '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
;; (rank-individually 'shopify '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
;; (rank-individually 'amazon '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
;; (rank-individually 'aircanada '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))
;; (rank-individually 'delta '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))

(defun rank-helper (S L)
    (if (null S)
        nil
        (cons (rank-individually (car S) L) (rank-helper (cdr S) L))
    )
)

(defun rank-sorter (L)
    (sort L 'rank-greater-than)
)

(defun rank-greater-than (L1 L2)
    (> (cadr L1) (cadr L2))
)

(defun rank-flattener (L)
    (if (null L)
        nil
        (cons (caar L) (rank-flattener (cdr L)))
    )
)
;; (rank-flattener '((a 0) (b 2) (c 3)))

(defun rank (S L)
    (rank-flattener (rank-sorter (rank-helper S L)))
)
;; (rank '(google spotify aircanada ualberta delta) '( (google shopify) (google aircanada) (amazon aircanada) (aircanada delta) (google google) ))