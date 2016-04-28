# .bash_profile

# gitstatus / gitprompt Hack
[[ -s ~/.bashrc ]] && source ~/.bashrc
. $HOME/.bash/gitprompt.sh

# homebrew bash-completion
# $ brew install bash-completion
# $ brew tap homebrew/completions
# completion scripts: https://github.com/Homebrew/homebrew-completions
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

# aliasing
alias mysql=/usr/local/mysql/bin/mysql
alias mysqladmin=/usr/local/mysql/bin/mysqladmin

alias ll="ls -la"

## aliases for ruby commands
alias be="bundle exec"
alias bi="bundle install"
alias migrate="bundle exec rake db:migrate:local"

## deploy() { bundle exec cap update_local; bundle exec cap "$2" "$1" deploy ; }
## alias deploy="bundle exec cap update_local; bundle exec cap uat api deploy"

## aliases for git-based commands
alias rebase="git fetch; git rebase origin/master"
alias gitr="git rebase origin/master"
alias gitf="git fetch"
alias gitd="git diff origin/master"
alias gitsync="git pull upstream master; git push origin master"

# aliases for maven
alias mci="mvn clean install"
alias mcifast="mvn clean install -DskipTests=true"

# aliases for docker
#alias docker_stopall="docker stop $(docker ps -a -q)"
#alias docker_removeall="docker rm $(docker ps -a -q)"
dcleanup(){
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

### the answer is does we second argument is higher
function _ver_higher {
  ver=`echo -ne "$1\n$2" |sort -Vr |head -n1`
  if [ "$2" == "$1" ]; then
    return 1
  elif [ "$2" == "$ver" ]; then
    return 0
  else
    return 1
  fi
}

function release() { 
  if [ _ver_higher ]; then
    mvn -B release:prepare -DreleaseVersion=$1 -DdevelopmentVersion=$2-SNAPSHOT
  else
    echo "developmentVersion:$2 must be larger than releaseVersion:$1"
  fi
}

function version() {
  mvn versions:set -DnewVersion=$1-SNAPSHOT; mvn versions:commit;
}

# aliases for curl
alias curltime='curl -o /dev/null -s -w "@/Users/tmack/.bash/curltime-format.txt"'

PATH=/usr/local/git/bin:$PATH 		# add git lib to PATH
PATH=$PATH:~/bin 			# add home bin directory to PATH
PATH=$PATH:/usr/local/mysql/bin 	# add mysql commands in PATH
PATH=$PATH:/usr/local/share/npm/bin	# add npm bin commands in PATH

export PATH
#export JAVA7_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home
#export JAVA8_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_92.jdk/Contents/Home
#export JAVA_HOME=$JAVA8_HOME
export JAVA_HOME=$(/usr/libexec/java_home)

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
