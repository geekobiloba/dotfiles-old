# vim: filetype=bash

# Create SSH config from Ansible inventory.
# Needs jq and ansible-inventory.

# This function runs in a subshell;
# any nested functions won't leak to its parent shell.
ai2sc()(
  local SSHOPTS

  # recursive
  _ai2sc_r(){
    local  INVFILE="$1"
    local PBOOKDIR="$2"

    local JSON
    local SSHCONF_HEAD
    local SSHCONF_BODY

    if [ -n "$INVFILE" ] && [ -n "$PBOOKDIR" ] ; then
      SSHCONF_HEAD+="$(
        echo "# From Ansible inventory: $( readlink -f "$INVFILE" )"
        echo "# and playbook directory: $( readlink -f "$PBOOKDIR" )"
      )"

      JSON="$(
        env \
          ANSIBLE_LOAD_CALLBACK_PLUGINS=1 \
          ANSIBLE_STDOUT_CALLBACK=json \
          ANSIBLE_CALLBACK_WHITELIST=json \
          ansible all \
            -i "$INVFILE" \
            --playbook-dir "$PBOOKDIR" \
            -m debug \
            -a '{ "msg": { "host": "{{ansible_host}}", "port": "{{ansible_port | default(22)}}", "user": "{{ansible_user | default("root")}}" } }'
      )"
    elif [ -n "$INVFILE" ] ; then
      SSHCONF_HEAD+="$(
        echo "# From Ansible inventory: $( readlink -f "$INVFILE" )"
      )"

      JSON="$(
        env \
          ANSIBLE_LOAD_CALLBACK_PLUGINS=1 \
          ANSIBLE_STDOUT_CALLBACK=json \
          ANSIBLE_CALLBACK_WHITELIST=json \
          ansible all \
            -i "$INVFILE" \
            -m debug \
            -a '{ "msg": { "host": "{{ansible_host}}", "port": "{{ansible_port | default(22)}}", "user": "{{ansible_user | default("root")}}" } }'
      )"
    else
      error_99
    fi

    
    ferror "ERROR: ansible-inventory exit code: $?"

    if [ -n "$JSON" ] ; then
      SSHCONF_BODY+="$(
        printf '%s' "$JSON" \
        | jq -r \
            --arg SSHOPTS "$SSHOPTS" '
            .plays[].tasks[].hosts |
            to_entries[]           | "
Host \(
    if .key != .value.msg.host and .value.msg.host != null then
      .key + " " + .value.msg.host
    else
      .key
    end
)
  Hostname \( .value.msg.host )
  Port     \( .value.msg.port )
  User     \( .value.msg.user )
\(
  if $SSHOPTS != "" then
    $SSHOPTS
  else
    ""
  end
)
" '
      )"
    else
      iferror "ansible generates empty JSON"
    fi

    iferror "ERROR: jq exit code: $?"

    {
      echo "$SSHCONF_HEAD"
      printf '%s\n' "$SSHCONF_BODY"
    } \
    | cat -s # squeeze trailing blank lines
  }

  # simple
  _ai2sc_s(){
    local  INVFILE="$1"
    local PBOOKDIR="$2"

    local JSON
    local SSHCONF_HEAD
    local SSHCONF_BODY

    if [ -n "$INVFILE" ] && [ -n "$PBOOKDIR" ] ; then
      SSHCONF_HEAD+="$(
        echo "# From Ansible inventory: $( readlink -f "$INVFILE" )"
        echo "# and playbook directory: $( readlink -f "$PBOOKDIR" )"
      )"

      JSON="$(
        ansible-inventory --list \
          -i "$INVFILE" \
          --playbook-dir "$PBOOKDIR"
      )"
    elif [ -n "$INVFILE" ] ; then
      SSHCONF_HEAD+="$(
        echo "# From Ansible inventory: $( readlink -f "$INVFILE" )"
      )"

      JSON="$(
        ansible-inventory --list \
          -i "$INVFILE"
      )"
    else
      error_99
    fi

    iferror "ERROR: ansible-inventory exit code: $?"

    if [ -n "$JSON" ] ; then
      SSHCONF_BODY+="$(
        printf '%s' "$JSON" \
        | jq -r \
            --arg SSHOPTS "$SSHOPTS" '
            ._meta.hostvars |
            to_entries[]    | "
