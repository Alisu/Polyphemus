reading
census

	"Instances and bytes of each class, from the raw headers of an image file."

	^ census ifNil: [ ToolCallFailed signal: 'census reads image files; this handle is not one' ]
