
export SSH_KEY=`cat ~/.ssh/id_rsa.pub`

docker build -t ruby-cstrainge:1.0 ./ruby-cstrainge \
    --build-arg "SSH_KEY=${SSH_KEY}"
