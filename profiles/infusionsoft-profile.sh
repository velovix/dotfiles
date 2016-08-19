# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# Java setup
export JAVA_HOME=/home/tyler/tools/jdk
export PATH=$PATH:$JAVA_HOME/bin

# Maven setup
export MAVEN_HOME=/home/tyler/tools/maven
export M2_HOME=$MAVEN_HOME
export MAVEN_OPTS='-Xmx2048m -XX:CompileCommand=exclude,com/infusion/databridge/MemoryRst,loadMeta'
export PATH=$PATH:$MAVEN_HOME/bin

# Ant setup
export ANT_HOME=/home/tyler/tools/ant
export PATH=$PATH:$ANT_HOME/bin

# Node.js Setup
export PATH=$PATH:/home/tyler/tools/node/bin

# Script directory setup
export PATH=$PATH:/home/tyler/scripts

# MySQL setup
export PATH=$PATH:/home/tyler/tools/mysql/bin

# Go setup
export GOPATH=/home/tyler/go

# IntelliJ setup
export PATH=$PATH:/home/tyler/tools/idea/bin

# MAT setup
export PATH=$PATH:/home/tyler/tools/mat

# JCA setup
export PATH=$PATH:/home/tyler/tools/jca

# VisualVM setup
export PATH=$PATH:/home/tyler/tools/visualvim/bin

# Gradle setup
export GRADLE_HOME=/home/tyler/tools/gradle
export PATH=$PATH:/home/tyler/tools/gradle/bin
