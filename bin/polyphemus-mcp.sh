#!/usr/bin/env bash
# Polyphemus as an MCP server over standard input and output (#71): one JSON-RPC message per
# line. An agent starts it through ssh, so nothing listens on the network:
#
#   ssh worker-box '~/polyphemus/Polyphemus/bin/polyphemus-mcp.sh'
#
# WORK picks the setup, as for bin/tdd.sh (default ~/polyphemus/pharo13, the latest release). It
# serves from that setup's warm.image, which bin/tdd.sh keeps at the working copy; the image is
# not saved. Standard output is the protocol's alone: everything else goes to standard error.
set -euo pipefail
WORK="${WORK:-$HOME/polyphemus/pharo13}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$WORK"
[ -f "$WORK/polyphemus.env" ] && { set -a; . "$WORK/polyphemus.env"; set +a; }
exec ./pharo warm.image --no-default-preferences st "$HERE/mcp-serve.st"
