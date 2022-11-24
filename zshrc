# ~/.zshrc
stty -echo

ZDOTDIR="$HOME/.config/zsh"

export LANG=en_US.UTF-8

# add extra dirs to path. allows to separate script bundles into dirs
for _dir in $HOME/bin/extra/*(/N); do
	export PATH=$_dir:$PATH
done

export PATH=$HOME/bin:$HOME/.gem/ruby/2.3.0/bin:$PATH
if [ $UID -eq 0 ]; then
  export PATH=/root/bin:$PATH
fi


# Colors {{{
#use these in functions/shell scripts
export NC='\e[0m'
export white='\e[0;30m'
export WHITE='\e[1;30m'
export red='\e[0;31m'
export RED='\e[1;31m'
export green='\e[0;32m'
export GREEN='\e[1;32m'
export yellow='\e[0;33m'
export YELLOW='\e[1;33m'
export blue='\e[0;34m'
export BLUE='\e[1;34m'
export magenta='\e[0;35m'
export MAGENTA='\e[1;35m'
export cyan='\e[0;36m'
export CYAN='\e[1;36m'
export black='\e[0;37m'
export BLACK='\e[1;37m'

# these are for use in PROMPT
p_nc=$'%{\e[0m%}'
p_white=$'%{\e[0;30m%}'
p_WHITE=$'%{\e[1;30m%}'
p_red=$'%{\e[0;31m%}'
p_RED=$'%{\e[1;31m%}'
p_green=$'%{\e[0;32m%}'
p_GREEN=$'%{\e[1;32m%}'
p_yellow=$'%{\e[0;33m%}'
p_YELLOW=$'%{\e[1;33m%}'
p_blue=$'%{\e[0;34m%}'
p_BLUE=$'%{\e[1;34m%}'
p_magenta=$'%{\e[0;35m%}'
p_MAGENTA=$'%{\e[1;35m%}'
p_cyan=$'%{\e[0;36m%}'
p_CYAN=$'%{\e[1;36m%}' 
p_black=$'%{\e[0;37m%}'
p_white=$'%{\e[1;37m%}'

# colors in framebuffer!
if [[ $TERM = "linux" ]]; then
  ${HOME}/bin/parse_xdefaults.sh  
  clear #for background artifacting
fi

# some better colors for ls
eval "`dircolors ~/.config/zsh/dircolors`"

# }}}
# Keybindings {{{
bindkey -e
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[2~' overwrite-mode
bindkey "^[[7~" beginning-of-line # Pos1
bindkey "^[[8~" end-of-line # End
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

# HOWTO make your own:
# bindkey '<crtl+v key>' action
# for some actions run `bindkey`

# "cd......" ;)
_rationalise-dot() {
  # if [[ $LBUFFER = "cd "* ]]; then
    if [[ $LBUFFER = *.. ]]; then
      LBUFFER+=/..
    else
      LBUFFER+=.
    fi
  # else
  #   LBUFFER+=.
  # fi
}
zle -N _rationalise-dot
bindkey . _rationalise-dot

# add edit command line feature ("alt-e")
autoload edit-command-line
zle -N edit-command-line
bindkey '\ee' edit-command-line

# source: http://github.com/xfire/dotfiles/blob/master/.zsh/abbrev_expansion
# power completion / abbreviation expansion / buffer expansion
# see http://zshwiki.org/home/examples/zleiab for details
# less risky than the global aliases but powerful as well
# just type the abbreviation key and afterwards ',' to expand it
typeset -Ag abbreviations
abbreviations=(
    'dn'        '&>/dev/null '
    'dn1'       '1>/dev/null '
    'dn2'       '2>/dev/null '
    '21'        '2>&1 '
    'l'         '| less'
    'll'        '|& less'
    'g'         '| grep '
    'gi'        '| grep -i '
    'eg'        '| egrep '
    'h'         '| head '
    'hh'        '|& head '
    't'         '| tail '
    'tt'        '|& tail '
    'wc'        '| wc'
    'wcl'       '| wc -l'
    's'         '| sort'
    'su'        '| sort -u'
    'sl'        '| sort | less'
    'a'         '| awk '
    'x'         '| xargs'
    'xx'        '|& xargs'
    'hide'      "echo -en '\033]50;nil2\007'"
    'tiny'      'echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-80-*-*-c-*-iso8859-15\007"'
    'small'     'echo -en "\033]50;6x10\007"'
    'medium'    'echo -en "\033]50;-misc-fixed-medium-r-normal--13-120-75-75-c-80-iso8859-15\007"'
    'default'   'echo -e "\033]50;-misc-fixed-medium-r-normal-*-*-140-*-*-c-*-iso8859-15\007"'
    'large'     'echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-150-*-*-c-*-iso8859-15\007"'
    'huge'      'echo -en "\033]50;-misc-fixed-medium-r-normal-*-*-210-*-*-c-*-iso8859-15\007"'
    'smartfont' 'echo -en "\033]50;-artwiz-smoothansi-*-*-*-*-*-*-*-*-*-*-*-*\007"'
    'semifont'  'echo -en "\033]50;-misc-fixed-medium-r-semicondensed-*-*-120-*-*-*-*-iso8859-15\007"'
    'da'        'du -sch '
    'j'         'jobs -l '
    'co'        "./configure && make && sudo make install"
    'ch'        "./configure --help"
    'rw-'       'chmod 600 '
    '600'       'chmod u+rw-x,g-rwx,o-rwx '
    'rwx'       'chmod u+rwx '
    '700'       'chmod u+rwx,g-rwx,o-rwx '
    'r--'       'chmod u+r-wx,g-rwx,o-rwx '
    '644'       'chmod u+rw-x,g+r-wx,o+r-wx\n # 4=r,2=w,1=x '
    '755'       'chmod u+rwx,g+r-w+x,o+r-w+x '
    'cx'        'chmod +x '
    'de'        'export DISPLAY=:0.0'
    'd'         'DISPLAY=:0.0'
)

globalias() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH,,}
}

zle -N globalias
bindkey ",," globalias

# }}}
# Variables {{{
#export CDPATH=.:$HOME
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
# if type vimpager &>/dev/null; then
# 	export MANPAGER=vimpager
# 	export PERLDOC_PAGER=vimpager
# fi
export LESSCHARSET="UTF-8"
export LESS='-i -n -w -M -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'

# Less Colors for Man Pages
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# }}}
# Terminal title {{{
# also found somewhere
prompt_eof_setup() {
  # preexec() is run after you press enter on your command but before the command is run.
  preexec() {
    # define screen/terminal title with the current command (http://aperiodic.net/phil/prompt/)
    case $TERM in
      rxvt-*)
        printf '\33]2;%s\007' $1
      ;;
      screen*)
        local CMD=${1[(wr)^(*=*|sudo|ssh|exec|-*)]}
        printf '\ek%s\e\\' $CMD;;
    esac
  }
}

prompt_eof_setup "$@"
# }}}
# Prompt {{{ 

# necessary if you want to use functions in the prompt
# without this they wouldn't be run again
#precmd () {
# this has to be on the edge or you have some spaces in the prompt 
# if you have any workaround please tell
if [[ $UID != 0 ]]; then
  local username_color=$p_blue
else
  local username_color=$p_red
fi
local host_color=$p_GREEN
local path_color=$p_BLUE
PROMPT="${username_color}$USERNAME${p_nc}@${host_color}%m${p_nc} ${path_color}%~${p_nc} > "
#}

## Spelling prompt
SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '

# }}}
# Functions {{{ 

ctail() {
tail $@ | ccze -A -o nolookups
}
# add current time to a file
mbk() {
	mv -b "${1}" "$(echo $1 | sed -r "s/(.*)(\.|$)(.*)/\1_`date +%Y-%m-%d_%H%M%S`\2\3/")"
}

# easily make backups 
bk() {
	cp -br "${1}" "$(echo $1 | sed -r "s/(.*)(\.|$)(.*)/\1_`date +%Y-%m-%d_%H%M%S`\2\3/")"
}

# chpwd () => a function which is executed whenever the directory is changed
chpwd() {
  ls
}

#idea by Gigamo http://bbs.archlinux.org/viewtopic.php?pid=478094#p478094
ls () {
  /usr/bin/ls -rhbtF --color=auto $@ &&
#    echo "${MAGENTA}Files: ${BLUE}$(/bin/ls -l $@ | grep -v "^[l|d|total]" | wc -l) ${GREEN}--- ${MAGENTA}Directories: ${BLUE}$(/bin/ls -l $@ | grep "^d" | wc -l)${NC}"
}


password() {
  if [[ -z $1 ]]; then
    count=8
  else
    count="$1"
  fi
  echo $(< /dev/urandom tr -dc A-Za-z0-9 | head -c$count)
}

# from the grml zshrc iirc
hglob() {
  echo -e "
      /      directories
      .      plain files
      @      symbolic links
      =      sockets
      p      named pipes (FIFOs)
      *      executable plain files (0100)
      %      device files (character or block special)
      %b     block special files
      %c     character special files
      r      owner-readable files (0400)
      w      owner-writable files (0200)
      x      owner-executable files (0100)
      A      group-readable files (0040)
      I      group-writable files (0020)
      E      group-executable files (0010)
      R      world-readable files (0004)
      W      world-writable files (0002)
      X      world-executable files (0001)
      s      setuid files (04000)
      S      setgid files (02000)
      t      files with the sticky bit (01000)
   print *(m-1)          # Dateien, die vor bis zu einem Tag modifiziert wurden.
   print *(a1)           # Dateien, auf die vor einem Tag zugegriffen wurde.
   print *(@)            # Nur Links
   print *(Lk+50)        # Dateien die ueber 50 Kilobytes grosz sind
   print *(Lk-50)        # Dateien die kleiner als 50 Kilobytes sind
   print **/*.c          # Alle *.c - Dateien unterhalb von \$PWD
   print **/*.c~file.c   # Alle *.c - Dateien, aber nicht 'file.c'
   print (foo|bar).*     # Alle Dateien mit 'foo' und / oder 'bar' am Anfang
   print *~*.*           # Nur Dateien ohne '.' in Namen
   chmod 644 *(.^x)      # make all non-executable files publically readable
   print -l *(.c|.h)     # Nur Dateien mit dem Suffix '.c' und / oder '.h'
   print **/*(g:users:)  # Alle Dateien/Verzeichnisse der Gruppe >users<
   echo /proc/*/cwd(:h:t:s/self//) # Analog zu >ps ax | awk '{print $1}'<"
}

# swaps 2 files
swap() {
  if [[ -z $1 ]] || [[ -z $2 ]] || [[ $1 = "-h" ]]; then
    echo -e "${blue}Usage:$NC swap <file> <file>";
    echo -e "Swaps files";
    return 1
  fi
  if [[ -f $1 ]] && [[ -f $2 ]]; then
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
  else
    echo -e "${RED}Error:$NC One or more files don't exist"
    return 1  
  fi
}


hgrep() {
	mpgrep <$HISTFILE "$@" | less
}

hless() {
	less $HISTFILE
}

# mount devices with udev
sdm() { udisksctl mount -b /dev/$1; }
sdu() { udisksctl unmount -b /dev/$1; }

# }}}
# History {{{
export HISTFILE=$ZDOTDIR/histfile
export HISTSIZE=10000
export SAVEHIST=500000
readonly HISTFILE
# }}}
# Other ZSH options {{{
autoload -U colors
colors

autoload -U zmv

# .. -> cd ../
setopt autocd

# cd /etc/**/foo/blub searches ;)
setopt extendedglob

