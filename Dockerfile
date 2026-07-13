FROM python:3.13-slim

# Instalar herramientas necesarias en Linux
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Descargar e instalar Lune para Linux (Versión x86_64 de 64 bits)
# Nota: Puedes cambiar v0.8.8 por la versión exacta de Lune que necesites
RUN curl -L -o lune.zip https://github.com/lune-org/lune/releases/download/v0.8.8/lune-0.8.8-linux-x86_64.zip \
    && unzip lune.zip \
    && mv lune /usr/local/bin/lune \
    && chmod +x /usr/local/bin/lune \
    && rm lune.zip

# Configurar el directorio de trabajo del bot
WORKDIR /app

# Copiar los requisitos e instalarlos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código del bot al contenedor
COPY . .

# Comando para iniciar tu bot
CMD ["python", "bot.py"]

