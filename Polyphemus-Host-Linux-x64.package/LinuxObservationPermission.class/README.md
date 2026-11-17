Who is allowed to read this image's memory.

This is the only part of Polyphemus that goes in the image being *observed* rather than the one
doing the observing, and the only foreign call in the project. Reading needs none; granting
permission needs one.

Yama's `ptrace_scope` is 1 on most machines, which lets only an ancestor read another process.
`prctl(PR_SET_PTRACER, ...)` lets a process name someone else instead -- a single observer, or
anyone of the same user -- and take it back again. Measured on Linux 6.x:

- it governs `/proc/<pid>/mem`, not only `ptrace` proper;
- it survives `execve`, which is why `bin/pharo-debuggable` can grant it before the virtual
  machine even starts, with no change to the virtual machine;
- it is revocable: granted, a sibling could read this process; cleared, the same sibling could
  not.

Grant as little as will do. `#allowObserver:` names one process; `#allowAnyObserver` opens this
image to every process of the same user, which is the setting to use when the observer is not
known in advance and to take back when it is.

An image that has wedged can neither grant nor revoke -- it cannot run anything. So this has to
have been done *before* the trouble, which is what the launcher is for.
