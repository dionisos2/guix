My guix configuration, currently not working.

```Console
$ sudo -E guix system -L ~/.config/guix/systems reconfigure ~/.config/guix/systems/portable.scm
ice-9/eval.scm:223:20: In procedure proc:
error: base-operating-system: unbound variable
hint: Did you forget `(use-modules (base-system))'?
```
