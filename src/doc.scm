(module rpn-doc (rpn:operator-usage rpn:help-messages)
  (import chicken scheme)
  (require-extension (only srfi-13 string-pad-right))
  (require-extension (only srfi-1 zip))
  (use (only data-structures compose))
  (import rpn-colour)

  (define (list-tint op-list)
    (string-append
     (tint (car op-list) 'cyan)
     " "
     (tint (cadr op-list) 'green)))

  (define (alist-tint op-alist)
    (cons
     (tint (car op-alist) 'purple)
     (list-tint (cdr op-alist))))

  (define (list-pad-by-max s-lst) ; surely there's a better way to do this
    (define car-max  (add1 (apply max (map (compose string-length car)  s-lst))))
    (define cadr-max (add1 (apply max (map (compose string-length cadr) s-lst))))
    (zip (map (lambda (s) (string-pad-right (car s)  car-max))  s-lst)
         (map (lambda (s) (string-pad-right (cadr s) cadr-max)) s-lst)))

  (define rpn:help-messages
    (map list-tint
         (list-pad-by-max
          '(("-h, -?, --help" "Print this help message")
            ("-V, --version" "Display version and licence information")
            ("-o, --operators" "Print a formatted list of operators")
            ("-e, --eval EXPRESSION" "Evaluate EXPRESSION")
            ("-i, --interactive" "Start interactive mode")
            ("-f, --file FILE" "Load expression from file")
            ("-s, --shunt EXPRESSION" "Convert infix EXPRESSION to RPN")
            ("-v, --verbose" "Explain each step")))))

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
         '(("(nil ->    )" "New value")
           ("( i  ->    )" "Pop one")
           ("(ii  ->    )" "Pop two")
           ("( n  ->    )" "Pop all")
           ("(    -> nil)" "Discard")
           ("(    ->   i)" "Push one")
           ("(    ->  ii)" "Push two")
           ("(    ->   n)" "Sweep"))))

  (define (rpn:operator-usage #!optional arg)
    (define (alist-print op)
      (print* (car op))
      (print* ": ")
      (print (cdr op)))
    (print "Notation:")
    (for-each print rpn:notation)
    (newline)
    (print "Mathematical operators:")
    (for-each alist-print rpn:maths-operators)
    (newline)
    (print "Stack operators:")
    (for-each alist-print rpn:stack-operators)
    (exit)))
