(module rpn-op (rpn-eval operators)
  (import chicken scheme)

  (define monadic '((~ . neg) (a . abs)))
  (define dyadic '((+ . +) (- . -) (* . *) (/ . quotient)
                   (^ . expt) (% . remainder)))
  (define polyadic '((m . min) (M . max)))
  (define operators (append monadic dyadic polyadic))

  (define (err message code)
    (print "Error: " message)
    (exit code))

  (define (neg token)
    (- token))

  (define (monad-op token stack)
    (cons
     ((eval (cdr (assoc token monadic))) (car stack))
     (cdr stack)))

  (define (dyad-op token stack)
    (cons
     ((eval (cdr (assoc token dyadic))) (car stack) (cadr stack))
     (cddr stack)))

  (define (polyad-op token stack)
    (list
     (apply (eval (cdr (assoc token polyadic))) stack)))

  (define (rpn-eval token stack)
    (cond
     ((integer? token)
      `(,@stack ,token))
     ((null? stack)
      (err "Stack empty." 1))
     ((assoc token monadic)
      (monad-op token stack))
     ((assoc token polyadic)
      (polyad-op token stack))
     ((null? (cdr stack))
      (err "Stack too short." 1))
     ((assoc token dyadic)
      (dyad-op token stack)))))
