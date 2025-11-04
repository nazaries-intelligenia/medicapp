# Arquitectura Multi-Persona (V19+)

## Introducción

A partir de la versión 19, MedicApp implementa una arquitectura **muchos-a-muchos** para permitir la gestión de medicamentos para múltiples personas desde una única aplicación. Esta funcionalidad está diseñada para:

- Familias que gestionan medicamentos de varios miembros
- Cuidadores que supervisan tratamientos de múltiples pacientes
- Usuarios que desean separar medicamentos propios de otros familiares

## Modelo de Datos

### Diagrama de Relaciones

```
┌─────────────┐
│   persons   │
│             │
│ - id        │
│ - name      │
│ - isDefault │
│ - createdAt │
└──────┬──────┘
       │
       │ 1
       │
       │ N (muchos-a-muchos)
       │
       ▼
┌──────────────────────┐         ┌───────────────┐
│ person_medications   │    N:1  │  medications  │
│                      ├────────►│               │
│ - id                 │         │ - id          │
│ - personId    (FK)   │         │ - name        │
│ - medicationId (FK)  │         │ - type        │
│ - durationType       │         │ - stockQuantity│
│ - doseSchedule       │         │ - lastRefill  │
│ - takenDosesToday    │         │ - lowStock    │
│ - requiresFasting    │         │ - lastDaily   │
│ - isSuspended        │         └───────────────┘
│ - ...                │
└──────┬───────────────┘
       │
       │ 1
       │
       │ N (historial)
       │
       ▼
┌──────────────────┐
│  dose_history    │
│                  │
│ - id             │
│ - medicationId   │
│ - personId (FK)  │
│ - scheduledTime  │
│ - registeredTime │
│ - status         │
│ - quantity       │
└──────────────────┘
```

### Principios de Diseño

1. **Separación de conceptos**:
   - `medications`: Datos **compartidos** (nombre, tipo, stock físico)
   - `person_medications`: Datos **específicos por persona** (horarios, seguimiento, configuración)

2. **Stock compartido**:
   - El stock físico es uno solo y se comparte entre todas las personas
   - Cuando una persona toma medicamento, el stock global se reduce
   - Útil para familias que comparten medicamentos

3. **Configuración independiente**:
   - Cada persona puede tener horarios diferentes para el mismo medicamento
   - Permite flexibilidad total en la configuración por usuario

## Flujos de Uso

### 1. Agregar Medicamento

**Flujo completo**:
```
Usuario → AddMedicationFlow → medications (crear/reutilizar)
                             ↓
                      person_medications (crear assignment)
                             ↓
                      NotificationService (programar)
```

**Lógica de reutilización**:
- Si existe un medicamento con el mismo nombre → reutilizar
- Si no existe → crear nuevo en `medications`
- Siempre se crea una nueva entrada en `person_medications`

**Código relevante**:
- `lib/screens/medication_info_screen.dart`: Detección de duplicados
- `lib/database/database_helper.dart::insertMedication()`: Lógica de inserción

### 2. Asignar Medicamento Existente a Persona

**Flujo**:
```
MedicationListScreen → PersonAssignmentScreen
                             ↓
                      Selección de personas
                             ↓
                      person_medications (crear/eliminar)
                             ↓
                      NotificationService (actualizar)
```

**Reglas de negocio**:
- Un medicamento puede estar asignado a múltiples personas
- Una persona no puede tener el mismo medicamento asignado dos veces
- Al desasignar la última persona, el medicamento permanece en `medications` pero no se muestra
- Al eliminar un medicamento, se eliminan todas sus asignaciones

**Código relevante**:
- `lib/screens/person_assignment_screen.dart`: UI de asignación
- `lib/database/database_helper.dart::assignMedicationToPerson()`: Lógica de asignación

### 3. Cambiar de Persona Activa

**Flujo**:
```
Usuario toca tab de persona → _selectedPerson cambia
                                     ↓
                              _loadMedications() recarga
                                     ↓
                       Filtra por personId en query
                                     ↓
                       UI se actualiza con medicamentos de esa persona
```

**Persistencia**:
- La persona seleccionada NO se persiste entre sesiones
- Siempre se inicia con la persona por defecto
- Esto evita confusión si múltiples usuarios abren la app

**Código relevante**:
- `lib/screens/medication_list_screen.dart::_buildPersonTabs()`: UI de tabs
- `lib/database/database_helper.dart::getMedicationsForPerson()`: Query filtrada

### 4. Registro de Dosis

**Flujo**:
```
Usuario registra dosis → Identificar persona activa
                               ↓
                        Actualizar person_medications
                               ↓
                        Reducir stockQuantity en medications
                               ↓
                        Insertar en dose_history con personId
                               ↓
                        Actualizar notificaciones para esa persona
```

