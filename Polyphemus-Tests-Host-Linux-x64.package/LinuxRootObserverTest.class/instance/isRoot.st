helpers
isRoot

	"Whether this Pharo runs as root: its real and effective uids, from /proc/self/status."

	^ (('/proc/self/status' asFileReference contents lines detect: [ :each | each beginsWith: 'Uid:' ])
		   substrings allButFirst first: 2) allSatisfy: [ :each | each = '0' ]
