(module rpn (calculate operators)
  (import chicken scheme)
  (define operators '((+ . +) (- . -) (* . *) (/ . quotient)
                   (^ . expt) (% . remainder)))

  (define (err message code)
    (print "Error: " message)
    (exit code))
  
  (define (work token stack)
    (if (null? stack)
        (err "Stack empty." 1))
    (let ((operator (assoc token operators)))
      (if operator
          (if (null? (cdr stack))
              (err "Stack too short." 1)
              (cons ((eval (cdr operator)) (cadr stack) (car stack)) (cddr stack)))
          (err "Invalid token." 2))))

  (define (calc exp stack step)
    (print step ": " exp " ⇒ " stack)
    (if (not (null? exp))
        (let ((token (string->number (car exp))))
          (if token
              (if (integer? token)
                  (calc (cdr exp) (cons token stack) (+ 1 step))
                  (err "Value not an integer." 3))
              (calc (cdr exp) (work (string->symbol (car exp)) stack) (+ 1 step))))
        stack))

  (define (calculate exp)
    (print "Input: " exp)
    (print "Output: " (calc exp '() 0))
    (exit)))
