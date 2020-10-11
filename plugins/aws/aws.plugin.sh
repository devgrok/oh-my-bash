# aws.plugin.sh
# Author: Michael Anckaert <michael.anckaert@sinax.be>
# Based on oh-my-zsh AWS plugin
#
# command 'agp' returns the selected AWS profile (aws get profile)
# command 'asp' sets the AWS profile to use (aws set profile)
#

export AWS_HOME=~/.aws

function agp {
  echo $AWS_DEFAULT_PROFILE
}

function asp {
  local rprompt=${RPROMPT/<aws:$(agp)>/}
  if [[ -z "$1" ]]; then
    unset AWS_DEFAULT_PROFILE AWS_PROFILE AWS_EB_PROFILE
    echo AWS profile cleared.
    return
  fi  

  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
}

function aws_profiles() {
  [[ -r "${AWS_CONFIG_FILE:-$HOME/.aws/config}" ]] || return 1
  grep '\[profile' "${AWS_CONFIG_FILE:-$HOME/.aws/config}"|sed -e 's/.*profile \([a-zA-Z0-9@_\.-]*\).*/\1/'
}

function _aws_profiles() {  
  local cur prev opts;
  _init_completion -n : || return;
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  #_init_completion -n : || return;
  COMPREPLY=( $(compgen -W "$(aws_profiles)" -- ${cur} ) )
}
complete -F _aws_profiles asp

