;;; Copyright (C) 2019  Sony Computer Science Laboratories Paris
;;;                     Remi van Trijp (www.remivantrijp.eu)
;;; 
;;;     This program is free software: you can redistribute it and/or modify
;;;     it under the terms of the GNU General Public License as published by
;;;     the Free Software Foundation, version 3 of the License.
;;; 
;;;     This program is distributed in the hope that it will be useful,
;;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;     GNU General Public License for more details.
;;; 
;;;     You should have received a copy of the GNU General Public License
;;;     along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;; ----------------------------------------------------------------------------

(in-package :beng)

;;;;;; Loading utilities.
;;;;;; ----------------------------------------------------------------
(defun lex-directory (lex-class)
  (remove-if-not #'(lambda(p)
                     (string= "lisp" (pathname-type p)))
                 (directory (beng-pathname :directory (list "lexicon" lex-class)))))

(defun grammar-directory (class)
  (remove-if-not #'(lambda(p)
                     (string= "lisp" (pathname-type p)))
                 (directory (beng-pathname :directory (list "grammar" class)))))

(defun idioms-directory ()
  (remove-if-not #'(lambda(p)
                      (string= "lisp" (pathname-type p)))
                  (directory (beng-pathname :directory (list "idioms")))))

(defun load-idioms ()
  (loop for path in (idioms-directory)
        do (load path)))

(defun load-lexical-constructions (lex-class)
  (loop for path in (lex-directory lex-class)
        do (load path)))

(defun load-lexicon (&optional (lex-classes '("adjectives"
                                              "adverbs"
                                              "auxiliaries"
                                              "determiners"
                                              "meta"
                                              "nationalities"
                                              "nouns"
                                              "prepositions"
                                              "pronouns"
                                              "verbs")))
  (with-disabled-monitors
    (loop for lex-class in lex-classes
          do (load-lexical-constructions lex-class))))

(defun load-adjective (word)
  (load (beng-pathname :directory '("lexicon" "adjectives")
                       :name word
                       :type "lisp")))

(defun load-adverb (word)
  (load (beng-pathname :directory '("lexicon" "adverbs")
                       :name word
                       :type "lisp")))

(defun load-nationality (word)
  (load (beng-pathname :directory '("lexicon" "nationalities")
                       :name word
                       :type "lisp")))

(defun load-noun (word)
  (load (beng-pathname :directory '("lexicon" "nouns")
                       :name word
                       :type "lisp")))

(defun load-preposition (word)
  (load (beng-pathname :directory '("lexicon" "prepositions")
                       :name word
                       :type "lisp")))

(defun load-verb (word)
  (load (beng-pathname :directory '("lexicon" "verbs")
                       :name word
                       :type "lisp")))

(defun load-articles ()
  (load (beng-pathname :directory '("lexicon" "determiners")
                       :name "articles"
                       :type "lisp")))
;; (load-articles)

(defun load-quantifiers ()
  (load (beng-pathname  :directory '("lexicon" "determiners")
                        :name "quantifiers"
                        :type "lisp")))
;; (load-quantifiers)

(defun load-possessive-pronouns ()
  (load (beng-pathname  :directory '("lexicon" "determiners")
                        :name "possessive-pronouns"
                        :type "lisp")))
;; (load-possessive-pronouns)

(defun load-demonstratives ()
  (load (beng-pathname  :directory '("lexicon" "determiners")
                        :name "demonstratives"
                        :type "lisp")))
;; (load-demonstratives)

(defun load-determiners ()
  (load-lexicon '("determiners")))
;; (load-determiners)

(defun load-grammatical-constructions (class)
  (loop for path in (grammar-directory class)
        do (load path)))
        
(defun load-grammar (&optional (classes '("referring-expressions"
                                          "argument-structure")))
                                          ;;"tam"
                                          ;;"voice")))
  (with-disabled-monitors
    (loop for class in classes
          do (load-grammatical-constructions class))))
;; (load-grammar)

;;;;;; Writing the lexicon.
;;;;;; ----------------------------------------------------------------
(defun write-lexicon ()
  (write-adjectives)
  (write-adverbs)
  (write-nationalities)
  (write-nouns)
  (write-prepositions)
  (write-verbs))
;; (write-lexicon)


;;;;;; Build a grammar.
;;;;;; ----------------------------------------------------------------
(defun build-grammar (&key (write-files? t))
  "For writing and loading constructions. Only use after instantiating a construction inventory."
  (with-disabled-monitors
    (when write-files?
      (format t "~%Writing constructional definitions (this may take a few seconds)...")
      (write-lexicon))
    (make-beng-cxns)
    (load-lexicon)
    (load-idioms)
    (load-grammar)
    (set-data (blackboard *fcg-constructions*) :fusion-hierarchy *fusion-hierarchy*)
    *fcg-constructions*))
;; (build-grammar)
;; (comprehend "the window broke")


;;;;;; Make and store an English lexicon image
;;;;;; ----------------------------------------------------------------
(defun save-beng (grammar &key (directory '("models"))
                               (name "beng")
                               (type "lisp"))
  "Stores the grammar 'grammar' in path 'file-path'"
  (let ((path (beng-pathname :directory directory :name name :type type)))
    (cl-store:store grammar path)))
;; (save-beng *fcg-constructions* :name "beng-only-lexicon")

(defun restore-beng (&key (name "beng") (directory '("models")) (type "lisp"))
  "Loads and returns the grammar 'grammar' in path 'file-path'"
  (let ((path (beng-pathname :directory directory :name name :type type)))
    (cl-store:restore path)))
;; (restore-beng :name "beng")
