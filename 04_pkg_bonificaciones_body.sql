/* ============================================================================
   PARTE 4: CUERPO DEL PAQUETE pkg_bonificaciones
   ============================================================================ */
 
CREATE OR REPLACE PACKAGE BODY pkg_bonificaciones AS
 
    /* -----------------------------------------------------------------------
       FUNCIÓN fn_calcular_bono
    ----------------------------------------------------------------------- */
    FUNCTION fn_calcular_bono (
        p_total_ventas IN empleados.total_ventas%TYPE,
        p_meta_ventas  IN empleados.meta_ventas%TYPE
    ) RETURN NUMBER
    IS
        v_porcentaje_alcanzado NUMBER;
        v_monto_bono           NUMBER := 0;
    BEGIN
        -- Excepción de sistema: división por cero si la meta viene en 0
        IF p_meta_ventas = 0 THEN
            RAISE ZERO_DIVIDE;
        END IF;
 
        v_porcentaje_alcanzado := (p_total_ventas / p_meta_ventas) * 100;
 
        -- Control CASE para aplicar la regla de negocio
        CASE
            WHEN v_porcentaje_alcanzado >= 100 THEN
                v_monto_bono := p_total_ventas * 0.10;
            WHEN v_porcentaje_alcanzado >= 80 THEN
                v_monto_bono := p_total_ventas * 0.05;
            ELSE
                v_monto_bono := 0;
        END CASE;
 
        RETURN ROUND(v_monto_bono, 2);
 
    EXCEPTION
        WHEN ZERO_DIVIDE THEN
            RAISE_APPLICATION_ERROR(-20001,
                'No se puede calcular la bonificación: la meta de ventas es cero.');
    END fn_calcular_bono;
 
 
    /* -----------------------------------------------------------------------
       PROCEDIMIENTO pr_procesar_bonificacion_empleado
    ----------------------------------------------------------------------- */
    PROCEDURE pr_procesar_bonificacion_empleado (
        p_id_empleado IN empleados.id_empleado%TYPE
    )
    IS
        -- Registro con %ROWTYPE para manejar todos los datos del empleado
        v_empleado    empleados%ROWTYPE;
        v_bono_calc   NUMBER;
        v_observacion VARCHAR2(200);
    BEGIN
        -- Cursor implícito para obtener los datos del empleado
        SELECT *
          INTO v_empleado
          FROM empleados
         WHERE id_empleado = p_id_empleado;
 
        -- Cálculo de la bonificaciónn reutilizando la función del paquete
        v_bono_calc := fn_calcular_bono(v_empleado.total_ventas, v_empleado.meta_ventas);
 
        v_observacion := 'Recalculo automático - ' ||
            ROUND((v_empleado.total_ventas / v_empleado.meta_ventas) * 100, 2) ||
            '% de la meta alcanzada';
 
        -- Actualiza el campo total_bonificacion del empleado
        UPDATE empleados
           SET total_bonificacion = v_bono_calc
         WHERE id_empleado = p_id_empleado;
 
        -- Registro de auditoría en HISTORIAL_BONIFICACIONES
        INSERT INTO historial_bonificaciones
            (id_historial, id_empleado, monto_bonificacion, fecha_calculo, observaciones)
        VALUES
            (seq_historial.NEXTVAL, p_id_empleado, v_bono_calc, SYSDATE, v_observacion);
 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002,
                'El empleado con ID ' || p_id_empleado || ' no existe.');
        WHEN ZERO_DIVIDE THEN
            RAISE_APPLICATION_ERROR(-20003,
                'El empleado con ID ' || p_id_empleado || ' tiene una meta de ventas igual a cero.');
    END pr_procesar_bonificacion_empleado;
 
 
    /* -----------------------------------------------------------------------
       PROCEDIMIENTO pr_obtener_reporte_bonos 
    ----------------------------------------------------------------------- */
    PROCEDURE pr_obtener_reporte_bonos (
        p_cargo          IN  empleados.cargo%TYPE DEFAULT NULL,
        p_bono_minimo    IN  NUMBER DEFAULT NULL,
        p_cursor_reporte OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN p_cursor_reporte FOR
            SELECT id_empleado,
                   nombre,
                   apellido,
                   cargo,
                   meta_ventas,
                   total_ventas,
                   total_bonificacion,
                   ROUND((total_ventas / meta_ventas) * 100, 2) AS porcentaje_meta
              FROM empleados
             WHERE (p_cargo IS NULL OR cargo = p_cargo)
               AND (p_bono_minimo IS NULL OR total_bonificacion >= p_bono_minimo)
             ORDER BY total_bonificacion DESC;
    END pr_obtener_reporte_bonos;
 
END pkg_bonificaciones;
/
 