# Funcionalidades de MedicApp

Este documento detalla todas as características e capacidades de MedicApp, unha aplicación avanzada de xestión de medicamentos deseñada para familias e coidadores.

---

## 1. Xestión Multi-Persoa (V19+)

### Arquitectura Moitos-a-Moitos

MedicApp implementa unha arquitectura sofisticada de xestión multi-persoa que permite a múltiples usuarios compartir medicamentos mentres manteñen configuracións de tratamento individuais. Esta funcionalidade está deseñada especificamente para familias, coidadores profesionais e grupos que necesitan coordinar a medicación de varias persoas.

A arquitectura baséase nun modelo relacional de moitos-a-moitos, onde cada medicamento (identificado por nome, tipo e stock compartido) pode ser asignado a múltiples persoas, e cada persoa pode ter múltiples medicamentos. O stock xestiónase de forma centralizada e descóntase automaticamente independentemente de quen tome o medicamento, o que permite un control preciso do inventario compartido sen duplicar datos.

Cada persoa pode configurar a súa propia pauta de tratamento para o mesmo medicamento, incluíndo horarios específicos, doses personalizadas, duración do tratamento, e preferencias de xaxún. Por exemplo, se unha nai e a súa filla comparten un mesmo medicamento, a nai pode ter configuradas tomas ás 8:00 e 20:00, mentres que a filla só necesita unha dose diaria ás 12:00. Ambas comparten o mesmo stock físico, pero cada unha recibe notificacións e seguimento independente segundo a súa pauta.

### Casos de Uso

Esta funcionalidade é especialmente útil en varios escenarios: familias onde varios membros toman o mesmo medicamento (como vitaminas ou suplementos), coidadores profesionais que xestionan a medicación de múltiples pacientes, fogares multixeracionais onde se comparten medicamentos comúns, e situacións onde se necesita controlar o stock compartido para evitar desabastecementos. O sistema permite realizar un seguimento detallado do historial de doses por persoa, facilitando a adherencia terapéutica e o control médico individualizado.

---

## 2. 14 Tipos de Medicamentos

### Catálogo Completo de Formas Farmacéuticas

MedicApp soporta 14 tipos diferentes de medicamentos, cada un con iconografía distintiva, esquema de cores específico e unidades de medida apropiadas. Esta diversidade permite rexistrar practicamente calquera forma farmacéutica que se atope nun botiquín doméstico ou profesional.

**Tipos dispoñibles:**

1. **Pastilla** - Cor azul, icono circular. Unidade: pastillas. Para comprimidos sólidos tradicionais.
2. **Cápsula** - Cor morado, icono de cápsula. Unidade: cápsulas. Para medicamentos en forma de cápsula xelatinosa.
3. **Inxección** - Cor vermello, icono de xeringuilla. Unidade: inxeccións. Para medicamentos que requiren administración parenteral.
4. **Xarope** - Cor laranxa, icono de vaso. Unidade: ml (mililitros). Para medicamentos líquidos de administración oral.
5. **Óvulo** - Cor rosa, icono ovalado. Unidade: óvulos. Para medicamentos de administración vaxinal.
6. **Supositorio** - Cor verde azulado (teal), icono específico. Unidade: supositorios. Para administración rectal.
7. **Inhalador** - Cor ciano, icono de aire. Unidade: inhalacións. Para medicamentos respiratorios.
8. **Sobre** - Cor marrón, icono de paquete. Unidade: sobres. Para medicamentos en po ou granulados.
9. **Spray** - Cor azul claro, icono de goteo. Unidade: ml (mililitros). Para nebulizadores e aerosoles nasais.
10. **Pomada** - Cor verde, icono de gota opaca. Unidade: gramos. Para medicamentos tópicos cremosos.
11. **Loción** - Cor índigo, icono de auga. Unidade: ml (mililitros). Para medicamentos líquidos tópicos.
12. **Apósito** - Cor ámbar, icono de curación. Unidade: apósitos. Para parches medicados e apósitos terapéuticos.
13. **Gota** - Cor gris azulado, icono de gota invertida. Unidade: gotas. Para colirios e gotas óticas.
14. **Outro** - Cor gris, icono xenérico. Unidade: unidades. Para calquera forma farmacéutica non categorizada.

### Beneficios do Sistema de Tipos

Esta clasificación detallada permite ao sistema calcular automaticamente o stock de forma precisa segundo a unidade de medida correspondente, mostrar iconos e cores que facilitan a identificación visual rápida, e xerar notificacións contextuais que mencionan o tipo específico de medicamento. Os usuarios poden xestionar desde tratamentos simples con pastillas ata réximes complexos que inclúen inhaladores, inxeccións e gotas, todo dentro dunha mesma interface coherente.

---

## 3. Fluxo de Adición de Medicamentos

### Medicamentos Programados (8 Pasos)

O proceso de adición dun medicamento con horario programado é guiado e estruturado para asegurar que se configure correctamente toda a información necesaria:

**Paso 1: Información Básica** - Introdúcese o nome do medicamento e selecciónase o tipo de entre as 14 opcións dispoñibles. O sistema valida que o nome non estea baleiro.

