handling
tellWith: aUIManager

	"Say why, in a message that stays until OK (#142)."

	aUIManager alert: self messageText title: 'Refused'
