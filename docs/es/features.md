# Funcionalidades de MedicApp

Este documento detalla todas las características y capacidades de MedicApp, una aplicación avanzada de gestión de medicamentos diseñada para familias y cuidadores.

---

## 1. Gestión Multi-Persona (V19+)

### Arquitectura Muchos-a-Muchos

MedicApp implementa una arquitectura sofisticada de gestión multi-persona que permite a múltiples usuarios compartir medicamentos mientras mantienen configuraciones de tratamiento individuales. Esta funcionalidad está diseñada específicamente para familias, cuidadores profesionales y grupos que necesitan coordinar la medicación de varias personas.

La arquitectura se basa en un modelo relacional de muchos-a-muchos, donde cada medicamento (identificado por nombre, tipo y stock compartido) puede ser asignado a múltiples personas, y cada persona puede tener múltiples medicamentos. El stock se gestiona de forma centralizada y se descuenta automáticamente independientemente de quién tome el medicamento, lo que permite un control preciso del inventario compartido sin duplicar datos.

Cada persona puede configurar su propia pauta de tratamiento para el mismo medicamento, incluyendo horarios específicos, dosis personalizadas, duración del tratamiento, y preferencias de ayuno. Por ejemplo, si una madre y su hija comparten un mismo medicamento, la madre puede tener configuradas tomas a las 8:00 y 20:00, mientras que la hija solo necesita una dosis diaria a las 12:00. Ambas comparten el mismo stock físico, pero cada una recibe notificaciones y seguimiento independiente según su pauta.

### Casos de Uso

Esta funcionalidad es especialmente útil en varios escenarios: familias donde varios miembros toman el mismo medicamento (como vitaminas o suplementos), cuidadores profesionales que gestionan la medicación de múltiples pacientes, hogares multigeneracionales donde se comparten medicamentos comunes, y situaciones donde se necesita controlar el stock compartido para evitar desabastecimientos. El sistema permite realizar un seguimiento detallado del historial de dosis por persona, facilitando la adherencia terapéutica y el control médico individualizado.

---

## 2. 14 Tipos de Medicamentos

### Catálogo Completo de Formas Farmacéuticas

MedicApp soporta 14 tipos diferentes de medicamentos, cada uno con iconografía distintiva, esquema de colores específico y unidades de medida apropiadas. Esta diversidad permite registrar prácticamente cualquier forma farmacéutica que se encuentre en un botiquín doméstico o profesional.

**Tipos disponibles:**

1. **Pastilla** - Color azul, icono circular. Unidad: pastillas. Para comprimidos sólidos tradicionales.
2. **Cápsula** - Color morado, icono de cápsula. Unidad: cápsulas. Para medicamentos en forma de cápsula gelatinosa.
3. **Inyección** - Color rojo, icono de jeringuilla. Unidad: inyecciones. Para medicamentos que requieren administración parenteral.
4. **Jarabe** - Color naranja, icono de vaso. Unidad: ml (mililitros). Para medicamentos líquidos de administración oral.
5. **Óvulo** - Color rosa, icono ovalado. Unidad: óvulos. Para medicamentos de administración vaginal.
6. **Supositorio** - Color verde azulado (teal), icono específico. Unidad: supositorios. Para administración rectal.
7. **Inhalador** - Color cian, icono de aire. Unidad: inhalaciones. Para medicamentos respiratorios.
8. **Sobre** - Color marrón, icono de paquete. Unidad: sobres. Para medicamentos en polvo o granulados.
9. **Spray** - Color azul claro, icono de goteo. Unidad: ml (mililitros). Para nebulizadores y aerosoles nasales.
10. **Pomada** - Color verde, icono de gota opaca. Unidad: gramos. Para medicamentos tópicos cremosos.
11. **Loción** - Color índigo, icono de agua. Unidad: ml (mililitros). Para medicamentos líquidos tópicos.
12. **Apósito** - Color ámbar, icono de curación. Unidad: apósitos. Para parches medicados y apósitos terapéuticos.
13. **Gota** - Color gris azulado, icono de gota invertida. Unidad: gotas. Para colirios y gotas óticas.
14. **Otro** - Color gris, icono genérico. Unidad: unidades. Para cualquier forma farmacéutica no categorizada.

### Beneficios del Sistema de Tipos

Esta clasificación detallada permite al sistema calcular automáticamente el stock de forma precisa según la unidad de medida correspondiente, mostrar iconos y colores que facilitan la identificación visual rápida, y generar notificaciones contextuales que mencionan el tipo específico de medicamento. Los usuarios pueden gestionar desde tratamientos simples con pastillas hasta regímenes complejos que incluyen inhaladores, inyecciones y gotas, todo dentro de una misma interfaz coherente.

---

## 3. Flujo de Adición de Medicamentos

### Medicamentos Programados (8 Pasos)

El proceso de adición de un medicamento con horario programado es guiado y estructurado para asegurar que se configure correctamente toda la información necesaria:

**Paso 1: Información Básica** - Se introduce el nombre del medicamento y se selecciona el tipo de entre las 14 opciones disponibles. El sistema valida que el nombre no esté vacío.

**Paso 2: Frecuencia de Tratamiento** - Se define el patrón de toma con seis opciones: todos los días, hasta acabar medicación, fechas específicas, días de la semana, cada N días, o según necesidad. Esta configuración determina cuándo se deben tomar las dosis.

**Paso 3: Configuración de Dosis** - Se establecen los horarios específicos de toma. El usuario puede elegir entre modo uniforme (misma dosis en todos los horarios) o dosis personalizadas por cada horario. Por ejemplo, se puede configurar 1 pastilla a las 8:00, 0.5 pastillas a las 14:00 y 2 pastillas a las 20:00.

**Paso 4: Horarios de Toma** - Se seleccionan las horas exactas en que se debe tomar el medicamento utilizando un selector de tiempo visual. Se pueden configurar múltiples horarios por día según lo prescrito.

**Paso 5: Duración del Tratamiento** - Si aplica según el tipo de frecuencia, se establecen las fechas de inicio y fin del tratamiento. Esto permite programar tratamientos con duración definida o tratamientos continuos.

**Paso 6: Configuración de Ayuno** - Se define si el medicamento requiere ayuno antes o después de la toma, la duración del período de ayuno en minutos, y si se desean notificaciones de recordatorio de ayuno.

**Paso 7: Stock Inicial** - Se introduce la cantidad de medicamento disponible en las unidades correspondientes al tipo seleccionado. El sistema utilizará este valor para el control de inventario.

**Paso 8: Asignación de Personas** - Se seleccionan las personas que tomarán este medicamento. Para cada persona, se puede configurar una pauta individual con horarios y dosis personalizadas, o heredar la configuración base.

### Medicamentos Ocasionales (2 Pasos)

Para medicamentos de uso esporádico o "según necesidad", el proceso se simplifica significativamente:

**Paso 1: Información Básica** - Nombre y tipo del medicamento.

**Paso 2: Stock Inicial** - Cantidad disponible. El sistema automáticamente configura el medicamento como "según necesidad", sin horarios programados ni notificaciones automáticas.

### Validaciones Automáticas

Durante todo el proceso, MedicApp valida que se hayan completado todos los campos obligatorios antes de permitir avanzar al siguiente paso. Se verifica que los horarios sean lógicos, que las dosis sean valores numéricos positivos, que las fechas de inicio no sean posteriores a las de fin, y que al menos se asigne una persona al medicamento.

---

## 4. Registro de Tomas

### Tomas Programadas

MedicApp gestiona automáticamente las tomas programadas según la configuración de cada medicamento y persona. Cuando llega la hora de una dosis, el usuario recibe una notificación y puede registrar la toma desde tres puntos: la pantalla principal donde aparece listada la dosis pendiente, la notificación directamente mediante acciones rápidas, o al tocar la notificación que abre una pantalla de confirmación detallada.

Al registrar una toma programada, el sistema descuenta automáticamente la cantidad correspondiente del stock compartido, marca la dosis como tomada en el día actual para esa persona específica, crea una entrada en el historial de dosis con timestamp exacto, y cancela la notificación pendiente si existe. Si el medicamento requiere ayuno posterior, se programa inmediatamente una notificación de fin de ayuno y se muestra una cuenta atrás visual en la pantalla principal.

### Tomas Ocasionales

