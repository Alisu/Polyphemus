inspection
storeTyped: aString inItemKeyed: aKey telling: aUIManager

	"A value typed into the Oop tab: stored, or why not said in a message that stays until OK (#142)."

	[ self store: aString inItemKeyed: aKey ]
		on: Error
		do: [ :error | aUIManager alert: error messageText title: 'Not stored' ]
