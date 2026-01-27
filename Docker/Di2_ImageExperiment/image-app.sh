#!/bin/bash

# Create temporary directories
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static
mkdir tempdir/uploads

# Copy website files to tempdir
cp image_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Create Dockerfile
echo "FROM python:3.9" > tempdir/Dockerfile
echo "RUN pip install --no-cache-dir --progress-bar off flask pillow" >> tempdir/Dockerfile
echo "COPY ./static /home/imageapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/imageapp/templates/" >> tempdir/Dockerfile
echo "COPY ./uploads /home/imageapp/uploads/" >> tempdir/Dockerfile
echo "COPY image_app.py /home/imageapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo "CMD python3 /home/imageapp/image_app.py" >> tempdir/Dockerfile

# Build the Docker container
cd tempdir
docker build -t imageapp .

# Run the Docker container
docker run -t -d -p 8080:8080 --name imagerunning imageapp

# Display running containers
docker ps -a