Para medicamentos configurados como "según necesidad" o cuando se necesita registrar una toma fuera de horario, MedicApp permite el registro manual. El usuario accede al medicamento desde el botiquín, selecciona "Tomar dosis", introduce la cantidad tomada manualmente, y el sistema descuenta del stock y registra en el historial con el horario actual. Esta funcionalidad es esencial para analgésicos, antitérmicos y otros medicamentos de uso esporádico.

### Tomas Excepcionales

El sistema también permite registrar dosis adicionales no programadas para medicamentos con horario fijo. Por ejemplo, si un paciente necesita una dosis extra de analgésico entre sus tomas habituales, puede registrarla como "dosis extra". Esta dosis se registra en el historial marcada como excepcional, descuenta stock, pero no afecta el seguimiento de adherencia de las dosis programadas regulares.

### Historial Automático

Cada acción de registro genera automáticamente una entrada completa en el historial que incluye: la fecha y hora programada de la dosis, la fecha y hora real de administración, la persona que tomó el medicamento, el nombre y tipo del medicamento, la cantidad exacta administrada, el estado (tomada o omitida), y si fue una dosis extra no programada. Este historial permite análisis detallado de la adherencia terapéutica y facilita reportes médicos.

---

## 5. Gestión de Fechas de Caducidad

### Control de Caducidad de Medicamentos

MedicApp permite registrar y monitorizar las fechas de caducidad de los medicamentos para garantizar la seguridad del tratamiento. Esta funcionalidad es especialmente importante para medicamentos ocasionales y suspendidos que permanecen almacenados durante períodos prolongados.

El sistema utiliza un formato simplificado MM/AAAA (mes/año) que coincide con el formato estándar impreso en los envases de medicamentos. Esto facilita la introducción de datos sin necesidad de conocer el día exacto de caducidad.

### Detección Automática de Estado

MedicApp evalúa automáticamente el estado de caducidad de cada medicamento:

- **Caducado**: El medicamento ha superado su fecha de caducidad y se muestra con una etiqueta roja de advertencia con icono de alerta.
- **Próximo a caducar**: Faltan 30 días o menos para la caducidad, se muestra con una etiqueta naranja de precaución con icono de reloj.
- **En buen estado**: Más de 30 días hasta la caducidad, no se muestra advertencia especial.

Las alertas visuales aparecen directamente en la tarjeta del medicamento en el botiquín, junto al estado de suspensión si aplica, permitiendo identificar rápidamente medicamentos que requieren atención.

### Registro de Fecha de Caducidad

El sistema solicita la fecha de caducidad en tres momentos específicos:

1. **Al crear medicamento ocasional**: Como último paso del proceso de creación (paso 2/2), se muestra un diálogo opcional para ingresar la fecha de caducidad antes de guardar el medicamento.

2. **Al suspender medicamento**: Cuando se suspende cualquier medicamento para todos los usuarios que lo comparten, se solicita la fecha de caducidad. Esto permite registrar la fecha del envase que quedará almacenado.

3. **Al recargar medicamento ocasional**: Después de añadir stock a un medicamento ocasional, se ofrece actualizar la fecha de caducidad para reflejar la fecha del nuevo envase adquirido.

En todos los casos, el campo es opcional y se puede omitir. El usuario puede cancelar la operación o simplemente dejar el campo vacío.

### Formato y Validaciones

El diálogo de entrada de fecha de caducidad proporciona dos campos separados:
- Campo de mes (MM): acepta valores de 01 a 12
- Campo de año (AAAA): acepta valores de 2000 a 2100

El sistema valida automáticamente que el mes esté en el rango correcto y que el año sea válido. Al completar el mes (2 dígitos), el foco se mueve automáticamente al campo de año para agilizar la entrada de datos.

La fecha se almacena en formato "MM/AAAA" (ejemplo: "03/2025") y se interpreta como el último día de ese mes para las comparaciones de caducidad. Esto significa que un medicamento con fecha "03/2025" se considerará caducado a partir del 1 de abril de 2025.

### Beneficios del Sistema

Esta funcionalidad ayuda a:
- Prevenir el uso de medicamentos caducados que podrían ser inefectivos o peligrosos
- Gestionar eficientemente el stock identificando medicamentos próximos a caducar
- Priorizar el uso de medicamentos según su fecha de caducidad
- Mantener un botiquín seguro con control visual del estado de cada medicamento
- Evitar desperdicios recordando revisar medicamentos antes de que caduquen

El sistema no impide el registro de dosis con medicamentos caducados, pero sí proporciona advertencias visuales claras para que el usuario tome decisiones informadas.

---

## 6. Control de Stock (Pastillero)

### Indicadores Visuales Intuitivos

El sistema de control de stock de MedicApp proporciona información en tiempo real del inventario disponible mediante un sistema de semáforos visuales. Cada medicamento muestra su cantidad actual en las unidades correspondientes, con indicadores de color que alertan sobre el estado del stock.

El código de colores es intuitivo: verde indica stock suficiente para más de 3 días, amarillo/ámbar alerta que el stock está bajo (menos de 3 días de suministro), y rojo indica que el medicamento está agotado. Los umbrales de días son configurables por medicamento, permitiendo ajustes según la criticidad de cada tratamiento.

### Cálculo Automático Inteligente

El cálculo de días restantes se realiza automáticamente considerando múltiples factores. Para medicamentos programados, el sistema analiza la dosis diaria total sumando todas las tomas configuradas de todas las personas asignadas, divide el stock actual entre esta dosis diaria, y estima los días de suministro restantes.

Para medicamentos ocasionales o "según necesidad", el sistema utiliza un algoritmo adaptativo que registra el consumo del último día de uso y lo emplea como predictor para estimar cuántos días durará el stock actual. Esta estimación se actualiza automáticamente cada vez que se registra un uso del medicamento.

### Umbral Configurable por Medicamento

Cada medicamento puede tener un umbral de alerta personalizado que determina cuándo se considera que el stock está bajo. El valor predeterminado es 3 días, pero puede ajustarse entre 1 y 10 días según las necesidades. Por ejemplo, medicamentos críticos como insulina pueden configurarse con un umbral de 7 días para permitir tiempo suficiente de reposición, mientras que suplementos menos críticos pueden usar umbrales de 1-2 días.

### Alertas y Reposición

Cuando el stock alcanza el umbral configurado, MedicApp muestra alertas visuales destacadas en la pantalla principal y en la vista de pastillero. El sistema sugiere automáticamente la cantidad a reponer basándose en el último reabastecimiento registrado, agilizando el proceso de actualización de inventario. Las alertas persisten hasta que el usuario registra nueva cantidad en stock, asegurando que no se olviden reposiciones críticas.

---

## 7. Botiquín

### Lista Alfabética Organizada

El botiquín de MedicApp presenta todos los medicamentos registrados en una lista ordenada alfabéticamente, facilitando la localización rápida de cualquier medicamento. Cada entrada muestra el nombre del medicamento, el tipo con su icono y color distintivo, el stock actual en las unidades correspondientes, y las personas asignadas a ese medicamento.

La vista de botiquín es especialmente útil para tener una visión global del inventario de medicamentos disponibles, sin la información de horarios que puede resultar abrumadora en la vista principal. Es la pantalla ideal para gestiones de inventario, búsqueda de medicamentos específicos y acciones de mantenimiento.

### Buscador en Tiempo Real

Un campo de búsqueda en la parte superior permite filtrar medicamentos instantáneamente mientras se escribe. La búsqueda es inteligente y considera tanto el nombre del medicamento como el tipo, lo que permite encontrar "todos los jarabes" o "medicamentos que contengan aspirina" con rapidez. Los resultados se actualizan en tiempo real sin necesidad de presionar botones adicionales.

### Acciones Rápidas Integradas

Desde cada medicamento en el botiquín, se puede acceder a un menú contextual con tres acciones principales:

**Editar** - Abre el editor completo del medicamento donde se pueden modificar todos los aspectos: nombre, tipo, horarios, dosis, personas asignadas, configuración de ayuno, etc. Los cambios se guardan y se resincronizan automáticamente las notificaciones.

**Eliminar** - Permite borrar permanentemente el medicamento del sistema tras una confirmación de seguridad. Esta acción cancela todas las notificaciones asociadas y elimina el registro del historial futuro, pero preserva el historial de dosis ya registradas para mantener integridad de datos.