# push cds to directory stack
setopt auto_pushd

# don't push something twice
setopt pushd_ignore_dups

# don't kill jobs when exiting shell 
setopt no_hup
# and don't warn
setopt no_check_jobs

# show us when some command didn't exit with 0
setopt print_exit_value

# makepkg -g > PKGBUILD 
# zsh: file exists: PKGBUILD
#
# work saved ;)
setopt no_clobber

#setopt inc_append_history
setopt no_bg_nice
setopt share_history
setopt bang_hist
setopt extended_history
#setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_find_no_dups
setopt nohistverify
setopt prompt_subst
#setopt hist_fcntl_lock
setopt always_to_end

unsetopt auto_remove_slash

# show the output of time if commands takes longer than n secs (only user+system)
REPORTTIME=5

# allow comments in interactive shells
setopt interactivecomments

# ignore lines starting with a space
setopt hist_ignore_space

# disable XON/XOFF flow control (^s/^q)
stty -ixon

# }}}
# Aliases {{{
# better ask before we loose data
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'

# function to make ls look nice is below
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lld='ls -ld'

alias dd='dd status=progress'
alias mdstat='cat /proc/mdstat'
alias grep='grep --color'

alias vp='PAGER=vimpager'
alias v='vim'
alias l='less'

alias sc='screen'
alias scw='screen -X eval "chdir $PWD"'

