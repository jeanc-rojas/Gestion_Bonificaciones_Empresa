# Sistema de Gestión de Bonificaciones (Oracle APEX / PL-SQL)

Proyecto de base de datos relacional y lógica de negocio desarrollada en PL/SQL para el cálculo y control de bonificaciones.

## Estructura de Scripts

Los archivos están numerados según su orden lógico de ejecución:

* `01_ddl.sql`: Creación de tablas, llaves primarias, foráneas y restricciones.
* `02_datos_prueba.sql`: Inserción de datos ficticios iniciales para poblar el modelo.
* `03_pkg_bonificaciones_spec.sql`: Especificación del paquete PL/SQL (`PACKAGE`) con las firmas de procedimientos y funciones.
* `04_pkg_bonificaciones_body.sql`: Cuerpo del paquete (`PACKAGE BODY`) con la lógica de cálculo de bonificaciones.
* `05_trigger.sql`: Disparadores para automatizar auditoría o validaciones ante eventos DML.
* `06_pruebas.sql`: Bloques anónimos PL/SQL para ejecutar pruebas unitarias del paquete y los triggers.
* `07_consultas_verificacion.sql`: Consultas `SELECT` para validar la integridad de los resultados generados.

## Instrucciones de Ejecución

1. Abrir **SQL Workshop > SQL Scripts** en Oracle APEX (o conectarse mediante DataGrip / SQL Developer).
2. Ejecutar los scripts de forma secuencial desde el `01` hasta el `07`.
3. Verificar la salida de los bloques de prueba en `06_pruebas.sql` y revisar las tablas finales con `07_consultas_verificacion.sql`.
