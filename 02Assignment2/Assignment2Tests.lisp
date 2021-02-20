(set 'pt1 '(fl-interp '(+ 10 5) nil)) ; > '15
(set 'pt2 '(fl-interp '(- 12 8) nil)) ; > '4
(set 'pt3 '(fl-interp '(* 5 9) nil))
(set 'pt4 '(fl-interp '(> 2 3) nil))
(set 'pt5 '(fl-interp '(< 1 131) nil))
(set 'pt6 '(fl-interp '(= 88 88) nil))
(set 'pt7 '(fl-interp '(and false true) nil))
(set 'pt8 '(fl-interp '(or true false) nil))
(set 'pt9 '(fl-interp '(not true) nil))
(set 'pt10 '(fl-interp '(number 354) nil))
(set 'pt11 '(fl-interp '(equal (3 4 1) (3 4 1)) nil))
(set 'pt12 '(fl-interp '(if false 2 3) nil))
(set 'pt13 '(fl-interp '(null ()) nil))
(set 'pt14 '(fl-interp '(atom (3)) nil))
(set 'pt15 '(fl-interp '(eq x x) nil))
(set 'pt16 '(fl-interp '(first (8 5 16)) nil))
(set 'pt17 '(fl-interp '(rest (8 5 16)) nil))
(set 'pt18 '(fl-interp '(cons 6 3) nil))
(set 'pt19 '(fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil))
(set 'pt20 '(fl-interp '(and (> (+ 3 2) (- 4 2)) (or (< 3 (* 2 2))) (not (= 3 2))) nil))
(set 'pt21 '(fl-interp '(or (= 5 (- 4 2)) (and (not (> 2 2)) (< 3 2))) nil))
(set 'pt22 '(fl-interp '(if (not (null (first (a c e)))) (if (number (first (a c e))) (first (a c e)) (cons (a c e) d)) (rest (a c e))) nil))

; Test find-fun
(set 'fft1 '(find-fun '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > t
(set 'fft2 '(find-fun '(greater 3 5) '((lesser (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > nil
(set 'fft3 '(find-fun '(greater 3 5) '((greater (x y z) = (if (> x y) x (if (< x y) y nil)))))) ; > nil

; Test count-elements
(set 'cet1 '(count-elements nil)) ; > 0
(set 'cet2 '(count-elements '((a)))) ; > 1
(set 'cet3 '(count-elements '(() a))) ; > 2

;
;; (set 'rt1 '(replace0 'X 3 '(if (> x y) x (if (< x y) y nil)))) ; > (if (> 3 Y) 3 (if (< 3 Y) Y nil))

; FL-Sub test
(set 'fst1 '(fl-sub '(X Y) '(3 5) '(if (> x y) x (if (< x y) y nil)))) ; > (if (> 3 5) 3 (if (< 3 5) 5 nil))


; (greater (x y) = (if (> x y) x (if (< x y) y nil)))
; User-defined
(set 'ut1 '(fl-interp '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > '5

;; (lambda (x) (if (> x y) x (if (< x y) y nil)))
;; (lambda (y) (lambda (x) (if (> x y) x (if (< x y) y nil))))
;; (((lambda (x) (lambda (y) (if (> x y) x (if (< x y) y nil)))) 3) 5)
;; (((lambda (x)
;;     (lambda (y) (if (< x y) x y))
;; )5)6)

;; ((
;;     lambda (x)
;;     (lambda (y) (if (< x y) x y))
;; ) 5 6)

;; (funcall
;;     (funcall
;;         (function
;;             (lambda (x)
;;                 (function 
;;                     (lambda (y)
;;                         (if (< x y) x y)
;;                     )
;;                 )
;;             )
;;         )
;;     4)
;; 9)