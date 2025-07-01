# Sistema Universal de Build, Clean, Deploy, Abort, Publish y Contexto por Proyecto

## ¿Cómo funciona?

- Ejecuta `./build.sh`, `./clean.sh`, `./deploy.sh`, `./abort.sh`, `./publish.sh` o `./get_context.sh` desde la raíz de tu proyecto.
- El sistema detecta el nombre de la carpeta raíz y ejecuta el flujo correspondiente definido en `project_flows.yaml`.
- Si el proyecto no existe, se crea automáticamente la carpeta y los scripts base con instrucciones para que los completes.
- El sistema también agrega el nuevo proyecto a `project_flows.yaml` si no existe.

## ¿Cómo ejecutar los scripts?

Desde la terminal, navega a la raíz del workspace (por ejemplo, la carpeta `macos`) y ejecuta cualquiera de los siguientes comandos:

```sh
./build.sh
./clean.sh
./deploy.sh
./abort.sh
./publish.sh
./get_context.sh
```

> **Nota:** Si el script no tiene permisos de ejecución, primero usa:
> `chmod +x build.sh clean.sh deploy.sh abort.sh publish.sh get_context.sh`

## ¿Qué hace cada script?

- **build.sh**: Compila o construye el proyecto activo según el flujo definido en `project_flows.yaml`.
- **clean.sh**: Realiza limpieza de archivos temporales, dependencias o builds previos del proyecto.
- **deploy.sh**: Despliega el proyecto en el entorno o dispositivo correspondiente.
- **abort.sh**: Detiene procesos, limpia recursos o cancela operaciones en curso.
- **publish.sh**: Sube artefactos (por ejemplo, APKs) a servicios externos como Google Drive.
- **get_context.sh**: Genera un contexto de código y prompts útiles para QA, documentación y desarrollo.

## ¿Cómo agregar un nuevo proyecto?

1. Ejecuta cualquier script universal (`./build.sh`, etc.) desde la raíz de tu nuevo proyecto.
2. El sistema creará la carpeta y los scripts base automáticamente (copiados de `Template`).
3. Edita los scripts generados en `./<TuProyecto>/` para personalizar los flujos reales.
4. El sistema agregará el proyecto a `project_flows.yaml` si no existe.

## Ejemplo de uso

```sh
cd /ruta/a/tu/workspace/macos
./build.sh
```
Esto compilará el proyecto correspondiente a la carpeta actual.

## Logs y errores

- Cada script puede generar logs en la carpeta `logs/` del proyecto (si está implementado).
- Los errores y advertencias se muestran en consola y se registran en los logs para facilitar el diagnóstico.

## Dependencias

- [yq](https://github.com/mikefarah/yq) (instala con `brew install yq` en Mac)
- bash/zsh

---

¿Dudas? Edita los scripts base o consulta los prompts generados en la carpeta `specs/` para personalizar aún más los flujos de trabajo.

## Ejemplo de flujo en un script generado

```sh
#!/bin/zsh
# build.sh para MiProyecto
echo "[AVISO] Debes definir el flujo de build para el proyecto MiProyecto en este archivo."
# Ejemplo:
# npm install
# npm run build
``` 