alias g='git'
alias xc="xclip"
alias xcp="xclip -o | fb"

alias rscp='rsync --partial --progress'
alias scp='scp -o ControlPath=none'

alias mkdir='nocorrect mkdir'
alias wget='nocorrect noglob wget'

alias s='sudo '
alias sd='systemctl'
alias sc='systemctl'
alias jc='journalctl'
alias su='su -'
alias t='task'
alias wcl='wc -l'
alias vim='nvim'

# boot to windows
alias windows='sudo grub-reboot "Winblows"; reboot'
alias remount 'sudo umount -lf /mnt/data && mount /mnt/data'

# thinkpad charge tresholds
alias fullcharge='sudo set_battery_thresholds 0 96 100'
alias defaultcharge='sudo set_battery_thresholds 0 40 80'

# other random aliases
alias timeup="date && uptime | cut -d'p' -f2 | cut -d ',' -f1,2"
alias cpu='watch grep \"cpu MHz\" /proc/cpuinfo'

# }}}
# Completion stuff {{{
autoload -Uz compinit
compinit

unsetopt correct_all

# correct 7etc/foo to /etc/foo
# if anyone has a working solution for /etc7foo please contact me
function _7slash {
   if [[ $words[CURRENT] = 7(#b)(*)(#e) ]]
   then
     compadd -U -X 'Correct leading 7 to /' -f /$match[1]
   fi
}

zstyle :compinstall filename '$HOME/.zshrc'

# performance tweaks
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.zsh/cache
zstyle ':completion:*' use-perl on

# completion colours
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' completer _complete _match _approximate _7slash 
zstyle ':completion:*:match:*' original only

# allow more mistypes if longer command
#zstyle -e ':completion:*:approximate:*' \
#        max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# ignore completion for commands we don't have
zstyle ':completion:*:functions' ignored-patterns '_*'

# get rid of .class and .o files for vim
zstyle ':completion:*:vim:*' ignored-patterns '*.(class|o)'

# show menu when tabbing
zstyle ':completion:*' menu yes select

# better completion for kill
zstyle ':completion:*:*:kill:*' command 'ps --forest -u$USER -o pid,%cpu,tty,cputime,cmd'

# Provide more processes in completion of programs like killall:
zstyle ':completion:*:processes-names' command 'ps c -u ${USER} -o command | uniq'
compdef pkill=killall

# bugged with zsh 4.3.10 for whatever reason
zstyle ':completion:*' file-sort time
#zstyle ':completion:*' file-sort name

# Ignore same file on rm
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

zstyle ':completion:*:wine:*' file-patterns '*.(exe|EXE):exe'

# don't complete usernames (the come from localhost!)
zstyle ':completion:*:(ssh|scp):*' users

# complete ssh hostnames
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}%%:*}#\[}%\]}) || _ssh_hosts=()
[[ -r ~/.ssh/config ]] && _ssh_config_hosts=($(sed -rn 's/host\s+(.+)/\1/ip' "$HOME/.ssh/config" | grep -v "\*" )) || _ssh_config_hosts=()
hosts=(
        $HOST
        "$_ssh_hosts[@]"
        $_ssh_config_hosts[@]
        localhost
    )
zstyle ':completion:*:hosts' hosts $hosts

# automagic url quoter
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# e.g. ls foo//bar -> ls foo/bar
zstyle ':completion:*' squeeze-slashes true

# if in foo/bar don't show bar when cd ../<TAB>
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# Prevent lost+found directory from being completed
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'

# ignore case when completing
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# make some stuff look better
# from: http://ft.bewatermyfriend.org/comp/zsh/zshrc.d/compsys.html
zstyle ':completion:*:descriptions' format "- %{${fg[yellow]}%}%d%{${reset_color}%} -"
zstyle ':completion:*:messages'     format "- %{${fg[cyan]}%}%d%{${reset_color}%} -"
zstyle ':completion:*:corrections'  format "- %{${fg[yellow]}%}%d%{${reset_color}%} - (%{${fg[cyan]}%}errors %e%{${reset_color}%})"
zstyle ':completion:*:default'      \
	select-prompt \
	"%{${fg[yellow]}%}Match %{${fg_bold[cyan]}%}%m%{${fg_no_bold[yellow]}%}  Line %{${fg_bold[cyan]}%}%l%{${fg_no_bold[red]}%}  %p%{${reset_color}%}"
zstyle ':completion:*:default'      \
	list-prompt   \
	"%{${fg[yellow]}%}Line %{${fg_bold[cyan]}%}%l%{${fg_no_bold[yellow]}%}  Continue?%{${reset_color}%}"
zstyle ':completion:*:warnings'     \
	format        \
	"- %{${fg_no_bold[red]}%}no match%{${reset_color}%} - %{${fg_no_bold[yellow]}%}%d%{${reset_color}%}"
zstyle ':completion:*' group-name ''

# manual pages are sorted into sections
# from: http://ft.bewatermyfriend.org/comp/zsh/zshrc.d/compsys.html
zstyle ':completion:*:manuals'       separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections   true

### highlight the original input.
    zstyle ':completion:*:original' \
        list-colors "=*=$color[red];$color[bold]"

### highlight words like 'esac' or 'end'
    zstyle ':completion:*:reserved-words' \
        list-colors "=*=$color[red]"

### colorize hostname completion
    zstyle ':completion:*:*:*:*:hosts' \
        list-colors "=*=$color[cyan];$color[bg-black]"

### colorize username completion
    zstyle ':completion:*:*:*:*:users' \
        list-colors "=*=$color[red];$color[bg-black]"

### colorize processlist for 'kill'
    zstyle ':completion:*:*:kill:*:processes' \
        list-colors "=(#b) #([0-9]#) #([^ ]#)*=$color[none]=$color[yellow]=$color[green]"

# complete my little rc function (archlinux startscripts)
function _rc () { 
  case $CURRENT in
    2) compadd $(find /etc/rc.d/ -maxdepth 1 -type f -executable -printf '%f ');;
    3) compadd $(/etc/rc.d/$words[2] 2> /dev/null | grep -i usage | sed 's/.*{\(.*\)}/\1/; s/|/ /g');;
  esac
}
compdef _rc rc

