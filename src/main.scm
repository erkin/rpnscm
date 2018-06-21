(require-extension (only srfi-37 args-fold option))
(import rpn-parse rpn-doc rpn-colour)

(define (rpn:version #!optional args) ; ignore arguments
  (print   (tint "rpnscm v0.17" 'cyan 'bold))
  (print   (tint "Copyright (C) 2018 Erkin Batu Altunbaş" 'cyan))
  (newline)
  (print* "Each file of this project's source code is subject ")
  (print  "to the terms of the Mozilla Public Licence v2.0")
  (print* "If a copy of the MPL was not distributed with this file, ")
  (print  "you can obtain one at https://mozilla.org/MPL/2.0/")
  (exit))

(define (rpn:usage #!optional opt name arg loads)
  (define unrecognised
    (if opt ; When called without options, the value of opt is #f.
        (if name
            (if (string? name)
                (if (string=? name "help")
                    #f
                    'long)
                (if (or (char=? name #\?) (char=? name #\h))
                    #f ; We don't actually check for 'short anywhere.
                    'short))
            'operand)
        #f))
  (when unrecognised
    (print
     (tint "error: " 'red 'bold)
     "Unrecognised "
     (case unrecognised
       ((long) (string-append "argument: " (tint (string-append "--" name) 'yellow)))
       ((short) (string-append "option: "  (tint (string #\- name) 'yellow)))
       ((operand) (string-append "operand: " (tint opt 'yellow)))))
    (newline))

  (print* (tint "Usage: " 'green))
  (print  (car (argv)) " -e " (tint "\"EXPRESSION\"" 'yellow))
  (print* "       ")
  (print  (car (argv)) " -f " (tint "FILE" 'yellow))
  (for-each print rpn:help-messages)
  (exit (if unrecognised 1 0)))

(define rpn:opts
  (list
   (option '(#\h #\? "help") #f #f
           rpn:usage)
   (option '(#\V "version") #f #f
           rpn:version)
   (option '(#\v "verbose") #f #f
           (lambda _ #t))
   (option '(#\o "operators") #f #f
           rpn:operator-usage)
   (option '(#\e "eval" "evaluate") #t #f
           (lambda (op name arg seed)
             (unless arg
               (print (tint "error: " 'red 'bold) "No expression provided.")
               (print "See " (tint "--help" 'green) " for more information.")
               (exit -1))
             (rpn:calculate arg seed)))
   (option '(#\i "interactive" "repl") #f #f
           (lambda _
             (rpn:repl seed)))
   (option '(#\f "file") #t #f
           (lambda (opt name arg seed)
             (unless arg
               (print (tint "error: " 'red 'bold) "No filename specified.")
               (print "See " (tint "--help" 'green) " for more information.")
               (exit -1))
             (rpn:calculate
              (with-input-from-file arg read-string)
              seed)))))

(define (main args)
  (if (pair? args)
      (args-fold args rpn:opts rpn:usage rpn:usage #f))
  (rpn:usage))

(main (command-line-arguments))
