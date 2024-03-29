# Base Container Development Environment

- **GitHub**: [alchemine/base-cde](https://github.com/alchemine/base-cde)
- **DockerHub**: [alchemine/base-cde](https://hub.docker.com/repository/docker/alchemine/base-cde)

# 1. Base Image

[`ubuntu:jammy-20240212`](https://hub.docker.com/_/ubuntu)

# 2. Installed Library

1. Python 3.8, 3.9, 3.10 (default: 3.8)
   - `update-alternatives --config python`
   - `update-alternatives --config pip`
2. apt packages
   - [context/utils/requirements.apt](https://github.com/alchemine/base-cde/blob/main/context/utils/requirements.apt)
   - [context/extension/requirements.apt](https://github.com/alchemine/base-cde/blob/main/context/extension/requirements.apt)
3. Poetry (1.7.1)
   - [context/utils/install_poetry.sh](https://github.com/alchemine/base-cde/blob/main/context/utils/install_poetry.sh)
4. Java (1.8.0_382)
   - [context/utils/install_java.sh](https://github.com/alchemine/base-cde/blob/main/context/utils/install_java.sh)

# 3. Usage

## 3.1 Project Sample

[alchemine/base-project](https://github.com/alchemine/base-project)

## 3.2 `docker run`

- [run.sh](https://github.com/alchemine/base-cde/blob/main/run.sh)

## 3.3 `docker-compose`

- [docker-compose.yaml](https://github.com/alchemine/base-cde/blob/main/docker-compose.yaml)

# 4. Dockerfile

- [Dockerfile](https://github.com/alchemine/base-cde/blob/main/Dockerfile)

# 5. Dev container

1. 환경변수(`BASE_CDE_PATH`, `HOME`) 등록

   ```json
   "build": {
      // Sets the run context to one level up instead of the .devcontainer folder.
      "context": "${localEnv:BASE_CDE_PATH}",
      // Update the 'dockerFile' property if you aren't using the standard 'Dockerfile' filename.
      "dockerfile": "${localEnv:BASE_CDE_PATH}/Dockerfile"
   },
   "mounts": ["source=${localEnv:HOME}/.ssh,target=/root/.ssh,type=bind"]
   ```

2. `.devcontainer` 복사
   ```bash
   cp -r ${BASE_CDE_PATH}/.devcontainer /path/to/target/folder
   ```
3. (optional) `requirements.txt` 설치

   ```json
   // .devcontainer.json

   ...
   "postCreateCommand": "pip install -r requirements.txt"
   ```
