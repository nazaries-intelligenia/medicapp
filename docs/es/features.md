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

## 5. Control de Stock (Pastillero)

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

## 6. Botiquín

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

## 7. Navegación Temporal

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

## 8. Notificaciones Inteligentes

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

---

## 9. Configuración de Ayuno

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

## 10. Historial de Dosis

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

## 11. Localización e Internacionalización

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

## 12. Interfaz Accesible y Usable

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
- **Tests**: Ver suite de tests en `test/` con 432+ tests que validan todas estas funcionalidades

---

Esta documentación refleja el estado actual de MedicApp en su versión 1.0.0, una aplicación madura y completa para gestión de medicamentos familiares con más de 75% de cobertura de tests y soporte completo para 8 idiomas.
