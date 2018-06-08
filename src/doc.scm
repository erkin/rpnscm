(module rpn-doc (rpn:operator-usage)
  (import chicken scheme)
  (import rpn-colour)

  (define (list-tint op-list)
     (string-append
      (tint (car op-list) 'cyan)
      " "
      (tint (cadr op-list) 'green)))

  (define (alist-tint op-alist)
    (cons
     (car op-alist)
     (list-tint (cdr op-alist))))

  (define rpn:maths-operators
    (map alist-tint
         '((n . ("( i ->   i)" "Negation"))
           (@ . ("( i ->   i)" "Absolute value"))
           (s . ("( i ->   i)" "Signum"))
           (+ . ("(ii ->   i)" "Addition"))
           (- . ("(ii ->   i)" "Subtraction"))
           (* . ("(ii ->   i)" "Multiplication"))
           (^ . ("(ii ->   i)" "Exponentiation"))
           (/ . ("(ii ->   i)" "Integer division (quotient)"))
           (% . ("(ii ->   i)" "Integer modulo (remainder)"))
           (S . ("( n ->   i)" "Sum of entire stack"))
           (P . ("( n ->   i)" "Product of entire stack"))
           (m . ("( n ->   i)" "Discard all but minimum"))
           (M . ("( n ->   i)" "Discard all but maximum")))))

  (define rpn:stack-operators
    (map alist-tint
         '((! . ("( i -> nil)" "Pop"))
           (? . ("( i ->   i)" "Peek"))
           (: . ("( i ->  ii)" "Dup"))
           (~ . ("(ii ->  ii)" "Swap"))
           ($ . ("( n -> nil)" "Empty")))))

  (define rpn:notation
    (map list-tint
     '(("(nil ->    ):" "New value")
       ("( i  ->    ):" "Pop one")
       ("(ii  ->    ):" "Pop two")
       ("( n  ->    ):" "Pop all")
       ("(    -> nil):" "Push nothing")
       ("(    ->   i):" "Push one")
       ("(    ->  ii):" "Push two")
       ("(    ->   n):" "Map"))))

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
