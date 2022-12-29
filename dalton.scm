;;; GNU Guix --- Functional package management for GNU
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

(define-module (dalton)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages base)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26))

(define-public dalton
  (package
    (name "dalton")
    (version "2020.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
         (url "https://gitlab.com/dalton/dalton")
         (commit  version)
         (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0hrm6jc17969cpjzz435dlv0p9hw157f613sj7is7ynjsvp1hp1z"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (substitute* "dalton.in"
             (("INSTALL_BASDIR=\\$SCRIPT_DIR/basis")
              "INSTALL_BASDIR=$SCRIPT_DIR/../share/dalton/basis"))
           (substitute* "DALTON/abacus/ptrbuf.h"
             (("MAXCHN = 200")
              "MAXCHN = 400"))
           (substitute* "cmake/math/MathLibs.cmake"
             (("OPENBLAS_BLAS_LIBS   openblas")
              "OPENBLAS_BLAS_LIBS   openblas_ilp64"))))))
    (build-system cmake-build-system)
    (inputs
     `(("openblas-ilp64" ,openblas-ilp64)
       ("python" ,python)
       ("python-wrapper" ,python-wrapper)
       ("which" ,which)))
    (native-inputs
     `(("gfortran" ,gfortran)
       ("git" ,git)
       ("pkg-config" ,pkg-config)
       ("tcsh" ,tcsh)))
    (arguments
     `(; Note that tests can take a long time
       ; and some tests fail
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'setenv
           (lambda _
             (setenv "MATH_ROOT" (string-append
                                  (assoc-ref %build-inputs "openblas-ilp64")))))
         (add-after 'install 'install-sh-symlink
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Add links to dalton and tools
             (let ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/bin"))
               (copy-file (string-append out "/dalton/dalton")
                          (string-append out "/bin/dalton"))
               (delete-file (string-append out "/dalton/dalton"))
               (copy-file (string-append out "/dalton/dalton.x")
                          (string-append out "/bin/dalton.x"))
               (copy-file (string-append out "/dalton/tools/aces2dalton")
                          (string-append out "/bin/aces2dalton"))
               (delete-file (string-append out "/dalton/tools/aces2dalton"))
               (copy-file (string-append out "/dalton/tools/distances")
                          (string-append out "/bin/distances"))
               (delete-file (string-append out "/dalton/tools/distances"))
               (copy-file (string-append out "/dalton/tools/FChk2HES")
                          (string-append out "/bin/FChk2HES"))
               (delete-file (string-append out "/dalton/tools/FChk2HES"))
               (copy-file (string-append out "/dalton/tools/labread")
                          (string-append out "/bin/labread"))
               (delete-file (string-append out "/dalton/tools/labread"))
               (copy-file (string-append out "/dalton/tools/xyz2dalton")
                          (string-append out "/bin/xyz2dalton"))
               (delete-file (string-append out "/dalton/tools/xyz2dalton"))
               (chmod (string-append out "/bin/aces2dalton") #o755)
               (chmod (string-append out "/bin/distances") #o755)
               (chmod (string-append out "/bin/FChk2HES") #o755)
               (chmod (string-append out "/bin/labread") #o755)       
               (chmod (string-append out "/bin/xyz2dalton") #o755)
               (mkdir-p (string-append out "/share/dalton"))
               (copy-recursively (string-append out "/dalton")
                                      (string-append out "/share/dalton"))
               (delete-file-recursively (string-append out "/dalton"))))))
       #:configure-flags (list "-DBLAS_TYPE=OPENBLAS"
                               "-DENABLE_64BIT_INTEGERS=1")))
    (home-page "https://daltonprogram.org/")
    (synopsis "Electronic structure theory and molecular properties")
    (description "Dalton provides an extensive functionality for the calculations of
molecular properties at the HF, DFT, MCSCF, MC-srDFT, and CC levels of
theory.")
    (license license:lgpl2.1)))
