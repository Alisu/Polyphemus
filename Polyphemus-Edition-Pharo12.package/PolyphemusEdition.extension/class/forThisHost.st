*Polyphemus-Edition-Pharo12
forThisHost

	"Loaded on a Pharo 12 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusMadeFor hostOfPharo: 12) targets: #( 12 )
