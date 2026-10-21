accessing
messageText

	^ 'cannot read ' , level asString , ': ' , reason asString
	  , (detail ifNil: [ '' ] ifNotNil: [ ' (' , detail , ')' ])
