A running image, written through /proc/<pid>/mem at the addresses the process itself uses. The reader refuses to write unless the process is stopped, which for a wedged image means held at a safepoint first (#24).

It makes objects in new space, at the end of past space: old space in a running image ends at its bridge, and eden is where the machine makes its own, holding the place in a register through a stop (#137, #167). It tells the collector when an old object comes to point at a young one.