**Paso 2: Frecuencia de Tratamento** - Defínese o patrón de toma con seis opcións: todos os días, ata acabar medicación, datas específicas, días da semana, cada N días, ou segundo necesidade. Esta configuración determina cando se deben tomar as doses.

**Paso 3: Configuración de Doses** - Establécense os horarios específicos de toma. O usuario pode elixir entre modo uniforme (mesma dose en todos os horarios) ou doses personalizadas por cada horario. Por exemplo, pódese configurar 1 pastilla ás 8:00, 0.5 pastillas ás 14:00 e 2 pastillas ás 20:00.

**Paso 4: Horarios de Toma** - Selecciónanse as horas exactas en que se debe tomar o medicamento utilizando un selector de tempo visual. Pódense configurar múltiples horarios por día segundo o prescrito.

**Paso 5: Duración do Tratamento** - Se aplica segundo o tipo de frecuencia, establécense as datas de inicio e fin do tratamento. Isto permite programar tratamentos con duración definida ou tratamentos continuos.

**Paso 6: Configuración de Xaxún** - Defínese se o medicamento require xaxún antes ou despois da toma, a duración do período de xaxún en minutos, e se se desexan notificacións de recordatorio de xaxún.

**Paso 7: Stock Inicial** - Introdúcese a cantidade de medicamento dispoñible nas unidades correspondentes ao tipo seleccionado. O sistema utilizará este valor para o control de inventario.

**Paso 8: Asignación de Persoas** - Selecciónanse as persoas que tomarán este medicamento. Para cada persoa, pódese configurar unha pauta individual con horarios e doses personalizadas, ou herdear a configuración base.

### Medicamentos Ocasionais (2 Pasos)

Para medicamentos de uso esporádico ou "segundo necesidade", o proceso simplifícase significativamente:

**Paso 1: Información Básica** - Nome e tipo do medicamento.

**Paso 2: Stock Inicial** - Cantidade dispoñible. O sistema automaticamente configura o medicamento como "segundo necesidade", sen horarios programados nin notificacións automáticas.

### Validacións Automáticas

Durante todo o proceso, MedicApp valida que se completasen todos os campos obrigatorios antes de permitir avanzar ao seguinte paso. Verifícase que os horarios sexan lóxicos, que as doses sexan valores numéricos positivos, que as datas de inicio non sexan posteriores ás de fin, e que polo menos se asigne unha persoa ao medicamento.

---

## 4. Rexistro de Tomas

### Tomas Programadas

MedicApp xestiona automaticamente as tomas programadas segundo a configuración de cada medicamento e persoa. Cando chega a hora dunha dose, o usuario recibe unha notificación e pode rexistrar a toma desde tres puntos: a pantalla principal onde aparece listada a dose pendente, a notificación directamente mediante accións rápidas, ou ao tocar a notificación que abre unha pantalla de confirmación detallada.

Ao rexistrar unha toma programada, o sistema desconta automaticamente a cantidade correspondente do stock compartido, marca a dose como tomada no día actual para esa persoa específica, crea unha entrada no historial de doses con timestamp exacto, e cancela a notificación pendente se existe. Se o medicamento require xaxún posterior, prográmase inmediatamente unha notificación de fin de xaxún e móstrase unha conta atrás visual na pantalla principal.

### Tomas Ocasionais

Para medicamentos configurados como "segundo necesidade" ou cando se necesita rexistrar unha toma fóra de horario, MedicApp permite o rexistro manual. O usuario accede ao medicamento desde o botiquín, selecciona "Tomar dose", introduce a cantidade tomada manualmente, e o sistema desconta do stock e rexistra no historial co horario actual. Esta funcionalidade é esencial para analxésicos, antitérmicos e outros medicamentos de uso esporádico.

### Tomas Excepcionais

O sistema tamén permite rexistrar doses adicionais non programadas para medicamentos con horario fixo. Por exemplo, se un paciente necesita unha dose extra de analxésico entre as súas tomas habituais, pode rexistrala como "dose extra". Esta dose rexístrase no historial marcada como excepcional, desconta stock, pero non afecta o seguimento de adherencia das doses programadas regulares.

### Historial Automático

Cada acción de rexistro xera automaticamente unha entrada completa no historial que inclúe: a data e hora programada da dose, a data e hora real de administración, a persoa que tomou o medicamento, o nome e tipo do medicamento, a cantidade exacta administrada, o estado (tomada ou omitida), e se foi unha dose extra non programada. Este historial permite análise detallada da adherencia terapéutica e facilita reportes médicos.

---

## 5. Control de Stock (Pastilleiro)

### Indicadores Visuais Intuitivos

O sistema de control de stock de MedicApp proporciona información en tempo real do inventario dispoñible mediante un sistema de semáforos visuais. Cada medicamento mostra a súa cantidade actual nas unidades correspondentes, con indicadores de cor que alertan sobre o estado do stock.

O código de cores é intuitivo: verde indica stock suficiente para máis de 3 días, amarelo/ámbar alerta que o stock está baixo (menos de 3 días de subministración), e vermello indica que o medicamento está esgotado. Os limiares de días son configurables por medicamento, permitindo axustes segundo a criticidade de cada tratamento.

### Cálculo Automático Intelixente

