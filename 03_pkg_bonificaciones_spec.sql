/* ============================================================================
   PARTE 3: ESPECIFICACIÓN DEL PAQUETE pkg_bonificaciones
   ============================================================================ */
 
CREATE OR REPLACE PACKAGE pkg_bonificaciones AS
 
    -- Excepciones personalizadas del paquete
    ex_empleado_no_existe   EXCEPTION;
    ex_meta_invalida        EXCEPTION;
 
    /* -----------------------------------------------------------------------
       Función que calcula el monto de bonificación de un empleado según
       el porcentaje alcanzado de su meta de ventas.
       Retorna: monto de bonificación
    ----------------------------------------------------------------------- */
    FUNCTION fn_calcular_bono (
        p_total_ventas IN empleados.total_ventas%TYPE,
        p_meta_ventas  IN empleados.meta_ventas%TYPE
    ) RETURN NUMBER;
 
    /* -----------------------------------------------------------------------
       Procedimiento que recalcula y actualiza la bonificación de un empleado
       específico, registrando el evento en HISTORIAL_BONIFICACIONES.
    ----------------------------------------------------------------------- */
    PROCEDURE pr_procesar_bonificacion_empleado (
        p_id_empleado IN empleados.id_empleado%TYPE
    );
 
    /* -----------------------------------------------------------------------
       Prcedimiento que devuelve, mediante un SYS_REFCURSOR, el reporte de
       bonificaciones filtrado opcionalmente por cargo y/o bonificación
       mínima.
    ----------------------------------------------------------------------- */
    PROCEDURE pr_obtener_reporte_bonos (
        p_cargo          IN  empleados.cargo%TYPE DEFAULT NULL,
        p_bono_minimo    IN  NUMBER DEFAULT NULL,
        p_cursor_reporte OUT SYS_REFCURSOR
    );
 
END pkg_bonificaciones;
/