**Tomar dosis** - Atajo rápido para registrar una toma manual, especialmente útil para medicamentos ocasionales. Si el medicamento está asignado a múltiples personas, primero solicita seleccionar quién lo toma.

### Gestión de Asignaciones

El botiquín también facilita la gestión de asignaciones persona-medicamento. Se pueden ver de un vistazo qué medicamentos están asignados a cada persona, agregar o quitar personas de un medicamento existente, y modificar las pautas individuales de cada persona sin afectar a los demás.

---

## 8. Navegación Temporal

### Deslizar Horizontal por Días

La pantalla principal de MedicApp implementa un sistema de navegación temporal que permite al usuario moverse entre diferentes días con un simple gesto de deslizar horizontal. Deslizar hacia la izquierda avanza al día siguiente, mientras que deslizar hacia la derecha retrocede al día anterior. Esta navegación es fluida y utiliza transiciones animadas que proporcionan feedback visual claro del cambio de fecha.

La navegación temporal es prácticamente ilimitada hacia el pasado y el futuro, permitiendo revisar el historial de medicación de semanas o meses atrás, o planificar con anticipación verificando qué medicamentos estarán programados en fechas futuras. El sistema mantiene un punto central virtual que permite miles de páginas en ambas direcciones sin impacto en el rendimiento.

### Selector de Calendario

Para saltos rápidos a fechas específicas, MedicApp integra un selector de calendario accesible desde un botón en la barra superior. Al tocar el icono de calendario, se abre un widget de calendario visual donde el usuario puede seleccionar cualquier fecha. Al seleccionar, la vista se actualiza instantáneamente para mostrar los medicamentos programados de ese día específico.

El calendario marca visualmente el día actual con un indicador destacado, facilita la selección de fechas pasadas para revisar adherencia, permite saltar a fechas futuras para planificación de viajes o eventos, y muestra la fecha seleccionada actual en la barra superior de forma permanente.

### Vista Día vs Vista Semanal

Aunque la navegación principal es por día, MedicApp proporciona contexto temporal adicional mostrando información relevante del período seleccionado. En la vista principal, los medicamentos se agrupan por horario de toma, lo que proporciona una línea temporal del día. Los indicadores visuales muestran qué dosis ya fueron tomadas, cuáles fueron omitidas, y cuáles están pendientes.

Para medicamentos con patrones semanales o intervalos específicos, la interfaz indica claramente si el medicamento corresponde al día seleccionado o no. Por ejemplo, un medicamento configurado para "lunes, miércoles, viernes" solo aparece en la lista cuando se visualizan esos días de la semana.

### Beneficios de la Navegación Temporal

Esta funcionalidad es especialmente valiosa para verificar si se tomó un medicamento en un día pasado, planificar qué medicamentos llevar en un viaje basándose en las fechas, revisar patrones de adherencia semanales o mensuales, y coordinar medicaciones de múltiples personas en un hogar durante períodos específicos.

---

## 9. Notificaciones Inteligentes

### Acciones Directas desde Notificación

MedicApp revoluciona la gestión de medicamentos mediante notificaciones con acciones integradas que permiten gestionar las dosis sin abrir la aplicación. Cuando llega la hora de una dosis, la notificación muestra tres botones de acción directa:

**Tomar** - Registra la dosis inmediatamente, descuenta del stock, crea entrada en historial, cancela la notificación, y si aplica, inicia el período de ayuno posterior con cuenta atrás.

**Posponer** - Aplaza la notificación por 10, 30 o 60 minutos según la opción seleccionada. La notificación reaparece automáticamente en el tiempo especificado.

**Saltar** - Registra la dosis como omitida, crea entrada en historial con estado "saltada" sin descontar stock, y cancela la notificación sin programar recordatorios adicionales.

Estas acciones funcionan incluso cuando el teléfono está bloqueado, haciendo que el registro de medicación sea instantáneo y sin fricción. El usuario puede gestionar su medicación completa desde las notificaciones sin necesidad de desbloquear el dispositivo o abrir la app.

### Cancelación Inteligente

El sistema de notificaciones implementa lógica avanzada de cancelación para evitar alertas redundantes o incorrectas. Cuando un usuario registra una dosis manualmente desde la app (sin usar la notificación), el sistema cancela automáticamente la notificación pendiente de esa dosis específica para ese día.

Si un medicamento se elimina o se suspende, todas sus notificaciones futuras se cancelan inmediatamente en segundo plano. Cuando se modifica el horario de un medicamento, las notificaciones antiguas se cancelan y se reprograman automáticamente con los nuevos horarios. Esta gestión inteligente asegura que el usuario solo reciba notificaciones relevantes y actuales.

### Notificaciones Persistentes para Ayuno

Para medicamentos que requieren ayuno, MedicApp muestra una notificación persistente especial durante todo el período de ayuno. Esta notificación no puede ser desechada manualmente y muestra una cuenta atrás en tiempo real del tiempo restante hasta que se pueda comer. Incluye la hora exacta en que finalizará el ayuno, lo que permite al usuario planificar sus comidas.

La notificación de ayuno tiene prioridad alta pero no emite sonido continuamente, evitando interrupciones molestas mientras mantiene visible la información crítica. Cuando finaliza el período de ayuno, la notificación se cancela automáticamente y se emite una alerta sonora breve para notificar al usuario que ya puede comer.

### Configuración Personalizada por Medicamento

Cada medicamento puede tener su configuración de notificaciones ajustada individualmente. Los usuarios pueden habilitar o deshabilitar notificaciones completamente para medicamentos específicos, manteniéndolos en el sistema para seguimiento pero sin alertas automáticas. Esta flexibilidad es útil para medicamentos que el usuario toma por rutina y no necesita recordatorios.

Además, la configuración de ayuno permite decidir si se desean notificaciones de inicio de ayuno (para medicamentos con ayuno previo) o simplemente usar la función sin alertas. MedicApp respeta estas preferencias individuales mientras mantiene la consistencia en el registro y seguimiento de todas las dosis.

### Compatibilidad con Android 12+

MedicApp está optimizado para Android 12 y versiones superiores, requiriendo y gestionando los permisos de "Alarmas y recordatorios" necesarios para notificaciones exactas. La aplicación detecta automáticamente si estos permisos no están concedidos y guía al usuario para habilitarlos desde la configuración del sistema, asegurando que las notificaciones lleguen puntualmente a la hora programada.

### Configuración de Tono de Notificación (Android 8.0+)

En dispositivos con Android 8.0 (API 26) o superior, MedicApp ofrece acceso directo a la configuración del tono de notificación desde los ajustes de la aplicación. Esta funcionalidad permite personalizar el sonido, vibración y otros parámetros de las notificaciones utilizando los canales de notificación del sistema.

La opción "Tono de notificación" solo aparece en la pantalla de Ajustes cuando el dispositivo cumple los requisitos mínimos de versión del sistema operativo. En versiones anteriores a Android 8.0, esta opción se oculta automáticamente ya que el sistema no soporta la configuración granular de canales de notificación.

---

## 10. Alertas de Stock Bajo

### Notificaciones Reactivas de Stock Insuficiente

MedicApp implementa un sistema inteligente de alertas de stock que protege al usuario de quedarse sin medicación en momentos críticos. Cuando un usuario intenta registrar una dosis (ya sea desde la pantalla principal o desde las acciones rápidas de notificación), el sistema verifica automáticamente si hay stock suficiente para completar la toma.

Si el stock disponible es menor que la cantidad requerida para la dosis, MedicApp muestra inmediatamente una alerta de stock insuficiente que impide el registro de la toma. Esta notificación reactiva indica claramente el nombre del medicamento afectado, la cantidad necesaria versus la disponible, y sugiere reponer el inventario antes de intentar registrar la dosis nuevamente.

Este mecanismo de protección previene registros incorrectos en el historial y garantiza la integridad del control de inventario, evitando que se descuente stock que físicamente no existe. La alerta es clara, no intrusiva, y guía al usuario directamente hacia la acción correctiva (reponer stock).

### Notificaciones Proactivas de Stock Bajo

Además de las alertas reactivas en el momento de tomar una dosis, MedicApp incluye un sistema proactivo de monitoreo diario de stock que anticipa problemas de desabastecimiento antes de que ocurran. Este sistema evalúa automáticamente el inventario de todos los medicamentos una vez al día, calculando los días de suministro restantes según el consumo programado.

