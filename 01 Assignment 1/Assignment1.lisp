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
(defun reachable (from to L visited DC)
    (cond
        
        (t nil)
    )
)

(defun reached-helper (x L DC)
    (cond ((null DC) nil)
        ((reachable x (cadar DC) L) (cons (cadar DC) (reached-helper x L (cdr DC))))
        (t (reached-helper x L (cdr DC))))
)

(defun reached (x L)
    (remove-duplicate (reached-helper x L L))
)
; (reached 'google '( (google shopify) (google aircanada) (amazon aircanada)))