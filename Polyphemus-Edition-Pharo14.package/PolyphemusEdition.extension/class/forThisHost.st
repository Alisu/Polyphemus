*Polyphemus-Edition-Pharo14
forThisHost

	"Loaded on a Pharo 14 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusMadeFor hostOfPharo: 14) targets: #( 14 )
