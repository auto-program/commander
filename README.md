COMMANDER
===

Most Powerful Shell Script Command Framework for Developers.Be your own commander, have fun :)

# Install

````
$: git clone git@github.com:auto-program/commander.git

$: cd commmander

$: ./bootstrap.sh
````

# Add a new custom command

````
$: cmd -h

	                                                  __
	  _________  ____ ___  ____ ___  ____ _____  ____/ /__  _____
	 / ___/ __ \/ __ \__ \/ __ \__ \/ __ \/ __ \/ __  / _ \/ ___/
	/ /__/ /_/ / / / / / / / / / / / /_/ / / / / /_/ /  __/ /
	\___/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/\___/_/


commander [cmd] version 0.0.3

cmd-add        add a custom command
cmd-del        remove a custom command
cmd-edit       edit a custom command
cmd-github     github user | repo management
cmd-help       help
cmd-list       list all custom commands
cmd-lock       lock screen command for mac
cmd-mysql      docker mysql service
cmd-net        docker network management
cmd-reboot     reboot command for mac
cmd-redis      docker redis service
cmd-shutdown   shutdown command for mac
cmd-ssh        ssh key | connection management
cmd-sshd       docker sshd service
cmd-vpn        pppoe service command for mac

# add a new custom command [demo]
$: cmd add demo

# edit cmd-demo script
$: cmd edit demo

# execute cmd-demo
$: cmd-demo

# or execute cmd-demo in another way
$: cmd demo

# remove custom command demo
$: cmd del demo

````

# Most Useful Commands for Mac User

> cmd-lock 

shell command for mac screen lock

> cmd-reboot

shell command for reboot your mac

> cmd-shutdown

shell command for shutdown your mac

> cmd-vpn start [vpn-name]

shell command for quick start vpn network

> cmd-ssh

shell command for ssh keys & ssh remote server connections management.

# Most Useful Commands for Developer

> cmd net

docker network command.

```` 
$: cmd net create

$: cmd net ls

$: cmd net remove

````

> cmd sshd

````
$: cmd sshd setup

$: cmd sshd start

$: cmd net ls

$: cmd sshd stop

````

you can use *cmd ssh con* to create a connect to the cmd-sshd server.

> cmd mysql

````
$: cmd mysql setup

$: cmd mysql start

$: cmd net ls

$: cmd mysql cli

$: cmd mysql stop
````


> cmd redis

````
$: cmd redis setup

$: cmd redis start

$: cmd net ls

$: cmd redis cli

$: cmd redis stop
````

> cmd github
