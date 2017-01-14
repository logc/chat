#lang racket/base
(require racket/tcp)

(provide send-request)

(define (send-request)
  (define-values (in out) (tcp-connect "localhost" 1212))
  (write "NICK" out)
  (flush-output out)
  (define result (read in))
  (close-input-port in)
  (close-output-port out)
  result)