O cálculo de días restantes realízase automaticamente considerando múltiples factores. Para medicamentos programados, o sistema analiza a dose diaria total sumando todas as tomas configuradas de todas as persoas asignadas, divide o stock actual entre esta dose diaria, e estima os días de subministración restantes.

Para medicamentos ocasionais ou "segundo necesidade", o sistema utiliza un algoritmo adaptativo que rexistra o consumo do último día de uso e empregao como preditor para estimar cantos días durará o stock actual. Esta estimación actualízase automaticamente cada vez que se rexistra un uso do medicamento.

### Limiar Configurable por Medicamento

Cada medicamento pode ter un limiar de alerta personalizado que determina cando se considera que o stock está baixo. O valor predeterminado é 3 días, pero pode axustarse entre 1 e 10 días segundo as necesidades. Por exemplo, medicamentos críticos como insulina poden configurarse cun limiar de 7 días para permitir tempo suficiente de reposición, mentres que suplementos menos críticos poden usar limiares de 1-2 días.

### Alertas e Reposición

Cando o stock alcanza o limiar configurado, MedicApp mostra alertas visuais destacadas na pantalla principal e na vista de pastilleiro. O sistema suxire automaticamente a cantidade a reponer baseándose no último reabastecemento rexistrado, axilizando o proceso de actualización de inventario. As alertas persisten ata que o usuario rexistra nova cantidade en stock, asegurando que non se esquecen reposicións críticas.

---

## 6. Botiquín

### Lista Alfabética Organizada

O botiquín de MedicApp presenta todos os medicamentos rexistrados nunha lista ordenada alfabeticamente, facilitando a localización rápida de calquera medicamento. Cada entrada mostra o nome do medicamento, o tipo co seu icono e cor distintiva, o stock actual nas unidades correspondentes, e as persoas asignadas a ese medicamento.

A vista de botiquín é especialmente útil para ter unha visión global do inventario de medicamentos dispoñibles, sen a información de horarios que pode resultar abrumadora na vista principal. É a pantalla ideal para xestións de inventario, busca de medicamentos específicos e accións de mantemento.

### Buscador en Tempo Real

Un campo de busca na parte superior permite filtrar medicamentos instantaneamente mentres se escribe. A busca é intelixente e considera tanto o nome do medicamento como o tipo, o que permite atopar "todos os xaropes" ou "medicamentos que conteñan aspirina" con rapidez. Os resultados actualízanse en tempo real sen necesidade de premer botóns adicionais.

### Accións Rápidas Integradas

Desde cada medicamento no botiquín, pódese acceder a un menú contextual con tres accións principais:

**Editar** - Abre o editor completo do medicamento onde se poden modificar todos os aspectos: nome, tipo, horarios, doses, persoas asignadas, configuración de xaxún, etc. Os cambios gárdanse e resincronízanse automaticamente as notificacións.

**Eliminar** - Permite borrar permanentemente o medicamento do sistema tras unha confirmación de seguridade. Esta acción cancela todas as notificacións asociadas e elimina o rexistro do historial futuro, pero preserva o historial de doses xa rexistradas para manter integridade de datos.

**Tomar dose** - Atallo rápido para rexistrar unha toma manual, especialmente útil para medicamentos ocasionais. Se o medicamento está asignado a múltiples persoas, primeiro solicita seleccionar quen o toma.

### Xestión de Asignacións

O botiquín tamén facilita a xestión de asignacións persoa-medicamento. Pódense ver dun vistazo que medicamentos están asignados a cada persoa, engadir ou quitar persoas dun medicamento existente, e modificar as pautas individuais de cada persoa sen afectar aos demais.

---

## 7. Navegación Temporal

### Deslizar Horizontal por Días

A pantalla principal de MedicApp implementa un sistema de navegación temporal que permite ao usuario moverse entre diferentes días cun simple xesto de deslizar horizontal. Deslizar cara á esquerda avanza ao día seguinte, mentres que deslizar cara á dereita retrocede ao día anterior. Esta navegación é fluída e utiliza transicións animadas que proporcionan feedback visual claro do cambio de data.

A navegación temporal é practicamente ilimitada cara ao pasado e o futuro, permitindo revisar o historial de medicación de semanas ou meses atrás, ou planificar con anticipación verificando que medicamentos estarán programados en datas futuras. O sistema mantén un punto central virtual que permite miles de páxinas en ambas direccións sen impacto no rendemento.

### Selector de Calendario

Para saltos rápidos a datas específicas, MedicApp integra un selector de calendario accesible desde un botón na barra superior. Ao tocar o icono de calendario, ábrese un widget de calendario visual onde o usuario pode seleccionar calquera data. Ao seleccionar, a vista actualízase instantaneamente para mostrar os medicamentos programados dese día específico.

O calendario marca visualmente o día actual cun indicador destacado, facilita a selección de datas pasadas para revisar adherencia, permite saltar a datas futuras para planificación de viaxes ou eventos, e mostra a data seleccionada actual na barra superior de forma permanente.

### Vista Día vs Vista Semanal