**Importante**:
- El stock se reduce GLOBALMENTE (afecta a todas las personas)
- El seguimiento (takenDosesToday) es POR PERSONA
- Las notificaciones se cancelan solo para esa persona

**Código relevante**:
- `lib/services/dose_action_service.dart`: Lógica centralizada de registro
- `lib/screens/dose_action_screen.dart`: UI de registro

## Gestión de Personas

### Crear Persona

**Validaciones**:
- Nombre no vacío
- Nombre único (case-insensitive)
- UUID generado automáticamente

**Código relevante**:
- `lib/screens/person_management_screen.dart`: UI de gestión
- `lib/database/database_helper.dart::insertPerson()`: Inserción

### Eliminar Persona

**Restricciones**:
- No se puede eliminar la persona por defecto
- Se muestra confirmación antes de eliminar

**Efecto cascada**:
1. Se eliminan todas las entradas en `person_medications` donde `personId = X`
2. Se eliminan todas las entradas en `dose_history` donde `personId = X`
3. Los medicamentos en `medications` permanecen intactos
4. Si un medicamento queda sin asignaciones, aún existe pero no se muestra

**Código relevante**:
- `lib/database/database_helper.dart::deletePerson()`: Eliminación con cascada

### Cambiar Persona Por Defecto

**Proceso**:
1. Se marca `isDefault = 0` en la persona actual por defecto
2. Se marca `isDefault = 1` en la nueva persona
3. Transacción atómica para garantizar que siempre hay exactamente una persona por defecto

**Código relevante**:
- `lib/database/database_helper.dart::setDefaultPerson()`: Cambio atómico

## Notificaciones

### Arquitectura por Persona

**Conceptos clave**:
- Cada notificación tiene un **notificationId único** basado en: `hash(medicationId + personId + doseTime)`
- Esto permite que el mismo medicamento tenga notificaciones independientes para diferentes personas
- Al cancelar/programar, solo se afectan las notificaciones de esa persona

**Ejemplo**:
```dart
// Persona A: Paracetamol a las 08:00
notificationId = hash("med123" + "personA" + "08:00") = 12345

// Persona B: Paracetamol a las 10:00
notificationId = hash("med123" + "personB" + "10:00") = 67890
```

**Código relevante**:
- `lib/services/notification_service.dart::_generateNotificationId()`: Generación de IDs
- `lib/services/notification_service.dart::scheduleMedicationNotifications()`: Programación con personId

### Actualización de Notificaciones

**Escenarios**:

1. **Editar horarios**:
   - Se cancelan todas las notificaciones de ese medicamento para esa persona
   - Se reprograman con la nueva configuración

2. **Cambiar nombre medicamento**:
   - Se reprograman notificaciones para TODAS las personas asignadas

3. **Suspender medicamento para una persona**:
   - Se cancelan notificaciones solo para esa persona
   - Otras personas siguen recibiendo notificaciones

**Código relevante**:
- `lib/screens/edit_sections/*.dart`: Lógica de edición con reprogramación

## Migración V16 → V19

### Proceso Automático

La migración se ejecuta automáticamente al abrir la app por primera vez después de actualizar:

```
1. Detectar versión actual (V16)
   ↓
2. Crear tablas nuevas:
   - persons
   - person_medications
   ↓
3. Crear persona por defecto:
   - name: "Usuario"
   - isDefault: 1
   ↓
4. Migrar cada medicamento:
   - Copiar datos de configuración a person_medications
   - Asociar con persona por defecto
   ↓
5. Actualizar dose_history:
   - Agregar campo personId
   - Asociar entradas legacy con persona por defecto
   ↓
6. Reprogramar notificaciones:
   - Cancelar todas las notificaciones legacy
   - Reprogramar con personId de persona por defecto
   ↓
7. Actualizar versión a V19
```

**Código relevante**:
- `lib/database/database_helper.dart::_onUpgrade()`: Orquestador de migración
- `lib/database/database_helper.dart::_migrateToMultiPersonArchitecture()`: Lógica de migración

### Retrocompatibilidad

**Métodos legacy que siguen funcionando**:
```dart
// Antiguo (V16)
await db.getMedications()
// Nuevo equivalente:
await db.getMedicationsForPerson(defaultPerson.id)

// Antiguo
await db.updateMedication(med)
// Sigue funcionando pero solo actualiza campos compartidos
```

**Estrategia**:
- Los métodos legacy ahora internamente llaman a los métodos nuevos
- Se usa la persona por defecto cuando no se especifica personId
- Esto permite que código antiguo siga funcionando sin cambios

## Decisiones de Diseño

### ¿Por qué muchos-a-muchos?

