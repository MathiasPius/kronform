build:
    docker build -t tools:latest tools/
    
tools:
    docker run -it --rm                       \
        -v $(pwd):/data                       \
        -v /run/user/1000/:/run/user/1000/:ro \
        -v $HOME/.gnupg:/home/user/.gnupg:ro  \
        tools:latest || true