Aínda que a navegación principal é por día, MedicApp proporciona contexto temporal adicional mostrando información relevante do período seleccionado. Na vista principal, os medicamentos agrúpanse por horario de toma, o que proporciona unha liña temporal do día. Os indicadores visuais mostran que doses xa foron tomadas, cales foron omitidas, e cales están pendentes.

Para medicamentos con patróns semanais ou intervalos específicos, a interface indica claramente se o medicamento corresponde ao día seleccionado ou non. Por exemplo, un medicamento configurado para "luns, mércores, venres" só aparece na lista cando se visualizan eses días da semana.

### Beneficios da Navegación Temporal

Esta funcionalidade é especialmente valiosa para verificar se se tomou un medicamento nun día pasado, planificar que medicamentos levar nunha viaxe baseándose nas datas, revisar patróns de adherencia semanais ou mensuais, e coordinar medicacións de múltiples persoas nun fogar durante períodos específicos.

---

## 8. Notificacións Intelixentes

### Accións Directas desde Notificación

MedicApp revoluciona a xestión de medicamentos mediante notificacións con accións integradas que permiten xestionar as doses sen abrir a aplicación. Cando chega a hora dunha dose, a notificación mostra tres botóns de acción directa:

**Tomar** - Rexistra a dose inmediatamente, desconta do stock, crea entrada no historial, cancela a notificación, e se aplica, inicia o período de xaxún posterior con conta atrás.

**Pospor** - Aplaza a notificación por 10, 30 ou 60 minutos segundo a opción seleccionada. A notificación reaparece automaticamente no tempo especificado.

**Saltar** - Rexistra a dose como omitida, crea entrada no historial con estado "saltada" sen descontar stock, e cancela a notificación sen programar recordatorios adicionais.

Estas accións funcionan incluso cando o teléfono está bloqueado, facendo que o rexistro de medicación sexa instantáneo e sen fricción. O usuario pode xestionar a súa medicación completa desde as notificacións sen necesidade de desbloquear o dispositivo ou abrir a app.

### Cancelación Intelixente

O sistema de notificacións implementa lóxica avanzada de cancelación para evitar alertas redundantes ou incorrectas. Cando un usuario rexistra unha dose manualmente desde a app (sen usar a notificación), o sistema cancela automaticamente a notificación pendente desa dose específica para ese día.

Se un medicamento se elimina ou se suspende, todas as súas notificacións futuras cancélanse inmediatamente en segundo plano. Cando se modifica o horario dun medicamento, as notificacións antigas cancélanse e reprográmanse automaticamente cos novos horarios. Esta xestión intelixente asegura que o usuario só reciba notificacións relevantes e actuais.

### Notificacións Persistentes para Xaxún

Para medicamentos que requiren xaxún, MedicApp mostra unha notificación persistente especial durante todo o período de xaxún. Esta notificación non pode ser desechada manualmente e mostra unha conta atrás en tempo real do tempo restante ata que se poida comer. Inclúe a hora exacta en que finalizará o xaxún, o que permite ao usuario planificar as súas comidas.

A notificación de xaxún ten prioridade alta pero non emite son continuamente, evitando interrupcións molestas mentres mantén visible a información crítica. Cando finaliza o período de xaxún, a notificación cancélase automaticamente e emítese unha alerta sonora breve para notificar ao usuario que xa pode comer.

### Configuración Personalizada por Medicamento

Cada medicamento pode ter a súa configuración de notificacións axustada individualmente. Os usuarios poden habilitar ou deshabilitar notificacións completamente para medicamentos específicos, manténdoos no sistema para seguimento pero sen alertas automáticas. Esta flexibilidade é útil para medicamentos que o usuario toma por rutina e non necesita recordatorios.

Ademais, a configuración de xaxún permite decidir se se desexan notificacións de inicio de xaxún (para medicamentos con xaxún previo) ou simplemente usar a función sen alertas. MedicApp respecta estas preferencias individuais mentres mantén a consistencia no rexistro e seguimento de todas as doses.

### Compatibilidade con Android 12+

MedicApp está optimizado para Android 12 e versións superiores, requirindo e xestionando os permisos de "Alarmas e recordatorios" necesarios para notificacións exactas. A aplicación detecta automaticamente se estes permisos non están concedidos e guía ao usuario para habitalos desde a configuración do sistema, asegurando que as notificacións cheguen puntualmente á hora programada.

---

## 9. Alertas de Stock Baixo

### Notificacións Reactivas de Stock Insuficiente

MedicApp implementa un sistema intelixente de alertas de stock que protexe ao usuario de quedarse sen medicación en momentos críticos. Cando un usuario intenta rexistrar unha dose (xa sexa desde a pantalla principal ou desde as accións rápidas de notificación), o sistema verifica automaticamente se hai stock suficiente para completar a toma.

Se o stock dispoñible é menor que a cantidade requirida para a dose, MedicApp mostra inmediatamente unha alerta de stock insuficiente que impide o rexistro da toma. Esta notificación reactiva indica claramente o nome do medicamento afectado, a cantidade necesaria versus a dispoñible, e suxire repor o inventario antes de intentar rexistrar a dose novamente.

Este mecanismo de protección prevén rexistros incorrectos no historial e garante a integridade do control de inventario, evitando que se desconte stock que fisicamente non existe. A alerta é clara, non intrusiva, e guía ao usuario directamente cara á acción correctiva (repor stock).

