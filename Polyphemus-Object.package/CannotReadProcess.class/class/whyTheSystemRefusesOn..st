explaining
whyTheSystemRefusesOn: aSystem

	"What the operating system wants before it lets a process be read, said as on that system
	('Linux', 'MacOS' or 'Windows', as PolyphemusHost names them)."

	aSystem = 'MacOS' ifTrue: [
		^ 'macOS gives a process''s task port to an observer run as root only, and never for a '
		  , 'system program: run the observer with sudo, and give the pid of the Pharo VM itself '
		  , '(Pharo.app/Contents/MacOS/Pharo), not of the script that started it.' ].
	aSystem = 'Windows' ifTrue: [
		^ 'Windows lets a process be opened by the same user, or by an administrator: run the '
		  , 'observer as the user who started the image, or as administrator.' ].
	^ 'Yama''s ptrace_scope is 1 on most machines, which lets only an ancestor read another '
	  , 'process. Start the image from here, or lower /proc/sys/kernel/yama/ptrace_scope, or run as root.'
