# --- Etapa 1: Construção (Build Stage) ---
# Usa a imagem oficial do Dart SDK para compilar o aplicativo.
FROM dart:stable AS build-env

# Define o diretório de trabalho dentro do container da etapa de build.
WORKDIR /app

# Copia os arquivos de definição de dependências primeiro para aproveitar o cache do Docker.
COPY pubspec.yaml .
COPY pubspec.lock .

# Baixa as dependências do Dart.
RUN dart pub get

# Copia o restante dos arquivos do seu projeto.
COPY . .

# Compila o seu servidor Dart para um binário executável nativo.
# O -o define o nome do arquivo de saída.
RUN dart compile exe bin/server.dart -o /app/telemetric_pump_server

# --- Etapa 2: Runtime (Runtime Stage) ---
# Usa uma imagem base Debian mínima para o ambiente de execução final.
# Isso resulta em uma imagem Docker final muito menor.
FROM debian:bookworm-slim

# Instala certificados CA para garantir que conexões HTTPS funcionem, se necessário.
#RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

# Define o diretório de trabalho dentro do container final.
WORKDIR /app

# Copia o binário compilado da etapa de construção para a imagem final.
COPY --from=build-env /app/telemetric_pump_server /app/telemetric_pump_server

# Define a porta que o container irá expor.
EXPOSE 4000

# Define o comando que será executado quando o container iniciar.
# Certifique-se de que seu código Shelf/Dart está configurado para escutar em '0.0.0.0' e na porta 4000.
ENTRYPOINT ["./telemetric_pump_server"]