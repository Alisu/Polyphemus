evaluating
evaluate: aSource below: aDepth

	"aSource evaluated in the frame aDepth below the debugger's, as the image's own debugger would:
	what it answers, which the image keeps for it to be read (#126)."

	| answer |
	answer := self answerOf: #evaluate with: { aSource. aDepth }.
	^ HeldEvaluation of: ((answer copyFrom: 2 to: answer size - 1) copyReplaceAll: '''''' with: '''') in: heldReading