# easier way to use sshfs ;)
function _ssh-mount () { 
  compadd $(cat ${HOME}/bin/ssh-mount.sh | egrep "Servers:.*" | sed "s#echo \-e \"\${green}Servers\:\$NC##g; s#\"\;##g; s#,##g") 
}
compdef _ssh-mount ssh-mount.sh

function _wake () {
  compadd $(wake)
}
compdef _wake wake


### BEGIN task auto-completion ###
fpath=($fpath /usr/local/share/doc/task/scripts/zsh)
autoload -Uz compinit
compinit -i

# OPTIONAL
# be verbose, i.e. show descriptions
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'

# group by tag names
zstyle ':completion:*' group-name ''

# OPTIONAL
# colors
autoload colors && colors

# The magic works as follows:
# * (#b) activates the use of brackets within regular expressions
# * the part to the next = character is a regular expression to be matched
# * color codes are separated with = characters
# * the first code is the default color
# * the other codes define the colors of the 1st, 2nd, etc. pair of brackets
# (See http://zshwiki.org/home/examples/compsys/colors for a detailed description.)

# You can use zstyle to configure the completion behaviour.
# Here is an example of adding colors to the list of suggestions:

# zstyle ':completion:*:*:task:*:arguments' list-colors "=(#b) #([^-]#)*=$color[cyan]=$color[bold];$color[blue]"
# zstyle ':completion:*:*:task:*:default' list-colors "=(#b) #([^-]#)*=$color[cyan]=$color[green]"
# zstyle ':completion:*:*:task:*:values' list-colors "=(#b) #([^-]#)*=$color[cyan]=$color[bold];$color[red]"
# zstyle ':completion:*:*:task:*:commands' list-colors "=(#b) #([^-]#)*=$color[cyan]=$color[yellow]"

### END task auto-completion ###

# }}}
# Greetings {{{
# }}}
# {{{ Other stuff that doesn't fit anywhere else
stty -ctlecho

# machine dependent stuff
source $ZDOTDIR/zshrc.local

if [[ -e $HOME/git/dotfiles/.zsh/zsh-syntax-highlighting-git/zsh-syntax-highlighting.zsh ]]; then
	source $HOME/git/dotfiles/.zsh/zsh-syntax-highlighting-git/zsh-syntax-highlighting.zsh
fi

#if type keychain >/dev/null; then
	#eval $(keychain --eval -q)
#fi

# }}}
#
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Show again
stty echo
# sinnloser cmt
# vim: set ft=zsh:
