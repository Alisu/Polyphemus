painting
closeOpenPixel

	"The open pixel's winner, kept against what an earlier walk left there."

	| best |
	openPixel ifNil: [ ^ self ].
	best := 0.
	1 to: openCounts size - 1 do: [ :code |
		(openCounts at: code + 1) > 0 ifTrue: [
			((self rankOf: code) > (self rankOf: best) or: [
				 (self rankOf: code) = (self rankOf: best) and: [ (openCounts at: code + 1) > (openCounts at: best + 1) ] ])
				ifTrue: [ best := code ] ] ].
	self offer: best bytes: (openCounts at: best + 1) object: (openFirsts at: best + 1) at: openPixel.
	openPixel := nil