El cálculo considera múltiples factores para estimar con precisión cuánto durará el stock actual:

**Para medicamentos programados** - El sistema suma la dosis diaria total de todas las personas asignadas, multiplica por los días configurados en el patrón de frecuencia (por ejemplo, si se toma solo lunes, miércoles y viernes, ajusta el cálculo), y divide el stock actual entre este consumo diario efectivo.

**Para medicamentos ocasionales ("según necesidad")** - Utiliza el registro del último día de consumo real como predictor, proporcionando una estimación adaptativa que mejora con el uso.

Cuando el stock de un medicamento alcanza el umbral configurado (por defecto 3 días, pero personalizable entre 1-10 días por medicamento), MedicApp emite una notificación proactiva de advertencia. Esta notificación muestra:

- Nombre del medicamento y tipo
- Días aproximados de suministro restantes
- Persona(s) afectada(s)
- Stock actual en unidades correspondientes
- Sugerencia de reposición

### Prevención de Spam de Notificaciones

Para evitar bombardear al usuario con alertas repetitivas, el sistema de notificaciones proactivas implementa lógica inteligente de frecuencia. Cada tipo de alerta de stock bajo se emite máximo una vez al día por medicamento. El sistema registra la última fecha en que se envió cada alerta y no vuelve a notificar hasta que:

1. Haya pasado al menos 24 horas desde la última alerta, O
2. El usuario haya repuesto el stock (restableciendo el contador)

Esta prevención de spam asegura que las notificaciones sean útiles y oportunas sin convertirse en una molestia que lleve al usuario a ignorarlas o deshabilitarlas.

### Integración con Control de Stock Visual

Las alertas de stock bajo no funcionan de forma aislada, sino que están profundamente integradas con el sistema de semáforos visuales del pastillero. Cuando un medicamento tiene stock bajo:

- Aparece marcado en rojo o ámbar en la lista del botiquín
- Muestra un icono de advertencia en la pantalla principal
- La notificación proactiva complementa estas señales visuales

Esta multicapa de información (visual + notificaciones) garantiza que el usuario sea consciente del estado del inventario desde múltiples puntos de contacto con la aplicación.

### Configuración y Personalización

Cada medicamento puede tener un umbral de alerta personalizado que determina cuándo se considera el stock "bajo". Medicamentos críticos como insulina o anticoagulantes pueden configurarse con umbrales de 7-10 días para permitir tiempo amplio de reposición, mientras que suplementos menos urgentes pueden usar umbrales de 1-2 días.

El sistema respeta estas configuraciones individuales, permitiendo que cada medicamento tenga su propia política de alertas adaptada a su criticidad y disponibilidad en farmacias.

---

## 11. Configuración de Ayuno

### Tipos: Before (Antes) y After (Después)

MedicApp soporta dos modalidades de ayuno claramente diferenciadas para adaptarse a diferentes prescripciones médicas:

**Ayuno Before (Antes)** - Se configura cuando el medicamento debe tomarse con el estómago vacío. El usuario debe haber ayunado durante el período especificado ANTES de tomar el medicamento. Por ejemplo, "30 minutos de ayuno antes" significa no haber comido nada durante los 30 minutos previos a la toma. Este tipo es común en medicamentos que requieren absorción óptima sin interferencia alimentaria.

**Ayuno After (Después)** - Se configura cuando después de tomar el medicamento se debe esperar sin comer. Por ejemplo, "60 minutos de ayuno después" significa que tras tomar el medicamento, no se puede ingerir alimentos durante 60 minutos. Este tipo es típico en medicamentos que pueden causar molestias gástricas o cuya efectividad se reduce con comida.

La duración del ayuno es completamente configurable en minutos, permitiendo ajustarse a prescripciones específicas que pueden variar desde 15 minutos hasta varias horas.

### Cuenta Atrás Visual en Tiempo Real

Cuando un medicamento con ayuno "después" ha sido tomado, MedicApp muestra una cuenta atrás visual prominente en la pantalla principal. Este contador se actualiza en tiempo real cada segundo, mostrando el tiempo restante en formato MM:SS (minutos:segundos). Junto a la cuenta atrás, se indica la hora exacta en que finalizará el período de ayuno, permitiendo planificación inmediata.

El componente visual de la cuenta atrás es imposible de ignorar: utiliza colores llamativos, se posiciona destacadamente en la pantalla, incluye el nombre del medicamento asociado, y muestra un icono de restricción alimentaria. Esta visibilidad constante asegura que el usuario no olvide la restricción alimentaria activa.

### Notificación Fija Durante el Ayuno

Complementando la cuenta atrás visual en la app, MedicApp muestra una notificación persistente del sistema durante todo el período de ayuno. Esta notificación es "ongoing" (en curso), lo que significa que no puede ser desechada por el usuario y permanece fija en la barra de notificaciones con máxima prioridad.

La notificación de ayuno muestra la misma información que la cuenta atrás en la app: nombre del medicamento, tiempo restante de ayuno, y hora estimada de finalización. Se actualiza periódicamente para reflejar el tiempo restante, aunque no en tiempo real constante para preservar batería. Esta doble capa de recordatorio (visual en app + notificación persistente) prácticamente elimina el riesgo de romper accidentalmente el ayuno.

### Cancelación Automática

El sistema gestiona automáticamente el ciclo de vida del ayuno sin intervención manual. Cuando el tiempo de ayuno se completa, varias acciones ocurren simultáneamente y de forma automática:

1. La cuenta atrás visual desaparece de la pantalla principal
2. La notificación persistente se cancela automáticamente
3. Se emite una notificación breve con sonido indicando "Ayuno completado, ya puedes comer"
4. El estado del medicamento se actualiza para reflejar que el ayuno ha finalizado

Esta automatización asegura que el usuario esté siempre informado del estado actual sin necesidad de recordar manualmente cuándo finalizó el ayuno. Si la app está en segundo plano cuando finaliza el ayuno, la notificación de finalización alerta al usuario inmediatamente.

### Configuración por Medicamento

No todos los medicamentos requieren ayuno, y entre los que sí lo requieren, las necesidades varían. MedicApp permite configurar individualmente para cada medicamento: si requiere ayuno o no (sí/no), el tipo de ayuno (antes/después), la duración exacta en minutos, y si se desean notificaciones de inicio de ayuno (para el tipo "antes").

Esta granularidad permite gestionar regímenes complejos donde algunos medicamentos se toman en ayunas, otros requieren espera post-ingesta, y otros no tienen restricciones, todo dentro de una interfaz coherente que maneja automáticamente cada caso según su configuración específica.

---

## 12. Historial de Dosis

### Registro Automático Completo

MedicApp mantiene un registro detallado y automático de cada acción relacionada con medicamentos. Cada vez que se registra una dosis (tomada u omitida), el sistema crea inmediatamente una entrada en el historial que captura información exhaustiva del evento.

Los datos registrados incluyen: identificador único de la entrada, ID del medicamento y su nombre actual, tipo de medicamento con su icono y color, ID y nombre de la persona que tomó/omitió la dosis, fecha y hora programada originalmente para la dosis, fecha y hora real en que se registró la acción, estado de la dosis (tomada o omitida), cantidad exacta administrada en las unidades correspondientes, y si fue una dosis extra no programada.

Este registro automático funciona independientemente de cómo se registró la dosis: desde la app, desde las acciones de notificación, o mediante registro manual. No requiere intervención del usuario más allá de la acción de registro básica, garantizando que el historial esté siempre completo y actualizado.

### Estadísticas de Adherencia Terapéutica

A partir del historial de dosis, MedicApp calcula automáticamente estadísticas de adherencia que proporcionan información valiosa sobre el cumplimiento del tratamiento. Las métricas incluyen:

**Tasa de Adherencia Global** - Porcentaje de dosis tomadas sobre el total de dosis programadas, calculado como (dosis tomadas / (dosis tomadas + dosis omitidas)) × 100.

**Total de Dosis Registradas** - Cuenta total de eventos en el historial dentro del período analizado.

**Dosis Tomadas** - Número absoluto de dosis registradas como tomadas exitosamente.

**Dosis Omitidas** - Número de dosis que fueron saltadas o no tomadas según lo programado.