Host \(
    if .key != .value.hostname and .value.hostname != null then
      .key + " " + .value.hostname
    else
      .key
    end
)
  Hostname \( .value.ipv4_addr // .value.ansible_host // .key )
  Port     \( .value.ansible_port // "22" )
  User     \( .value.ansible_user // "root" )
\(
  if $SSHOPTS != "" then
    $SSHOPTS
  else
    ""
  end
)
" '
      )"
    else
      iferror "ansible-inventory generates empty JSON"
    fi

    iferror "ERROR: jq exit code: $?"

    {
      echo "$SSHCONF_HEAD"
      printf '%s\n' "$SSHCONF_BODY"
    } \
    | cat -s # squeeze trailing blank lines
  }

  sshopt(){
    shift $1

    SSHOPTS="$(
      for o in "$@" ; do
        echo "  $o"
      done
    )"
  }

  usage(){
    cat <<-"EOF"
			ai2sc - Parse Ansible inventory file into SSH config

			Usage

			  ai2sc FLAG1
			  ai2sc [FLAG2] INVENTORY_FILE [PLAYBOOK_DIR] [FLAG3 SSH_OPTS]

			Options

			  FLAG1
			    -h
			    --help

			    Show this help.

			  FLAG2
			    -r
			    --recursive

			    Expand variable recursively, which is useful for dynamic
          inventories. This option may give warning, which can be
          safely ignored.

			  FLAG3
			    -o
			    --option

			    Show this help.

			  SSH_OPTS
			    SSH_OPT1 [SSH_OPT2] [SSH_OPT3] ... [SSH_OPTn]

			  SSH_OPTn
			    SSH configuration option; each may be separated by whitespaces
			    or optional whitespace and exactly one '='.  The latter format
			    is useful to avoid the need to quote whitespace.
EOF
  }

  error_1(){
    usage
    return 1
  }

  error_2(){
    echo "ERROR: Unrecognized option: $1"
    return 2
  }

  error_3(){
    echo "ERROR: No such file or directory: $1"
    return 3
  }

  error_99(){
    echo "ERROR: Unknown error"
    return 99
  }

  iferror(){
    local LASTEXIT=$?
    if [ $? -ne 0 ] ; then
      echo ${1:-"Last exit code: $LASTEXIT"}
      return ${2:-99}
    fi
  }

  case "$1" in
    -h|--help)
      usage
    ;;
    -r|--recursive)
      shift
      if [ -f "$1" ] ; then
        case "$2" in
          -o|--option)
            sshopt 3 "$@"
            _ai2sc_r "$1"
          ;;
          -*)
            error_2 "$2"
          ;;
          "")
            _ai2sc_r "$1"
          ;;
          *)
            if [ -d "$2" ] ; then
              case "$4" in
                -o|--option)
                  sshopt 4 "$@"
                  _ai2sc_r "$1" "$2"
                ;;
                -*)
                  error_2 "$4"
                ;;
                "")
                  #_ai2sc_r "$1" "$2"
                  _ai2sc_r "$1" "$2"
                ;;
                *)
                  error_1
                ;;
              esac
            else
              if [ -f "$2" ] ; then
                error_1
              else
                error_3 "$2"
              fi
            fi
          ;;
        esac
      else
        if [ -d "$1" ] ; then
          error_1
        else
          error_3 "$1"
        fi
      fi
    ;;
    -*)
      error_2 "$1"
    ;;
    "")
      error_1
    ;;
    *)
      if [ -f "$1" ] ; then
        case "$2" in
          -o|--option)
            sshopt 3 "$@"
            _ai2sc_s "$1"
          ;;
          -*)
            error_2 "$2"
          ;;
          "")
            _ai2sc_s "$1"
          ;;
          *)
            if [ -d "$2" ] ; then
              case "$3" in
                -o|--option)
                  sshopt 4 "$@"
                  _ai2sc_s "$1" "$2"
                ;;
                -*)
                  error_2 "$3"
                ;;
                "")
                  #_ai2sc_s "$1" "$2"
                  _ai2sc_s "$1" "$2"
                ;;
                *)
                  error_1
                ;;
              esac
            else
              if [ -f "$2" ] ; then
                error_1
              else
                error_3 "$2"
              fi
            fi
          ;;
        esac
      else
        if [ -d "$1" ] ; then
          error_1
        else
          error_3 "$1"
        fi
      fi
    ;;
  esac
)

