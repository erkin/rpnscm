(module rpn-op (rpn:eval rpn:operators)
  (import chicken scheme)

;;; Monadic operators
  ;; negate
  ;; 3 n -5 n
  ;; (-3 5)
  (define (rpn:neg stack) 
    `(,(- (car stack)) ,@(cdr stack)))

  ;; absolute value
  ;; 3 @ -5 @
  ;; (3 5)
  (define (rpn:abs stack)
    `(,(abs (car stack)) ,@(cdr stack)))

  ;; duplicate
  ;; 5 :
  ;; (5 5)
  (define (rpn:dup stack)
    `(,(car stack) ,(car stack) ,@(cdr stack)))
  
  ;; pop
  ;; 3 5 !
  ;; "5"
  ;; (3)
  (define (rpn:pop stack)
    (print " " (car stack))
    (cdr stack))

  ;; peek
  ;; 3 5 ?
  ;; "5"
  ;; (3 5)
  (define (rpn:pek stack)
    (print " " (car stack))
    stack)

  ;; sign
  ;; 3 s -5 s
  ;; (1 -1)
  (define (rpn:sig stack)
    `(,(signum (car stack)) ,@(cdr stack)))

  
;;; Dyadic
  ;; addition
  ;; 3 5 + -3 5 +
  ;; (8 2)
  (define (rpn:add stack)
    `(,(+ (car stack) (cadr stack)) ,@(cddr stack)))

  ;; subtraction
  ;; 5 3 - 3 5 - -3 5 -
  ;; (2 -2 -8)
  (define (rpn:sub stack)
    `(,(- (cadr stack) (car stack)) ,@(cddr stack)))

  ;; multiplication
  ;; 3 -5 *
  ;; (-15)
  (define (rpn:mul stack)
    `(,(* (cadr stack) (car stack)) ,@(cddr stack)))

  ;; [integer] division
  ;; -20 5 / 5 3 /
  ;; (-4 1)
  (define (rpn:div stack)
    `(,(quotient (cadr stack) (car stack)) ,@(cddr stack)))

  ;; exponentiation
  ;; 3 5 ^ 5 3 ^
  ;; (243 125)
  (define (rpn:exp stack)
    `(,(expt (cadr stack) (car stack)) ,@(cddr stack)))

  ;; [integer] modulo
  ;; 3 5 % 5 3 %
  ;; (3 2)
  (define (rpn:mod stack)
    `(,(remainder (cadr stack) (car stack)) ,@(cddr stack)))

  ;; swap
  ;; 3 5 ~
  ;; (5 3)
  (define (rpn:swp stack)
    `(,(cadr stack) ,(car stack) ,@(cddr stack)))

  
;;; Polyadic
  ;; minimum
  ;; 7 -3 5 m
  ;; (-3)
  (define (rpn:min stack)
    (list (apply min stack)))
  
  ;; maximum
  ;; 7 -3 5 M
  ;; (7)
  (define (rpn:max stack)
    (list (apply max stack)))
  
  ;; summation
  ;; 7 -3 5 S
  ;; (9)
  (define (rpn:sum stack)
    (list (apply + stack)))
  
  ;; product
  ;; 7 -3 5 M
  ;; (-105)
  (define (rpn:pro stack)
    (list (apply * stack)))

  ;; empty
  ;; 7 -3 5 $
  ;; ()
  (define (rpn:emp stack)
    (list))

  ;; alists of procedures defined above
  (define rpn:monadic  `((n . ,rpn:neg) (@ . ,rpn:abs)
                         (: . ,rpn:dup) (! . ,rpn:pop)
                         (s . ,rpn:sig) (? . ,rpn:pek)))
  (define rpn:dyadic   `((+ . ,rpn:add) (- . ,rpn:sub)
                         (* . ,rpn:mul) (/ . ,rpn:div)
                         (^ . ,rpn:exp) (% . ,rpn:mod)
                         (~ . ,rpn:swp)               ))
  (define rpn:polyadic `((m . ,rpn:min) (M . ,rpn:max)
                         (S . ,rpn:sum) (P . ,rpn:pro)
                         ($ . ,rpn:emp)))

  (define rpn:operators (append rpn:monadic rpn:dyadic rpn:polyadic))

  (define (rpn:eval token stack)
    (cond                    ; Each integer is a niladic push operator
     ((integer? token)       ; Push new number
      `(,token ,@stack))     ; It's an operator if it's not a number
     ((null? stack)
      (print "Stack empty.") ; Return stack if it's empty
      stack)
     ((assoc token rpn:dyadic)   ; Make sure the stack has 2+ elements
      (if (pair? (cdr stack))    ; For dyadic operations only
          ((cdr (assoc token rpn:dyadic)) stack)
          (begin
            (print "Stack too short.")
            stack)))     ; Return stack otherwise
     (else               ; Other operations require at least 1 element
      ((cdr (assoc token rpn:operators)) stack)))))
