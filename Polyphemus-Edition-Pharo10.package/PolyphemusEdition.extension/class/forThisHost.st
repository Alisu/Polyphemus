*Polyphemus-Edition-Pharo10
forThisHost

	"Loaded on a Pharo 10 host only (BaselineOfPolyphemus); what it reads is what its suite checks."

	^ self host: (PolyphemusMadeFor hostOfPharo: 10) targets: #( 10 )
