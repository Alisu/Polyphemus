#!/usr/bin/env bash
# Build an edition's setup from nothing, as the box's were built by hand (docs/editions.md):
# its pinned Pharo image and VM, Polyphemus loaded from this checkout, a core of it for the
# dump tests, and the launcher the live tests need. For CI (.github/workflows/editions.yml).
#
#   bin/ci-setup.sh 13 ~/setup
#
# Then WORK=~/setup bin/tdd.sh --all runs that edition's suite.
set -euo pipefail
EDITION="$1"
WORK="$2"
CHECKOUT="$(cd "$(dirname "$0")/.." && pwd)"
. "$CHECKOUT/bin/portable.sh"
HOST="$(uname -s)"
case "$HOST" in MINGW*|MSYS*) HOST=Windows ;; esac
# Pharo reads paths as Windows writes them (D:/a/...), not as Git Bash does (/d/a/...).
CHECKOUT_FOR_PHARO="$CHECKOUT"
[ "$HOST" = Windows ] && CHECKOUT_FOR_PHARO="$(cd "$CHECKOUT" && pwd -W)"

case "$EDITION" in
  10) IMAGE=100/Pharo10.0.1-0.build.527.sha.0542643.arch.64bit;      VM=PharoVM-9.0.22-421845e ;;
  11) IMAGE=110/Pharo11-SNAPSHOT.build.688.sha.cf3d3fd.arch.64bit;   VM=PharoVM-10.0.5-2757766 ;;
  12) IMAGE=120/Pharo12.0-SNAPSHOT.build.1519.sha.aa50f9c.arch.64bit; VM=PharoVM-10.3.2-b8793dd2 ;;
  13) IMAGE=130/Pharo13.0-SNAPSHOT.build.749.sha.d7c6f761d5.arch.64bit; VM=PharoVM-v10.3.11+0.a585304 ;;
  14) IMAGE=140/Pharo14.0-SNAPSHOT.build.771.sha.bf1210affa.arch.64bit; VM=PharoVM-v12.0.5-beta+0.7884d28 ;;
  *) echo "no edition $EDITION"; exit 2 ;;
esac
# macOS (Apple silicon, docs/handover-macos.md): the same VM builds as Linux's under longer
# names, in Pharo.app; a stock VM leaves no core, so the dump tests skip.
if [ "$HOST" = Darwin ]; then
  case "$EDITION" in
    10) VM=PharoVM-9.0.22-421845e1 ;;
    11) VM=PharoVM-10.0.5-2757766f ;;
    12) VM=PharoVM-10.3.2-b8793dd2 ;;
    13) VM=PharoVM-v10.3.11+0.a585304b1 ;;
    14) VM=PharoVM-v12.0.5-beta+0.7884d2853 ;;
  esac
  VM_URL="https://files.pharo.org/vm/pharo-spur64-headless/Darwin-arm64/$VM-Darwin-arm64-bin.zip"
  VM_BINARY=Pharo.app/Contents/MacOS/Pharo
# Windows x64 (docs/handover-windows.md): Pharo 13 only so far.
elif [ "$HOST" = Windows ]; then
  case "$EDITION" in
    13) VM=PharoVM-v10.3.11+0.a585304b1 ;;
    *) echo "no Windows VM pinned for Pharo $EDITION"; exit 2 ;;
  esac
  VM_URL="https://files.pharo.org/vm/pharo-spur64-headless/Windows-x86_64/$VM-Windows-x86_64-bin.zip"
  VM_BINARY=PharoConsole.exe
else
  VM_URL="https://files.pharo.org/vm/pharo-spur64-headless/Linux-x86_64/$VM-Linux-x86_64-bin.zip"
  VM_BINARY=pharo
fi

mkdir -p "$WORK"
cd "$WORK"

echo "== Pharo $EDITION: image and VM =="
curl -fsSL -o image.zip "https://files.pharo.org/image/$IMAGE.zip"
unzip -q -o image.zip
curl -fsSL -o vm.zip "$VM_URL"
mkdir -p pharo-vm
unzip -q -o vm.zip -d pharo-vm
rm image.zip vm.zip
cat > pharo <<LAUNCHER
#!/usr/bin/env bash
DIR="\$(cd "\$(dirname "\$0")" && pwd)"
set -f
exec "\$DIR/pharo-vm/$VM_BINARY" --headless "\$@"
LAUNCHER
chmod +x pharo
base="$(ls *.image | head -1)"
cp "$base" dev.image
cp "${base%.image}.changes" dev.changes
# A junction on Windows: a symbolic link there needs Developer Mode or elevation.
if [ "$HOST" = Windows ]; then
  [ -e Polyphemus ] && cmd //c "rmdir Polyphemus"
  cmd //c "mklink /J Polyphemus $(cygpath -w "$CHECKOUT")" > /dev/null
else
  ln -sfn "$CHECKOUT" Polyphemus
fi

echo "== Pharo $EDITION: loading Polyphemus and VMMaker =="
cat > load.st <<ST
[ Metacello new
	baseline: #Polyphemus;
	repository: 'filetree://$CHECKOUT_FOR_PHARO';
	onConflictUseIncoming;
	load ] on: Error do: [ :e | ('LOAD_ERR ' , e class name , ' ' , e messageText asString) traceCr ].
[ (IceRepositoryCreator new location: '$CHECKOUT_FOR_PHARO' asFileReference; createRepository) register ]
	on: Error do: [ :e | ('REGISTER_ERR ' , e class name , ' ' , e messageText asString) traceCr ].
('LOADED ' , (Smalltalk globals includesKey: #PolyphemusEdition) printString) traceCr.
Smalltalk snapshot: true andQuit: true
ST
timeout 3600 ./pharo dev.image --no-default-preferences st load.st 2>&1 | tr -d '\033' | tee load.log | grep -E "LOAD_ERR|REGISTER_ERR|LOADED" || true
grep -q "LOADED true" load.log || { echo "!! Polyphemus did not load"; tail -40 load.log; exit 1; }
! grep -q "REGISTER_ERR" load.log || { echo "!! the checkout is not registered in Iceberg (a shallow clone?)"; exit 1; }

cat > polyphemus.env <<ENV
POLYPHEMUS_TARGET_PHARO=$EDITION
ENV
[ "$HOST" = Darwin ] || [ "$HOST" = Windows ] || echo "POLYPHEMUS_CORE=$WORK/pharo.core" >> polyphemus.env
cat > idle.st <<'ST'
"Stay alive so something can take a dump of us."
(Delay forSeconds: 240) wait.
Smalltalk exitSuccess
ST

if [ "$HOST" != Darwin ] && [ "$HOST" != Windows ]; then
  echo "== Pharo $EDITION: a core for the dump tests =="
  WORK="$WORK" "$CHECKOUT/bin/take-dump.sh" "$WORK/pharo.core" "$WORK/dev.image"
fi

echo "== Pharo $EDITION: ready =="
