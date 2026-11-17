helpers
executableStartOfSelf

	"Where this process maps its first file from its start, the VM executable: its ELF header.
	Not the first region since VM 10.3, whose position-independent executable maps above the
	heap."

	| line |
	line := '/proc/self/maps' asFileReference contents lines detect: [ :each |
		        | fields |
		        fields := each substrings.
		        fields size >= 6 and: [
			        (fields at: 3) asInteger = 0 and: [ fields last beginsWith: '/' ] ] ].
	^ Integer readFrom: (line copyUpTo: $-) base: 16
