*Polyphemus-Object
valueThenLetGo: aLetGoBlock

	"My value, then aLetGoBlock run once however that ends: on an error, before the error goes
	on, so that a debugger open on it never keeps a held process stopped (#96)."

	| done letGo |
	done := false.
	letGo := [ done ifFalse: [ done := true. aLetGoBlock value ] ].
	^ [ [ self value ] on: Error do: [ :error | letGo value. error pass ] ] ensure: letGo
