accessing
metacelloAttribute

	"How the baseline names this host for Metacello, which names Pharo versions but no operating
	system: the attribute that picks its Polyphemus-Host package."

	^ (os asLowercase , '-' , cpu asLowercase) asSymbol
