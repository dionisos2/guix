;; Ceci est une configuration de système d'exploitation générée par
;; l'installateur graphique.
;;
;; Une fois l'installation terminée, vous pouvez apprendre à modifier
;; ce fichier pour ajuster la configuration du système et le passer à
;; la commande « guix system reconfigure » pour rendre vos changements
;; effectifs.


;; Indique quels modules importer pour accéder aux variables
;; utilisées dans cette configuration.

;; SEE : https://config.daviwil.com/systems

(define-module (portable)
  #:use-module (base-system)
  #:use-module (gnu)) ;; Why is it needed ?

(operating-system

 (inherit base-operating-system)
 (host-name "portable")
 (swap-devices (list (swap-space
                      (target (uuid
                               "289a2038-51ad-42af-970e-8cff434e727f")))))

 ;; La liste des systèmes de fichiers qui seront « montés ». Les identifiants
 ;; de systèmes de fichiers uniques (« UUIDs ») qui se trouvent ici s'obtiennent
 ;; en exécutant « blkid » dans un terminal.
 (file-systems (cons* (file-system
                       (mount-point "/")
                       (device (uuid
                                "fe777591-2e81-48b2-b741-5554bd1e6831"
                                'ext4))
                       (type "ext4"))
                      (file-system
                       (mount-point "/home")
                       (device (uuid
                                "b759a46e-7e93-45bc-beed-963803a60ff6"
                                'ext4))
                       (type "ext4"))
                      (file-system
                       (mount-point "/boot/efi")
                       (device (uuid "C753-9E25"
                                     'fat16))
                       (type "vfat")) %base-file-systems)))
