/* ============================================================================
   PARTE 7: CONSULTAS DE VERIFICACIÓN (SOLO LECTURA)
   ============================================================================ */
 
-- 7.1 Estado actual de bonificaciones por empleado
SELECT id_empleado, nombre, apellido, cargo, meta_ventas, total_ventas, total_bonificacion,
       ROUND((total_ventas / meta_ventas) * 100, 2) AS porcentaje_meta
  FROM empleados
 ORDER BY id_empleado;
 
-- 7.2 Historial de auditoría de bonificaciones
SELECT h.id_historial, e.nombre, e.apellido, h.monto_bonificacion,
       h.fecha_calculo, h.observaciones
  FROM historial_bonificaciones h
  JOIN empleados e ON e.id_empleado = h.id_empleado
 ORDER BY h.id_historial;
 
-- Consultando cambios (venta adicional de prueba) para el id 3
 SELECT COUNT(*) FROM ventas WHERE id_empleado = 3;