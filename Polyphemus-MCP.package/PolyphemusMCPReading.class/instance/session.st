reading
session

	"The debug session of a held image, which steps it."

	^ session ifNil: [ ToolCallFailed signal: handle asString , ' is ' , kind , ', not a held image: hold one with hold' ]
