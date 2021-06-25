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

(define-module (python-psi4)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages graphviz)  
  #:use-module (gnu packages maths)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages version-control)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system python)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (libint)
  #:use-module (libxc)
  #:use-module (python-gau2grid))

(define-public python-psi4
  (package
   (name "python-psi4")
   (version "1.4")
   (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/psi4/psi4")
                   (commit (string-append "v" version "rc2"))
                   (recursive? #t)))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "12r91ixs1sba15b9yybn9rjbcj6pwq9zlzmvl7i1rgng1av9nakk"))))
   (build-system cmake-build-system)
   (inputs
    `(("openblas" ,openblas)
      ("libint" ,libint)
      ("libxc" ,libxc)
      ("graphviz" ,graphviz)))
   (native-inputs
    `(("doxygen" ,doxygen)
      ("tcsh" ,tcsh)
      ("perl" ,perl)
      ("gcc" ,gcc)))
   (propagated-inputs
    `(("python" ,python)
      ("python-wrapper" ,python-wrapper)
      ("python-h5py" ,python-h5py)
      ("python-numpy" ,python-numpy)
      ("pybind11" ,pybind11)
      ("python-gau2grid" ,python-gau2grid)
      ("python-pytest" ,python-pytest)
      ("python-scipy" ,python-scipy)
      ("python-setuptools" ,python-setuptools)
      ("python-setuptools-scm" ,python-setuptools-scm)
;      ("python-sphinx-psi-theme" ,python-sphinx-psi-theme)
;      ("python-cloud_sptheme" ,python-cloud_sptheme)
;      ("python-sphinx-automodapi" ,python-sphinx-automodapi)
;      ("python-graphviz" ,python-graphviz)
      ))
   (arguments
    `(#:configure-flags
      (list "-DBLAS_TYPE=OPENBLAS"
	    (string-append
	     "-DLibxc_DIR="
	     (assoc-ref %build-inputs "libxc"))
	    (string-append
	     "-DLibint2_DIR="
	     (assoc-ref %build-inputs "libint")))))
;   (arguments
;    `(#:phases
;       (modify-phases %standard-phases
;         (add-before 'build 'configure
;           (lambda* (#:key inputs outputs #:allow-other-keys)
;             (let (;(out (assoc-ref outputs "out"))
;                   (libcint (assoc-ref %build-inputs "libcint"))
;                   (libxc (assoc-ref %build-inputs "libxc"))
;                   (xcfun (assoc-ref %build-inputs "xcfun")))
;               (setenv "PYSCF_INC_DIR"
;                       (string-append libcint ":"
;                                      libxc ":"
;                                      xcfun))))))))
   (home-page "https://github.com/psi4/psi4")
   (synopsis "")
   (description "")
   (license license:asl2.0)))
