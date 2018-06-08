(module rpn-colour (tint)
  (import chicken scheme)
  (define (tint string colour #!optional (emphasis 'regular))
    (string-append "\033["
                   (case emphasis
                     ((regular)    "0;3")
                     ((bold)       "1;3")
                     ((underline)  "4;3")
                     ((background) "4"))
                   (case colour
                     ((black)  "0")
                     ((red)    "1")
                     ((green)  "2")
                     ((yellow) "3")
                     ((blue)   "4")
                     ((purple) "5")
                     ((cyan)   "6")
                     ((white)  "7"))
                   "m" string "\033[0m")))

