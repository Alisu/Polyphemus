*Polyphemus-Edition-Pharo11
forThisHost

	"Loaded on a Pharo 11 host only (BaselineOfPolyphemus); what it reads is what its suite checks:
	Pharo 10 and Pharo 11 images, on VM 10."

	^ self host: (PolyphemusHost pharo: 11 os: 'Linux' cpu: 'x64') targets: #( 10 11 )
