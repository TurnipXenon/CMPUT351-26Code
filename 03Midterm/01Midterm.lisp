;; 4a
(defun xintersect (S1 S2 AC)
    (cond
        (
            (null S1) 
            AC
        )
        (
            (or (not (member (car S1) S2)) (member (car S1) AC))
            (xintersect (cdr S1) S2 AC)
        )
        (
            t
            (xintersect (cdr S1) S2 (cons (car S1) AC))
        )
    )
)

(defun intersect (S1 S2)
    (xintersect S1 S2 nil)
)

;; 4b
(defun max0 (L)
    (cond
        (
            (null L)
            0
        )
        (
            (atom L)
            L
        )
        (
            t
            (let
                (
                    (A (max0 (car L)))
                    (B (max0 (cdr L)))
                )
                (if
                    (> A B)
                    A
                    B
                )
            )
        )
    )
)

;; 4c
(defun 0exam (P)
    (cons (+ (car P) 2) (cdr P))
)

(defun 1exam (P)
    (* (car P) (cdr P))
)

(defun exam (L)
    (reduce '+ (mapcar '1exam (mapcar '0exam L)))
)

;; 4d
(defun swap (L)
    (if
        (null L)
        nil
        (cons (cons (cdr (car L)) (car (car L))) (swap (cdr L)))
    )
)

;; 4e
(defun swapAll (L)
    (cond
        ((null L) nil)
        ((and (atom (car L)) (atom (cdr L))) L)
        (t (swap (mapcar 'swapAll L)))
    )
)