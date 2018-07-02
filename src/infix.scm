(declare (unit rpn-infix))
(declare (uses rpn-parse))
(declare (uses rpn-colour))

(module rpn-infix (rpn:infix)
  (import chicken scheme)
  (require-extension (only srfi-13 string-tokenize))
  (import rpn-parse rpn-colour)

  (define-constant rpn:precedence
    '((* . 3) (/ . 3) (+ . 2) (- . 2)))

  (define (rpn:shunt expression)
    )
  
  (define (rpn:infix expression)
    (print (tint (rpn:shunt (rpn:exp-check (string-tokenize expression) '())) 'cyan))
    (exit)))
