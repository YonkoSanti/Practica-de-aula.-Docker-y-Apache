# Práctica de Aula: Docker y Apache

**Autor:** Santiago Posada Osorio  
**Curso:** 2º ASIR (Administración de Sistemas Informáticos en Red)  
**Módulo:** Implantación de Aplicaciones Web (IAW)

---

## Índice de Contenidos
1. [Introducción](#introducción)
2. [Paso 1: Descargar la imagen de Debian](#paso-1-descargar-la-imagen-de-debian)
3. [Paso 2: Arrancar el contenedor interactivo y en segundo plano](#paso-2-arrancar-el-contenedor-interactivo-y-en-segundo-plano)
4. [Paso 3: Ejecutar una shell Bash en el contenedor](#paso-3-ejecutar-una-shell-bash-en-el-contenedor)
5. [Paso 4: Instalar Apache2 en el contenedor](#paso-4-instalar-apache2-en-el-contenedor)
6. [Paso 5: Arrancar el servicio Apache](#paso-5-arrancar-el-servicio-apache)
7. [Paso 6: Comprobar el funcionamiento desde el navegador](#paso-6-comprobar-el-funcionamiento-desde-el-navegador)
8. [Paso 7: Crear una página HTML personalizada (`santi.html`)](#paso-7-paso-7-crear-una-página-html-personalizada-santihtml)
9. [Paso 8: Acceder a la página desde el navegador](#paso-8-acceder-a-la-página-desde-el-navegador)
10. [Paso 9: Acceder mediante el navegador de línea de comandos `elinks`](#paso-9-acceder-mediante-el-navegador-de-línea-de-comandos-elinks)
11. [Paso 10: Automatizar con un `Dockerfile`](#paso-10-automatizar-con-un-dockerfile)
12. [Paso 11: Construir la imagen desde el `Dockerfile`](#paso-11-construir-la-imagen-desde-el-dockerfile)
13. [Paso 12: Ejecutar el contenedor basado en nuestra imagen personalizada](#paso-12-ejecutar-el-contenedor-basado-en-nuestra-imagen-personalizada)
14. [Paso 13: Copiar un archivo local con `docker cp`](#paso-13-copiar-un-archivo-local-con-docker-cp)
15. [Paso 14: Configurar el despliegue con `docker-compose.yml` y volúmenes](#paso-14-configurar-el-despliegue-con-docker-composeyml-y-volúmenes)

---

## Introducción
Practica realizada en clase sobre Debian y apache 

---

## Paso 1: Descargar la imagen de Debian
Primero, buscamos y descargamos la imagen oficial de Debian desde Docker Hub. En este caso utilizaremos la versión `trixie-backports`.

<img width="642" height="358" alt="image" src="https://github.com/user-attachments/assets/4aed4f4d-eb8b-4d97-9766-44f8d2b66cab" />


```bash
docker pull debian:trixie-backports
```
<img width="916" height="145" alt="image" src="https://github.com/user-attachments/assets/8a4527c3-d2a2-4ed4-80c4-7eab07d67432" />

---

## Paso 2: Arrancar el contenedor interactivo y en segundo plano
Arrancamos el contenedor asignándole un nombre (`mi-servidor-debian`), mapeando el puerto 80 del host al puerto 80 del contenedor, y ejecutándolo de forma interactiva y en segundo plano (`-dit`).

```bash
docker run -dit --name mi-servidor-debian -p 80:80 debian:trixie-backports
```
<img width="916" height="101" alt="image" src="https://github.com/user-attachments/assets/1a81fff3-b7dc-4b5c-a86f-c368ccd8efcb" />


Como debería salir
<img width="916" height="63" alt="image" src="https://github.com/user-attachments/assets/dfb535d9-af2d-4388-93c7-214029c9afd2" />

---

## Paso 3: Ejecutar una shell Bash en el contenedor
Accedemos al interior del contenedor en ejecución utilizando el comando `exec` con una terminal interactiva bash:

```bash
docker exec -it mi-servidor-debian bash
```
<img width="916" height="101" alt="image" src="https://github.com/user-attachments/assets/030d93d6-62e5-4ad9-b0c6-38fd5f6bd935" />

---

## Paso 4: Instalar Apache2 en el contenedor
Una vez dentro de la shell del contenedor con privilegios de root, actualizamos los repositorios e instalamos el servidor web Apache2:

```bash
apt update && apt install -y apache2
```
<img width="916" height="228" alt="image" src="https://github.com/user-attachments/assets/0d82e2a8-be31-4d25-845d-6c1aa21ab3f1" />

---
![alt text](image-5.png)
## Paso 5: Arrancar el servicio Apache
Iniciamos manualmente el servicio web dentro del contenedor:

```bash
service apache2 start
```
<img width="916" height="102" alt="image" src="https://github.com/user-attachments/assets/b2e59f29-f2fe-4dad-b997-3652d75782a7" />

---

## Paso 6: Comprobar el funcionamiento desde el navegador
Abrimos nuestro navegador web local y accedemos a `http://localhost`. Deberá mostrarse la página por defecto de bienvenida de Apache2 en Debian (*"It works!"*).

<img width="660" height="355" alt="image" src="https://github.com/user-attachments/assets/ae6deefc-3a2d-4cb3-b318-f5cd2f5643fb" />

---

## Paso 7: Crear una página HTML personalizada (`santi.html`)
Creamos una página web sencilla directamente en el directorio raíz de publicaciones de Apache dentro del contenedor:

```bash
echo "<html><body><h1>Hola, soy Santi y mi servidor Apache funciona en Docker</h1></body></html>" > /var/www/html/santi.html
```
<img width="916" height="74" alt="image" src="https://github.com/user-attachments/assets/8d2d166a-be81-4c1e-8ed4-457226f0f34a" />

---

## Paso 8: Acceder a la página desde el navegador
Comprobamos que la nueva página es accesible desde el navegador web introduciendo:
`http://localhost/santi.html`

<img width="795" height="192" alt="image" src="https://github.com/user-attachments/assets/e18d0c2b-b3fd-4782-a846-248024a59f23" />

---

## Paso 9: Borramos todo 
Borramos lo creado y volveremos a hacerlo mediante un dockerfile

---

## Paso 10: Automatizar con un `Dockerfile`
Creamos un fichero llamado `Dockerfile` en nuestro equipo local para empaquetar y automatizar todo el proceso anterior sin necesidad de configurarlo manualmente paso a paso:

> **Nota:** Debemos tener creado un HTML llamado `santi.html` con el contenido  que queramos mostrar.

<img width="916" height="295" alt="image" src="https://github.com/user-attachments/assets/549aa5ee-3b79-4482-bfde-2558b4d1d756" />


```dockerfile
# Usamos la imagen Debian oficial
FROM debian:latest

# Actualizar repositorios e instalar Apache2 y elinks en una sola capa
RUN apt update && apt install -y apache2 elinks

# Copiar el archivo HTML personalizado al directorio raíz web del contenedor
COPY santi.html /var/www/html/santi.html

# Exponer el puerto 80 para el tráfico web
EXPOSE 80

# Ejecutar Apache en primer plano para evitar que el contenedor se detenga
CMD ["apache2ctl", "-D", "FOREGROUND"]
```
<img width="916" height="480" alt="image" src="https://github.com/user-attachments/assets/fcd831b0-2c6d-4969-9178-d1c7166bd996" />

<img width="916" height="394" alt="image" src="https://github.com/user-attachments/assets/4e453deb-c8a3-442a-955a-55e57cc669d3" />


---

## Paso 11: Construir la imagen desde el `Dockerfile`
Compilamos nuestra imagen personalizada etiquetándola con el nombre `santi-debian-apache`:

```bash
docker build -t santi-debian-apache .
```
<img width="916" height="210" alt="image" src="https://github.com/user-attachments/assets/9e8dc2f4-0b2e-4c57-8ae6-c2433523ce0b" />
<img width="916" height="100" alt="image" src="https://github.com/user-attachments/assets/c501781a-20d4-49a2-8bc3-eee168dee07a" />

---

## Paso 12: Ejecutar el contenedor basado en nuestra imagen personalizada
Lanzamos el contenedor recién creado mapeándolo al puerto `8080` de nuestra máquina anfitriona:

```bash
docker run -d -p 8080:80 --name contenedor-santi santi-debian-apache
```
<img width="916" height="94" alt="image" src="https://github.com/user-attachments/assets/99376a33-0fd3-40f3-92f6-4e0791848038" />
<img width="916" height="123" alt="image" src="https://github.com/user-attachments/assets/af03820f-dd6a-423d-a862-0331a9339f51" />

Y si queremos comprobar el correcto funcionamiento interno mediante elinks accediendo al contenedor en ejecución:

```bash
docker exec -it contenedor-santi elinks http://localhost/santi.html
```
<img width="916" height="289" alt="image" src="https://github.com/user-attachments/assets/349c8b86-3448-4fce-a413-864dd4d38515" />
<img width="916" height="263" alt="image" src="https://github.com/user-attachments/assets/8ae2651f-c009-48b3-a5e4-ace0edcc40dc" />


---

## Paso 13: Copiar un archivo local con `docker cp`
Para demostrar el traspaso de ficheros en caliente hacia un contenedor en ejecución, creamos un archivo local `santi_extra.html` y lo copiamos mediante el comando `docker cp`:

```bash
echo "<html><body><h1>Fichero extra copiado con docker cp para Santi</h1></body></html>" > santi_extra.html
docker cp santi_extra.html contenedor-santi:/var/www/html/extra.html
```
<img width="916" height="126" alt="image" src="https://github.com/user-attachments/assets/35df131b-182b-4b85-a2a3-842a42dec8d5" />

---

## Paso 14: Configurar el despliegue con `docker-compose.yml` y volúmenes
Creamos un fichero `docker-compose.yml` para orquestar el despliegue del servicio web mapeando mediante un volumen la carpeta local `./html-local` con la ruta de contenido web del contenedor (`/var/www/html`):

<img width="916" height="360" alt="image" src="https://github.com/user-attachments/assets/07c003dd-1660-4895-a8f7-2de0b95f3f6c" />

```yaml
services:
  web:
    image: santi-debian-apache
    container_name: apache-santi-compose
    ports:
      - "8090:80"
    volumes:
      - ./html-local:/var/www/html
```
<img width="916" height="408" alt="image" src="https://github.com/user-attachments/assets/128c35a6-7525-4ac3-82f7-e527862c778a" />


Finalmente, levantamos la infraestructura definida ejecutando:

```bash
docker compose up -d
```
<img width="916" height="164" alt="image" src="https://github.com/user-attachments/assets/b01b83ab-f858-40f0-86e4-c7c6740fa0ec" />

---