Estas estadísticas se calculan dinámicamente basándose en los filtros aplicados, permitiendo análisis por períodos específicos, medicamentos individuales o personas concretas. Son especialmente útiles para identificar patrones de incumplimiento, evaluar la efectividad del régimen de horarios actual, y proporcionar información objetiva en consultas médicas.

### Filtros Avanzados Multidimensionales

La pantalla de historial incluye un sistema de filtrado potente que permite analizar los datos desde múltiples perspectivas:

**Filtro por Persona** - Muestra solo las dosis de una persona específica, ideal para seguimiento individual en entornos multi-persona. Incluye opción "Todas las personas" para vista global.

**Filtro por Medicamento** - Permite enfocarse en un medicamento particular, útil para evaluar la adherencia de tratamientos específicos. Incluye opción "Todos los medicamentos" para vista completa.

**Filtro por Rango de Fechas** - Define un período temporal específico con fecha de inicio y fecha de fin. Útil para generar reportes de adherencia mensual, trimestral o para períodos personalizados que coincidan con consultas médicas.

Los filtros son acumulativos y se pueden combinar. Por ejemplo, se pueden ver "todas las dosis de Ibuprofeno tomadas por María en el mes de enero", proporcionando análisis muy granulares. Los filtros activos se muestran visualmente en chips informativos que pueden removerse individualmente.

### Exportación de Datos

Aunque la interfaz actual no implementa exportación directa, el historial de dosis se almacena en la base de datos SQLite de la aplicación, que puede ser exportada completa mediante la funcionalidad de backup del sistema. Esta base de datos contiene todas las entradas de historial en formato estructurado que puede ser procesado posteriormente con herramientas externas para generar reportes personalizados, gráficos de adherencia, o integración con sistemas de gestión médica.

El formato de los datos es relacional y normalizado, con claves foráneas que vinculan medicamentos, personas y entradas de historial, facilitando análisis complejos y extracción de información para presentaciones médicas o auditorías de tratamiento.

---

## 13. Localización e Internacionalización

### 8 Idiomas Completamente Soportados

MedicApp está traducida de forma profesional y completa a 8 idiomas, cubriendo la mayoría de lenguas habladas en la península ibérica y ampliando su alcance a Europa:

**Español (es)** - Idioma principal, traducción nativa con toda la terminología médica precisa.

**English (en)** - Inglés internacional, adaptado para usuarios angloparlantes globales.

**Deutsch (de)** - Alemán estándar, con terminología médica europea.

**Français (fr)** - Francés europeo con vocabulario farmacéutico apropiado.

**Italiano (it)** - Italiano estándar con términos médicos localizados.

**Català (ca)** - Catalán con términos médicos específicos del sistema sanitario catalán.

**Euskara (eu)** - Vasco con terminología sanitaria apropiada.

**Galego (gl)** - Gallego con vocabulario médico regionalizado.

Cada traducción no es una simple conversión automática, sino una localización cultural que respeta las convenciones médicas, formatos de fecha/hora, y expresiones idiomáticas de cada región. Los nombres de medicamentos, tipos farmacéuticos y términos técnicos están adaptados al vocabulario médico local de cada idioma.

### Cambio Dinámico de Idioma

MedicApp permite cambiar el idioma de la interfaz en cualquier momento desde la pantalla de configuración. Al seleccionar un nuevo idioma, la aplicación se actualiza instantáneamente sin necesidad de reiniciar. Todos los textos de la interfaz, mensajes de notificación, etiquetas de botones, descripciones de ayuda y mensajes de error se actualizan inmediatamente al idioma seleccionado.

El cambio de idioma es fluido y no afecta a los datos almacenados. Los nombres de medicamentos introducidos por el usuario se mantienen tal como fueron ingresados, independientemente del idioma de la interfaz. Solo los elementos de UI generados por el sistema cambian de idioma, preservando la información médica personalizada.

### Separadores Decimales Localizados

MedicApp respeta las convenciones numéricas de cada región para los separadores decimales. En idiomas como español, francés, alemán e italiano, se utiliza la coma (,) como separador decimal: "1,5 pastillas", "2,25 ml". En inglés, se utiliza el punto (.): "1.5 tablets", "2.25 ml".

Esta localización numérica se aplica automáticamente en todos los campos de entrada de cantidades: dosis de medicamento, stock disponible, cantidades a reponer. Los teclados numéricos se configuran automáticamente para mostrar el separador decimal correcto según el idioma activo, evitando confusiones y errores de entrada.

### Formatos de Fecha y Hora Localizados

Los formatos de fecha y hora también se adaptan a las convenciones regionales. Los idiomas europeos continentales utilizan el formato DD/MM/YYYY (día/mes/año), mientras que el inglés puede usar MM/DD/YYYY en algunas variantes. Los nombres de meses y días de la semana aparecen traducidos en los selectores de calendario y en las vistas de historial.

Las horas se muestran en formato de 24 horas en todos los idiomas europeos (13:00, 18:30), que es el estándar médico internacional y evita ambigüedades AM/PM. Esta consistencia es crítica en contextos médicos donde la precisión horaria es vital para la efectividad del tratamiento.

### Pluralización Inteligente

El sistema de localización incluye lógica de pluralización que adapta los textos según las cantidades. Por ejemplo, en español: "1 pastilla" pero "2 pastillas", "1 día" pero "3 días". Cada idioma tiene sus propias reglas de pluralización que el sistema respeta automáticamente, incluyendo casos complejos en catalán, euskera y gallego que tienen reglas de plural diferentes al español.

Esta atención al detalle lingüístico hace que MedicApp se sienta natural y nativa en cada idioma, mejorando significativamente la experiencia del usuario y reduciendo la carga cognitiva al interactuar con la aplicación en contextos médicos potencialmente estresantes.

---

## 14. Sistema de Caché Inteligente

### Arquitectura de Caché Multi-Nivel

MedicApp implementa un sistema de caché sofisticado que reduce drásticamente los accesos a la base de datos, mejorando significativamente el rendimiento y la capacidad de respuesta de la aplicación. El sistema está diseñado específicamente para optimizar las consultas más frecuentes relacionadas con medicamentos, historial de dosis y estadísticas de adherencia.

### Componentes del Sistema

**SmartCacheService** - El núcleo del sistema es una implementación genérica de caché que combina dos estrategias de evicción poderosas:

- **TTL (Time-To-Live) automático**: Cada entrada en el caché tiene una fecha de expiración configurable. Cuando una entrada expira, se considera inválida y la próxima consulta fuerza una recarga desde la base de datos. Esto asegura que los datos nunca estén demasiado desactualizados.

- **Algoritmo LRU (Least Recently Used)**: Cuando el caché alcanza su capacidad máxima, automáticamente evicta la entrada que menos recientemente ha sido accedida. Este algoritmo garantiza que los datos más frecuentemente consultados permanezcan en memoria.

**MedicationCacheService** - Esta capa especializada gestiona cuatro cachés independientes, cada uno optimizado para un tipo específico de datos:

1. **medicationsCache** (10 minutos TTL, 50 entradas máximo):
   - Almacena medicamentos individuales por ID
   - Ideal para consultas repetidas del mismo medicamento
   - TTL moderado porque los medicamentos pueden editarse frecuentemente

2. **listsCache** (5 minutos TTL, 20 entradas máximo):
   - Cachea listas completas de medicamentos filtradas por persona o criterios
   - TTL más corto porque las listas cambian cuando se añaden/editan medicamentos
   - Mejora dramáticamente la carga de pantalla principal

3. **historyCache** (3 minutos TTL, 30 entradas máximo):
   - Almacena consultas de historial de dosis
   - TTL corto porque el historial se actualiza constantemente con nuevas dosis
   - Optimiza las vistas de historial con filtros específicos

4. **statisticsCache** (30 minutos TTL, 10 entradas máximo):
   - Cachea cálculos estadísticos pesados (adherencia, tendencias)
   - TTL largo porque las estadísticas no cambian drásticamente minuto a minuto
   - Reduce cálculos costosos de análisis de adherencia

### Patrón Cache-Aside

El sistema implementa el patrón cache-aside mediante el método `getOrCompute()`:

```dart
final medications = await cache.getOrCompute(
  'medications_person123',
  () => database.getMedicationsForPerson('person123'),
);
```

