accessing
messageText

	reason = #itIsThisVeryImage ifTrue: [
		^ 'cannot read process ' , pid asString
		  , ': it is this very image; reading or holding it would stop the observer itself (#117).' ].
	^ reason = #theOperatingSystemRefused
		  ifTrue: [
			  'cannot read process ' , pid asString , ': the operating system refused. '
			  , (self class whyTheSystemRefusesOn: PolyphemusHost currentOS) ]
		  ifFalse: [ 'cannot read process ' , pid asString , ': ' , reason asString ]
