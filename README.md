# Go, Docker and Github Action Integration (godockact)

📓 An Example of how to use a GitHub Action to compile a Go program and put it into a Docker container

## Status

![godockact](https://github.com/sorens/godockact/workflows/godockact/badge.svg)

## Summary

This mini project was born from my desire to construct a docker container with just the binary output of a Go lang project. At the time, I had been using the docker `COPY` directive to move the entire go directory into the container and compile it there via the Dockerfile. However, to minimize complexity, I wanted the docker container to only contain the necessary binary output from the build and not the source and supporting files from the repository.

I was sure it was possible, but I needed to connect the dots between the containers in the Github Action that would build the code and the one that would construct the final docker package.

This repository is my example and test for making that happen. The Github Action (described at `.github/workflows/create_docker_image.yml`) performs the following steps:

1. Set up a Go 1.14.2 environment using `actions/setup-go@v2.0.3`

2. Checks out the Go lang code from the repository using `actions/checkout@v2.1.0`

3. Bumps the git tag using `anothrNick/github-tag-action@1.22.0`

4. Cross-compiles the binaries using `make` provided by the Makefile. This creates the binary `hello`

5. Build the docker image using the Dockerfile, which copies `hello`, the specific binary output, into the container into `/usr/local/bin/` using `COPY build/linux/* /usr/local/bin/`

6. Authenticate to the Github package registry

7. Push the docker image to the Github package repository with the a tag created in the bump step above.

Each commit to the master branch of this respository will trigger the `create_docker_image.yml` Github Action, which will bump the version (creating a new tag), creating an updated docker image and pushing that docker image to the registry. The docker image will only contain the output of `build/linux/*` and not the entire Go source respository.

## Package Registry

You can pull this package using the `docker pull` command:

```shell
$ docker pull docker.pkg.github.com/sorens/godockact/hello:latest
latest: Pulling from sorens/godockact/hello
90fe46dd8199: Pull complete 
35a4f1977689: Pull complete 
bbc37f14aded: Pull complete 
74e27dc593d4: Pull complete 
38b1453721cb: Pull complete 
780391780e20: Pull complete 
0f7fd9f8d114: Pull complete 
23b54d1cbf8e: Pull complete 
c1a4a87be5ce: Pull complete 
c423acab52cd: Pull complete 
bfe28ff5ef32: Pull complete 
904607262d0c: Pull complete 
Digest: sha256:26abe29783ea77d4286477d516073d6a18cb0ec50c258ad790bdb404692a651a
Status: Downloaded newer image for docker.pkg.github.com/sorens/godockact/hello:latest
docker.pkg.github.com/sorens/godockact/hello:latest
```

When you run this docker container, you see:

```shell
$ docker run docker.pkg.github.com/sorens/godockact/hello:latest
hello, world
Today is Saturday
```

## Contributions

Thanks to @yokumar9780 for the initial contributions on how to bump a version and push the package itself to the registry!