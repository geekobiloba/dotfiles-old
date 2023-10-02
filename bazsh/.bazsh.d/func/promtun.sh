# Manage SSH tunnel to prometheus host

promtun(){(
  local XFLAG=0
  local TPORT=9090
  local PPORT=9090
  local SSECS=300
  local LHOST=localhost
  local PHOST
  local IPFAM

  _help(){
    cat <<EOF
promtun - Manage SSH tunnel to Prometheus host

USAGE

  promtun  -m {{host}} [-p {{pport}}] [-t {{tport}}] [-s {{secs}}] [-4|-6]

  promtun  (-l|-k|-h)

OPTIONS

  -m  {{host}}   Prometheus hostname or IP

  -p  {{pport}}  Prometheus host port (default: 9090)

  -t  {{tport}}  Local tunnel port (default: 9090)

  -s  {{secs}}   Sleep duration in second (default: 300)

  -4         IPv4 only

  -6         IPv6 only

  -l         List tunnel

  -k         Kill all tunnels

  -h         Show this help

NOTES

This function is a helper when you want to use Promql CLI,
but your Prometheus is behind a proxy or firewall,
and all your access is an SSH.

See <https://github.com/nalbury/promql-cli> to setup.
EOF
  } # _help

  _list_tun(){
    pgrep -fl 'ssh.*sleep'
    exit
  } # _list_tun

  _kill_tun(){
    pkill -fl 'ssh.*sleep'
    exit
  } # __kill_tun

  _open_tun(){
    case "$IPFAM" in
      (4) LHOST='127.0.0.1' ;;
      (6) LHOST='[::1]'     ;;
    esac

    ssh -fnL $TPORT:$LHOST:$PPORT $PHOST sleep $SSECS
  } # _open_tun

  # Process arguments
  while getopts :m:p:t:s:46lkh o ; do
    case "$o" in
      (m  ) PHOST=$OPTARG XFLAG=1 ;;
      (p  ) PPORT=$OPTARG         ;;
      (t  ) TPORT=$OPTARG         ;;
      (s  ) SSECS=$OPTARG         ;;
      (4|6) IPFAM=$o              ;;
      (l  ) _list_tun             ;;
      (k  ) _kill_tun             ;;
      (h  )
        _print_help
        exit
        ;;
      (*  )
        _print_help_err
        exit 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  # Main
  if [ $XFLAG -eq 1 ] ; then
    _open_tun
  else
    _print_help_err
    return 1
  fi
)} # promtun

