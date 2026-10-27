*Polyphemus-Object
valueThenLetGo: aLetGoBlock

	"My value, then aLetGoBlock run once however that ends: on an error, a halt or a warning, before it
	is shown again (#96), and nothing more of me if it is proceeded, the process running again (#103)."

	| done letGo |
	done := false.
	letGo := [ done ifFalse: [ done := true. aLetGoBlock value ] ].
	^ [ [ self value ] on: Error , Halt , Warning do: [ :error | letGo value. error copy signal. nil ] ] ensure: letGo
