/* ============================================================================
   PARTE 5: TRIGGER trg_actualizar_bono_venta
   ============================================================================ */
 
CREATE OR REPLACE TRIGGER trg_actualizar_bono_venta
AFTER INSERT OR UPDATE ON ventas
FOR EACH ROW
DECLARE
    v_diferencia NUMBER;
BEGIN
    IF INSERTING THEN
        -- Suma el monto completo al total_ventas del empleado
        UPDATE empleados
           SET total_ventas = total_ventas + :NEW.monto
         WHERE id_empleado = :NEW.id_empleado;
 
    ELSIF UPDATING THEN
        -- Ajusta solo la diferencia entre el monto nuevo y el anterior
        v_diferencia := :NEW.monto - :OLD.monto;
        UPDATE empleados
           SET total_ventas = total_ventas + v_diferencia
         WHERE id_empleado = :NEW.id_empleado;
    END IF;
 
    -- Llama al paquete para recalcular y actualizar la bonificación al instante
    pkg_bonificaciones.pr_procesar_bonificacion_empleado(:NEW.id_empleado);
END;
/
 
 