(set 'pt1 '(fl-interp '(+ 10 5) nil)) ; > '15
(set 'pt2 '(fl-interp '(- 12 8) nil)) ; > '4
(set 'pt3 '(fl-interp '(* 5 9) nil)) ; > 45
(set 'pt4 '(fl-interp '(> 2 3) nil)) ; > 'nil
(set 'pt5 '(fl-interp '(< 1 131) nil)) ; > 't
(set 'pt6 '(fl-interp '(= 88 88) nil)) ; > 't
(set 'pt7 '(fl-interp '(and false true) nil)) ; > 'nil
(set 'pt8 '(fl-interp '(or true false) nil)) ; >'t
(set 'pt9 '(fl-interp '(not true) nil)) ; > 'nil
(set 'pt10 '(fl-interp '(number 354) nil)) ; > 't
(set 'pt11 '(fl-interp '(equal (3 4 1) (3 4 1)) nil)) ; >'t
(set 'pt12 '(fl-interp '(if false 2 3) nil)) ; >'3
(set 'pt13 '(fl-interp '(null ()) nil)) ; >'t
(set 'pt14 '(fl-interp '(atom (3)) nil)) ; >'nil
(set 'pt15 '(fl-interp '(eq x x) nil)) ; > 't
(set 'pt16 '(fl-interp '(first (8 5 16)) nil)) ; > '8
(set 'pt17 '(fl-interp '(rest (8 5 16)) nil)) ; > '(5 16)
(set 'pt18 '(fl-interp '(cons 6 3) nil)) ; >'(6 . 3)
(set 'pt19 '(fl-interp '(+ (* 2 2) (* 2 (- (+ 2 (+ 1 (- 7 4))) 2))) nil)) ; > '12
(set 'pt20 '(fl-interp '(and (> (+ 3 2) (- 4 2)) (or (< 3 (* 2 2))) (not (= 3 2))) nil)) ; > 't
(set 'pt21 '(fl-interp '(or (= 5 (- 4 2)) (and (not (> 2 2)) (< 3 2))) nil)) ; > 'nil
(set 'pt22 '(fl-interp '(if (not (null (first (a c e)))) (if (number (first (a c e))) (first (a c e)) (cons (a c e) d)) (rest (a c e))) nil)) ; >' ((a c e) . d)

; Test find-fun
(set 'fft1 '(find-fun '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > t
(set 'fft2 '(find-fun '(greater 3 5) '((lesser (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > nil
(set 'fft3 '(find-fun '(greater 3 5) '((greater (x y z) = (if (> x y) x (if (< x y) y nil)))))) ; > nil

; Test count-elements
(set 'cet1 '(count-elements nil)) ; > 0
(set 'cet2 '(count-elements '((a)))) ; > 1
(set 'cet3 '(count-elements '(() a))) ; > 2

;
(set 'rt1 '(replace0 '(X Y) '(3 5) 'X)) ; > (if (> 3 Y) 3 (if (< 3 Y) Y nil))

; FL-Sub test
(set 'fst1 '(fl-sub '(X Y) '(3 5) '(if (> x y) x (if (< x y) y nil)))) ; > (if (> 3 5) 3 (if (< 3 5) 5 nil))


; (greater (x y) = (if (> x y) x (if (< x y) y nil)))
; User-defined basic = 4
(set 'ut1 '(fl-interp '(greater 3 5) '((greater (x y) = (if (> x y) x (if (< x y) y nil)))))) ; > '5
(set 'ut2 '(fl-interp '(square 4) '((square (x) = (* x x))))) ; > '16
(set 'ut3 '(fl-interp '(simpleinterest 4 2 5) '((simpleinterest (x y z) = (* x (* y z)))))) ; > '40
(set 'ut4 '(fl-interp '(xor t nil) '((xor (x y) = (if (equal x y) nil t))))) ; > 't
(set 'ut5 '(fl-interp '(cadr (5 1 2 7)) '((cadr(x) = (first (rest x)))))) ; > '1

; More complex = 6 total
(set 'ut6 '(fl-interp '(last (s u p)) '((last(x) = (if (null (rest x)) (first x) (last (rest x))))))) ; > 'p
(set 'ut7 '(fl-interp '(push (1 2 3) 4) '((push (x y) = (if (null x) (cons y nil) (cons (first x) (push (rest x) y))))))) ; > '(1 2 3 4)
(set 'ut8 '(fl-interp '(pop (1 2 3)) '((pop(x) = (if (atom (rest (rest x))) (cons (first x) nil) (cons (first x)(pop (rest x)))))))) ; > '(1 2)
(set 'ut9 '(fl-interp '(power 4 2) '((power(x y) = (if (= y 1) x (power (* x x) (- y 1))))))) ; > '16
(set 'ut10 '(fl-interp '(factorial 4) '((factorial(x) = (if (= x 1) 1 (* x (factorial (- x 1)))))))) ; > '24
(set 'ut11 '(fl-interp '(divide 24 4) '((divide (x y) = (div x y 0)) (div (x y z) = (if (> (* y z) x) (- z 1) (div x y (+ z 1))))))) ; > '6
(set 'ut12 '(fl-interp '(divide 24 4) '((divide (x y) = (divine x y 0)) (div (x y z) = (if (> (* y z) x) (- z 1) (div x y (+ z 1))))))) ; > 'divine 24 0

; self testing
(set 'st1 '(fl-interp '(f0 1 2) '((f0 () = 0) (f0 (A) = 1) (f0 (A B) = 2) (f0 (A B C) = 3))))
(set 'st2 '(fl-interp '(f0) '((f0 () = 0) (f0 (A) = 1) (f0 (A B) = 2) (f0 (A B C) = 3))))