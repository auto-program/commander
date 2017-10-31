COMMANDER
===

Most Powerful Shell Script Command Framework for Developers.Be your own commander, have fun :)

# Install

````
$: git clone git@github.com:auto-program/commander.git
$: cd commmander
$: ./bootstrap.sh
please input your editor [default: vi]: code
please input your data root directory [default:/Users/liujianping/commander/volumns]:

============================================================
 NOTE
============================================================
please execute:
    echo 'source /Users/liujianping/commander/command.sh' >> ~/.bash_profile
    source ~/.bash_profile
or for zsh:
    echo 'autoload bashcompinit' >> ~/.zshrc
    echo 'bashcompinit' >> ~/.zshrc
    echo 'source /Users/liujianping/commander/command.sh' >> ~/.zshrc
    source ~/.zshrc
run "cmd -h" to print all available functions
````

# Add a new customer command

````
$: cmd -h

	                                                  __
	  _________  ____ ___  ____ ___  ____ _____  ____/ /__  _____
	 / ___/ __ \/ __ \__ \/ __ \__ \/ __ \/ __ \/ __  / _ \/ ___/
	/ /__/ /_/ / / / / / / / / / / / /_/ / / / / /_/ /  __/ /
	\___/\____/_/ /_/ /_/_/ /_/ /_/\__,_/_/ /_/\__,_/\___/_/


commander [cmd] version 0.0.2

cmd-add        新增子命令
cmd-del        删除子命令
cmd-edit       编辑子命令
cmd-github     GitHub管理
cmd-help       帮助
cmd-list       列举子命令
cmd-lock       Mac 锁屏
cmd-mysql      基于docker的MySQL服务
cmd-net        基于docker的网络环境
cmd-reboot     Mac 重启
cmd-redis      基于docker的Redis服务
cmd-shutdown   Mac 关机
cmd-ssh        SSH密钥与远程主机管理
cmd-sshd       基于docker的sshd服务
cmd-vpn        启停VPN服务命令

# add a new custom command [demo]
$: cmd add demo

# edit cmd-demo script
$: cmd edit demo

# execute cmd-demo
$: cmd-demo

or 

# execute cmd-demo in another way
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

> cmd sshd

> cmd mysql

> cmd redis

> cmd github
