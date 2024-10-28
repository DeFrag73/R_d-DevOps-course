# Nginx on Alpine in Docker

This project sets up an Nginx web server on an Alpine-based Docker image. The server serves static content from the `index.html` file, and the Nginx configuration is customized using the `default.conf` file.

## Project Contents

- **Dockerfile**: Contains the instructions for building the Docker image.
- **index.html**: A simple static HTML page that will be served by Nginx.
- **default.conf**: Nginx configuration file to customize the web server's behavior.

## Steps to Use

### Step 1: Clone the repository

Clone this repository to your local machine:

```bash
git clone https://github.com/DeFrag73/R_d-DevOps-course.git
cd Lecture_16
```

### Step 2: Build the Docker Image

To build the Docker image using the provided `Dockerfile`, run the following command:

```bash
docker build -t my-nginx-image .
```

This command will build a Docker image with the name `my-nginx-image`.

### Step 3: Run the Docker Container

Once the image is built, you can run the container using this command:

```bash
docker run -d -p 8080:80 my-nginx-image
```

This command runs the container in detached mode (`-d`) and maps port 80 from inside the container <br>
(where Nginx serves traffic) to port 8080 on your local machine.

### Step 4: Access the Web Page

You can check that Nginx is serving your static `index.html` file by visiting:

```bash
http://localhost:8080
```

Alternatively, you can use `curl`:

```bash
curl http://localhost:8080
```

If everything is set up correctly, you should see the content of the `index.html` file.
![htmlWORK!.png](htmlWORK%21.png)

### Step 5 
Start the container with CPU and memory usage limits:
```bash
docker run -d --name limited-nginx --cpus="0.5" --memory="256m" -p 8081:80 rootless-nginx
```
- **-cpus="0.5":** limit CPU usage to half the core.
- -memory="256m": limit the container memory to 256 MB.
- p 8081:80: forward port 8081 to port 80 in the container.

To see resource usage:

```bash
docker stats limited-nginx
```
![limeted container.png](limeted%20container.png)

## File Descriptions

### 1. `Dockerfile`

```Dockerfile
FROM alpine:latest
RUN apk update && apk add nginx
COPY index.html /usr/share/nginx/html/
COPY default.conf /etc/nginx/http.d/
CMD ["nginx", "-g", "daemon off;"]
```

This Dockerfile does the following:
- **Base Image**: Uses the `alpine:latest` base image, a minimal Linux distribution.
- **Nginx Installation**: Installs `nginx` using Alpine's package manager `apk`.
- **Copy Files**: Copies `index.html` to Nginx's default document root `/usr/share/nginx/html/` and places the Nginx configuration file `default.conf` in `/etc/nginx/http.d/`.
- **Nginx Startup Command**: Runs Nginx in the foreground (`daemon off`).

### 2. `index.html`

This file contains the HTML content served by Nginx. You can modify it to change the webpage content. It is copied to the Nginx default directory `/usr/share/nginx/html/`.

### 3. `default.conf`

The Nginx configuration file used to customize the behavior of the Nginx server. This file is placed in `/etc/nginx/http.d/`.

#### Example Configuration:

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}
```

This configuration tells Nginx to listen on port 80 and serve the file `index.html` from `/usr/share/nginx/html`.

## Stopping and Removing the Container

To stop the running container:

1. Get the `container_id` by running:

   ```bash
   docker ps
   ```

2. Stop the container:

   ```bash
   docker stop <container_id>
   ```

To remove the container:

```bash
docker rm <container_id>
```

## Removing the Docker Image

To delete the built Docker image:

1. List the images and find the `image_id`:

   ```bash
   docker images
   ```

2. Remove the image:

   ```bash
   docker rmi <image_id>
   ```

## Notes

- Ensure that port 8080 is free on your local machine before running the container.
- You can modify the `index.html` and `default.conf` files to customize the behavior of the Nginx server and the content it serves.

## Author

This project is a basic setup for deploying Nginx on Alpine Linux inside a Docker container.
```

### Опис:

1. **Описує, як побудувати Docker образ.**
2. **Описує запуск контейнера з використанням мапування порту 8080.**
3. **Робить огляд вмісту файлів Dockerfile, index.html та default.conf.**
4. **Детально описує, як зупинити, видалити контейнери та образи.**
