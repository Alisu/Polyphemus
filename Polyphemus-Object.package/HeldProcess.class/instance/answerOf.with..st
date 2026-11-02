asking
answerOf: aHelperName with: someValues

	"What one of the image's agent helpers answers on those values, written as literals (#118)."

	^ channel ask: '(self at: ' , aHelperName storeString , ') valueWithArguments: ' , someValues asArray storeString
