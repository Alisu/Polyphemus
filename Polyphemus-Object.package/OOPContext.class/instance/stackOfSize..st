context protocol
stackOfSize: anInteger

	| contexts current |
	contexts := OrderedCollection new.
	current := self.
	[ current notNil and: [ contexts size < anInteger ] ] whileTrue: [
		contexts add: current.
		current := current sender ].
	^ contexts
