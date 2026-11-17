accessing
loadsWithTheCore: aPackageName

	"Whether the baseline loads it wherever it loads the core: this Pharo's edition, this host's
	package, what this VMMaker needs."

	^ #( 'Polyphemus-Edition-' 'Polyphemus-Host-' 'Polyphemus-VMMaker-' ) anySatisfy: [ :each |
		  aPackageName beginsWith: each ]
