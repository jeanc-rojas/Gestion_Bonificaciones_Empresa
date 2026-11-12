/* ============================================================================
   SISTEMA DE GESTIÓN DE BONIFICACIONES - EMPRESA TECHSALES
   Curso: BD Avanzado - Oracle PL/SQL 
   ============================================================================ */
 
/* ============================================================================
   PARTE 1: SCRIPT DDL
   ============================================================================ */

-- ----------------------------------------------------------------------------
-- Tabla: EMPLEADOS
-- ----------------------------------------------------------------------------
CREATE TABLE empleados (
    id_empleado        NUMBER(6)        NOT NULL,
    nombre             VARCHAR2(50)     NOT NULL,
    apellido           VARCHAR2(50)     NOT NULL,
    cargo              VARCHAR2(40)     NOT NULL,
    meta_ventas        NUMBER(10,2)     NOT NULL,
    total_ventas       NUMBER(12,2)     DEFAULT 0 NOT NULL,
    total_bonificacion NUMBER(10,2)     DEFAULT 0 NOT NULL,
    CONSTRAINT pk_empleados PRIMARY KEY (id_empleado),
    CONSTRAINT ck_empleados_meta_positiva CHECK (meta_ventas > 0),
    CONSTRAINT ck_empleados_ventas_no_neg CHECK (total_ventas >= 0),
    CONSTRAINT ck_empleados_bono_no_neg CHECK (total_bonificacion >= 0)
);
 
-- Índice adicional por cargo (útil para reportes filtrados)
CREATE INDEX idx_empleados_cargo ON empleados (cargo);
 
 
-- ----------------------------------------------------------------------------
-- Tabla: VENTAS
-- ----------------------------------------------------------------------------
CREATE TABLE ventas (
    id_venta      NUMBER(8)      NOT NULL,
    id_empleado   NUMBER(6)      NOT NULL,
    monto         NUMBER(10,2)   NOT NULL,
    fecha_venta   DATE           DEFAULT SYSDATE NOT NULL,
    trimestre     NUMBER(1)      NOT NULL,
    CONSTRAINT pk_ventas PRIMARY KEY (id_venta),
    CONSTRAINT fk_ventas_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleados (id_empleado),
    CONSTRAINT ck_ventas_monto_positivo CHECK (monto > 0),
    CONSTRAINT ck_ventas_trimestre CHECK (trimestre BETWEEN 1 AND 4)
);
 
-- Índice de rendimiento sobre la FK id_empleado (muy consultado por el trigger
-- y por los reportes de bonificaciones)
CREATE INDEX idx_ventas_id_empleado ON ventas (id_empleado);
CREATE INDEX idx_ventas_fecha ON ventas (fecha_venta);
 
 
-- ----------------------------------------------------------------------------
-- Tabla: HISTORIAL_BONIFICACIONES (para auditoría)
-- ----------------------------------------------------------------------------
CREATE TABLE historial_bonificaciones (
    id_historial       NUMBER(8)      NOT NULL,
    id_empleado        NUMBER(6)      NOT NULL,
    monto_bonificacion NUMBER(10,2)   NOT NULL,
    fecha_calculo       DATE          DEFAULT SYSDATE NOT NULL,
    observaciones       VARCHAR2(200),
    CONSTRAINT pk_historial_bonificaciones PRIMARY KEY (id_historial),
    CONSTRAINT fk_historial_empleado FOREIGN KEY (id_empleado)
        REFERENCES empleados (id_empleado),
    CONSTRAINT ck_historial_monto_no_neg CHECK (monto_bonificacion >= 0)
);
 
CREATE INDEX idx_historial_id_empleado ON historial_bonificaciones (id_empleado);
 
 
-- ----------------------------------------------------------------------------
-- Secuencias para generación automática de identificadores
-- ----------------------------------------------------------------------------
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_empleados';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_ventas';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN
    EXECUTE IMMEDIATE 'DROP SEQUENCE seq_historial';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
 
CREATE SEQUENCE seq_empleados START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_ventas START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE seq_historial START WITH 1 INCREMENT BY 1;
 