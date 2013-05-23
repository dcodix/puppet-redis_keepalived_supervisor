
node default {

}

node "vmr01.adm.int" {
	import "supervisord"
	import "rediskeepalived"

        class { "rediskeepalived": }
	rediskeepalived::config { '6379': }
        rediskeepalived::config { '6380': }
        rediskeepalived::config { '6381': }
        rediskeepalived::config { '6383': }
        rediskeepalived::config { '6385': }
        rediskeepalived::config { '6386': }
        rediskeepalived::config { '6387': }
        rediskeepalived::config { '6388': }
	class { "supervisord": }
	supervisord::config { 'keepalived.ini': }
	supervisord::config { 'redis.ini': }
}
