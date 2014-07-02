#Android
export ANDROID_HOME=/usr/local/opt/android-sdk

PATH="$PATH:/usr/local/opt/android-sdk/tools"
PATH="$PATH:/usr/local/opt/android-sdk/platform-tools"
#PATH="$PATH:/usr/local/opt/android-sdk/build-tools/18.0.1"
PATH="$PATH:/opt/ruby-enterprise-1.8.7-2010.02/bin"
PATH="$PATH:/Users/patrick/.m2/repository"
export PATH

export JAVA_HOME=`/usr/libexec/java_home -v 1.6`
export PATH=$PATH:/opt/ruby-enterprise-1.8.7-2010.02/bin
# Alias'
alias gs="git status"
alias gd="git diff"
alias gdc="git diff --cached"
alias gl="git log"
alias l="ls -la"
alias cdandroid="cd /Users/patrick/code/android"
alias cdautomation="cd /Users/patrick/code/automation"
alias cdios="cd /Users/patrick/code/ios-app"
alias androidemulator="emulator -avd Android4.3"
alias androidhierarchy="/usr/local/opt/android-sdk/tools/hierarchyviewer"
alias androidinspector="/usr/local/opt/android-sdk/tools/uiautomatorviewer"
alias runandroidtests="cd ~/code/automation/GroupMeAppium/ && mvn -DappName=GroupMe-production-debug-unaligned.apk -Dtest=test.java.com.groupme.appium.android.suites.*Test surefire-report:report"
alias runiphonetests="cd ~/code/automation/GroupMeAppium/ && mvn -Dtest=test.java.com.groupme.appium.ios.suites.*Test -DappName=GroupMe.app surefire-report:report"
alias reloadprofile=". ~/.profile"
alias updateandroid="/Users/patrick/code/automation/GroupMeAppium/apk/UpdateApps.sh /Users/patrick/code/"
alias updateios="/Users/patrick/code/automation/GroupMeAppium/app/UpdateApps.sh /Users/patrick/code/"
alias adbrestart="adb kill-server && adb start-server"

#Prompt coloring
# Check that terminfo exists before changing TERM var to xterm-256color
# Prevents prompt flashing in Mac OS X 10.6 Terminal.app
if [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM='xterm-256color'
fi

tput sgr 0 0

# Base styles and color palette
# Solarized colors
# https://github.com/altercation/solarized/tree/master/iterm2-colors-solarized
BOLD=$(tput bold)
RESET=$(tput sgr0)
SOLAR_YELLOW=$(tput setaf 136)
SOLAR_ORANGE=$(tput setaf 166)
SOLAR_RED=$(tput setaf 124)
SOLAR_MAGENTA=$(tput setaf 125)
SOLAR_VIOLET=$(tput setaf 61)
SOLAR_BLUE=$(tput setaf 33)
SOLAR_CYAN=$(tput setaf 37)
SOLAR_GREEN=$(tput setaf 70)
SOLAR_WHITE=$(tput setaf 254)

style_user="\[${RESET}${SOLAR_ORANGE}\]"
style_host="\[${RESET}${SOLAR_RED}\]"
style_path="\[${RESET}${SOLAR_GREEN}\]"
style_chars="\[${RESET}${SOLAR_WHITE}\]"
style_branch="${SOLAR_CYAN}"

if [[ "$SSH_TTY" ]]; then
    # connected via ssh
    style_host="\[${BOLD}${SOLAR_RED}\]"
elif [[ "$USER" == "root" ]]; then
    # logged in as root
    style_user="\[${BOLD}${SOLAR_RED}\]"
fi

is_git_repo() {
    $(git rev-parse --is-inside-work-tree &> /dev/null)
}

is_git_dir() {
    $(git rev-parse --is-inside-git-dir 2> /dev/null)
}

get_git_branch() {
    local branch_name

    # Get the short symbolic ref
    branch_name=$(git symbolic-ref --quiet --short HEAD 2> /dev/null) ||
    # If HEAD isn't a symbolic ref, get the short SHA
    branch_name=$(git rev-parse --short HEAD 2> /dev/null) ||
    # Otherwise, just give up
    branch_name="(unknown)"

    printf $branch_name
}

# Git status information
prompt_git() {
    local git_info git_state uc us ut st

    if ! is_git_repo || is_git_dir; then
        return 1
    fi

    git_info=$(get_git_branch)

    # Check for uncommitted changes in the index
    if ! $(git diff --quiet --ignore-submodules --cached); then
        uc="+"
    fi

    # Check for unstaged changes
    if ! $(git diff-files --quiet --ignore-submodules --); then
        us="!"
    fi

    # Check for untracked files
    if [ -n "$(git ls-files --others --exclude-standard)" ]; then
        ut="?"
    fi

    # Check for stashed files
    if $(git rev-parse --verify refs/stash &>/dev/null); then
        st="$"
    fi

    git_state=$uc$us$ut$st

    # Combine the branch name and state information
    if [[ $git_state ]]; then
        git_info="$git_info[$git_state]"
    fi

    printf "${SOLAR_WHITE} on ${style_branch}${git_info}"
}


# Set the terminal title to the current working directory
PS1="\[\033]0;\w\007\]"
# Build the prompt
PS1+="\n" # Newline
PS1+="${style_user}\u" # Username
PS1+="${style_chars}@" # @
#PS1+="${style_host}\h" # Host
#PS1+="${style_chars}: " # :
PS1+="${style_path}\w" # Working directory
PS1+="\$(prompt_git)" # Git details
#PS1+="\n" # Newline
#PS1+="${style_path}[\d \t] ${style_chars}$ \[${RESET}\]" # $ (and reset color)
PS1+="${style_chars}$ \[${RESET}\]" # $ (and reset color)