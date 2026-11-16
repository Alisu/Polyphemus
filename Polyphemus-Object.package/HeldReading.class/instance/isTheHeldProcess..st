private
isTheHeldProcess: aReifiedObject

	"Whether what was found where the held process was, or is looked for, is it: an object, of that
	hash, a Process. What is there after a collection may be anything, a forwarder or what does
	not read: not it."

	^ aReifiedObject notNil and: [
		  aReifiedObject isObjectOop and: [
			  [ aReifiedObject oopHash = hash and: [ aReifiedObject oopClassName = 'Process' ] ]
				  on: PolyphemusError
				  do: [ :refusal | false ] ] ]