### Notificacións Proactivas de Stock Baixo

Ademais das alertas reactivas no momento de tomar unha dose, MedicApp inclúe un sistema proactivo de monitorización diaria de stock que anticipa problemas de desabastecemento antes de que ocorran. Este sistema avalía automaticamente o inventario de todos os medicamentos unha vez ao día, calculando os días de subministración restantes segundo o consumo programado.

O cálculo considera múltiples factores para estimar con precisión canto durará o stock actual:

**Para medicamentos programados** - O sistema suma a dose diaria total de todas as persoas asignadas, multiplica polos días configurados no patrón de frecuencia (por exemplo, se se toma só luns, mércores e venres, axusta o cálculo), e divide o stock actual entre este consumo diario efectivo.

**Para medicamentos ocasionais ("segundo necesidade")** - Utiliza o rexistro do último día de consumo real como preditor, proporcionando unha estimación adaptativa que mellora co uso.

Cando o stock dun medicamento alcanza o limiar configurado (por defecto 3 días, pero personalizable entre 1-10 días por medicamento), MedicApp emite unha notificación proactiva de advertencia. Esta notificación mostra:

- Nome do medicamento e tipo
- Días aproximados de subministración restantes
- Persoa(s) afectada(s)
- Stock actual en unidades correspondentes
- Suxestión de reposición

### Prevención de Spam de Notificacións

Para evitar bombardear ao usuario con alertas repetitivas, o sistema de notificacións proactivas implementa lóxica intelixente de frecuencia. Cada tipo de alerta de stock baixo emítese máximo unha vez ao día por medicamento. O sistema rexistra a última data na que se enviou cada alerta e non volve a notificar ata que:

1. Pasase polo menos 24 horas desde a última alerta, OU
2. O usuario repuxese o stock (restablecendo o contador)

Esta prevención de spam asegura que as notificacións sexan útiles e oportunas sen converterse nunha molestia que leve ao usuario a ignorialas ou deshabitalas.

### Integración con Control de Stock Visual

As alertas de stock baixo non funcionan de forma illada, senón que están profundamente integradas co sistema de semáforos visuais do pastilleiro. Cando un medicamento ten stock baixo:

- Aparece marcado en vermello ou ámbar na lista do botiquín
- Mostra un icono de advertencia na pantalla principal
- A notificación proactiva complementa estas sinais visuais

Esta multicapa de información (visual + notificacións) garante que o usuario sexa consciente do estado do inventario desde múltiples puntos de contacto coa aplicación.

### Configuración e Personalización

Cada medicamento pode ter un limiar de alerta personalizado que determina cando se considera o stock "baixo". Medicamentos críticos como insulina ou anticoagulantes poden configurarse con limiares de 7-10 días para permitir tempo amplo de reposición, mentres que suplementos menos urxentes poden usar limiares de 1-2 días.

O sistema respecta estas configuracións individuais, permitindo que cada medicamento teña a súa propia política de alertas adaptada á súa criticidade e dispoñibilidade en farmacias.

---

## 10. Configuración de Xaxún

### Tipos: Before (Antes) e After (Despois)

MedicApp soporta dúas modalidades de xaxún claramente diferenciadas para adaptarse a diferentes prescricións médicas:

**Xaxún Before (Antes)** - Configúrase cando o medicamento debe tomarse co estómago baleiro. O usuario debe ter xaxuado durante o período especificado ANTES de tomar o medicamento. Por exemplo, "30 minutos de xaxún antes" significa non ter comido nada durante os 30 minutos previos á toma. Este tipo é común en medicamentos que requiren absorción óptima sen interferencia alimentaria.

**Xaxún After (Despois)** - Configúrase cando despois de tomar o medicamento se debe esperar sen comer. Por exemplo, "60 minutos de xaxún despois" significa que tras tomar o medicamento, non se pode inxerir alimentos durante 60 minutos. Este tipo é típico en medicamentos que poden causar molestias gástricas ou cuxa efectividade redúcese con comida.

A duración do xaxún é completamente configurable en minutos, permitindo axustarse a prescricións específicas que poden variar desde 15 minutos ata varias horas.

### Conta Atrás Visual en Tempo Real

Cando un medicamento con xaxún "despois" foi tomado, MedicApp mostra unha conta atrás visual prominente na pantalla principal. Este contador actualízase en tempo real cada segundo, mostrando o tempo restante en formato MM:SS (minutos:segundos). Xunto á conta atrás, indícase a hora exacta en que finalizará o período de xaxún, permitindo planificación inmediata.

O compoñente visual da conta atrás é imposible de ignorar: utiliza cores chamativas, posiciónase destacadamente na pantalla, inclúe o nome do medicamento asociado, e mostra un icono de restrición alimentaria. Esta visibilidade constante asegura que o usuario non esqueza a restrición alimentaria activa.

### Notificación Fixa Durante o Xaxún

Complementando a conta atrás visual na app, MedicApp mostra unha notificación persistente do sistema durante todo o período de xaxún. Esta notificación é "ongoing" (en curso), o que significa que non pode ser desechada polo usuario e permanece fixa na barra de notificacións con máxima prioridade.

