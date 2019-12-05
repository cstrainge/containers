
# We're working with Ruby, and Rails here, so this seems to be a good starting point.
FROM ruby:2.5



# Lets make sure we're up to date.  I install some tools I ofetn tend to want, then I also want to
# make sure node npm and yarn are available.
RUN \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt update && \
apt upgrade -y && \
apt install -y nodejs npm yarn lsb-base lsb-release sudo tree htop curl wget net-tools



# Let's make sure that the dev and ssh servers are accessable.
EXPOSE 3000 22



# Create my user account.  It might make sense in the future to parameterize this.
RUN \
useradd -ms /bin/bash cstrainge && \
echo "cstrainge ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
mkdir /home/cstrainge/workdir && \
chown cstrainge.cstrainge /home/cstrainge/workdir

#echo 'cstrainge:password' | chpasswd && \


# Ok, switch to my user account and get some config setup.
#  * Note, I also rely on the start-up function to import my .bashrc for convience.
USER cstrainge
WORKDIR /home/cstrainge
ENV HOME /home/cstrainge



RUN sudo apt-get install -y openssh-server
RUN sudo mkdir -p /var/run/sshd
RUN sudo mkdir -p /etc/ssh
RUN sudo touch /etc/ssh/sshd_config
RUN sudo sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
RUN sudo sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo touch /root/.Xauthority


ARG SSH_KEY
ENV SSH_KEY=$SSH_KEY

RUN mkdir -p /home/cstrainge/.ssh/
RUN echo ${SSH_KEY} | cat > /home/cstrainge/.ssh/authorized_keys
RUN chmod o-rw /home/cstrainge/.ssh/
RUN chmod g-rw /home/cstrainge/.ssh/



# TODO: This doesn't seem to be working, so I need to look into this.
RUN gem install rails --user-install



# Convigure git for convience, some of this could be parameterized as well.
# TODO: It could be cool to setup something that could auto import the user's git config instead
#       like my .bashrc.
RUN \
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --" && \
git config --global user.email "nullptr.0@gmail.com" && \
git config --global user.name "Chloë Strainge" && \
git config --global core.editor "vim"



ADD .extra-init.sh /home/cstrainge
RUN sudo chown cstrainge.cstrainge .extra-init.sh



# TODO: Some of these tools like gem like to save stuff in the user folder, it might be interesting
#       to persist this in a volume or something, but perhaps per project?  More thinking/learing
#       current best practices is required here.



# Ok, when we start the container interactivly, run bash.
CMD /bin/bash
