# Automation Testing Repository with app SpeedTest by Ookla

Este repositorio incluye los archivos necesarios para realizar unas pruebas de automatización de tests de velocidad mediante la aplicación SpeedTest by Ookla, a través de RobotFramework y Python contra terminales conectados a un STF(Smartphone Test Farm) de forma paralela. 

## Docker 
El repositorio incluye los siguientes archivos de Docker en caso de querer realizar la automatización a través de un contenedor Docker y también el Docker-compose.yaml para desplegar un STF:
- [`docker-compose.yaml`](https://github.com/jgpnavarro/Slicing-automation/blob/main/docker-compose.yaml): Despliega un STF (Smartphone Test Farm) utilizando Docker Compose.
- [`Dockerfile`](https://github.com/jgpnavarro/Slicing-automation/blob/main/Dockerfile): Prepara una imagen de Docker con Appium y las configuraciones necesarias para la automatización de las pruebas con RobotFramework y Appium.
- Para construir la imagen local incluida en el repositorio, primero ejecuta desde la carpeta base:

```bash
docker build . -t your-tag
```

- Para construir el contenedor:
```bash
docker run -it -p 4723:4723 -v $(pwd):/base-folder -w /base-folder your-tag:latest bash
```

## Jenkins
- [`pod.yaml`](https://github.com/jgpnavarro/Slicing-automation/blob/main/pod.yaml): Define los contenedores utilizados en el Jenkinsfile para desplegar un pod efímero a través de Kubernetes.
- [`Jenkinsfile`](https://github.com/jgpnavarro/Slicing-automation/blob/main/Jenkinsfile): Gestiona la pipeline de CI/CD que automatiza la ejecución de pruebas y la recopilación de resultados.

### RobotFramework files

- [`Tests`](https://github.com/jgpnavarro/Slicing-automation/blob/main/Tests): [`SpeedTestApp.robot`](https://github.com/jgpnavarro/Slicing-automation/blob/main/Tests/SpeedTestApp.robot) es el archivo que hace uso de los resources para lanzar el pruebas de velocidad.

- [`/Resources`](https://github.com/jgpnavarro/Slicing-automation/blob/main/Resources): son los archivos que vamos a usar a modo de bibliotecas, encargados de realizar la conexión con los terminales a través de STF y los pasos necesarios dentro de la aplicación de Speedtest para lanzar las pruebas de velocidad y obtener los resultados.

### Archivos de Configuración

- [`DevicesSet.txt`](https://github.com/jgpnavarro/Slicing-automation/blob/main/DevicesSet.txt): Contiene los datos necesarios para configurar los dispositivos objetivo de las pruebas.
- [`run_parallel_tests.py`](https://github.com/jgpnavarro/Slicing-automation/blob/main/run_parallel_tests.py): Script que prepara y ejecuta pruebas paralelas para cada dispositivo configurado, utilizando el siguiente comando:
  ```bash
  pabot --pabotlibport 8817 --verbose --pabotlib --processes 2 --argumentfile1 Device1.txt --argumentfile2 Device2.txt --outputdir ./Output ./Tests/SpeedTestApp.robot
  ```
 - En caso de ejecutarlo a través del Jenkins, la herramienta lanza el comando anterior directamente. Si queremos hacerlo a través del contenedor de Docker, debemos ejecutar el archivo `run_parallel_tests.py` manualmente.
 - Por último, si queremos configurar más teléfonos, tendremos que añadirlos en `DevicesSet.txt`.
