private
isTheHeldProcess: aReifiedObject

	^ aReifiedObject notNil and: [
		  [ aReifiedObject oopHash = hash and: [ aReifiedObject oopClassName = 'Process' ] ]
			  on: Error
			  do: [ :e | false ] ]
