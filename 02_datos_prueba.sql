/* ============================================================================
   PARTE 2: DATOS DE PRUEBA (DML)
   ============================================================================ */
 
INSERT INTO empleados (id_empleado, nombre, apellido, cargo, meta_ventas, total_ventas, total_bonificacion)
VALUES (seq_empleados.NEXTVAL, 'Bruce', 'Banner', 'Ejecutivo de Ventas', 20000, 0, 0);
 
INSERT INTO empleados (id_empleado, nombre, apellido, cargo, meta_ventas, total_ventas, total_bonificacion)
VALUES (seq_empleados.NEXTVAL, 'Clark', 'Kent', 'Ejecutivo de Ventas', 15000, 0, 0);
 
INSERT INTO empleados (id_empleado, nombre, apellido, cargo, meta_ventas, total_ventas, total_bonificacion)
VALUES (seq_empleados.NEXTVAL, 'Peter', 'Parker', 'Ejecutivo Junior', 12000, 0, 0);
 
INSERT INTO empleados (id_empleado, nombre, apellido, cargo, meta_ventas, total_ventas, total_bonificacion)
VALUES (seq_empleados.NEXTVAL, 'Bruce', 'Wayne', 'Ejecutivo Senior', 25000, 0, 0);
 
COMMIT;
 
-- Las ventas se insertan mediante el trigger trg_actualizar_bono_venta,
-- por lo que total_ventas y total_bonificacion se recalculan automáticamente
-- Empleado 1 (Bruce Banner, meta 20000) -> ventas que suman 22000 (110% => bono 10%)
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 1, 12000, TO_DATE('15/01/2026','DD/MM/YYYY'), 1);
 
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 1, 10000, TO_DATE('20/02/2026','DD/MM/YYYY'), 1);
 
-- Empleado 2 (Clark kent, meta 15000) -> ventas que suman 13000 (86.6% => bono 5%)
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 2, 8000, TO_DATE('10/01/2026','DD/MM/YYYY'), 1);
 
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 2, 5000, TO_DATE('18/02/2026','DD/MM/YYYY'), 1);
 
-- Empleado 3 (Peter Parker, meta 12000) -> ventas que suman 7000 (58.3% => bono 0%)
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 3, 4000, TO_DATE('12/01/2026','DD/MM/YYYY'), 1);
 
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 3, 3000, TO_DATE('22/02/2026','DD/MM/YYYY'), 1);
 
-- Empleado 4 (Bruce Wayne, meta 25000) -> ventas que suman 26500 (106% => bono 10%)
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 4, 15000, TO_DATE('05/01/2026','DD/MM/YYYY'), 1);
 
INSERT INTO ventas (id_venta, id_empleado, monto, fecha_venta, trimestre)
VALUES (seq_ventas.NEXTVAL, 4, 11500, TO_DATE('28/02/2026','DD/MM/YYYY'), 1);
 
COMMIT;
 
 