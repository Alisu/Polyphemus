debugger protocol
selector

	"The selector as a symbol of this image, so the debugger's menus can use it. It
	names a method of another image, which is worth remembering before acting on it."

	^ [ self oopSelector asString asSymbol ] on: Error do: [ :e | #unknownSelector ]
