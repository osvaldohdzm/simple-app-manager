# Sistema Universal de Build, Clean, Deploy y Abort por Proyecto

## ¿Cómo funciona?

- Ejecuta `./build.sh`, `./clean.sh`, `./deploy.sh` o `./abort.sh` desde la raíz de tu proyecto.
- El sistema detecta el nombre de la carpeta raíz y ejecuta el flujo correspondiente definido en `project_flows.yaml`.
- Si el proyecto no existe, se crea automáticamente la carpeta y los scripts base con instrucciones para que los completes.

## ¿Cómo agregar un nuevo proyecto?

1. Ejecuta cualquier script (`./build.sh`, etc.) desde la raíz de tu nuevo proyecto.
2. El sistema creará la carpeta y los scripts base.
3. Edita los scripts en `./<TuProyecto>/` para definir los flujos reales.
4. Agrega tu proyecto a `project_flows.yaml` siguiendo el formato existente.

## Dependencias

- [yq](https://github.com/mikefarah/yq) (instala con `brew install yq` en Mac)
- bash/zsh

## Ejemplo de flujo en un script generado

```sh
#!/bin/zsh
# build.sh para MiProyecto
echo "[AVISO] Debes definir el flujo de build para el proyecto MiProyecto en este archivo."
# Ejemplo:
# npm install
# npm run build
``` 