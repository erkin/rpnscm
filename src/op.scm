(module rpn-op (rpn-eval operators) 
  (import chicken scheme)

  (define monadic '((? . rpn-neg) (a . rpn-abs) (: . rpn-dup) (! . rpn-pop)))
  (define dyadic '((+ . rpn-add) (- . rpn-sub) (* . rpn-mul) (/ . rpn-div)
                   (^ . rpn-exp) (% . rpn-mod) (~ . rpn-swp)))
  (define polyadic '((m . rpn-min) (M . rpn-max) (Σ . rpn-sum) (Π . rpn-pro)))
  (define operators (append monadic dyadic polyadic))

  ;;; Monadic
  (define (rpn-neg stack)
    `(,(- (car stack)) ,@(cdr stack)))

  (define (rpn-abs stack)
    `(,(abs (car stack)) ,@(cdr stack)))

  (define (rpn-dup stack)
    `(,(car stack) `(car stack) ,@(cdr stack)))
  
  (define (rpn-pop stack)
    (print (car stack))
    (cdr stack))

  ;;; Dyadic
  (define (rpn-add stack)
    `(,(+ (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-sub stack)
    `(,(- (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-mul stack)
    `(,(* (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-div stack)
    `(,(quotient (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-exp stack)
    `(,(expt (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-mod stack)
    `(,(remainder (car stack) (cadr stack)) ,@(cddr stack)))

  (define (rpn-swp stack)
    `(,(cadr stack) (car stack) ,@(cddr stack)))

  ;; Polyadic
  (define (rpm-min stack)
    (list (min stack)))
  
  (define (rpn-max stack)
    (list (max stack)))
  
  (define (rpn-sum stack)
    (list (apply + stack)))
  
  (define (rpn-pro stack)
    (list (apply * stack)))


  (define (rpn-eval token stack)
    (cond
     ((integer? token)    ; Push new number
      `(,@stack ,token))  ; It's an operator if it's not a number
     ((null? stack)
      (print "Stack empty.")  ; Return stack if it's empty
      stack)
     ((assoc token dyadic)    ; Make sure the stack has 2+ elements
      (if (pair? (cdr stack)) ; For dyadic operations only
          ((eval (cdr (assoc token dyadic))) stack)
          (begin
            (print "Stack too short.")
            stack)))          ; Return stack otherwise
     (else  ; Other operations require at least 1 element
      ((eval (cdr (assoc token operators))) stack)))))
