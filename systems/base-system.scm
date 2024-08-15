(define-module (base-system)
  #:use-module (gnu)
  ;; #:use-module (srfi srfi-1) ; ?
  #:use-module (gnu system nss)
	#:use-module (gnu system file-systems);;hum
  #:use-module (gnu services pm)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services docker)
  #:use-module (gnu services networking)
  #:use-module (gnu services virtualization)
  #:use-module (gnu packages wm)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages vim)
  #:use-module (gnu packages gtk)
  #:use-module (gnu services dbus)
  ;; #:use-module (gnu services blueman)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages mtools)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages gnuzilla)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages web-browsers)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages package-management)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd)
	#:use-module (my-modules)
	;; #:use-module (gnu packages sway)
	)

(use-service-modules nix)
(use-service-modules desktop xorg)
(use-service-modules cups networking ssh)

(use-package-modules certs)
(use-package-modules shells)

(define-public %guix-hpc-pub-key
	(plain-file "guix-hpc.pub"
							"(public-key
 (ecc
  (curve Ed25519)
  (q #89FBA276A976A8DE2A69774771A92C8C879E0F24614AAAAE23119608707B3F06#)))"))

(define-public %nonguix-pub-key
  (plain-file "non-guix.pub"
							"(public-key
 (ecc
  (curve Ed25519)
  (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))"))

(define-public %my-services
  ;; My very own list of services.
	(modify-services
	 %desktop-services
	 (guix-service-type config => (guix-configuration
																 (inherit config)
																 (substitute-urls
																	(append (list "https://substitutes.nonguix.org" "https://guix.bordeaux.inria.fr")
																					%default-substitute-urls))
																 (authorized-keys
																	(append (list %nonguix-pub-key %guix-hpc-pub-key)
																					%default-authorized-guix-keys))))
	 )
  )

(define-public base-operating-system
  (operating-system
	 (host-name "base-system")
	 (kernel linux)
	 (firmware (list linux-firmware))
	 (initrd microcode-initrd)
	 (locale "en_US.utf8")
	 (timezone "Europe/Paris")
	 (keyboard-layout (keyboard-layout "fr" "bepo_afnor"))

	 ;; La liste des comptes utilisateurs (« root » est implicite).
	 (users (cons* (user-account
									(name "dionisos")
									(comment "Dionisos")
									(group "users")
									(home-directory "/home/dionisos")
									(supplementary-groups '("wheel" "lp" "lpadmin" "netdev" "audio" "video")))
								 %base-user-accounts))

	 ;; Paquets installés pour tout le système. Les utilisateurs et utilisatrices peuvent aussi installer des paquets
	 ;; sous leur propre compte : utilisez « guix search MOT-CLÉ » pour chercher
	 ;; des paquets et « guix install PAQUET » pour installer un paquet.

	 (packages (append (list
											;; (specification->package "nss-certs")
											epson-inkjet-printer-escpr
											bluez
											bluez-alsa
											git
											ntfs-3g
											fuse-exfat
											stow
											vim
											emacs
											xterm
											pulseaudio
											tlp
											xf86-input-libinput
											gvfs
											my-qtile
											sway
											)%base-packages))

	 ;; Voici la liste des services du système.  Pour trouver les services disponibles,
	 ;; lancez « guix system search MOT-CLÉ » dans un terminal.
	 (services
		(append (list
						 (service bluetooth-service-type)
						 (service gnome-desktop-service-type)
						 (service xfce-desktop-service-type)
						 ;; (simple-service 'dbus-extras
             ;;    dbus-root-service-type
             ;;    (list blueman))
						 (set-xorg-configuration
							(xorg-configuration (keyboard-layout keyboard-layout)))
						 (service cups-service-type
											(cups-configuration
											 (web-interface? #t)
											 (extensions
												(list cups-filters epson-inkjet-printer-escpr))))
						 ) %my-services))
	 
	 (bootloader (bootloader-configuration
								(bootloader grub-efi-bootloader)
								(targets (list "/boot/efi"))
								(keyboard-layout keyboard-layout)))
	 (file-systems (cons*
                   (file-system
                     (mount-point "/tmp")
                     (device "none")
                     (type "tmpfs")
                     (check? #f))
                   %base-file-systems))
	 ))
