downloading
fetchCommandFrom: aURL named: aName into: aDirectory

	"One fetch as one shell command, safe beside another (#74): under a lock on aDirectory, in a
	directory of its own, nothing if another got there first, the image moved in last. Without
	the VM's LD_LIBRARY_PATH: curl dies on the VM's own libraries."

	^ 'env -u LD_LIBRARY_PATH flock ' , aDirectory , ' sh -c ''test -f ' , aDirectory , '/' , aName
	  , '.image || { d=$(mktemp -d ' , aDirectory , '/.fetch.XXXXXX) && cd "$d" && curl -fsSL -o fetched.zip '
	  , aURL
	  , ' && unzip -q -o fetched.zip && for e in image changes sources; do for f in *.$e; do [ -e "$f" ] && mv "$f" '
	  , aName , '.$e; done; done; mv ' , aName , '.changes ' , aName , '.sources ' , aDirectory
	  , '/ 2>/dev/null; mv ' , aName , '.image ' , aDirectory , '/; cd / && rm -rf "$d"; }'''
