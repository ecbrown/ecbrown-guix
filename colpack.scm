;;; Copyright © 2021 Eric Brown <ecbrown@ericcbrown.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (colpack)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system cmake)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (gnu packages))

(define-public colpack
   ;; The latest tagged release is 3 years old and there have been
   ;; unreleased fixes, so we take the last commit.
   (let ((commit "f328cad4141c4c6e3e30a58efcbcdacf8849124e")
         (revision "1"))
   (package
     (name "colpack")
     (version (git-version "1.0.10" revision commit))
     (source (origin
               (method git-fetch)
               (uri (git-reference
                     (url "https://salsa.debian.org/science-team/colpack.git")
                     (commit "f328cad4141c4c6e3e30a58efcbcdacf8849124e")))
               (file-name (git-file-name name version))
               (sha256
                (base32
                 "1c7i2gm28hjpgv3qjavmbd488q3zdxfnx10w193v3xxhincfcxl6"))))
     (build-system cmake-build-system)
     (arguments
      '(#:configure-flags '("-DENABLE_OPENMP=ON")))
     (home-page "http://cscapes.cs.purdue.edu/coloringpage/")
     (synopsis "Graph Coloring Algorithm package")
     (description
      "The overall aim of this project is to exploit the sparsity available in
 large-scale Jacobian and Hessian matrices the best possible way in order to
 make their computation using automatic differentiation (AD) (or finite
 differences) efficient.")
     (license license:bsd-3))))
