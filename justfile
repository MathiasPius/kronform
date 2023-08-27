build:
    docker build -t tools:latest tools/
    
tools:
    docker run -it --rm                    \
        -v $(pwd):/data                    \
        -v $HOME/.gnupg:/home/user/.gnupg  \
        -v /run/user/1000/:/run/user/1000/ \
        tools:latest