A read only view of the processes a snapshot holds: their state, their stacks, and
the source of each frame.

Read only on purpose. A snapshot is a file, not a running image: there is nothing to
step and nothing to evaluate. Frames come from the contexts the VM wrote, and source
from the image own sources file, falling back to bytecodes where there is none.
