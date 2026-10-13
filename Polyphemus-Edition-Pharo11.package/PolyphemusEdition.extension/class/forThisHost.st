*Polyphemus-Edition-Pharo11
forThisHost

	"Loaded on a Pharo 11 host only (BaselineOfPolyphemus); what it reads is what its suite checks:
	Pharo 10 and Pharo 11 images, on VM 10."

	^ self host: (PolyphemusMadeFor hostOfPharo: 11) targets: #( 10 11 )
