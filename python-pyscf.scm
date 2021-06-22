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

(define-module (python-pyscf)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system python)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26)
  #:use-module (libcint)
  #:use-module (libxc)
  #:use-module (xcfun))

(define-public python-pyscf
  (package
   (name "python-pyscf")
   (version "1.7.6")
   (source (origin
             (method git-fetch)
             (uri (git-reference
                   (url "https://github.com/pyscf/pyscf")
                   (commit (string-append "v" version))
                   (recursive? #t)))
             (file-name (git-file-name name version))
             (sha256
              (base32
               "1plicf3df732mcwzsinfbmlzwwi40sh2cxy621v7fny2hphh14dl"))))
   (build-system python-build-system)
   (inputs
    `(("openblas-ilp64" ,openblas-ilp64)
      ("libcint" ,libcint)
      ("libxc" ,libxc)
      ("xcfun" ,xcfun)))
   (native-inputs
    `(("cmake" ,cmake)
      ("gcc" ,gcc)))
   (propagated-inputs
    `(("python" ,python)
      ("python-wrapper" ,python-wrapper)
      ("python-h5py" ,python-h5py)
      ("python-numpy" ,python-numpy)
      ("python-scipy" ,python-scipy)
      ("python-setuptools" ,python-setuptools)
      ("python-setuptools-scm" ,python-setuptools-scm)))
   (arguments
    `(#:phases
       (modify-phases %standard-phases
         (add-before 'build 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let (;(out (assoc-ref outputs "out"))
                   (libcint (assoc-ref %build-inputs "libcint"))
                   (libxc (assoc-ref %build-inputs "libxc"))
                   (xcfun (assoc-ref %build-inputs "xcfun")))
               (setenv "PYSCF_INC_DIR"
                       (string-append libcint ":"
                                      libxc ":"
                                      xcfun))))))))
   (home-page "https://pyscf.org/")
   (synopsis "Electronic structure theory suite in Python and C")
   (description "The Python-based Simulations of Chemistry Framework (PySCF) is a
collection of electronic structure modules powered by Python. The
package provides a simple, lightweight, and efficient platform for
quantum chemistry calculations and methodology development. PySCF can
be used to simulate the properties of molecules, crystals, and custom
Hamiltonians using mean-field and post-mean-field methods.")
   (license license:asl2.0)))
