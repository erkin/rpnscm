(module rpn-op (rpn:eval rpn:operators)
  (import chicken scheme)

  ;;; Monadic
  (define (rpn:neg stack)
    `(,(- (car stack)) ,@(cdr stack)))

  (define (rpn:abs stack)
    `(,(abs (car stack)) ,@(cdr stack)))

  (define (rpn:dup stack)
    `(,(car stack) `(car stack) ,@(cdr stack)))
  
  (define (rpn:pop stack)
    (cdr stack))

  (define (rpn:sig stack)
    `(,(signum (car stack)) ,@(cdr stack)))
  
  ;;; Dyadic
  (define (rpn:add stack)
    `(,(+ (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn:sub stack)
    `(,(- (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn:mul stack)
    `(,(* (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn:div stack)
    `(,(quotient (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn:exp stack)
    `(,(expt (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn:mod stack)
    `(,(remainder (car stack) (cadr stack)) ,@(cddr stack)))

  ;; Polyadic
  (define (rpn:min stack)
    (list (min stack)))
  
  (define (rpn:max stack)
    (list (max stack)))
  
  (define (rpn:sum stack)
    (list (apply + stack)))
  
  (define (rpn:pro stack)
    (list (apply * stack)))

  (define rpn:monadic  `((~ . ,rpn:neg) (a . ,rpn:abs)
                         (d . ,rpn:dup) (p . ,rpn:pop)
                         (s . ,rpn:sig)               ))
  (define rpn:dyadic   `((+ . ,rpn:add) (- . ,rpn:sub)
                         (* . ,rpn:mul) (/ . ,rpn:div)
                         (^ . ,rpn:exp) (% . ,rpn:mod)))
  (define rpn:polyadic `((m . ,rpn:min) (M . ,rpn:max)
                         (Σ . ,rpn:sum) (Π . ,rpn:pro)))

  (define rpn:operators (append rpn:monadic rpn:dyadic rpn:polyadic))

  (define (rpn:eval token stack)
    (cond
     ((integer? token)    ; Push new number
      `(,@stack ,token))  ; It's an operator if it's not a number
     ((null? stack)
      (print "Stack empty.")  ; Return stack if it's empty
      stack)
     ((assoc token rpn:dyadic)    ; Make sure the stack has 2+ elements
      (if (pair? (cdr stack)) ; For dyadic operations only
          ((cdr (assoc token rpn:dyadic)) stack)
          (begin
            (print "Stack too short.")
            stack)))          ; Return stack otherwise
     (else  ; Other operations require at least 1 element
      ((eval (cdr (assoc token rpn:operators))) stack)))))
