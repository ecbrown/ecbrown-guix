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

(define-module (openmolcas)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages sphinx)
  #:use-module (gnu packages tex)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages base)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system cmake)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-26))

(define-public openmolcas
  (package
    (name "openmolcas")
    (version "21.06")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
         (url "https://gitlab.com/Molcas/OpenMolcas")
         (commit (string-append "v" version))
         (recursive? #f)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "13ryy9i0a0h7gk71wh9a8ni7ar2w41k1lq8az3aasa13p3byjswl"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (substitute* "CMakeLists.txt"
             (("NAMES openblas")
              "NAMES openblas_ilp64"))
           (substitute* "sbin/help_basis"
             (("MOLCAS, 'basis_library'")
              "MOLCAS, 'share', 'basis_library'"))))))
    (build-system cmake-build-system)
    (inputs
     `(("hdf5" ,hdf5)
       ("openblas-ilp64" ,openblas-ilp64)
       ("perl" ,perl)
       ("python" ,python)
       ("libxml2" ,libxml2)
       ("texlive" ,texlive)))
    (native-inputs
     `(("gfortran" ,gfortran)
       ("git" ,git)
       ("pkg-config" ,pkg-config)))
    (propagated-inputs `(("python-pyparsing" ,python-pyparsing)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-sh-symlink
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Script to move files into FHS
             (let ((out (assoc-ref outputs "out")))
               (mkdir-p (string-append out "/share/openmolcas"))
               (copy-file (string-append out "/LICENSE")
                          (string-append out "/share/openmolcas/LICENSE"))
               (delete-file (string-append out "/LICENSE"))
               (copy-file (string-append out "/CONTRIBUTORS.md")
                          (string-append out "/share/openmolcas/CONTRIBUTORS.md"))
               (delete-file (string-append out "/CONTRIBUTORS.md"))
               (copy-file (string-append out "/molcas.rte")
                          (string-append out "/share/openmolcas/molcas.rte"))
               (delete-file (string-append out "/molcas.rte"))
               (copy-file (string-append out "/.molcashome")
                          (string-append out "/share/openmolcas/.molcashome"))
               (delete-file (string-append out "/.molcashome"))
               (copy-file (string-append out "/.molcasversion")
                          (string-append out "/share/openmolcas/.molcasversion"))
               (delete-file (string-append out "/.molcasversion"))
               (mkdir-p (string-append out "/share/openmolcas/basis_library"))
               (copy-recursively (string-append out "/basis_library")
                                 (string-append out "/share/openmolcas/basis_library"))
               (delete-file-recursively (string-append out "/basis_library"))
               (mkdir-p (string-append out "/share/openmolcas/data"))
               (copy-recursively (string-append out "/data")
                                      (string-append out "/share/openmolcas/data"))
               (delete-file-recursively (string-append out "/data"))
               (mkdir-p (string-append out "/share/openmolcas/doc"))
               (copy-recursively (string-append out "/doc")
                                      (string-append out "/share/openmolcas/doc"))
               (mkdir-p (string-append out "/share/openmolcas/bin"))
               (copy-recursively (string-append out "/bin")
                                 (string-append out "/share/openmolcas/bin"))
               (delete-file-recursively (string-append out "/bin"))
               (mkdir-p (string-append out "/bin"))
               (copy-file (string-append out "/pymolcas")
                          (string-append out "/bin/pymolcas"))
               (delete-file (string-append out "/pymolcas"))
               (mkdir-p (string-append out "/share/openmolcas/sbin"))
               (copy-recursively (string-append out "/sbin")
                                 (string-append out "/share/openmolcas/sbin"))
               (delete-file-recursively (string-append out "/sbin"))))))
       #:configure-flags (list
                          "-DOPENMP=ON"
                          "-DLINALG=OpenBLAS"
                          (string-append "-DOPENBLASROOT="
                                         (assoc-ref %build-inputs "openblas-ilp64")))))
    (home-page "https://gitlab.com/Molcas/OpenMolcas")
    (synopsis "Electronic structure theory with multiconfigurational methods")
    (description "OpenMolcas is a quantum chemistry software package.  It includes
programs to apply many different electronic structure methods to
chemical systems, but its key feature is the multiconfigurational
approach, with methods like CASSCF and CASPT2.")
    (license license:lgpl2.1)))
