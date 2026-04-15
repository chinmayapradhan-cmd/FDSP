FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN mkdir -p /root/.dbt && \
    cp .github/profiles/profiles.yml /root/.dbt/profiles.yml

CMD ["dbt", "run"]
