FROM python:3.9
RUN pip install --no-cache-dir --progress-bar off flask pillow
COPY ./static /home/imageapp/static/
COPY ./templates /home/imageapp/templates/
COPY ./uploads /home/imageapp/uploads/
COPY image_app.py /home/imageapp/
WORKDIR /home/imageapp
EXPOSE 8080
CMD python3 /home/imageapp/image_app.py