Este patrón verifica primero el caché. Si la entrada existe y no ha expirado (cache hit), la retorna inmediatamente. Si no existe o ha expirado (cache miss), ejecuta la función de cómputo, almacena el resultado en caché, y lo retorna. Esta abstracción simplifica el uso del caché en toda la aplicación.

### Invalidación Inteligente

Cuando se modifican datos, el sistema invalida selectivamente solo los cachés afectados:

- **Al crear/editar medicamento**: Invalida caché del medicamento específico y listas que lo contienen
- **Al registrar dosis**: Invalida historial del medicamento y estadísticas de la persona
- **Al eliminar medicamento**: Limpia todas las cachés relacionadas con ese ID

Esta invalidación selectiva evita limpiar todo el sistema de caché, preservando datos válidos que no fueron afectados por el cambio.

### Métricas y Monitoreo

Cada caché mantiene estadísticas en tiempo real:

- **Hit Rate**: Porcentaje de requests satisfechos desde caché sin acceder a BD
- **Hits**: Contador de accesos exitosos desde caché
- **Misses**: Contador de accesos que requirieron consultar la BD
- **Evictions**: Número de entradas removidas por LRU o expiración

Estas métricas son valiosas para ajustar los parámetros de caché (TTL y tamaño máximo) según patrones de uso reales.

### Beneficios Medidos

El sistema de caché proporciona mejoras tangibles de rendimiento:

- **60-80% reducción** en queries a base de datos para datos frecuentemente accedidos
- **Lista de medicamentos**: De 50-200ms a 2-5ms en cache hits (40-100x más rápido)
- **Consultas de historial**: De 300-500ms a 5-10ms en cache hits (60-100x más rápido)
- **Cálculos estadísticos**: De 800-1200ms a 10-15ms en cache hits (80-120x más rápido)

Estos números traducen en una experiencia de usuario notablemente más fluida, especialmente al navegar repetidamente entre pantallas o cambiar filtros.

### Gestión de Memoria Responsable

El sistema limita estrictamente el uso de memoria mediante:

- Tamaños máximos configurados por tipo de caché
- Algoritmo LRU que evicta automáticamente entradas antiguas
- Timer de limpieza que elimina entradas expiradas cada minuto
- Invalidación proactiva al modificar datos relacionados

Esta gestión asegura que el caché mejore el rendimiento sin causar problemas de memoria en dispositivos con recursos limitados.

---

## 15. Sistema de Recordatorios Inteligentes

### Análisis de Adherencia Terapéutica

MedicApp incluye un sistema avanzado de análisis de adherencia que va más allá del simple seguimiento de dosis tomadas/omitidas. El sistema examina patrones históricos para identificar tendencias, problemas recurrentes y oportunidades de mejora.

**Análisis Multi-Dimensional** - El método `analyzeAdherence()` realiza un análisis exhaustivo del historial de dosis de un paciente para un medicamento específico:

**Métricas por Día de la Semana**: Calcula la tasa de adherencia individual para cada día (lunes a domingo). Esto revela si ciertos días de la semana son problemáticos. Por ejemplo, puede detectar que los fines de semana tienen 30% menos adherencia que los días laborables, indicando que la rutina laboral ayuda a recordar las dosis.

**Métricas por Hora del Día**: Analiza la adherencia según el horario de la dosis (mañana, mediodía, tarde, noche). Identifica si ciertas horas son consistentemente problemáticas. Por ejemplo, puede revelar que las dosis de 22:00 tienen solo 40% de adherencia, mientras que las de 08:00 tienen 90%.

**Identificación de Mejores/Peores Períodos**: El sistema determina automáticamente cuál es el mejor día de la semana y el mejor horario del día en términos de adherencia. Esto proporciona insights valiosos sobre cuándo el paciente es más consistente con su medicación.

**Días Problemáticos**: Lista específicamente los días donde la adherencia cae por debajo del 50%, marcándolos como críticos para intervención. Esta lista permite focalizar esfuerzos de mejora en los períodos más problemáticos.

**Recomendaciones Personalizadas**: Basándose en todos los patrones detectados, el sistema genera sugerencias automáticas como:
- "Considera mover la dosis de 22:00 a 20:00 (mejor adherencia histórica)"
- "Los fines de semana necesitan recordatorios adicionales"
- "Tu adherencia matutina es excelente, intenta consolidar dosis en la mañana"

**Cálculo de Tendencia**: Compara adherencia reciente (últimos 7 días) con adherencia histórica (últimos 30 días) para determinar si el patrón está mejorando, manteniéndose estable, o declinando. Una tendencia positiva indica que las estrategias actuales están funcionando.

### Predicción de Omisiones

**Modelo Predictivo** - El método `predictSkipProbability()` utiliza machine learning básico para predecir la probabilidad de que una dosis específica sea omitida:

**Entrada del Modelo**: Recibe información contextual sobre la dosis a predecir:
- Día de la semana específico (ej: sábado)
- Hora del día específica (ej: 22:00)
- ID de persona y medicamento

**Análisis de Patrones Históricos**: Examina el historial de dosis para situaciones similares (mismo día de semana, misma hora) y calcula qué porcentaje de esas dosis fueron omitidas en el pasado.

**Clasificación de Riesgo**: Convierte la probabilidad numérica en una clasificación cualitativa:
- **Riesgo Bajo**: <30% probabilidad de omisión
- **Riesgo Medio**: 30-60% probabilidad
- **Riesgo Alto**: >60% probabilidad

**Identificación de Factores**: Proporciona explicaciones de por qué se predice ese nivel de riesgo:
- "Los sábados tienen 60% más omisiones que días laborables"
- "El horario 22:00 es consistentemente problemático"
- "Tu adherencia ha declinado en las últimas 2 semanas"

**Casos de Uso**: Esta funcionalidad habilita alertas proactivas. Por ejemplo, si el sistema detecta que una dosis del sábado a las 22:00 tiene 75% de probabilidad de omisión, puede enviar una notificación preventiva adicional o sugerir al usuario reprogramar esa dosis.

### Optimización de Horarios

**Sugerencias Inteligentes** - El método `suggestOptimalTimes()` actúa como un asistente personal que ayuda al usuario a encontrar los mejores horarios para sus medicamentos:

**Identificación de Horarios Problemáticos**: Analiza todos los horarios actuales del medicamento y marca aquellos con adherencia inferior al 70% como candidatos para optimización.

**Búsqueda de Alternativas**: Para cada horario problemático, busca en el historial horarios alternativos donde el usuario históricamente ha tenido mejor adherencia.

**Cálculo de Potencial de Mejora**: Compara la adherencia actual del horario problemático con la adherencia esperada del horario sugerido, calculando el potencial de mejora. Por ejemplo: "Mover de 22:00 (45% adherencia) a 20:00 (82% adherencia) = +37% mejora potencial".

**Priorización por Impacto**: Ordena las sugerencias por impacto esperado, mostrando primero aquellas que tienen mayor potencial de mejorar la adherencia global.

**Justificaciones Basadas en Datos**: Cada sugerencia viene acompañada de una razón específica derivada del historial:
- "Tu adherencia a las 20:00 es consistentemente alta (82%)"
- "Nunca has omitido dosis entre 08:00-09:00"
- "Las dosis matutinas tienen 40% más adherencia que nocturnas"

### Integración con la Aplicación

Estas funcionalidades de análisis inteligente están diseñadas para ser integradas en varios puntos de la aplicación:

**Pantalla de Estadísticas Detalladas**: Una vista dedicada que muestra el análisis completo de adherencia con gráficos visuales de tendencias, mapas de calor por día/hora, y lista de recomendaciones priorizadas.

**Alertas Proactivas**: Notificaciones automáticas cuando se detectan patrones preocupantes:
- "Tu adherencia para [Medicamento] ha declinado un 20% esta semana"
- "Detectamos que omites dosis los viernes consistentemente"

**Asistente de Configuración de Horarios**: Durante la creación o edición de medicamentos, el sistema puede sugerir horarios óptimos basándose en el historial de adherencia del usuario con otros medicamentos.

**Reportes Médicos**: Generación automática de informes de adherencia con insights para compartir con profesionales de la salud durante consultas.

---

## 16. Tema Oscuro Nativo

### Sistema Completo de Tematización

MedicApp implementa un sistema profesional de temas con soporte nativo para modo claro y oscuro, siguiendo estrictamente las directrices de Material Design 3 (Material You) de Google.