A notificación de xaxún mostra a mesma información que a conta atrás na app: nome do medicamento, tempo restante de xaxún, e hora estimada de finalización. Actualízase periodicamente para reflectir o tempo restante, aínda que non en tempo real constante para preservar batería. Esta dobre capa de recordatorio (visual en app + notificación persistente) practicamente elimina o risco de romper accidentalmente o xaxún.

### Cancelación Automática

O sistema xestiona automaticamente o ciclo de vida do xaxún sen intervención manual. Cando o tempo de xaxún se completa, varias accións ocorren simultaneamente e de forma automática:

1. A conta atrás visual desaparece da pantalla principal
2. A notificación persistente cancélase automaticamente
3. Emítese unha notificación breve con son indicando "Xaxún completado, xa podes comer"
4. O estado do medicamento actualízase para reflectir que o xaxún finalizou

Esta automatización asegura que o usuario estea sempre informado do estado actual sen necesidade de recordar manualmente cando finalizou o xaxún. Se a app está en segundo plano cando finaliza o xaxún, a notificación de finalización alerta ao usuario inmediatamente.

### Configuración por Medicamento

Non todos os medicamentos requiren xaxún, e entre os que si o requiren, as necesidades varían. MedicApp permite configurar individualmente para cada medicamento: se require xaxún ou non (si/non), o tipo de xaxún (antes/despois), a duración exacta en minutos, e se se desexan notificacións de inicio de xaxún (para o tipo "antes").

Esta granularidade permite xestionar réximes complexos onde algúns medicamentos tómanse en xaxunas, outros requiren espera post-inxesta, e outros non teñen restricións, todo dentro dunha interface coherente que manexa automaticamente cada caso segundo a súa configuración específica.

---

## 11. Historial de Doses

### Rexistro Automático Completo

MedicApp mantén un rexistro detallado e automático de cada acción relacionada con medicamentos. Cada vez que se rexistra unha dose (tomada ou omitida), o sistema crea inmediatamente unha entrada no historial que captura información exhaustiva do evento.

Os datos rexistrados inclúen: identificador único da entrada, ID do medicamento e o seu nome actual, tipo de medicamento co seu icono e cor, ID e nome da persoa que tomou/omitiu a dose, data e hora programada orixinalmente para a dose, data e hora real en que se rexistrou a acción, estado da dose (tomada ou omitida), cantidade exacta administrada nas unidades correspondentes, e se foi unha dose extra non programada.

Este rexistro automático funciona independentemente de como se rexistrou a dose: desde a app, desde as accións de notificación, ou mediante rexistro manual. Non require intervención do usuario máis alá da acción de rexistro básica, garantindo que o historial estea sempre completo e actualizado.

### Estatísticas de Adherencia Terapéutica

A partir do historial de doses, MedicApp calcula automaticamente estatísticas de adherencia que proporcionan información valiosa sobre o cumprimento do tratamento. As métricas inclúen:

**Taxa de Adherencia Global** - Porcentaxe de doses tomadas sobre o total de doses programadas, calculado como (doses tomadas / (doses tomadas + doses omitidas)) × 100.

**Total de Doses Rexistradas** - Conta total de eventos no historial dentro do período analizado.

**Doses Tomadas** - Número absoluto de doses rexistradas como tomadas exitosamente.

**Doses Omitidas** - Número de doses que foron saltadas ou non tomadas segundo o programado.

Estas estatísticas calcúlanse dinamicamente baseándose nos filtros aplicados, permitindo análise por períodos específicos, medicamentos individuais ou persoas concretas. Son especialmente útiles para identificar patróns de incumprimento, avaliar a efectividade do réxime de horarios actual, e proporcionar información obxectiva en consultas médicas.

### Filtros Avanzados Multidimensionais

A pantalla de historial inclúe un sistema de filtrado potente que permite analizar os datos desde múltiples perspectivas:

**Filtro por Persoa** - Mostra só as doses dunha persoa específica, ideal para seguimento individual en entornos multi-persoa. Inclúe opción "Todas as persoas" para vista global.

**Filtro por Medicamento** - Permite enfocarse nun medicamento particular, útil para avaliar a adherencia de tratamentos específicos. Inclúe opción "Todos os medicamentos" para vista completa.

**Filtro por Rango de Datas** - Define un período temporal específico con data de inicio e data de fin. Útil para xerar reportes de adherencia mensual, trimestral ou para períodos personalizados que coincidan con consultas médicas.

Os filtros son acumulativos e pódense combinar. Por exemplo, pódense ver "todas as doses de Ibuprofeno tomadas por María no mes de xaneiro", proporcionando análise moi granulares. Os filtros activos móstranse visualmente en chips informativos que poden removerse individualmente.

### Exportación de Datos

Aínda que a interface actual non implementa exportación directa, o historial de doses almacénase na base de datos SQLite da aplicación, que pode ser exportada completa mediante a funcionalidade de backup do sistema. Esta base de datos contén todas as entradas de historial en formato estruturado que pode ser procesado posteriormente con ferramentas externas para xerar reportes personalizados, gráficos de adherencia, ou integración con sistemas de xestión médica.

