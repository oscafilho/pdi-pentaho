# Integração Pentaho Data Integration - PDI

## Passo 1
Baixar o arquivo no site [Pentaho-PDI](https://sourceforge.net/projects/pentaho/files/Pentaho-9.3/client-tools/pdi-ce-9.3.0.0-428.zip/download)

## Passo 2
Adicione na pasta "predownloaded" o arquivo "pdi-ce-9.3.0.0-428.zip", pois é necessário para criar a imagem

## Passo 3
Caso queira modificar a versão altere os seguintes parametros no Dockerfile
```sh
ARG PENTAHO_INSTALLER_NAME=pdi-ce
ARG PENTAHO_VERSION=9.3.0.0
ARG PENTAHO_PACKAGE_DIST=428
```

## Building the package
 Criar o Build da Versão
```sh
docker build -t {NOME_IMAGE} .
```

## Executando a Image
```sh
docker run -ti --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/pdi/.Xauthority --net=host --pid=host --ipc=host {NOME_IMAGE}
```
