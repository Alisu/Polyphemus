*Polyphemus-Edition-Pharo14
forThisHost

	"Loaded on a Pharo 14 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusHost pharo: 14 os: 'Linux' cpu: 'x64') targets: #( 14 )
