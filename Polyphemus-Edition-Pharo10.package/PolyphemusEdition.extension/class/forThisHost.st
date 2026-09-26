*Polyphemus-Edition-Pharo10
forThisHost

	"Loaded on a Pharo 10 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusHost pharo: 10 os: 'Linux' cpu: 'x64') targets: #( 10 )
