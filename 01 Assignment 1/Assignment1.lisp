;QUESTION 1
;todo: documentation
(defun xmember (X Y)
    (if (or (null Y) (atom Y))
        nil
        (or (or (equal X (car Y))
                (xmember X (car Y))
            )
            (xmember X (cdr Y))
        )
    )
)

;; (xmember '1 '(1))
;; T
;; >(xmember '1 '( (1) 2 3))
;; NIL
;; >(xmember '(1) '((1) 2 3))
;; T
;; (xmember nil nil)
;; NIL
;; (xmember nil '(nil))
;; T
;; (xmember nil '((nil)))
;; NIL
;; (xmember '(nil) '(1 2 3 (nil)))
;; T
(xmember '(nil) '(nil))

;QUESTION 2
;todo: documentation
(defun flatten (X)
    (cond
        ((null X) nil)
        ((atom (car X)) 
                (cons (car X)
                    (flatten (cdr X))))
        (t
            (append
                (flatten (car X))
                (flatten (cdr X))
            )
        )
    )
)

;; (flatten '(a (b c) d))
;; (flatten '((((a)))))
;; (flatten '(a (b c) (d ((e)) f)))

;QUESTION 3
;todo: documentation
(defun remove-duplicate (X)
    (cond
        ((null X) nil)
        ((null (cdr X)) X)
        ((xmember (car X) (cdr X)) (remove-duplicate (cdr X)))
        (t (cons (car X) (remove-duplicate (cdr X))))
    )
)

;QUESTION 4
;todo: documentation
(defun mix (L1 L2)
    (cond
        ((null L1) L2)
        ((null L2) L1)
        (t (append
                (cons (car L1) (cons(car L2) nil))
                (mix (cdr L1) (cdr L2))
            )
        )
    )
)

;QUESTION 5
;todo: documentation
(defun multi-append (E S)
    (cond ((null S) (cons (cons E nil) nil))
        ((null (car S)) (multi-append E (cdr S)))
        (t (cons (cons E (car S))
            (multi-append E (cdr S))))
    )
)

(defun set-equal (X Y)
    t
)

(defun set-member (X Y)
    (if (or (null Y) (atom Y))
        nil
        (or (or (set-equal X (car Y))
                (set-member X (car Y))
            )
            (set-member X (cdr Y))
        )
    )
)

(defun set-cleanup (X)
    X
    ;; (cond
    ;;     ((null X) nil)
    ;;     ((null (cdr X)) X)
    ;;     ((set-member (car X) (cdr X)) (set-cleanup (cdr X)))
    ;;     (t (cons (car X) (set-cleanup (cdr X))))
    ;; )
)

(defun set-union (L R)
    (remove-duplicate (append L R))
)

(defun gen-subsets (L E R AC)
    (if
        (null E)
        nil
        (set-union AC (set-union
            (gen-subsets (cdr L) (car L) (cons E R) AC)
            (let ((P (allsubsets (append L R)))) (set-union
                P
                (multi-append E P)
            ))
        ))
    )
)

(defun allsubsets (L)
    (gen-subsets (cdr L) (car L) nil (cons nil nil))
)

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