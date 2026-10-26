asking
call: aHelperName with: someValues

	"Ask the image to run one of its agent's helpers (PolyphemusAgent helpersSource) on those
	values, written as literals: nothing of their text pasted into the request (#118)."

	^ channel ask: '(self at: ' , aHelperName storeString , ') valueWithArguments: ' , someValues asArray storeString , '. nil'
