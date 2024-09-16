# Debug Container

Container image to debug rust/go/node.js projects in Neovim.

1. Use docker image directly to start container or make it base image.
2. Attach host filesystem with project sourcecode.
3. Start container. keep-alive.sh entrypoint will just let container run forever.
4. Go inside container with `docker exec`.
5. Start your project in Neovim in DAP session.
