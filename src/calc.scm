(module rpn (calculate operators)
  (import chicken scheme)
  (define dyadic '("+" "-" "*" "/" "expt" "modulo" "remainder" "quotient"))
  (define monadic '("abs" "floor" "ceiling" "round" "truncate"
                    "numerator" "denominator" "exp" "log" "sqrt"
                    "sin" "cos" "tan" "asin" "acon" "atan"))
  (define polyadic '("gcd" "lcm" "max" "min"))
  (define operators (list monadic dyadic polyadic))

  (define (work token stack)
    (if (null? stack)
        (begin
          (print "Error: Stack empty.")
          (exit 1)))
    (cond ((and (null? (cdr stack)) (member token dyadic))
           (print "Error: Stack too short for dyadic operations.")
           (exit 1))
          ((member token dyadic)
           (cons ((eval (string->symbol token)) (cadr stack) (car stack)) (cddr stack)))
          ((member token monadic)
           (cons ((eval (string->symbol token)) (car stack)) (cdr stack)))
          ((member token polyadic)
           (cons (apply (eval (string->symbol token)) stack) '()))
          (else
           (print "Error: Invalid operator: " token)
           (exit 2))))

  (define (calc exp stack step)
    (print step ": " exp " ⇒ " stack)
    (if (not (null? exp))
        (let ((token (string->number (car exp))))
          (if token
              (calc (cdr exp) (cons token stack) (+ 1 step))
              (calc (cdr exp) (work (car exp) stack) (+ 1 step))))
        stack))

  (define (calculate exp)
    (print "Input: " exp)
    (print "Output: " (calc exp '() 0))
    (exit)))
