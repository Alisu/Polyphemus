downloading
fetchCommandFrom: aURL named: aName into: aDirectory

	"One fetch as one shell command, safe beside another (#74): in a directory of its own, nothing
	if another got there first, the image moved in last, so two at once still leave it whole; under
	a lock on aDirectory where flock exists, which macOS lacks. Without the VM's LD_LIBRARY_PATH:
	curl dies on the VM's own libraries."

	^ 'env -u LD_LIBRARY_PATH $(command -v flock >/dev/null 2>&1 && echo flock ' , aDirectory , ') sh -c ''test -f ' , aDirectory , '/' , aName
	  , '.image || { d=$(mktemp -d ' , aDirectory , '/.fetch.XXXXXX) && cd "$d" && curl -fsSL -o fetched.zip '
	  , aURL
	  , ' && unzip -q -o fetched.zip && for e in image changes sources; do for f in *.$e; do [ -e "$f" ] && mv "$f" '
	  , aName , '.$e; done; done; mv ' , aName , '.changes ' , aName , '.sources ' , aDirectory
	  , '/ 2>/dev/null; mv ' , aName , '.image ' , aDirectory , '/; cd / && rm -rf "$d"; }'''
