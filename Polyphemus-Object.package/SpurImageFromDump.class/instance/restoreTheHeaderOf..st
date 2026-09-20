writing
restoreTheHeaderOf: anOop

	"Whether this was compiled code holding its CogMethod where its header belongs, in which
	case the header is back (#3)."

	| scanner |
	scanner := dumped raw scanner.
	((scanner formatIn: (scanner headerAt: anOop)) >= 24 and: [
		 ((scanner slotOf: anOop at: 1) bitAnd: 7) ~= 1 ]) ifFalse: [ ^ false ].
	dumped memory
		storePointerUnchecked: 0
		ofObject: anOop
		withValue: (self cogLayout methodHeaderOf: anOop).
	^ true
