/* ============================================================================
   PARTE 6: BLOQUE DE PRUEBA Y VALIDACIÓN
   ============================================================================
   Solo contiene pruebas con efectos (inserciones, manejo de excepciones, consumo
   de SYS_REFCURSOR)
   ============================================================================ */
 
-- 6.1 Bloque anónimo: inserta una nueva venta para Peter Parker (id 3),
--     que le hará superar el 80% de su meta y muestra el cambio automático
DECLARE
    v_ventas_antes NUMBER;
    v_bono_antes   NUMBER;
    v_ventas_despues NUMBER;
    v_bono_despues   NUMBER;
BEGIN
    SELECT total_ventas, total_bonificacion
      INTO v_ventas_antes, v_bono_antes
      FROM empleados
     WHERE id_empleado = 3;
 
    -- Nueva venta que empuja a Peter por encima del 80% de su meta
    INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
    VALUES (seq_ventas.NEXTVAL, 3, 3500, SYSDATE, 1);
 
    SELECT total_ventas, total_bonificacion
      INTO v_ventas_despues, v_bono_despues
      FROM empleados
     WHERE id_empleado = 3;
 
    DBMS_OUTPUT.PUT_LINE('--- Prueba de trigger automático (Peter Parker) ---');
    DBMS_OUTPUT.PUT_LINE('Ventas antes: ' || v_ventas_antes || ' | Bono antes: ' || v_bono_antes);
    DBMS_OUTPUT.PUT_LINE('Ventas después: ' || v_ventas_despues || ' | Bono después: ' || v_bono_despues);
END;
/
 
-- 6.2 Prueba de manejo de excepciones: intento de procesar un empleado
--     que no existe
BEGIN
    pkg_bonificaciones.pr_procesar_bonificacion_empleado(999);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Excepción controlada: ' || SQLERRM);
END;
/
 
-- 6.3 Consumo del procedimiento con SYS_REFCURSOR: reporte completo
DECLARE
    v_cursor_reporte SYS_REFCURSOR;
    v_id_empleado    empleados.id_empleado%TYPE;
    v_nombre         empleados.nombre%TYPE;
    v_apellido       empleados.apellido%TYPE;
    v_cargo          empleados.cargo%TYPE;
    v_meta           empleados.meta_ventas%TYPE;
    v_ventas         empleados.total_ventas%TYPE;
    v_bono           empleados.total_bonificacion%TYPE;
    v_porcentaje     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Reporte completo de bonificaciones ---');
 
    pkg_bonificaciones.pr_obtener_reporte_bonos(
        p_cargo          => NULL,
        p_bono_minimo    => NULL,
        p_cursor_reporte => v_cursor_reporte
    );
 
    LOOP
        FETCH v_cursor_reporte
         INTO v_id_empleado, v_nombre, v_apellido, v_cargo, v_meta, v_ventas, v_bono, v_porcentaje;
        EXIT WHEN v_cursor_reporte%NOTFOUND;
 
        DBMS_OUTPUT.PUT_LINE(
            v_id_empleado || ' - ' || v_nombre || ' ' || v_apellido ||
            ' (' || v_cargo || ') | Meta: ' || v_meta ||
            ' | Ventas: ' || v_ventas ||
            ' | Bono: ' || v_bono ||
            ' | % Meta: ' || v_porcentaje || '%'
        );
    END LOOP;
 
    CLOSE v_cursor_reporte;
END;
/
 
-- 6.4 Prueba del reporte filtrado por bonificación mínima (solo bono >= 1000)
DECLARE
    v_cursor_reporte SYS_REFCURSOR;
    v_id_empleado    empleados.id_empleado%TYPE;
    v_nombre         empleados.nombre%TYPE;
    v_apellido       empleados.apellido%TYPE;
    v_cargo          empleados.cargo%TYPE;
    v_meta           empleados.meta_ventas%TYPE;
    v_ventas         empleados.total_ventas%TYPE;
    v_bono           empleados.total_bonificacion%TYPE;
    v_porcentaje     NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Reporte filtrado: bonificación >= 1000 ---');
 
    pkg_bonificaciones.pr_obtener_reporte_bonos(
        p_cargo          => NULL,
        p_bono_minimo    => 1000,
        p_cursor_reporte => v_cursor_reporte
    );
 
    LOOP
        FETCH v_cursor_reporte
         INTO v_id_empleado, v_nombre, v_apellido, v_cargo, v_meta, v_ventas, v_bono, v_porcentaje;
        EXIT WHEN v_cursor_reporte%NOTFOUND;
 
        DBMS_OUTPUT.PUT_LINE(
            v_id_empleado || ' - ' || v_nombre || ' ' || v_apellido ||
            ' | Bono: ' || v_bono
        );
    END LOOP;
 
    CLOSE v_cursor_reporte;
END;
/
 