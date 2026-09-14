contexts
livePages

	"The stack pages that hold frames. Most of a VM's pages are free most of the time: this
	image has thirty-two and one of them is in use."

	^ [ (OOPStackPageJournal newWith: self) pages reject: [ :each | each isFreePage ] ]
		  on: Error
		  do: [ :e | #(  ) ]
