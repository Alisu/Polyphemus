*Polyphemus-Edition-Pharo12
forThisHost

	"Loaded on a Pharo 12 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusHost pharo: 12 os: 'Linux' cpu: 'x64') targets: #( 12 )
