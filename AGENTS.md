# For an agent working on Polyphemus

Read this first on any machine other than the Ubuntu box (`CLAUDE.md` describes the box and the
project). Then read the handover for your machine: `docs/handover-windows.md` on the Windows
laptop.

## The project in three lines

Polyphemus reads the memory of Pharo images from outside: a damaged image file (stage 1), a
crashed or stale process or its dump (stage 2), a running image that it can hold, step, inspect
and edit (stage 3). All three are done on Linux x64, for Pharo 10 to 14, one **edition** per host
Pharo (`docs/editions.md`). Théo is porting it to other operating systems now.

## How Théo works, and what he has asked for

- **Ask before every download**: name, source, size. One approval covers the files named, no
  more.
- **Never handle credentials.** Théo signs in to GitHub, `gh` and anything else himself.
- **Anything that needs administrator rights, Théo runs himself** (on Windows: UAC prompts,
  installers that elevate). Never change security settings: Defender, UAC, the firewall, what a
  process may read of another. On Linux the equivalent rule was: never touch `ptrace_scope`.
- **No third-party remote-access tools** (Tailscale and the like).
- **No contact with the Pharo team**: no upstream bug reports, issues or pull requests to
  pharo-project, not even drafts. Upstream bugs are worked around here and written down in
  `docs/patch-notes.md`.
- **TDD, strictly**: a failing test first, then the code. A casual idea from Théo gets a proposal,
  not code.
- **Bugs go to GitHub issues** on `Alisu/Polyphemus` first (what fails, how to reproduce, what was
  ruled out), then a regression test naming the issue (`"#12"` in its comment), then a commit that
  says `Fixes #12`. Features need no issue.
- **Method comments are one to three lines** (`bin/long-comments.py` flags longer ones).
  History, measurements and reasoning go to issues, commits and `docs/`.
- **Verify, don't guess**: a fact about Pharo, VMMaker or the VM is checked in the image, the
  source or the binary (as the struct layouts were read with `gdb ptype /o`), not recalled.
- **Measure before and after** anything claimed to be faster.
- **Make the change asked for**, and say so separately if something else needs doing.
- **Gate in tiers** (`CLAUDE.md`, Working agreement): before a commit, the suite of the edition
  you work on; before anything reaches `stage2`, every edition, Linux ones included.
- **Waiting on a job**: wait on something it writes (a log's last line), with a bound on the
  wait, never on a process listing that matches your own command line.
- **Each edition gets a section in `docs/patch-notes.md`**: what moved underneath, what we
  changed, what is not done yet. Théo reads those to know what an edition changed.
- He writes in English. He often asks "where do we stand": answer with what is done, what is
  running, what is next, and what waits on him.
