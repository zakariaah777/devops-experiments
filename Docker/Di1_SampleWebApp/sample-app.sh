#!/bin/bash

# Create temporary directories
mkdir tempdir
mkdir tempdir/templates
mkdir tempdir/static

# Copy website files to tempdir
cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

# Create Dockerfile
echo "FROM python" > tempdir/Dockerfile
echo "RUN pip install flask" >> tempdir/Dockerfile
echo "COPY ./static /home/myapp/static/" >> tempdir/Dockerfile
echo "COPY ./templates /home/myapp/templates/" >> tempdir/Dockerfile
echo "COPY sample_app.py /home/myapp/" >> tempdir/Dockerfile
echo "EXPOSE 8080" >> tempdir/Dockerfile
echo "CMD python3 /home/myapp/sample_app.py" >> tempdir/Dockerfile

# Build the Docker container
cd tempdir
docker build -t sampleapp .

# Run the Docker container
docker run -t -d -p 8080:8080 --name samplerunning sampleapp

# Display running containers
docker ps -a
