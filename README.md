# forge-dev-kasm-docker
A containerized Forge-Dev environment

To build and run container
sudo docker system prune -a
sudo docker build -t forge-kasm .
sudo docker run -it -p 3000:3000 forge-kasm bash
