# forge-dev-kasm-docker
# A Forge-Dev containerized environment using KasmVNC

# To create the image
Open a terminal in either forge-dev-kasm-docker folder and run:
```
docker build -t forge-kasm .
```

# To run the container
After the image is built run:
```
docker run -it -p 3000:3000 forge-kasm bash
```

# To run the container detatched running in the background:
```
docker run -d -it -p 3000:3000 forge-kasm bash
```

# To Access container
After the container is running, access container, localhost:3000 in your web browser.
After accessing the container in your browser run one of the following command:
```
sudo bash initial-setup.sh
```
# To start Forge-Dev environment run
```
bash forge-dev-kasm-docker.sh
```