O formato dos datos é relacional e normalizado, con claves foráneas que vinculan medicamentos, persoas e entradas de historial, facilitando análise complexas e extracción de información para presentacións médicas ou auditorías de tratamento.

---

## 12. Localización e Internacionalização

### 8 Idiomas Completamente Soportados

MedicApp está traducida de forma profesional e completa a 8 idiomas, cubrindo a maioría de linguas faladas na península ibérica e ampliando o seu alcance a Europa:

**Español (es)** - Idioma principal, tradución nativa con toda a terminoloxía médica precisa.

**English (en)** - Inglés internacional, adaptado para usuarios anglofalantes globais.

**Deutsch (de)** - Alemán estándar, con terminoloxía médica europea.

**Français (fr)** - Francés europeo con vocabulario farmacéutico apropiado.

**Italiano (it)** - Italiano estándar con termos médicos localizados.

**Català (ca)** - Catalán con termos médicos específicos do sistema sanitario catalán.

**Euskara (eu)** - Éuscaro con terminoloxía sanitaria apropiada.

**Galego (gl)** - Galego con vocabulario médico rexionalizado.

Cada tradución non é unha simple conversión automática, senón unha localización cultural que respecta as convencións médicas, formatos de data/hora, e expresións idiomáticas de cada rexión. Os nomes de medicamentos, tipos farmacéuticos e termos técnicos están adaptados ao vocabulario médico local de cada idioma.

### Cambio Dinámico de Idioma

MedicApp permite cambiar o idioma da interface en calquera momento desde a pantalla de configuración. Ao seleccionar un novo idioma, a aplicación actualízase instantaneamente sen necesidade de reiniciar. Todos os textos da interface, mensaxes de notificación, etiquetas de botóns, descricións de axuda e mensaxes de erro actualízanse inmediatamente ao idioma seleccionado.

O cambio de idioma é fluído e non afecta aos datos almacenados. Os nomes de medicamentos introducidos polo usuario mantéñense tal como foron ingresados, independentemente do idioma da interface. Só os elementos de UI xerados polo sistema cambian de idioma, preservando a información médica personalizada.

### Separadores Decimais Localizados

MedicApp respecta as convencións numéricas de cada rexión para os separadores decimais. En idiomas como español, francés, alemán e italiano, utilízase a coma (,) como separador decimal: "1,5 pastillas", "2,25 ml". En inglés, utilízase o punto (.): "1.5 tablets", "2.25 ml".

Esta localización numérica aplícase automaticamente en todos os campos de entrada de cantidades: doses de medicamento, stock dispoñible, cantidades a reponer. Os teclados numéricos configúranse automaticamente para mostrar o separador decimal correcto segundo o idioma activo, evitando confusións e erros de entrada.

### Formatos de Data e Hora Localizados

Os formatos de data e hora tamén se adaptan ás convencións rexionais. Os idiomas europeos continentais utilizan o formato DD/MM/YYYY (día/mes/ano), mentres que o inglés pode usar MM/DD/YYYY nalgunhas variantes. Os nomes de meses e días da semana aparecen traducidos nos selectores de calendario e nas vistas de historial.

As horas móstranse en formato de 24 horas en todos os idiomas europeos (13:00, 18:30), que é o estándar médico internacional e evita ambigüidades AM/PM. Esta consistencia é crítica en contextos médicos onde a precisión horaria é vital para a efectividade do tratamento.

### Pluralización Intelixente

O sistema de localización inclúe lóxica de pluralización que adapta os textos segundo as cantidades. Por exemplo, en galego: "1 pastilla" pero "2 pastillas", "1 día" pero "3 días". Cada idioma ten as súas propias regras de pluralización que o sistema respecta automaticamente, incluíndo casos complexos en catalán, éuscaro e galego que teñen regras de plural diferentes ao español.

Esta atención ao detalle lingüístico fai que MedicApp se sinta natural e nativa en cada idioma, mellorando significativamente a experiencia do usuario e reducindo a carga cognitiva ao interactuar coa aplicación en contextos médicos potencialmente estresantes.

---

## 13. Interface Accesible e Usable

### Material Design 3

MedicApp está construída seguindo estrictamente as directrices de Material Design 3 (Material You) de Google, o sistema de deseño máis moderno e accesible para aplicacións Android. Esta decisión arquitectónica garantiza múltiples beneficios:

**Consistencia Visual** - Todos os elementos de interface (botóns, tarxetas, diálogos, campos de texto) seguen patróns visuais estándar que os usuarios de Android recoñecen instintivamente. Non hai que aprender unha interface completamente nova.

**Tematización Dinámica** - Material 3 permite que a app adopte as cores do sistema do usuario (se está en Android 12+), creando unha experiencia visual cohesiva co resto do dispositivo. As cores de acento, fondos e superficies adáptanse automaticamente.

**Compoñentes Accesibles Nativos** - Todos os controis de Material 3 están deseñados desde o principio para ser accesibles, con áreas de toque xenerosas (mínimo 48x48dp), contrastes adecuados, e soporte para lectores de pantalla.

### Tipografía Ampliada e Lexible

A aplicación utiliza unha xerarquía tipográfica clara con tamaños de fonte xenerosos que facilitan a lectura sen fatiga visual:

