baselines
customProjectAttributes

	"Metacello names Pharo versions but no operating system: this host's, as
	PolyphemusHost>>metacelloAttribute names it (#'linux-x64', #'macos-arm64'), picks its
	Polyphemus-Host package. Read from OSPlatform: nothing of Polyphemus is loaded yet."

	| os subtype cpu |
	os := OSPlatform current isWindows
		      ifTrue: [ 'windows' ]
		      ifFalse: [
			      OSPlatform current isMacOS
				      ifTrue: [ 'macos' ]
				      ifFalse: [ 'linux' ] ].
	subtype := OSPlatform current subtype asString.
	cpu := (#( 'x86_64' 'x64' 'X64' 'AMD64' ) includes: subtype)
		       ifTrue: [ 'x64' ]
		       ifFalse: [
			       (#( 'arm64' 'aarch64' ) includes: subtype)
				       ifTrue: [ 'arm64' ]
				       ifFalse: [ subtype asLowercase ] ].
	^ { (os , '-' , cpu) asSymbol }
