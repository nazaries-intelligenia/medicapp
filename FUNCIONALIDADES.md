# Funcionalidades

## Gestión Multi-Persona (V19+)

- **Soporte para múltiples personas**: Gestiona medicamentos para toda la familia desde una única aplicación (usuario principal, familiares, pacientes a cargo)
- **Sistema de tabs por persona**: Navegación rápida entre personas mediante pestañas en la pantalla principal, persona por defecto identificada visualmente
- **Asignación de medicamentos**: Interfaz dedicada para asignar/desasignar medicamentos a personas, visualización clara del estado de asignaciones, gestión desde menú contextual de cada medicamento
- **Configuración independiente**: Cada persona puede tener sus propios horarios, frecuencias y configuraciones para el mismo medicamento compartido
- **Stock compartido**: Los medicamentos físicos se comparten (un solo stock), pero cada persona tiene su seguimiento independiente
- **Notificaciones por persona**: Las notificaciones se envían según la configuración de cada persona, con identificación clara del destinatario
- **Historial por persona**: Seguimiento independiente de adherencia y tomas para cada persona
- **Gestión de personas**: Crear, editar y eliminar personas desde Ajustes, una persona siempre marcada como por defecto, protección contra eliminación accidental
- **Migración automática**: Los datos existentes se migran automáticamente a la persona por defecto al actualizar a V19+

## Gestión de Medicamentos

- **Añadir medicamentos**: Flujo guiado modular con 8 pasos para medicamentos programados (información básica, duración, fechas, frecuencia, dosis, horarios, ayuno, stock) o flujo simplificado de 2 pasos para medicamentos ocasionales
- **Tipos de medicamento**: 7 tipos disponibles (Pastilla, Inyección, Óvulo, Aplicación, Gota, Gramo, Mililitro), cada uno con su unidad específica
- **Programación de horarios**: Múltiples horarios por medicamento con dosis personalizadas, intervalo de dosis fijo o horarios específicos, validación de divisores de 24 horas
- **Duración del tratamiento**: 6 opciones: todos los días, hasta acabar medicación, fechas específicas, días de la semana, cada N días, o según necesidad (ocasional)
- **Control de fechas**: Fecha de inicio/fin opcional, progreso del tratamiento, estados pendiente/activo/finalizado
- **Registro de tomas**: Sistema inteligente con registro programado (selección de horarios, opción de toma extra siempre visible, validaciones de stock y dosis disponibles) y registro manual para ocasionales. **Tomas extra/excepcionales** fuera de horario programado con confirmación cuando todas las tomas están registradas, registro independiente en historial con badge distintivo (estrella púrpura), soporte de ayuno "después" dinámico, visualización en pantalla principal con indicadores diferenciados. Reprogramación inteligente de notificaciones que previene duplicados cuando se toma antes de tiempo
- **Gestión de stock (Pastillero)**: Pantalla dedicada con indicadores visuales (verde/naranja/rojo), cálculo automático de duración estimada (basado en dosis diaria o consumo real para ocasionales), umbral configurable (1-30 días), tarjetas resumen con totales
- **Botiquín**: Lista alfabética completa con buscador integrado, modal de acciones rápidas (reanudar, registrar, recargar, editar, eliminar), recarga inteligente con sugerencias basadas en última recarga, registro de ocasionales con aparición automática en pantalla principal, pull-to-refresh
- **Próxima toma**: Visualiza la hora de la siguiente toma en la lista principal
- **Notificaciones push**: Recordatorios automáticos diarios con nombre y tipo, cancelación inteligente al registrar tomas, acciones directas desde notificaciones (registrar/marcar no tomada/posponer), navegación robusta con reintentos, actualización automática de la pantalla principal
- **Configuración de ayuno**: Tipo (antes/después), duración personalizable en horas y minutos, notificaciones inteligentes (ayuno "antes" programado automáticamente, ayuno "después" dinámico basado en hora real de toma), fusión automática de solapamientos, edición flexible, **cuenta atrás visual** opcional (activa/próxima según tipo de ayuno, tiempo restante en formato legible, colores diferenciados, preferencia configurable desde Ajustes), **notificación fija persistente** (solo Android, muestra medicamento más urgente, actualización automática cada minuto, no descartable, prioridad baja)
- **Historial de dosis**: Registro automático con hora programada y real, estadísticas de adherencia (total, tomadas, omitidas, porcentaje), vista cronológica con indicadores de puntualidad y códigos de color, filtros por fecha y medicamento, tabla optimizada con índices, **edición de hora de registro** (cambiar hora real de toma desde historial, también disponible en pantalla principal cuando ajuste "mostrar hora real" está activo, preserva todos los campos excepto hora registrada)
- **Navegación por días en pantalla principal**: Deslizar horizontalmente para navegar entre días (deslizar izquierda para día anterior, derecha para día siguiente), navegación ilimitada hacia pasado y futuro, título actualizado dinámicamente con la fecha seleccionada, visualización histórica completa (medicamentos programados con todas sus tomas registradas/omitidas/extras y medicamentos ocasionales tomados ese día), edición completa de tomas históricas (cambiar estado, eliminar, cambiar hora de registro), operaciones solo afectan al historial sin modificar stock actual en días anteriores
- **Edición modular**: 6 secciones independientes (información básica, duración, frecuencia, horarios, ayuno, cantidad), cada sección se guarda inmediatamente, preservación automática de todos los campos
- **Suspensión de medicamentos**: Pausa temporal de notificaciones, visibilidad selectiva (no aparece en Pastillero ni pantalla principal, sí en Botiquín), reactivación rápida desde el Botiquín
- **Validación inteligente**: Prevención de duplicados (case-insensitive), validación de fechas/días/frecuencias, alertas de horarios duplicados, validación de cantidades no negativas
- **Interfaz responsiva**: Material Design 3, layout adaptable (3 medicamentos por fila), scroll optimizado. Navegación adaptativa con 4 secciones (Inicio, Medicinas, Historial, Ajustes), pestañas Material 3 para Pastillero/Botiquín, etiquetas adaptativas según dispositivo, NavigationBar (móviles ≤600px) o NavigationRail (tablets/horizontal), pull-to-refresh
- **Indicadores visuales de stock**: Códigos de color en pantalla principal (rojo: agotado, naranja: bajo, sin indicador: suficiente), detalles al tocar (cantidad exacta y duración estimada)
- **Soporte multiidioma**: 5 idiomas (Español, Inglés, Catalán, Gallego, Euskera), detección automática según sistema, traducciones completas, sistema extensible con archivos ARB
- **Exportación e importación de base de datos**: Backup completo con timestamp, compartir mediante cualquier app, importación con validación de integridad, backup automático antes de importar, restauración automática si falla, accesible desde ajustes

## Herramientas de Depuración

- **Pantalla de depuración de notificaciones**: Pantalla completa dedicada con pestañas por persona, información detallada de estado (permisos de notificaciones, permisos de alarmas exactas, contador de notificaciones pendientes), listado de notificaciones agendadas filtrado por persona (tipo de notificación, medicamento, fecha y hora programadas, indicadores de urgencia), visualización de medicamentos y horarios configurados por persona, accesible desde menú de depuración (múltiples toques en título)
