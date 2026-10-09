# Usamos la imagen Debian
FROM debian:latest

# Actualizar repositorios e instalar Apache y elinks en una sola capa
RUN apt update && apt install -y apache2 elinks

# Copiar el archivo HTML personalizado al directorio raíz web del contenedor
COPY santi.html /var/www/html/santi.html

# Exponer el puerto 80 para el tráfico web
EXPOSE 80

# Ejecutar Apache en primer plano para que el contenedor no se detenga
CMD ["apache2ctl", "-D", "FOREGROUND"]