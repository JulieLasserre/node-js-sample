# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/windows/servercore:ltsc2019 AS installer

# Spécifiez la version de Node.js à installer
ARG NODE_VERSION=20.11.1

# Téléchargez et installez Node.js
RUN powershell -Command \
    Invoke-WebRequest -Uri "https://nodejs.org/dist/v${Env:NODE_VERSION}/node-v${Env:NODE_VERSION}-win-x64.zip" -OutFile C:\nodejs.zip ; \
    Expand-Archive C:\nodejs.zip -DestinationPath C:\nodejs ; \
    Move-Item -Path "C:\nodejs\node-v${Env:NODE_VERSION}-win-x64\*" -Destination C:\nodejs ; \
    Remove-Item -Path C:\nodejs.zip -Force

# Définissez le chemin d'installation de Node.js dans la variable d'environnement PATH
RUN setx /M PATH "%PATH%;C:\nodejs"

# Configurez le répertoire de travail
WORKDIR /usr/src/app

# Téléchargez les dépendances
COPY package.json .
COPY package-lock.json .
RUN npm ci --omit=dev

# Copiez le reste des fichiers source
COPY . .

# Exposez le port 3000
EXPOSE 3000

ENTRYPOINT ["powershell.exe"]
# Exécutez l'application
CMD ["npm", "start"]
