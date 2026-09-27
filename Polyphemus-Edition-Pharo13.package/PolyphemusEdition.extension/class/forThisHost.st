*Polyphemus-Edition-Pharo13
forThisHost

	"Loaded on a Pharo 13 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusHost pharo: 13 os: 'Linux' cpu: 'x64') targets: #( 13 )
