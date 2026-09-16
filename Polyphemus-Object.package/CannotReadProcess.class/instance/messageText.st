accessing
messageText

	^ reason = #theOperatingSystemRefused
		  ifTrue: [
			  'cannot read process ' , pid asString
			  , ': the operating system refused. Yama''s ptrace_scope is 1 on most machines, '
			  , 'which lets only an ancestor read another process. Start the image from here, '
			  , 'or lower /proc/sys/kernel/yama/ptrace_scope, or run as root.' ]
		  ifFalse: [ 'cannot read process ' , pid asString , ': ' , reason asString ]