### Tres Modos de Operación

**Modo System (Automático)**: La aplicación detecta y sigue la configuración de tema del sistema operativo del dispositivo. Si el usuario cambia su teléfono a modo oscuro en la configuración del sistema, MedicApp automáticamente cambia a su tema oscuro sin intervención. Este modo es el predeterminado y proporciona la experiencia más integrada con el dispositivo.

**Modo Light (Claro Forzado)**: Fuerza la aplicación a usar el tema claro independientemente de la configuración del sistema. Útil para usuarios que prefieren modo oscuro en el sistema pero quieren MedicApp en modo claro por legibilidad en contextos médicos.

**Modo Dark (Oscuro Forzado)**: Fuerza el tema oscuro incluso si el sistema está en modo claro. Ideal para usuarios que usan la app frecuentemente de noche y quieren reducir fatiga visual y ahorro de batería en pantallas OLED.

### Esquemas de Color Cohesivos

**Tema Claro**: Diseñado para máxima legibilidad en condiciones de buena iluminación:
- Fondos blancos y superficies gris muy claro
- Texto negro con suficiente contraste (ratio 4.5:1 o superior)
- Colores primarios vibrantes para elementos interactivos
- Sombras sutiles para jerarquía visual

**Tema Oscuro**: Optimizado para uso nocturno y reducción de fatiga visual:
- Fondos negro puro (#000000) para máximo ahorro de batería en OLED
- Superficies en grises oscuros con elevación visible
- Colores desaturados que no cansan la vista
- Texto blanco/gris claro con ratios de contraste apropiados
- Eliminación de blanco puro que puede ser deslumbrante

### Personalización Exhaustiva de Componentes

Cada componente Material Design está estilizado consistentemente en ambos temas:

**AppBar**: Barras superiores con colores de fondo que reflejan la superficie principal, texto legible, e iconos contrastados.

**Cards**: Tarjetas con elevación apropiada (más pronunciada en oscuro), bordes redondeados suaves, y colores de superficie diferenciados del fondo.

**FloatingActionButton**: Botones de acción prominentes con colores primarios destacados, sombras apropiadas, e iconos claros.

**InputFields**: Campos de texto con bordes visibles en ambos modos, etiquetas flotantes, colores de error distinguibles, y estados de focus claros.

**Dialogs**: Diálogos modales con esquinas redondeadas, superficies elevadas que destacan sobre el fondo, y acciones de botón claramente diferenciadas.

**SnackBars**: Notificaciones temporales con fondo semi-opaco, texto legible, y posicionamiento consistente.

**Text Hierarchy**: Jerarquía tipográfica completa con tamaños, pesos y colores apropiados para títulos, subtítulos, cuerpo y etiquetas en ambos modos.

### Gestión de Estado Reactiva

**ThemeProvider**: Un `ChangeNotifier` que gestiona el estado del tema actual:
- Mantiene el `ThemeMode` activo (system/light/dark)
- Notifica a todos los widgets suscritos cuando cambia el tema
- Persiste la elección del usuario en SharedPreferences
- Carga el tema guardado automáticamente al iniciar la app

**Integración con MaterialApp**: La aplicación escucha cambios del ThemeProvider y actualiza instantáneamente sin reiniciar:

```dart
MaterialApp(
  theme: AppTheme.lightTheme,        // Tema claro
  darkTheme: AppTheme.darkTheme,     // Tema oscuro
  themeMode: themeProvider.themeMode, // Modo actual
)
```

### Transiciones Fluidas

Los cambios de tema son completamente fluidos:
- Sin necesidad de reiniciar la aplicación
- Animación suave de transición de colores
- Preservación completa del estado de la app
- Actualización instantánea de todos los widgets visibles

### Beneficios para el Usuario

**Accesibilidad Mejorada**: Usuarios con sensibilidad a la luz brillante pueden usar modo oscuro cómodamente. Usuarios con baja visión pueden beneficiarse del alto contraste del modo claro.

**Ahorro de Batería**: En dispositivos con pantallas OLED/AMOLED, el tema oscuro con negros puros puede ahorrar 30-60% de energía de pantalla comparado con tema claro.

**Reducción de Fatiga Visual**: El modo oscuro reduce significativamente la emisión de luz azul, siendo más cómodo para uso nocturno o prolongado.

**Integración con Sistema**: El modo automático crea una experiencia cohesiva donde MedicApp se siente como una parte nativa del sistema operativo.

**Preferencia Persistente**: La elección del usuario se guarda y se mantiene entre sesiones, no requiriendo reconfiguraciones repetidas.

---

## 17. Interfaz Accesible y Usable

### Material Design 3

MedicApp está construida siguiendo estrictamente las directrices de Material Design 3 (Material You) de Google, el sistema de diseño más moderno y accesible para aplicaciones Android. Esta decisión arquitectónica garantiza múltiples beneficios:

**Consistencia Visual** - Todos los elementos de interfaz (botones, tarjetas, diálogos, campos de texto) siguen patrones visuales estándar que los usuarios de Android reconocen instintivamente. No hay que aprender una interfaz completamente nueva.

**Tematización Dinámica** - Material 3 permite que la app adopte los colores del sistema del usuario (si está en Android 12+), creando una experiencia visual cohesiva con el resto del dispositivo. Los colores de acento, fondos y superficies se adaptan automáticamente.

**Componentes Accesibles Nativos** - Todos los controles de Material 3 están diseñados desde el principio para ser accesibles, con áreas de toque generosas (mínimo 48x48dp), contrastes adecuados, y soporte para lectores de pantalla.

### Tipografía Ampliada y Legible

La aplicación utiliza una jerarquía tipográfica clara con tamaños de fuente generosos que facilitan la lectura sin fatiga visual:

**Títulos de Pantalla** - Tamaño grande (24-28sp) para orientación clara de dónde está el usuario.

**Nombres de Medicamentos** - Tamaño destacado (18-20sp) en negrita para identificación rápida.

**Información Secundaria** - Tamaño medio (14-16sp) para detalles complementarios como horarios y cantidades.

**Texto de Ayuda** - Tamaño estándar (14sp) para instrucciones y descripciones.

El interlineado es generoso (1.5x) para evitar que las líneas se confundan, especialmente importante para usuarios con problemas de visión. Las fuentes utilizadas son sin serifa (sans-serif) que han demostrado mejor legibilidad en pantallas digitales.

### Alto Contraste Visual

MedicApp implementa una paleta de colores con ratios de contraste que cumplen y superan las directrices WCAG 2.1 AA para accesibilidad. El contraste mínimo entre texto y fondo es de 4.5:1 para texto normal y 3:1 para texto grande, asegurando legibilidad incluso en condiciones de iluminación subóptimas.

Los colores se utilizan de forma funcional además de estética: rojo para alertas de stock bajo o ayuno activo, verde para confirmaciones y stock suficiente, ámbar para advertencias intermedias, azul para información neutra. Pero crucialmente, el color nunca es el único indicador: siempre se complementa con iconos, texto o patrones.

### Navegación Intuitiva y Predecible

La estructura de navegación de MedicApp sigue principios de simplicidad y previsibilidad:

**Pantalla Principal Central** - La vista de medicamentos del día es el hub principal desde el que todo es accesible en máximo 2 toques.

**Navegación por Pestañas** - La barra inferior con 3 pestañas (Medicamentos, Botiquín, Historial) permite cambio instantáneo entre las vistas principales sin animaciones confusas.

**Botones de Acción Flotantes** - Las acciones primarias (agregar medicamento, filtrar historial) se realizan mediante botones flotantes (FAB) en posición consistente, fáciles de alcanzar con el pulgar.

**Breadcrumbs y Back Button** - Siempre es claro en qué pantalla está el usuario y cómo volver atrás. El botón de retorno está siempre en la posición superior izquierda estándar.

### Feedback Visual y Táctil

Cada interacción produce feedback inmediato: los botones muestran efecto "ripple" al ser presionados, las acciones exitosas se confirman con snackbars verdes que aparecen brevemente, los errores se indican con diálogos rojos explicativos, y los procesos largos (como exportar base de datos) muestran indicadores de progreso animados.

Este feedback constante asegura que el usuario siempre sepa que su acción fue registrada y el sistema está respondiendo, reduciendo la ansiedad típica de aplicaciones médicas donde un error podría tener consecuencias importantes.

### Diseño para Uso con Una Mano

Reconociendo que los usuarios frecuentemente manejan medicamentos con una mano (mientras sostienen el envase con la otra), MedicApp optimiza la ergonomía para uso con una mano:

- Elementos interactivos principales en la mitad inferior de la pantalla
- Botones de acción flotante en esquina inferior derecha, alcanzable con el pulgar
- Evitación de menús en esquinas superiores que requieren reajustar el agarre
- Gestos de deslizar horizontal (más cómodos que verticales) para navegación temporal

Esta consideración ergonómica reduce la fatiga física y hace que la app sea más cómoda de usar en situaciones reales de medicación, que a menudo ocurren de pie o en movimiento.

---

## 18. Widget de Pantalla de Inicio (Android)

### Vista Rápida de Dosis Diarias

MedicApp incluye un widget nativo de Android para la pantalla de inicio que permite visualizar las dosis programadas del día actual sin necesidad de abrir la aplicación. Este widget proporciona información esencial de un vistazo, ideal para usuarios que necesitan un recordatorio visual constante de su medicación.

### Características del Widget

**Tamaño 2x2**: El widget ocupa un espacio de 2x2 celdas en la pantalla de inicio (aproximadamente 146x146dp), siendo lo suficientemente compacto para no ocupar demasiado espacio pero con información claramente legible.

**Lista de Dosis del Día**: Muestra todas las dosis programadas para el día actual, filtrando automáticamente por `durationType` para mostrar solo medicamentos que corresponden al día de hoy. Los medicamentos configurados como "según necesidad" (`asNeeded`) se excluyen automáticamente del widget. Para cada dosis se muestra:
- Nombre del medicamento
- Hora programada de cada dosis
- Estado visual (pendiente, tomada u omitida)

**Indicadores de Estado Visuales**: El widget utiliza tres estados visuales distintos para identificar rápidamente el estado de cada dosis:
- **Círculo verde relleno con check (✓)**: Dosis ya tomada - El texto aparece al 70% de opacidad para indicar que está completada
- **Círculo verde vacío (○)**: Dosis pendiente - El texto aparece al 100% de opacidad para máxima visibilidad
- **Círculo gris punteado (◌)**: Dosis omitida/saltada - El texto aparece al 50% de opacidad indicando que fue saltada intencionalmente

**Contador de Progreso**: En la cabecera del widget se muestra un contador "X/Y" indicando cuántas dosis se han tomado del total programado para el día.

### Integración con la Aplicación

**Actualización Automática**: El widget se actualiza automáticamente cada vez que:
- Se registra una dosis (tomada, omitida o extra)
- Se añade o modifica un medicamento
- Se cambia el día (a medianoche)

**Acceso Rápido a la Aplicación**: Tocar cualquier parte del widget (cabecera, elementos de la lista o espacio vacío) abre instantáneamente la aplicación principal de MedicApp, proporcionando acceso inmediato para gestionar las dosis o consultar más información.

**Comunicación Flutter-Android**: La integración utiliza un MethodChannel (`com.medicapp.medicapp/widget`) que permite a la aplicación Flutter notificar al widget nativo cuando los datos cambian.

**Lectura Directa de Base de Datos**: El widget accede directamente a la base de datos SQLite de la aplicación para obtener los datos de medicamentos, asegurando información actualizada incluso cuando la app no está en ejecución.

### Tema Visual DeepEmerald

El widget utiliza la paleta de colores DeepEmerald, el tema por defecto de MedicApp:

- **Fondo**: Verde oscuro profundo (#1E2623) con 90% de opacidad
- **Iconos y acentos**: Verde claro (#81C784)
- **Texto**: Blanco con diferentes niveles de opacidad según el estado
- **Divisores**: Verde claro con transparencia

Esta coherencia visual asegura que el widget se integre perfectamente con la estética de la aplicación.

### Limitaciones Técnicas

**Solo Android**: El widget es una funcionalidad nativa de Android y no está disponible en iOS, web u otras plataformas.

**Persona por Defecto**: El widget muestra las dosis de la persona configurada como predeterminada en la aplicación. No permite seleccionar diferentes personas directamente desde el widget.

### Archivos Relacionados

- `android/app/src/main/kotlin/.../MedicationWidgetProvider.kt` - Proveedor principal del widget
- `android/app/src/main/kotlin/.../MedicationWidgetService.kt` - Servicio para la ListView del widget
- `android/app/src/main/res/layout/medication_widget_layout.xml` - Layout principal
- `android/app/src/main/res/xml/medication_widget_info.xml` - Configuración del widget
- `lib/services/widget_service.dart` - Servicio Flutter para comunicación con el widget

---

## Integración de Funcionalidades

Todas estas características no funcionan de forma aislada, sino que están profundamente integradas para crear una experiencia cohesiva. Por ejemplo:

- Un medicamento agregado en el flujo de 8 pasos se asigna automáticamente a personas, genera notificaciones según su tipo de frecuencia, aparece en el botiquín ordenado alfabéticamente, registra sus dosis en el historial, y actualiza estadísticas de adherencia.

- Las notificaciones respetan la configuración de ayuno, actualizando automáticamente la cuenta atrás visual cuando se registra una dosis con ayuno posterior.

- El control de stock multi-persona calcula correctamente los días restantes considerando las dosis de todas las personas asignadas, y alerta cuando el umbral se alcanza independientemente de quién tome el medicamento.

- El cambio de idioma actualiza instantáneamente todas las notificaciones pendientes, las pantallas visibles, y los mensajes del sistema, manteniendo consistencia total.

Esta integración profunda es lo que convierte a MedicApp de una simple lista de medicamentos en un sistema completo de gestión terapéutica familiar.

---

## Referencias a Documentación Adicional

Para información más detallada sobre aspectos específicos:

- **Arquitectura Multi-Persona**: Ver documentación de base de datos (tablas `persons`, `medications`, `person_medications`)
- **Sistema de Notificaciones**: Ver código fuente en `lib/services/notification_service.dart`
- **Modelo de Datos**: Ver modelos en `lib/models/` (especialmente `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localización**: Ver archivos `.arb` en `lib/l10n/` para cada idioma
- **Tests**: Ver suite de tests en `test/` con 601+ tests que validan todas estas funcionalidades
- **Widget Android**: Ver `android/app/src/main/kotlin/.../MedicationWidget*.kt` para el widget de pantalla de inicio

---

## 19. Optimización para Tablets

### Diseño Responsivo Adaptativo

MedicApp está optimizada para funcionar perfectamente en tablets y pantallas grandes, adaptando automáticamente su interfaz según el tamaño del dispositivo.

### Sistema de Breakpoints

La aplicación utiliza un sistema de puntos de ruptura basado en las directrices de Material Design:

- **Teléfono**: < 600dp - Diseño de una columna, navegación inferior
- **Tablet**: 600-840dp - Diseño adaptativo, NavigationRail lateral
- **Escritorio**: > 840dp - Diseño optimizado con contenido centrado

### Características Responsivas

**Navegación Adaptativa**: En tablets y modo horizontal, la aplicación muestra un NavigationRail lateral en lugar de la barra de navegación inferior, proporcionando más espacio para el contenido principal.

**Contenido Centrado**: En pantallas grandes, las listas de medicamentos, historial y configuración se centran con un ancho máximo de 700-900px para mejorar la legibilidad y evitar líneas de texto excesivamente largas.

**Grids Adaptativos**: El botiquín y el historial de dosis utilizan layouts de grid que muestran 2-3 columnas en tablets, aprovechando mejor el espacio disponible.

**Diálogos Optimizados**: Los diálogos y formularios tienen un ancho máximo de 400-500px en tablets para evitar que se estiren demasiado.

### Archivos Relacionados

- `lib/utils/responsive_helper.dart` - Utilidades de diseño responsivo
- `lib/widgets/responsive/adaptive_grid.dart` - Widgets adaptativos (AdaptiveGrid, ContentContainer, ResponsiveRow)

---

Esta documentación refleja el estado actual de MedicApp en su versión 1.0.0, una aplicación madura y completa para gestión de medicamentos familiares con más de 75% de cobertura de tests, soporte completo para 8 idiomas, y widget de pantalla de inicio para Android.