**Títulos de Pantalla** - Tamaño grande (24-28sp) para orientación clara de onde está o usuario.

**Nomes de Medicamentos** - Tamaño destacado (18-20sp) en negra para identificación rápida.

**Información Secundaria** - Tamaño medio (14-16sp) para detalles complementarios como horarios e cantidades.

**Texto de Axuda** - Tamaño estándar (14sp) para instrucións e descricións.

O interlineado é xeneroso (1.5x) para evitar que as liñas se confundan, especialmente importante para usuarios con problemas de visión. As fontes utilizadas son sans-serif que demostraron mellor lexibilidade en pantallas dixitais.

### Alto Contraste Visual

MedicApp implementa unha paleta de cores con ratios de contraste que cumpren e superan as directrices WCAG 2.1 AA para accesibilidade. O contraste mínimo entre texto e fondo é de 4.5:1 para texto normal e 3:1 para texto grande, asegurando lexibilidade incluso en condicións de iluminación subóptimas.

As cores utilízanse de forma funcional ademais de estética: vermello para alertas de stock baixo ou xaxún activo, verde para confirmacións e stock suficiente, ámbar para advertencias intermedias, azul para información neutra. Pero crucialmente, a cor nunca é o único indicador: sempre se complementa con iconos, texto ou patróns.

### Navegación Intuitiva e Predecible

A estrutura de navegación de MedicApp segue principios de simplicidade e previsibilidade:

**Pantalla Principal Central** - A vista de medicamentos do día é o hub principal desde o que todo é accesible en máximo 2 toques.

**Navegación por Pestanas** - A barra inferior con 3 pestanas (Medicamentos, Botiquín, Historial) permite cambio instantáneo entre as vistas principais sen animacións confusas.

**Botóns de Acción Flotantes** - As accións primarias (engadir medicamento, filtrar historial) realízanse mediante botóns flotantes (FAB) en posición consistente, fáciles de alcanzar co polgar.

**Breadcrumbs e Back Button** - Sempre é claro en que pantalla está o usuario e como volver atrás. O botón de retorno está sempre na posición superior esquerda estándar.

### Feedback Visual e Táctil

Cada interacción produce feedback inmediato: os botóns mostran efecto "ripple" ao ser premidos, as accións exitosas confírmanse con snackbars verdes que aparecen brevemente, os erros indícanse con diálogos vermellos explicativos, e os procesos longos (como exportar base de datos) mostran indicadores de progreso animados.

Este feedback constante asegura que o usuario sempre saiba que a súa acción foi rexistrada e o sistema está respondendo, reducindo a ansiedade típica de aplicacións médicas onde un erro podería ter consecuencias importantes.

### Deseño para Uso cunha Man

Recoñecendo que os usuarios frecuentemente manexan medicamentos cunha man (mentres sosteñen o envase coa outra), MedicApp optimiza a ergonomía para uso cunha man:

- Elementos interactivos principais na metade inferior da pantalla
- Botóns de acción flotante en esquina inferior dereita, alcanzable co polgar
- Evitación de menús en esquinas superiores que requiren reaxustar o agarre
- Xestos de deslizar horizontal (máis cómodos que verticais) para navegación temporal

Esta consideración ergonómica reduce a fatiga física e fai que a app sexa máis cómoda de usar en situacións reais de medicación, que a miúdo ocorren de pé ou en movemento.

---

## Integración de Funcionalidades

Todas estas características non funcionan de forma illada, senón que están profundamente integradas para crear unha experiencia cohesiva. Por exemplo:

- Un medicamento engadido no fluxo de 8 pasos asígnase automaticamente a persoas, xera notificacións segundo o seu tipo de frecuencia, aparece no botiquín ordenado alfabeticamente, rexistra as súas doses no historial, e actualiza estatísticas de adherencia.

- As notificacións respectan a configuración de xaxún, actualizando automaticamente a conta atrás visual cando se rexistra unha dose con xaxún posterior.

- O control de stock multi-persoa calcula correctamente os días restantes considerando as doses de todas as persoas asignadas, e alerta cando o limiar se alcanza independentemente de quen tome o medicamento.

- O cambio de idioma actualiza instantaneamente todas as notificacións pendentes, as pantallas visibles, e as mensaxes do sistema, mantendo consistencia total.

Esta integración profunda é o que converte a MedicApp dunha simple lista de medicamentos nun sistema completo de xestión terapéutica familiar.

---

## Referencias a Documentación Adicional

Para información máis detallada sobre aspectos específicos:

- **Arquitectura Multi-Persoa**: Ver documentación de base de datos (táboas `persons`, `medications`, `person_medications`)
- **Sistema de Notificacións**: Ver código fonte en `lib/services/notification_service.dart`
- **Modelo de Datos**: Ver modelos en `lib/models/` (especialmente `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localización**: Ver arquivos `.arb` en `lib/l10n/` para cada idioma
- **Tests**: Ver suite de tests en `test/` con 432+ tests que validan todas estas funcionalidades

---

Esta documentación reflicte o estado actual de MedicApp na súa versión 1.0.0, unha aplicación madura e completa para xestión de medicamentos familiares con máis do 75% de cobertura de tests e soporte completo para 8 idiomas.
