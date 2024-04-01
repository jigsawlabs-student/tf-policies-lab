FROM python:3.8.5-alpine3.12

WORKDIR /app

EXPOSE 80
ENV FLASK_APP=app.py

COPY ./src .
RUN pip3 install -r requirements.txt

CMD ["flask", "run", "--host=0.0.0.0", "--port=80"]