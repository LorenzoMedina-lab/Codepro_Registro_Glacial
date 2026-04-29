# 🐧 Data Engineering Challenge - Penguin Academy

## 🚀 Descripción del Proyecto
Este repositorio contiene la solución técnica integral para el diseño, modelado y construcción de una base de datos relacional robusta en **PostgreSQL**. El proyecto se centra en la transformación de un conjunto de datos (dataset) crudo e inconsistente proveniente de archivos CSV en un núcleo transaccional íntegro, optimizado y auditable para un sistema de e-commerce.

## 🛠️ Arquitectura y Flujo de Trabajo
El proyecto implementa un flujo **ETL (Extract, Transform, Load)** dividido en 5 etapas secuenciales, asegurando la separación de preocupaciones y la trazabilidad del dato:

1. **`01_tablas_staging.sql`**: Creación del esquema de "cuarentena" con tipos de datos flexibles (`TEXT`) para permitir la ingesta total del origen sin bloqueos de formato.
2. **`02_validacion_anomalias_staging.sql`**: Análisis profundo de inconsistencias estructurales, errores matemáticos y corrupción de tipos presentes en el dataset original.
3. **`03_core_schema_and_load.sql`**: Definición del esquema transaccional final (`public`) aplicando **Normalización**, **PK**, **FK** y **CHECK Constraints**.
4. **`04_etl_migration.sql`**: Lógica de limpieza y transformación (manejo de nulos, eliminación de espacios, casting de tipos) y carga definitiva de datos.
5. **`05_queries_and_validations.sql`**: Consultas de validación de integridad y generación de indicadores de negocio clave.

## 🕵️ Hallazgos de la Auditoría de Datos
A través de la implementación de reglas de integridad en el motor de base de datos, se detectaron y neutralizaron las siguientes anomalías:
- **6,911 Pagos Inválidos:** Registros con montos de 0.00 o negativos que fueron bloqueados por restricciones de chequeo financiero.
- **Corrupción de Auditoría:** Campos numéricos que contenían valores de texto en el origen.
- **Fallas Matemáticas:** Descuentos en la tabla de ítems que no habían sido aplicados al total de línea en el CSV original.

## 🔐 Seguridad y Mejores Prácticas
Se documenta y justifica la prevención de vulnerabilidades de **SQL Injection** mediante el aislamiento de esquemas y la recomendación del uso de **Consultas Parametrizadas** en la capa de aplicación, garantizando que el motor trate las entradas de usuario como datos y no como comandos ejecutables.

## 📊 Métricas Finales del Sistema
Tras el proceso de limpieza, la base de datos se consolidó con los siguientes volúmenes de datos íntegros:
- **Clientes:** 30,000
- **Productos:** 8,000
- **Órdenes:** 120,000
- **Pagos Consolidados:** 133,089 (Filtrados de 140,000 originales)
- **Ítems de Pedido:** 360,000

## ⚙️ Requisitos e Instalación
1. Clonar el repositorio.
2. Contar con una instancia de **PostgreSQL 14+**.
3. Ejecutar los scripts en el orden numérico indicado (`01` al `05`) utilizando **pgAdmin 4** o `psql`.

---
*Proyecto desarrollado como parte del programa CodePRO en Penguin Academy.*
