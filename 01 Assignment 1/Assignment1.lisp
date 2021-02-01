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
<<<<<<< HEAD
> (allsubsets '(a b)) => (nil (b) (a b) (a))
> (allsubsets '(a b c)) => (nil (c) (b c) (b) (a c) (a b c) (a b) (a))
=======
> (allsubsets '(a b)) => (nil (a) (b) (a b))
>>>>>>> 3235b509ecc932fa8b7e6a12af75c730c86df586

|#

(defun multi-append (E S)
    (cond ((null S) (cons (cons E nil) nil))
        ((null (car S)) (multi-append E (cdr S)))
        (t (cons (cons E (car S))
            (multi-append E (cdr S))))
    )
)



(defun xset-member (X L)
    (cond
        ((null L) nil)
        ((equal X (car L)) t)
        (t (xset-member X (cdr L)))
    )
)

(defun xset-subset (X L)
    (cond
        ((null X) t)
        ((xset-member (car X) L) (xset-subset (cdr X) L))
        (t nil)
    )
)

(defun xset-equal (X Y)
    (if (and (xset-subset X Y) (xset-subset Y X))
        t
        nil
    )
)

(defun set-contains (X L)
    (cond
        ((null L) nil)
        ((xset-equal X (car L)) t)
        (t (set-contains X (cdr L)))
    )
)


#| Helper function gen-subsets

The function gen-subsets returns a list of all subsets of the set union of the argument 
list L, and a list with the atom E as a sole element.

The function gen-subsets is a helper function for allsubsets by serving as an accumulator.

Test cases:
> 

|#

(defun gen-subsets (L E R AC)
<<<<<<< HEAD
    (if (null E)
        (cons nil nil)
        (append 
            AC ; retains nil in the
            (gen-subsets (cdr L) (car L) (cons E R) nil)
            (let 
                ((P (allsubsets (append L R)))) 
                (append P (multi-append E P))
            )
        )
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
> (set-cleanup '(nil) nil) => (NIL)
> (set-cleanup '((A) (A)) nil) => ((A))
> (set-cleanup '((B A) (A B)) nil) => ((A B))
> (set-cleanup '((B A C) (A B C) (C A B)) nil) => ((C A B))

|#

(defun set-cleanup (X AC)
    (cond 
        ((null X) nil)
        (
            (set-contains (car X) (cdr X))
            (set-cleanup (cdr X) AC)
        )
        (
            t
            (cons (car X) (set-cleanup (cdr X) AC))
        )
=======
    (if
        (null E)
        nil
        (append AC (append
            (gen-subsets (cdr L) (car L) (cons E R) AC)
            (let ((P (allsubsets (append L R)))) (append
                P
                (multi-append E P)
            ))
        ))
>>>>>>> 3235b509ecc932fa8b7e6a12af75c730c86df586
    )
)


<<<<<<< HEAD
#| QUESTION 5 function allsubsets |#
(defun allsubsets (L)
    (set-cleanup 
        (gen-subsets (cdr L) (car L) nil (cons nil nil)) 
        nil
    )
=======
#| Helper function set-cleanup

The function set-cleanup removes duplicate subsets in list X and accumulates non-duplicated
elements int list argument AC. Subsets are considered to be duplicates or equal 
if they have the same elements, and the ordering in them do not matter. 
When initially using set-cleanup, AC should be NIL.
All the elements in X are lists.

Test cases:
(set-cleanup '(nil) nil) => (NIL)
(set-cleanup '((A) (A)) nil) => ((A))
(set-cleanup '((B A) (A B)) nil) => ((A B))
(set-cleanup '((B A C) (A B C) (C A B)) nil) => ((C A B))

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
    (set-cleanup (gen-subsets (cdr L) (car L) nil (cons nil nil)) nil)
>>>>>>> 3235b509ecc932fa8b7e6a12af75c730c86df586
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