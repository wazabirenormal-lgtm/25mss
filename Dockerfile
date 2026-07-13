FROM python:3.13-slim

# Instalar herramientas del sistema y Node.js (necesario para luamin/beautify.js)
RUN apt-get update && apt-get install -y curl unzip nodejs && rm -rf /var/lib/apt/lists/*

# 1. Descargar e instalar LUNE para Linux
RUN curl -L -o lune.zip https://github.com/lune-org/lune/releases/download/v0.8.8/lune-0.8.8-linux-x86_64.zip \
    && unzip lune.zip \
    && mv lune /usr/local/bin/lune \
    && chmod +x /usr/local/bin/lune \
    && rm lune.zip

# 2. Descargar e instalar DARKLUA para Linux
RUN curl -L -o darklua.zip https://github.com/seaofvoices/darklua/releases/download/v0.13.1/darklua-linux-x86_64.zip \
    && unzip darklua.zip \
    && mv darklua /usr/local/bin/darklua \
    && chmod +x /usr/local/bin/darklua \
    && rm darklua.zip

# Configurar directorio de trabajo
WORKDIR /app

# Copiar e instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código del bot
COPY . .

CMD ["python", "bot.py"]
