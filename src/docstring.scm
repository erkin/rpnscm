(module rpn.docstring (rpn:operator-usage)
  (import chicken scheme)
  (define rpn:maths-operators
    '((n . "( i ->   i) Negation")
      (@ . "( i ->   i) Absolute value")
      (s . "( i ->   i) Signum")
      (+ . "(ii ->   i) Addition")
      (- . "(ii ->   i) Subtraction")
      (* . "(ii ->   i) Multiplication")
      (^ . "(ii ->   i) Exponentiation")
      (/ . "(ii ->   i) Integer division (quotient)")
      (% . "(ii ->   i) Integer modulo (remainder)")
      (S . "( n ->   i) Sum of entire stack")
      (P . "( n ->   i) Product of entire stack")
      (m . "( n ->   i) Discard all but minimum")
      (M . "( n ->   i) Discard all but maximum")))

  (define rpn:stack-operators
    '((! . "( i -> nil) Pop")
      (? . "( i ->   i) Peek")
      (: . "( i ->  ii) Dup")
      (~ . "(ii ->  ii) Swap")
      ($ . "( n -> nil) Empty")))

  (define rpn:notation
    '("(nil ->    ): New value"
      "( i  ->    ): Pop"
      "(ii  ->    ): Pop two"
      "( n  ->    ): Pop all"
      "(    ->   i): Push"
      "(    ->  ii): Push two"
      "(    -> nil): Push nothing"))

  (define (rpn:operator-usage)
    (define (alist-print op)
      (display (car op))
      (display ": ")
      (print (cdr op)))
    (print "Notation:")
    (for-each print rpn:notation)
    (newline)
    (print "Maths operators:")
    (for-each alist-print rpn:maths-operators)
    (newline)
    (print "Stack operators:")
    (for-each alist-print rpn:stack-operators)
    (exit)))
