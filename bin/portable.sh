# Sourced by bin/tdd.sh and bin/run-tests.sh: what they use that a Mac lacks. macOS has no
# timeout(1) (and bash 3.2, so no mapfile): where timeout is missing, a perl stand-in answers as
# GNU's does -- 124 when time runs out, else the command's own status. On Linux nothing changes.
if ! command -v timeout >/dev/null 2>&1; then
  if command -v gtimeout >/dev/null 2>&1; then
    timeout() { gtimeout "$@"; }
  else
    timeout() {
      perl -e '
        my $seconds = shift @ARGV;
        my $pid = fork();
        die "fork: $!" unless defined $pid;
        if ($pid == 0) { exec { $ARGV[0] } @ARGV or exit 127; }
        $SIG{ALRM} = sub { kill "TERM", $pid; sleep 1; kill "KILL", $pid; waitpid($pid, 0); exit 124; };
        alarm $seconds;
        waitpid($pid, 0);
        my $status = $?;
        exit($status & 127 ? 128 + ($status & 127) : $status >> 8);
      ' "$@"
    }
  fi
  export -f timeout
fi
