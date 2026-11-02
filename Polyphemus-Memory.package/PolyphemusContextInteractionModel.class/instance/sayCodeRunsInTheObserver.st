telling
sayCodeRunsInTheObserver

	"Said in the debugger's title until it closes: no image runs its code, the observer does."

	self owner ifNotNil: [ :code |
		code owner ifNotNil: [ :debugger |
			debugger withWindowDo: [ :window |
				(window title beginsWith: '[Code runs in the observer]') ifFalse: [
					window title: '[Code runs in the observer] ' , window title ] ] ] ]