**Alternativas consideradas**:
1. **Una app por persona**: Requiere instalar múltiples veces, complicado de gestionar
2. **Medicamentos duplicados por persona**: Redundancia innecesaria, stock inconsistente
3. **Muchos-a-muchos** ✅: Flexibilidad máxima, stock compartido, configuración independiente

### ¿Por qué stock compartido?

**Escenario real**:
- Una familia tiene un frasco de Paracetamol
- Papá lo toma a las 08:00 y 20:00
- Mamá lo toma a las 14:00
- El frasco físico es UNO SOLO

**Solución**:
- `medications.stockQuantity` es compartido
- Cuando cualquier persona toma, el stock global se reduce
- Alarma de stock bajo considera el consumo de TODAS las personas

### ¿Por qué no persistir persona seleccionada?

**Problema potencial**:
- Usuario A selecciona "Mamá" y cierra app
- Usuario B (Mamá) abre app y ve sus propios medicamentos
- Pero el contexto dice "Mamá" así que ella asume correctamente
- Usuario A vuelve a abrir y aún ve "Mamá", puede registrar dosis por error

**Solución**:
- Siempre iniciar con persona por defecto
- Requiere selección explícita en cada sesión
- Evita errores de contexto

## Tests

### Tests Actualizados para V19+

1. **`test/integration/dose_registration_test.dart`**:
   - Actualizados para usar persona por defecto
   - Verifican que las dosis se registren con personId correcto

2. **`test/integration/edit_medication_test.dart`**:
   - 3 tests con problemas de timing corregidos
   - Agregado polling activo para esperar actualización de UI
   - Verifican que ediciones actualicen person_medications

3. **`test/integration/add_medication_test.dart`**:
   - Verifican que medicamentos duplicados se reutilicen correctamente
   - Confirman que la arquitectura muchos-a-muchos funciona

### Estrategia de Testing

**Unit tests**:
- Modelos: Person, validaciones
- Database: Métodos CRUD multi-persona
- Services: Lógica de asignación

**Integration tests**:
- Flujos completos: agregar, editar, eliminar, asignar
- Verificación de estado UI después de operaciones async
- Validación de notificaciones por persona

**Código relevante**:
- `test/integration/*.dart`: Tests de integración
- `test/helpers/`: Helpers de testing reutilizables

## Puntos de Extensión Futura

### Funcionalidades Potenciales

1. **Perfiles con más información**:
   - Foto de perfil
   - Edad, peso (para dosificación automática)
   - Alergias, condiciones médicas

2. **Compartir entre dispositivos**:
   - Backend sincronizado
   - Múltiples usuarios gestionando misma familia

3. **Reportes por persona**:
   - Estadísticas de adherencia comparativas
   - Gráficos de consumo por persona

4. **Stock por persona** (alternativa):
   - Medicamentos NO compartidos
   - Campo `isShared` en medications

### Consideraciones Técnicas

**Para implementar sincronización**:
- Agregar campos `updatedAt`, `syncedAt` a todas las tablas
- Implementar resolución de conflictos
- Backend con API REST o GraphQL
- Autenticación y autorización por familia

**Para implementar perfiles extendidos**:
- Agregar campos a `persons`: `photoUrl`, `dateOfBirth`, `weight`, `allergies`
- UI de perfil expandida
- Integración con cámara para fotos

## Troubleshooting

### Problema: Medicamento no aparece después de asignarlo

**Causa**: No hay refresh después de asignación

**Solución**:
```dart
await DatabaseHelper.instance.assignMedicationToPerson(...);
await _loadMedications(); // Recargar lista
```

### Problema: Notificaciones duplicadas

**Causa**: NotificationId no incluye personId

**Solución**: Verificar que se use el método correcto:
```dart
// ✅ Correcto
await NotificationService.instance.scheduleMedicationNotifications(
  medication,
  personId: person.id,
);

// ❌ Incorrecto (legacy)
await NotificationService.instance.scheduleMedicationNotifications(medication);
```

### Problema: Stock inconsistente

**Causa**: Actualizar `person_medications.stockQuantity` en lugar de `medications.stockQuantity`

**Solución**: Stock siempre en `medications`:
```dart
// ✅ Correcto
await db.update('medications', {'stockQuantity': newStock});

// ❌ Incorrecto
await db.update('person_medications', {'stockQuantity': newStock});
```

## Referencias

- **BASE_DE_DATOS.md**: Esquema completo de tablas
- **FUNCIONALIDADES.md**: Funcionalidades de usuario
- **lib/models/person.dart**: Modelo de datos
- **lib/database/database_helper.dart**: Capa de persistencia
- **lib/screens/person_management_screen.dart**: UI de gestión
- **lib/screens/person_assignment_screen.dart**: UI de asignación
