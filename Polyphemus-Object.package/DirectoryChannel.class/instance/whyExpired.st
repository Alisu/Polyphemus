private
whyExpired

	| limit |
	limit := [ (directory / 'expired') contents trimBoth asNumber ] on: Error do: [ :e | nil ].
	^ 'the hold ended after '
	  , (limit ifNil: [ 'its limit' ] ifNotNil: [
			   limit >= 60000
				   ifTrue: [ (limit // 60000) printString , ' minutes' ]
				   ifFalse: [ (limit / 1000) asFloat printString , ' seconds' ] ])
	  , ' without a request, and the image went on: hold it again (Polyphemus holdLimit:)'
