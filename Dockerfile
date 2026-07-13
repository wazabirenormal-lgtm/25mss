FROM python:3.13-slim

# Evitar que Wine intente abrir ventanas flotantes o diálogos interactivos
ENV WINEDEBUG=-all
ENV DEBIAN_FRONTEND=noninteractive

# Instalar herramientas del sistema, Node.js, NPM y Wine
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    nodejs \
    npm \
    wine \
    wine64 \
    && rm -rf /var/lib/apt/lists/*

# 1. Descargar e instalar LUNE para Linux (X86_64) de forma nativa
RUN curl -L -o lune.zip https://github.com/lune-org/lune/releases/download/v0.8.8/lune-0.8.8-linux-x86_64.zip \
    && unzip lune.zip \
    && mv lune /usr/local/bin/lune \
    && chmod +x /usr/local/bin/lune \
    && rm lune.zip

# 2. Descargar e instalar DARKLUA para Linux (X86_64) de forma nativa
RUN curl -L -o darklua.zip https://github.com/seaofvoices/darklua/releases/download/v0.13.1/darklua-linux-x86_64.zip \
    && unzip darklua.zip \
    && mv darklua /usr/local/bin/darklua \
    && chmod +x /usr/local/bin/darklua \
    && rm darklua.zip

# Configurar el directorio de trabajo del bot
WORKDIR /app

# Crear de forma anticipada la estructura completa de carpetas que usa tu bot.py
RUN mkdir -p dumps/original \
             dumps/dumped \
             dumps/beautify \
             dumps/rename \
             dumps/decompile \
             deobfuscate/.in \
             deobfuscate/.out \
             unobfuscated \
             obfuscated \
             hook_op/file_cache

# Copiar e instalar las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código del bot al contenedor
COPY . .

# Inicializar configuración interna de Wine para que no pierda tiempo en la primera ejecución
RUN winecfg-development || wineboot --init

CMD ["python", "bot.py"]
