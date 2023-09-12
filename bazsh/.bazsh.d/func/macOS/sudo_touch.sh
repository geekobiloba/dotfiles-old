# macOS - Set sudo to use Touch ID
#
# Must be reexecuted after every OS update

sudo_touch(){
  local PAM_SUDO=/etc/pam.d/sudo

  sudo chmod u+w $PAM_SUDO

  sudo /usr/bin/sed -ri '' \
    -e '/pam_tid\.so/d' \
    -e 's/(auth)([[:space:]]+)(sufficient)([[:space:]]+)(pam_smartcard\.so)/\1\2\3\4pam_tid.so\n\1\2\3\4\5/' \
    $PAM_SUDO

  sudo chmod u-w $PAM_SUDO
}

