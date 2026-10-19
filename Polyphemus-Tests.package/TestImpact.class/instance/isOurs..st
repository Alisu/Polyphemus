testing
isOurs: aMethod

	^ [ aMethod package name beginsWith: 'Polyphemus' ] on: Error do: [ :e | false ]
