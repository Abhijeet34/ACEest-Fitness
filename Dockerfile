FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN pip install .

RUN mkdir -p instance

EXPOSE 5000

CMD ["gunicorn", "-b", "0.0.0.0:5000", "aceest:create_app()"]
