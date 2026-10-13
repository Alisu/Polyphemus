*Polyphemus-Edition-Pharo13
forThisHost

	"Loaded on a Pharo 13 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusMadeFor hostOfPharo: 13) targets: #( 13 )
