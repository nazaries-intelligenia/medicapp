# Fonctionnalités de MedicApp

Ce document détaille toutes les caractéristiques et capacités de MedicApp, une application avancée de gestion de médicaments conçue pour les familles et les soignants.

---

## 1. Gestion Multi-Personnes (V19+)

### Architecture Plusieurs-à-Plusieurs

MedicApp implémente une architecture sophistiquée de gestion multi-personnes qui permet à plusieurs utilisateurs de partager des médicaments tout en maintenant des configurations de traitement individuelles. Cette fonctionnalité est spécifiquement conçue pour les familles, les soignants professionnels et les groupes qui ont besoin de coordonner la médication de plusieurs personnes.

L'architecture est basée sur un modèle relationnel plusieurs-à-plusieurs, où chaque médicament (identifié par son nom, son type et son stock partagé) peut être assigné à plusieurs personnes, et chaque personne peut avoir plusieurs médicaments. Le stock est géré de manière centralisée et est automatiquement décrémenté indépendamment de qui prend le médicament, permettant un contrôle précis de l'inventaire partagé sans dupliquer les données.

Chaque personne peut configurer sa propre directive de traitement pour le même médicament, incluant des horaires spécifiques, des doses personnalisées, la durée du traitement et les préférences de jeûne. Par exemple, si une mère et sa fille partagent le même médicament, la mère peut avoir des prises configurées à 8h00 et 20h00, tandis que la fille n'a besoin que d'une dose quotidienne à 12h00. Toutes deux partagent le même stock physique, mais chacune reçoit des notifications et un suivi indépendant selon sa directive.

### Cas d'Usage

Cette fonctionnalité est particulièrement utile dans plusieurs scénarios : familles où plusieurs membres prennent le même médicament (comme des vitamines ou des suppléments), soignants professionnels qui gèrent la médication de plusieurs patients, foyers multigénérationnels où des médicaments communs sont partagés, et situations où il est nécessaire de contrôler le stock partagé pour éviter les ruptures. Le système permet de suivre en détail l'historique des doses par personne, facilitant l'adhérence thérapeutique et le contrôle médical individualisé.

---

## 2. 14 Types de Médicaments

### Catalogue Complet de Formes Pharmaceutiques

MedicApp supporte 14 types différents de médicaments, chacun avec une iconographie distinctive, un schéma de couleurs spécifique et des unités de mesure appropriées. Cette diversité permet d'enregistrer pratiquement toute forme pharmaceutique que l'on trouve dans une pharmacie domestique ou professionnelle.

**Types disponibles :**

1. **Comprimé** - Couleur bleue, icône circulaire. Unité : comprimés. Pour les comprimés solides traditionnels.
2. **Capsule** - Couleur violette, icône de capsule. Unité : capsules. Pour les médicaments en forme de capsule gélatineuse.
3. **Injection** - Couleur rouge, icône de seringue. Unité : injections. Pour les médicaments nécessitant une administration parentérale.
4. **Sirop** - Couleur orange, icône de verre. Unité : ml (millilitres). Pour les médicaments liquides à administration orale.
5. **Ovule** - Couleur rose, icône ovale. Unité : ovules. Pour les médicaments à administration vaginale.
6. **Suppositoire** - Couleur vert bleuté (teal), icône spécifique. Unité : suppositoires. Pour l'administration rectale.
7. **Inhalateur** - Couleur cyan, icône d'air. Unité : inhalations. Pour les médicaments respiratoires.
8. **Sachet** - Couleur marron, icône de paquet. Unité : sachets. Pour les médicaments en poudre ou granulés.
9. **Spray** - Couleur bleu clair, icône de goutte. Unité : ml (millilitres). Pour les nébuliseurs et aérosols nasaux.
10. **Pommade** - Couleur verte, icône de goutte opaque. Unité : grammes. Pour les médicaments topiques crémeux.
11. **Lotion** - Couleur indigo, icône d'eau. Unité : ml (millilitres). Pour les médicaments liquides topiques.
12. **Pansement** - Couleur ambre, icône de guérison. Unité : pansements. Pour les patchs médicamenteux et pansements thérapeutiques.
13. **Goutte** - Couleur gris bleuté, icône de goutte inversée. Unité : gouttes. Pour les collyres et gouttes otiques.
14. **Autre** - Couleur grise, icône générique. Unité : unités. Pour toute forme pharmaceutique non catégorisée.

### Avantages du Système de Types

Cette classification détaillée permet au système de calculer automatiquement le stock de manière précise selon l'unité de mesure correspondante, d'afficher des icônes et des couleurs qui facilitent l'identification visuelle rapide, et de générer des notifications contextuelles qui mentionnent le type spécifique de médicament. Les utilisateurs peuvent gérer des traitements simples avec des comprimés jusqu'à des régimes complexes incluant des inhalateurs, des injections et des gouttes, le tout dans une même interface cohérente.

---

## 3. Flux d'Ajout de Médicaments

### Médicaments Programmés (8 Étapes)

Le processus d'ajout d'un médicament avec horaire programmé est guidé et structuré pour assurer que toutes les informations nécessaires soient correctement configurées :

**Étape 1 : Informations de Base** - On introduit le nom du médicament et on sélectionne le type parmi les 14 options disponibles. Le système valide que le nom ne soit pas vide.

**Étape 2 : Fréquence de Traitement** - On définit le schéma de prise avec six options : tous les jours, jusqu'à épuisement de la médication, dates spécifiques, jours de la semaine, tous les N jours, ou selon besoin. Cette configuration détermine quand les doses doivent être prises.

**Étape 3 : Configuration des Doses** - On établit les horaires spécifiques de prise. L'utilisateur peut choisir entre mode uniforme (même dose à tous les horaires) ou doses personnalisées par chaque horaire. Par exemple, on peut configurer 1 comprimé à 8h00, 0,5 comprimé à 14h00 et 2 comprimés à 20h00.

**Étape 4 : Horaires de Prise** - On sélectionne les heures exactes auxquelles le médicament doit être pris en utilisant un sélecteur de temps visuel. Plusieurs horaires par jour peuvent être configurés selon la prescription.

**Étape 5 : Durée du Traitement** - Si applicable selon le type de fréquence, on établit les dates de début et de fin du traitement. Cela permet de programmer des traitements à durée définie ou des traitements continus.

**Étape 6 : Configuration du Jeûne** - On définit si le médicament nécessite un jeûne avant ou après la prise, la durée de la période de jeûne en minutes, et si l'on souhaite des notifications de rappel de jeûne.

**Étape 7 : Stock Initial** - On introduit la quantité de médicament disponible dans les unités correspondant au type sélectionné. Le système utilisera cette valeur pour le contrôle d'inventaire.

**Étape 8 : Assignation de Personnes** - On sélectionne les personnes qui prendront ce médicament. Pour chaque personne, on peut configurer une directive individuelle avec horaires et doses personnalisées, ou hériter la configuration de base.

### Médicaments Occasionnels (2 Étapes)

Pour les médicaments d'usage sporadique ou "selon besoin", le processus est considérablement simplifié :

**Étape 1 : Informations de Base** - Nom et type du médicament.

**Étape 2 : Stock Initial** - Quantité disponible. Le système configure automatiquement le médicament comme "selon besoin", sans horaires programmés ni notifications automatiques.

### Validations Automatiques

Tout au long du processus, MedicApp valide que tous les champs obligatoires aient été complétés avant de permettre de passer à l'étape suivante. On vérifie que les horaires soient logiques, que les doses soient des valeurs numériques positives, que les dates de début ne soient pas postérieures aux dates de fin, et qu'au moins une personne soit assignée au médicament.

---

## 4. Enregistrement des Prises

### Prises Programmées

MedicApp gère automatiquement les prises programmées selon la configuration de chaque médicament et personne. Lorsque l'heure d'une dose arrive, l'utilisateur reçoit une notification et peut enregistrer la prise depuis trois points : l'écran principal où apparaît la dose en attente, la notification directement via des actions rapides, ou en touchant la notification qui ouvre un écran de confirmation détaillé.

Lors de l'enregistrement d'une prise programmée, le système décrémente automatiquement la quantité correspondante du stock partagé, marque la dose comme prise dans le jour actuel pour cette personne spécifique, crée une entrée dans l'historique des doses avec horodatage exact, et annule la notification en attente si elle existe. Si le médicament nécessite un jeûne postérieur, une notification de fin de jeûne est immédiatement programmée et un compte à rebours visuel est affiché sur l'écran principal.

### Prises Occasionnelles

Pour les médicaments configurés comme "selon besoin" ou lorsqu'il est nécessaire d'enregistrer une prise hors horaire, MedicApp permet l'enregistrement manuel. L'utilisateur accède au médicament depuis l'armoire à pharmacie, sélectionne "Prendre dose", introduit la quantité prise manuellement, et le système décrémente le stock et enregistre dans l'historique avec l'horaire actuel. Cette fonctionnalité est essentielle pour les analgésiques, antipyrétiques et autres médicaments d'usage sporadique.

### Prises Exceptionnelles

Le système permet également d'enregistrer des doses additionnelles non programmées pour les médicaments à horaire fixe. Par exemple, si un patient a besoin d'une dose supplémentaire d'analgésique entre ses prises habituelles, il peut l'enregistrer comme "dose supplémentaire". Cette dose est enregistrée dans l'historique marquée comme exceptionnelle, décrémente le stock, mais n'affecte pas le suivi d'adhérence des doses programmées régulières.

### Historique Automatique

Chaque action d'enregistrement génère automatiquement une entrée complète dans l'historique qui inclut : la date et l'heure programmée de la dose, la date et l'heure réelle d'administration, la personne qui a pris le médicament, le nom et le type du médicament, la quantité exacte administrée, le statut (prise ou omise), et si c'était une dose supplémentaire non programmée. Cet historique permet une analyse détaillée de l'adhérence thérapeutique et facilite les rapports médicaux.

---

## 5. Gestion des Dates de Péremption

### Contrôle de Péremption des Médicaments

MedicApp permet d'enregistrer et de surveiller les dates de péremption des médicaments pour garantir la sécurité du traitement. Cette fonctionnalité est particulièrement importante pour les médicaments occasionnels et suspendus qui restent stockés pendant de longues périodes.

Le système utilise un format simplifié MM/AAAA (mois/année) qui correspond au format standard imprimé sur les emballages de médicaments. Cela facilite la saisie des données sans avoir besoin de connaître le jour exact de péremption.

### Détection Automatique de l'État

MedicApp évalue automatiquement l'état de péremption de chaque médicament :

- **Périmé** : Le médicament a dépassé sa date de péremption et s'affiche avec une étiquette rouge d'avertissement avec icône d'alerte.
- **Proche de la péremption** : 30 jours ou moins avant la péremption, s'affiche avec une étiquette orange de précaution avec icône d'horloge.
- **En bon état** : Plus de 30 jours avant la péremption, aucun avertissement spécial n'est affiché.

Les alertes visuelles apparaissent directement sur la carte du médicament dans l'armoire à pharmacie, à côté du statut de suspension le cas échéant, permettant d'identifier rapidement les médicaments nécessitant une attention.

### Enregistrement de la Date de Péremption

Le système demande la date de péremption à trois moments spécifiques :

1. **Lors de la création d'un médicament occasionnel** : Comme dernière étape du processus de création (étape 2/2), une boîte de dialogue optionnelle apparaît pour saisir la date de péremption avant d'enregistrer le médicament.

2. **Lors de la suspension d'un médicament** : Lors de la suspension d'un médicament pour tous les utilisateurs qui le partagent, la date de péremption est demandée. Cela permet d'enregistrer la date de l'emballage qui restera stocké.

3. **Lors du réapprovisionnement d'un médicament occasionnel** : Après avoir ajouté du stock à un médicament occasionnel, le système propose de mettre à jour la date de péremption pour refléter la date du nouvel emballage acquis.

Dans tous les cas, le champ est optionnel et peut être ignoré. L'utilisateur peut annuler l'opération ou simplement laisser le champ vide.

### Format et Validations

La boîte de dialogue de saisie de date de péremption fournit deux champs séparés :
- Champ du mois (MM) : accepte des valeurs de 01 à 12
- Champ de l'année (AAAA) : accepte des valeurs de 2000 à 2100

Le système valide automatiquement que le mois est dans la plage correcte et que l'année est valide. En complétant le mois (2 chiffres), le focus se déplace automatiquement vers le champ de l'année pour accélérer la saisie des données.

La date est stockée au format "MM/AAAA" (exemple : "03/2025") et est interprétée comme le dernier jour de ce mois pour les comparaisons de péremption. Cela signifie qu'un médicament avec la date "03/2025" sera considéré comme périmé à partir du 1er avril 2025.

### Avantages du Système

Cette fonctionnalité aide à :
- Prévenir l'utilisation de médicaments périmés qui pourraient être inefficaces ou dangereux
- Gérer efficacement le stock en identifiant les médicaments proches de la péremption
- Prioriser l'utilisation des médicaments selon leur date de péremption
- Maintenir une armoire à pharmacie sûre avec un contrôle visuel de l'état de chaque médicament
- Éviter le gaspillage en rappelant de vérifier les médicaments avant qu'ils ne périment

Le système n'empêche pas l'enregistrement de doses avec des médicaments périmés, mais fournit des avertissements visuels clairs pour que l'utilisateur puisse prendre des décisions éclairées.

---

## 6. Contrôle de Stock (Pilulier)

### Indicateurs Visuels Intuitifs

Le système de contrôle de stock de MedicApp fournit des informations en temps réel de l'inventaire disponible via un système de feux de signalisation visuels. Chaque médicament affiche sa quantité actuelle dans les unités correspondantes, avec des indicateurs de couleur qui alertent sur l'état du stock.

Le code de couleurs est intuitif : vert indique un stock suffisant pour plus de 3 jours, jaune/ambre alerte que le stock est bas (moins de 3 jours d'approvisionnement), et rouge indique que le médicament est épuisé. Les seuils de jours sont configurables par médicament, permettant des ajustements selon la criticité de chaque traitement.

### Calcul Automatique Intelligent

Le calcul des jours restants s'effectue automatiquement en considérant plusieurs facteurs. Pour les médicaments programmés, le système analyse la dose quotidienne totale en additionnant toutes les prises configurées de toutes les personnes assignées, divise le stock actuel par cette dose quotidienne, et estime les jours d'approvisionnement restants.

Pour les médicaments occasionnels ou "selon besoin", le système utilise un algorithme adaptatif qui enregistre la consommation du dernier jour d'usage et l'emploie comme prédicteur pour estimer combien de jours durera le stock actuel. Cette estimation se met à jour automatiquement chaque fois qu'un usage du médicament est enregistré.

### Seuil Configurable par Médicament

Chaque médicament peut avoir un seuil d'alerte personnalisé qui détermine quand le stock est considéré comme bas. La valeur par défaut est de 3 jours, mais peut être ajustée entre 1 et 10 jours selon les besoins. Par exemple, les médicaments critiques comme l'insuline peuvent être configurés avec un seuil de 7 jours pour permettre un temps suffisant de réapprovisionnement, tandis que les suppléments moins critiques peuvent utiliser des seuils de 1-2 jours.

### Alertes et Réapprovisionnement

Lorsque le stock atteint le seuil configuré, MedicApp affiche des alertes visuelles mises en évidence sur l'écran principal et dans la vue du pilulier. Le système suggère automatiquement la quantité à réapprovisionner en se basant sur le dernier réapprovisionnement enregistré, accélérant le processus de mise à jour de l'inventaire. Les alertes persistent jusqu'à ce que l'utilisateur enregistre une nouvelle quantité en stock, assurant que les réapprovisionnements critiques ne soient pas oubliés.

---

## 7. Armoire à Pharmacie

### Liste Alphabétique Organisée

L'armoire à pharmacie de MedicApp présente tous les médicaments enregistrés dans une liste ordonnée alphabétiquement, facilitant la localisation rapide de tout médicament. Chaque entrée affiche le nom du médicament, le type avec son icône et sa couleur distinctive, le stock actuel dans les unités correspondantes, et les personnes assignées à ce médicament.

La vue de l'armoire à pharmacie est particulièrement utile pour avoir une vision globale de l'inventaire de médicaments disponibles, sans l'information des horaires qui peut être accablante dans la vue principale. C'est l'écran idéal pour les gestions d'inventaire, la recherche de médicaments spécifiques et les actions de maintenance.

### Moteur de Recherche en Temps Réel

Un champ de recherche en haut permet de filtrer les médicaments instantanément pendant qu'on écrit. La recherche est intelligente et considère tant le nom du médicament que le type, ce qui permet de trouver "tous les sirops" ou "médicaments contenant aspirine" rapidement. Les résultats se mettent à jour en temps réel sans besoin de presser des boutons additionnels.

### Actions Rapides Intégrées

Depuis chaque médicament dans l'armoire, on peut accéder à un menu contextuel avec trois actions principales :

**Modifier** - Ouvre l'éditeur complet du médicament où tous les aspects peuvent être modifiés : nom, type, horaires, doses, personnes assignées, configuration de jeûne, etc. Les changements sont sauvegardés et les notifications sont automatiquement resynchronisées.

**Supprimer** - Permet d'effacer définitivement le médicament du système après une confirmation de sécurité. Cette action annule toutes les notifications associées et élimine le registre de l'historique futur, mais préserve l'historique des doses déjà enregistrées pour maintenir l'intégrité des données.

**Prendre dose** - Raccourci rapide pour enregistrer une prise manuelle, particulièrement utile pour les médicaments occasionnels. Si le médicament est assigné à plusieurs personnes, il demande d'abord de sélectionner qui le prend.

### Gestion des Assignations

L'armoire à pharmacie facilite également la gestion des assignations personne-médicament. On peut voir d'un coup d'œil quels médicaments sont assignés à chaque personne, ajouter ou retirer des personnes d'un médicament existant, et modifier les directives individuelles de chaque personne sans affecter les autres.

---

## 8. Navigation Temporelle

### Glisser Horizontal par Jours

L'écran principal de MedicApp implémente un système de navigation temporelle qui permet à l'utilisateur de se déplacer entre différents jours avec un simple geste de glissement horizontal. Glisser vers la gauche avance au jour suivant, tandis que glisser vers la droite recule au jour précédent. Cette navigation est fluide et utilise des transitions animées qui fournissent un retour visuel clair du changement de date.

La navigation temporelle est pratiquement illimitée vers le passé et le futur, permettant de réviser l'historique de médication de semaines ou mois en arrière, ou de planifier à l'avance en vérifiant quels médicaments seront programmés à des dates futures. Le système maintient un point central virtuel qui permet des milliers de pages dans les deux directions sans impact sur les performances.

### Sélecteur de Calendrier

Pour des sauts rapides à des dates spécifiques, MedicApp intègre un sélecteur de calendrier accessible depuis un bouton dans la barre supérieure. En touchant l'icône du calendrier, un widget de calendrier visuel s'ouvre où l'utilisateur peut sélectionner n'importe quelle date. Lors de la sélection, la vue se met à jour instantanément pour afficher les médicaments programmés de ce jour spécifique.

Le calendrier marque visuellement le jour actuel avec un indicateur mis en évidence, facilite la sélection de dates passées pour réviser l'adhérence, permet de sauter à des dates futures pour la planification de voyages ou événements, et affiche la date sélectionnée actuelle dans la barre supérieure de manière permanente.

### Vue Jour vs Vue Hebdomadaire

Bien que la navigation principale soit par jour, MedicApp fournit un contexte temporel additionnel en affichant des informations pertinentes de la période sélectionnée. Dans la vue principale, les médicaments sont regroupés par horaire de prise, ce qui fournit une ligne temporelle du jour. Les indicateurs visuels montrent quelles doses ont déjà été prises, lesquelles ont été omises, et lesquelles sont en attente.

Pour les médicaments avec des schémas hebdomadaires ou intervalles spécifiques, l'interface indique clairement si le médicament correspond au jour sélectionné ou non. Par exemple, un médicament configuré pour "lundi, mercredi, vendredi" n'apparaît dans la liste que lorsqu'on visualise ces jours de la semaine.

### Avantages de la Navigation Temporelle

Cette fonctionnalité est particulièrement précieuse pour vérifier si un médicament a été pris un jour passé, planifier quels médicaments emporter dans un voyage en se basant sur les dates, réviser les schémas d'adhérence hebdomadaires ou mensuels, et coordonner les médications de plusieurs personnes dans un foyer durant des périodes spécifiques.

---

## 9. Notifications Intelligentes

### Actions Directes depuis la Notification

MedicApp révolutionne la gestion des médicaments via des notifications avec actions intégrées qui permettent de gérer les doses sans ouvrir l'application. Lorsque l'heure d'une dose arrive, la notification affiche trois boutons d'action directe :

**Prendre** - Enregistre la dose immédiatement, décrémente le stock, crée une entrée dans l'historique, annule la notification, et si applicable, initie la période de jeûne postérieur avec compte à rebours.

**Reporter** - Reporte la notification de 10, 30 ou 60 minutes selon l'option sélectionnée. La notification réapparaît automatiquement dans le temps spécifié.

**Sauter** - Enregistre la dose comme omise, crée une entrée dans l'historique avec statut "sautée" sans décrémenter le stock, et annule la notification sans programmer de rappels additionnels.

Ces actions fonctionnent même lorsque le téléphone est verrouillé, rendant l'enregistrement de médication instantané et sans friction. L'utilisateur peut gérer sa médication complète depuis les notifications sans besoin de déverrouiller l'appareil ou ouvrir l'application.

### Annulation Intelligente

Le système de notifications implémente une logique avancée d'annulation pour éviter des alertes redondantes ou incorrectes. Lorsqu'un utilisateur enregistre une dose manuellement depuis l'application (sans utiliser la notification), le système annule automatiquement la notification en attente de cette dose spécifique pour ce jour.

Si un médicament est supprimé ou suspendu, toutes ses notifications futures sont annulées immédiatement en arrière-plan. Lorsque l'horaire d'un médicament est modifié, les anciennes notifications sont annulées et reprogrammées automatiquement avec les nouveaux horaires. Cette gestion intelligente assure que l'utilisateur ne reçoit que des notifications pertinentes et actuelles.

### Notifications Persistantes pour le Jeûne

Pour les médicaments nécessitant un jeûne, MedicApp affiche une notification persistante spéciale durant toute la période de jeûne. Cette notification ne peut pas être rejetée manuellement et affiche un compte à rebours en temps réel du temps restant jusqu'à ce qu'on puisse manger. Elle inclut l'heure exacte à laquelle le jeûne se terminera, ce qui permet à l'utilisateur de planifier ses repas.

La notification de jeûne a une priorité haute mais n'émet pas de son continuellement, évitant des interruptions gênantes tout en maintenant visible l'information critique. Lorsque la période de jeûne se termine, la notification s'annule automatiquement et une alerte sonore brève est émise pour notifier l'utilisateur qu'il peut désormais manger.

### Configuration Personnalisée par Médicament

Chaque médicament peut avoir sa configuration de notifications ajustée individuellement. Les utilisateurs peuvent activer ou désactiver complètement les notifications pour des médicaments spécifiques, les maintenant dans le système pour le suivi mais sans alertes automatiques. Cette flexibilité est utile pour les médicaments que l'utilisateur prend par routine et n'a pas besoin de rappels.

De plus, la configuration de jeûne permet de décider si l'on souhaite des notifications de début de jeûne (pour les médicaments avec jeûne préalable) ou simplement utiliser la fonction sans alertes. MedicApp respecte ces préférences individuelles tout en maintenant la cohérence dans l'enregistrement et le suivi de toutes les doses.

### Compatibilité avec Android 12+

MedicApp est optimisé pour Android 12 et versions supérieures, nécessitant et gérant les permissions "Alarmes et rappels" nécessaires pour des notifications exactes. L'application détecte automatiquement si ces permissions ne sont pas accordées et guide l'utilisateur pour les activer depuis la configuration du système, assurant que les notifications arrivent ponctuellement à l'heure programmée.

### Configuration du Son de Notification (Android 8.0+)

Sur les appareils fonctionnant sous Android 8.0 (API 26) ou supérieur, MedicApp offre un accès direct à la configuration du son de notification depuis les paramètres de l'application. Cette fonctionnalité permet de personnaliser le son, la vibration et d'autres paramètres de notification en utilisant les canaux de notification du système.

L'option "Son de notification" n'apparaît dans l'écran Paramètres que lorsque l'appareil répond aux exigences minimales de version du système d'exploitation. Sur les versions antérieures à Android 8.0, cette option est automatiquement masquée car le système ne prend pas en charge la configuration granulaire des canaux de notification.

---

## 10. Alertes de Stock Faible

### Notifications Réactives de Stock Insuffisant

MedicApp implémente un système intelligent d'alertes de stock qui protège l'utilisateur contre le risque de se retrouver sans médication aux moments critiques. Lorsqu'un utilisateur tente d'enregistrer une dose (que ce soit depuis l'écran principal ou depuis les actions rapides de notification), le système vérifie automatiquement s'il y a suffisamment de stock pour compléter la prise.

Si le stock disponible est inférieur à la quantité requise pour la dose, MedicApp affiche immédiatement une alerte de stock insuffisant qui empêche l'enregistrement de la prise. Cette notification réactive indique clairement le nom du médicament concerné, la quantité nécessaire versus celle disponible, et suggère de réapprovisionner l'inventaire avant de tenter d'enregistrer la dose à nouveau.

Ce mécanisme de protection prévient les enregistrements incorrects dans l'historique et garantit l'intégrité du contrôle d'inventaire, évitant de décrémenter du stock qui n'existe pas physiquement. L'alerte est claire, non intrusive, et guide l'utilisateur directement vers l'action corrective (réapprovisionner le stock).

### Notifications Proactives de Stock Faible

En plus des alertes réactives au moment de prendre une dose, MedicApp inclut un système proactif de surveillance quotidienne du stock qui anticipe les problèmes d'approvisionnement avant qu'ils ne surviennent. Ce système évalue automatiquement l'inventaire de tous les médicaments une fois par jour, calculant les jours d'approvisionnement restants selon la consommation programmée.

Le calcul considère plusieurs facteurs pour estimer avec précision combien de temps durera le stock actuel :

**Pour les médicaments programmés** - Le système additionne la dose quotidienne totale de toutes les personnes assignées, multiplie par les jours configurés dans le schéma de fréquence (par exemple, si pris uniquement lundi, mercredi et vendredi, il ajuste le calcul), et divise le stock actuel par cette consommation quotidienne effective.

**Pour les médicaments occasionnels ("selon besoin")** - Il utilise l'enregistrement du dernier jour de consommation réelle comme prédicteur, fournissant une estimation adaptative qui s'améliore avec l'usage.

Lorsque le stock d'un médicament atteint le seuil configuré (par défaut 3 jours, mais personnalisable entre 1-10 jours par médicament), MedicApp émet une notification proactive d'avertissement. Cette notification affiche :

- Nom du médicament et type
- Jours approximatifs d'approvisionnement restants
- Personne(s) concernée(s)
- Stock actuel en unités correspondantes
- Suggestion de réapprovisionnement

### Prévention du Spam de Notifications

Pour éviter de bombarder l'utilisateur avec des alertes répétitives, le système de notifications proactives implémente une logique intelligente de fréquence. Chaque type d'alerte de stock faible est émis au maximum une fois par jour par médicament. Le système enregistre la dernière date à laquelle chaque alerte a été envoyée et ne notifie plus jusqu'à ce que :

1. Au moins 24 heures se soient écoulées depuis la dernière alerte, OU
2. L'utilisateur ait réapprovisionné le stock (réinitialisant le compteur)

Cette prévention du spam assure que les notifications soient utiles et opportunes sans devenir une nuisance qui conduirait l'utilisateur à les ignorer ou les désactiver.

### Intégration avec le Contrôle de Stock Visuel

Les alertes de stock faible ne fonctionnent pas de manière isolée, mais sont profondément intégrées avec le système de feux de signalisation visuels du pilulier. Lorsqu'un médicament a un stock faible :

- Il apparaît marqué en rouge ou ambre dans la liste de l'armoire à pharmacie
- Il affiche une icône d'avertissement sur l'écran principal
- La notification proactive complète ces signaux visuels

Cette approche multicouche d'information (visuelle + notifications) garantit que l'utilisateur soit conscient de l'état de l'inventaire depuis plusieurs points de contact avec l'application.

### Configuration et Personnalisation

Chaque médicament peut avoir un seuil d'alerte personnalisé qui détermine quand le stock est considéré comme "faible". Les médicaments critiques comme l'insuline ou les anticoagulants peuvent être configurés avec des seuils de 7-10 jours pour permettre un temps suffisant de réapprovisionnement, tandis que les suppléments moins urgents peuvent utiliser des seuils de 1-2 jours.

Le système respecte ces configurations individuelles, permettant à chaque médicament d'avoir sa propre politique d'alertes adaptée à sa criticité et sa disponibilité en pharmacie.

---

## 11. Configuration du Jeûne

### Types : Before (Avant) et After (Après)

MedicApp supporte deux modalités de jeûne clairement différenciées pour s'adapter à différentes prescriptions médicales :

**Jeûne Before (Avant)** - Se configure lorsque le médicament doit être pris à jeun. L'utilisateur doit avoir jeûné durant la période spécifiée AVANT de prendre le médicament. Par exemple, "30 minutes de jeûne avant" signifie ne rien avoir mangé durant les 30 minutes précédant la prise. Ce type est commun dans les médicaments nécessitant une absorption optimale sans interférence alimentaire.

**Jeûne After (Après)** - Se configure lorsqu'après avoir pris le médicament, il faut attendre sans manger. Par exemple, "60 minutes de jeûne après" signifie qu'après avoir pris le médicament, on ne peut pas ingérer d'aliments durant 60 minutes. Ce type est typique des médicaments qui peuvent causer des troubles gastriques ou dont l'efficacité est réduite avec de la nourriture.

La durée du jeûne est complètement configurable en minutes, permettant de s'ajuster à des prescriptions spécifiques qui peuvent varier de 15 minutes à plusieurs heures.

### Compte à Rebours Visuel en Temps Réel

Lorsqu'un médicament avec jeûne "après" a été pris, MedicApp affiche un compte à rebours visuel proéminent sur l'écran principal. Ce compteur se met à jour en temps réel chaque seconde, affichant le temps restant au format MM:SS (minutes:secondes). À côté du compte à rebours, on indique l'heure exacte à laquelle la période de jeûne se terminera, permettant une planification immédiate.

Le composant visuel du compte à rebours est impossible à ignorer : il utilise des couleurs vives, se positionne de manière mise en évidence sur l'écran, inclut le nom du médicament associé, et affiche une icône de restriction alimentaire. Cette visibilité constante assure que l'utilisateur n'oublie pas la restriction alimentaire active.

### Notification Fixe Durant le Jeûne

Complétant le compte à rebours visuel dans l'application, MedicApp affiche une notification persistante du système durant toute la période de jeûne. Cette notification est "ongoing" (en cours), ce qui signifie qu'elle ne peut pas être rejetée par l'utilisateur et reste fixe dans la barre de notifications avec priorité maximale.

La notification de jeûne affiche la même information que le compte à rebours dans l'application : nom du médicament, temps restant de jeûne, et heure estimée de fin. Elle se met à jour périodiquement pour refléter le temps restant, bien que pas en temps réel constant pour préserver la batterie. Cette double couche de rappel (visuel dans l'application + notification persistante) élimine pratiquement le risque de rompre accidentellement le jeûne.

### Annulation Automatique

Le système gère automatiquement le cycle de vie du jeûne sans intervention manuelle. Lorsque le temps de jeûne est complété, plusieurs actions se produisent simultanément et automatiquement :

1. Le compte à rebours visuel disparaît de l'écran principal
2. La notification persistante s'annule automatiquement
3. Une notification brève avec son est émise indiquant "Jeûne terminé, vous pouvez manger"
4. L'état du médicament se met à jour pour refléter que le jeûne est terminé

Cette automatisation assure que l'utilisateur soit toujours informé de l'état actuel sans besoin de se rappeler manuellement quand le jeûne s'est terminé. Si l'application est en arrière-plan lorsque le jeûne se termine, la notification de fin alerte l'utilisateur immédiatement.

### Configuration par Médicament

Tous les médicaments ne nécessitent pas de jeûne, et parmi ceux qui le nécessitent, les besoins varient. MedicApp permet de configurer individuellement pour chaque médicament : s'il nécessite un jeûne ou non (oui/non), le type de jeûne (avant/après), la durée exacte en minutes, et si l'on souhaite des notifications de début de jeûne (pour le type "avant").

Cette granularité permet de gérer des régimes complexes où certains médicaments se prennent à jeun, d'autres nécessitent une attente post-ingestion, et d'autres n'ont pas de restrictions, le tout dans une interface cohérente qui gère automatiquement chaque cas selon sa configuration spécifique.

---

## 12. Historique des Doses

### Enregistrement Automatique Complet

MedicApp maintient un registre détaillé et automatique de chaque action liée aux médicaments. Chaque fois qu'une dose est enregistrée (prise ou omise), le système crée immédiatement une entrée dans l'historique qui capture des informations exhaustives de l'événement.

Les données enregistrées incluent : identifiant unique de l'entrée, ID du médicament et son nom actuel, type de médicament avec son icône et sa couleur, ID et nom de la personne qui a pris/omis la dose, date et heure programmée originellement pour la dose, date et heure réelle à laquelle l'action a été enregistrée, statut de la dose (prise ou omise), quantité exacte administrée dans les unités correspondantes, et si c'était une dose supplémentaire non programmée.

Cet enregistrement automatique fonctionne indépendamment de la façon dont la dose a été enregistrée : depuis l'application, depuis les actions de notification, ou via enregistrement manuel. Il ne nécessite pas d'intervention de l'utilisateur au-delà de l'action d'enregistrement de base, garantissant que l'historique soit toujours complet et à jour.

### Statistiques d'Adhérence Thérapeutique

À partir de l'historique des doses, MedicApp calcule automatiquement des statistiques d'adhérence qui fournissent des informations précieuses sur le respect du traitement. Les métriques incluent :

**Taux d'Adhérence Global** - Pourcentage de doses prises sur le total de doses programmées, calculé comme (doses prises / (doses prises + doses omises)) × 100.

**Total de Doses Enregistrées** - Compte total d'événements dans l'historique durant la période analysée.

**Doses Prises** - Nombre absolu de doses enregistrées comme prises avec succès.

**Doses Omises** - Nombre de doses qui ont été sautées ou non prises selon la programmation.

Ces statistiques se calculent dynamiquement en se basant sur les filtres appliqués, permettant des analyses par périodes spécifiques, médicaments individuels ou personnes concrètes. Elles sont particulièrement utiles pour identifier des schémas de non-respect, évaluer l'efficacité du régime d'horaires actuel, et fournir des informations objectives lors des consultations médicales.

### Filtres Avancés Multidimensionnels

L'écran d'historique inclut un système de filtrage puissant qui permet d'analyser les données depuis plusieurs perspectives :

**Filtre par Personne** - Affiche seulement les doses d'une personne spécifique, idéal pour le suivi individuel dans des environnements multi-personnes. Inclut l'option "Toutes les personnes" pour une vue globale.

**Filtre par Médicament** - Permet de se concentrer sur un médicament particulier, utile pour évaluer l'adhérence de traitements spécifiques. Inclut l'option "Tous les médicaments" pour une vue complète.

**Filtre par Plage de Dates** - Définit une période temporelle spécifique avec date de début et date de fin. Utile pour générer des rapports d'adhérence mensuelle, trimestrielle ou pour des périodes personnalisées qui coïncident avec des consultations médicales.

Les filtres sont cumulatifs et peuvent être combinés. Par exemple, on peut voir "toutes les doses d'Ibuprofène prises par Marie en janvier", fournissant des analyses très granulaires. Les filtres actifs sont affichés visuellement dans des chips informatifs qui peuvent être retirés individuellement.

### Exportation de Données

Bien que l'interface actuelle n'implémente pas d'exportation directe, l'historique des doses est stocké dans la base de données SQLite de l'application, qui peut être exportée complètement via la fonctionnalité de backup du système. Cette base de données contient toutes les entrées d'historique dans un format structuré qui peut être traité ultérieurement avec des outils externes pour générer des rapports personnalisés, graphiques d'adhérence, ou intégration avec des systèmes de gestion médicale.

Le format des données est relationnel et normalisé, avec des clés étrangères qui lient médicaments, personnes et entrées d'historique, facilitant des analyses complexes et l'extraction d'information pour des présentations médicales ou audits de traitement.

---

## 13. Localisation et Internationalisation

### 8 Langues Complètement Supportées

MedicApp est traduite de manière professionnelle et complète en 8 langues, couvrant la majorité des langues parlées dans la péninsule ibérique et élargissant sa portée à l'Europe :

**Español (es)** - Langue principale, traduction native avec toute la terminologie médicale précise.

**English (en)** - Anglais international, adapté pour les utilisateurs anglophones globaux.

**Deutsch (de)** - Allemand standard, avec terminologie médicale européenne.

**Français (fr)** - Français européen avec vocabulaire pharmaceutique approprié.

**Italiano (it)** - Italien standard avec termes médicaux localisés.

**Català (ca)** - Catalan avec termes médicaux spécifiques du système sanitaire catalan.

**Euskara (eu)** - Basque avec terminologie sanitaire appropriée.

**Galego (gl)** - Galicien avec vocabulaire médical régionalisé.

Chaque traduction n'est pas une simple conversion automatique, mais une localisation culturelle qui respecte les conventions médicales, formats de date/heure, et expressions idiomatiques de chaque région. Les noms de médicaments, types pharmaceutiques et termes techniques sont adaptés au vocabulaire médical local de chaque langue.

### Changement Dynamique de Langue

MedicApp permet de changer la langue de l'interface à tout moment depuis l'écran de configuration. En sélectionnant une nouvelle langue, l'application se met à jour instantanément sans besoin de redémarrer. Tous les textes de l'interface, messages de notification, étiquettes de boutons, descriptions d'aide et messages d'erreur se mettent à jour immédiatement dans la langue sélectionnée.

Le changement de langue est fluide et n'affecte pas les données stockées. Les noms de médicaments introduits par l'utilisateur se maintiennent tels qu'ils ont été saisis, indépendamment de la langue de l'interface. Seuls les éléments d'UI générés par le système changent de langue, préservant l'information médicale personnalisée.

### Séparateurs Décimaux Localisés

MedicApp respecte les conventions numériques de chaque région pour les séparateurs décimaux. Dans les langues comme l'espagnol, le français, l'allemand et l'italien, on utilise la virgule (,) comme séparateur décimal : "1,5 comprimés", "2,25 ml". En anglais, on utilise le point (.) : "1.5 tablets", "2.25 ml".

Cette localisation numérique s'applique automatiquement dans tous les champs de saisie de quantités : dose de médicament, stock disponible, quantités à réapprovisionner. Les claviers numériques se configurent automatiquement pour afficher le séparateur décimal correct selon la langue active, évitant les confusions et erreurs de saisie.

### Formats de Date et Heure Localisés

Les formats de date et heure s'adaptent également aux conventions régionales. Les langues européennes continentales utilisent le format JJ/MM/AAAA (jour/mois/année), tandis que l'anglais peut utiliser MM/JJ/AAAA dans certaines variantes. Les noms de mois et jours de la semaine apparaissent traduits dans les sélecteurs de calendrier et dans les vues d'historique.

Les heures sont affichées au format 24 heures dans toutes les langues européennes (13:00, 18:30), qui est le standard médical international et évite les ambiguïtés AM/PM. Cette cohérence est critique dans des contextes médicaux où la précision horaire est vitale pour l'efficacité du traitement.

### Pluralisation Intelligente

Le système de localisation inclut une logique de pluralisation qui adapte les textes selon les quantités. Par exemple, en français : "1 comprimé" mais "2 comprimés", "1 jour" mais "3 jours". Chaque langue a ses propres règles de pluralisation que le système respecte automatiquement, incluant des cas complexes en catalan, basque et galicien qui ont des règles de pluriel différentes de l'espagnol.

Cette attention au détail linguistique fait que MedicApp se sent naturelle et native dans chaque langue, améliorant significativement l'expérience utilisateur et réduisant la charge cognitive lors de l'interaction avec l'application dans des contextes médicaux potentiellement stressants.

---

## 14. Système de Cache Intelligent

### Architecture de Cache Multi-Niveau

MedicApp implémente un système de cache sophistiqué qui optimise radicalement les performances de l'application en réduisant les accès répétitifs à la base de données SQLite. Le système utilise un pattern cache-aside avec algorithme LRU (Least Recently Used) et TTL (Time-To-Live) automatique pour garantir que les données restent fraîches tout en maximisant les bénéfices de performance.

### SmartCacheService : Le Moteur de Cache

Le cœur du système est `SmartCacheService<T>`, une classe générique réutilisable qui peut cacher tout type de données. Cette classe implémente plusieurs fonctionnalités avancées :

**Algorithme LRU (Least Recently Used)** - Lorsque le cache atteint sa capacité maximale, il évicte automatiquement les entrées les moins récemment accédées. Cela assure que les données plus fréquemment consultées restent en mémoire, optimisant le taux de hits.

**TTL (Time-To-Live) Configurable** - Chaque entrée du cache a une durée de vie définie. Après l'expiration du TTL, les données sont considérées obsolètes et seront rechargées depuis la base de données lors du prochain accès. Cela équilibre performance et fraîcheur des données.

**Pattern Cache-Aside** - La méthode `getOrCompute()` simplifie l'usage du cache : elle vérifie d'abord si les données sont dans le cache (hit), et seulement si elles ne le sont pas (miss), elle exécute la fonction de calcul fournie pour obtenir les données depuis la source.

**Auto-Nettoyage** - Un timer périodique s'exécute chaque minute pour éliminer automatiquement les entrées expirées du cache, évitant l'accumulation de mémoire morte sans intervention manuelle.

**Statistiques en Temps Réel** - Le service suit méticuleusement les métriques de performance : nombre de hits (accès satisfaits depuis cache), misses (nécessitant accès à BD), évictions LRU, et calcule le hit rate (pourcentage d'efficacité du cache).

### MedicationCacheService : Caches Spécialisés

MedicApp utilise quatre caches spécialisés, chacun optimisé pour un type de donnée spécifique avec des configurations de TTL et taille adaptées à leurs schémas d'accès :

**medicationsCache (TTL: 10 minutes, Taille: 50 entrées)** - Cache les médicaments individuels. Configuré avec un TTL relativement long car les données de médicament changent rarement, mais assez court pour refléter les modifications lorsqu'elles se produisent.

**listsCache (TTL: 5 minutes, Taille: 20 entrées)** - Cache les listes de médicaments filtrées par personne ou critères. TTL plus court car ces listes changent plus fréquemment lorsque les doses sont prises ou omises.

**historyCache (TTL: 3 minutes, Taille: 30 entrées)** - Cache les requêtes d'historique de doses. TTL court car l'historique se met à jour constamment lorsque les utilisateurs enregistrent de nouvelles doses.

**statisticsCache (TTL: 30 minutes, Taille: 10 entrées)** - Cache les calculs statistiques complexes (observance, tendances). TTL long car ces statistiques sont coûteuses à calculer et ne nécessitent pas d'être en temps réel à la seconde près.

### Impact Mesuré sur les Performances

Les bénéfices du système de cache sont dramatiques et mesurables :

**Réduction des Accès à Base de Données** - Entre 60-80% de réduction des requêtes SQL pour les données fréquemment accédées. Cela diminue la charge sur la BD et prolonge la durée de vie de l'appareil.

**Temps de Chargement des Listes** - Sans cache : 50-200ms par chargement de liste de médicaments. Avec cache hit : 2-5ms. Amélioration de 10-40x.

**Requêtes d'Historique Complexes** - Sans cache : 300-500ms pour requêtes avec joins et filtres. Avec cache hit : 5-10ms. Amélioration de 30-50x.

**Calculs Statistiques Lourds** - Sans cache : 800-1200ms pour calculs d'observance avec agrégations complexes. Avec cache hit : 10-15ms. Amélioration de 60-80x.

Ces améliorations se traduisent en une expérience utilisateur perceptiblement plus fluide, avec des transitions instantanées entre écrans et une réactivité immédiate lors de la navigation.

### Invalidation Intelligente

Le cache ne sert à rien si les données sont obsolètes. MedicApp implémente une stratégie d'invalidation intelligente qui élimine sélectivement les entrées de cache affectées par les modifications, sans vider complètement le cache :

**Lors de création/modification de médicament** - Seules les entrées du cache liées à ce médicament spécifique sont invalidées. Les données d'autres médicaments restent en cache.

**Lors d'enregistrement de dose** - Les caches d'historique et de listes pour la personne concernée sont invalidés, mais les caches de médicaments individuels restent valides.

**Lors de modification de configuration** - Invalidation globale seulement si nécessaire (par exemple, changement de personne active).

Cette granularité d'invalidation maximise le taux de hits du cache en préservant autant de données valides que possible.

### Statistiques et Monitoring

Le système de cache fournit des métriques détaillées pour monitoring :

```dart
final stats = MedicationCacheService.medicationsCache.statistics;
// stats.hits : Nombre de requêtes satisfaites depuis cache
// stats.misses : Nombre de requêtes nécessitant accès à BD
// stats.evictions : Nombre d'évictions LRU
// stats.hitRate : Pourcentage de hits (0.0-1.0)
```

Ces statistiques permettent d'optimiser les configurations de TTL et taille pour chaque cache, et d'identifier les opportunités d'amélioration additionnelles.

---

## 15. Rappels Intelligents

### Analyse d'Observance Thérapeutique

MedicApp va au-delà de simplement enregistrer si les doses ont été prises ou omises. Le service `IntelligentRemindersService` analyse les schémas d'observance pour générer des insights actionnables qui aident les utilisateurs à améliorer leur adhésion au traitement.

### analyzeAdherence() : Analyse Complète de Schémas

Cette fonction réalise une analyse multidimensionnelle de l'historique de doses pour identifier des schémas de succès et de problèmes.

**Métriques par Jour de la Semaine** - Le système calcule le taux d'observance pour chaque jour (lundi à dimanche). Cela révèle si certains jours de la semaine sont systématiquement problématiques. Par exemple, de nombreux utilisateurs ont une observance plus faible les week-ends lorsque les routines sont perturbées.

**Métriques par Heure du Jour** - Analyse quels horaires de prise ont la meilleure adhésion. Identifie si les doses du matin sont plus fiables que celles du soir, ou si les prises de midi sont régulièrement oubliées pendant le travail.

**Détection de Meilleurs/Pires Jours et Horaires** - Identifie automatiquement le jour de la semaine et l'horaire avec la plus haute observance, et ceux avec la plus basse. Ces informations sont critiques pour l'optimisation.

**Liste de Jours Problématiques** - Génère une liste de jours spécifiques où l'observance est tombée en dessous de 50%, signalant des problèmes graves nécessitant attention immédiate.

**Analyse de Tendance** - Calcule si l'observance s'améliore, est stable, ou décline au fil du temps en comparant l'observance récente (dernière semaine) avec l'historique plus ancien.

**Recommandations Personnalisées** - Basé sur tous les facteurs ci-dessus, génère des suggestions concrètes et actionnables. Par exemple : "Envisage de déplacer la dose de 22h00 à 20h00, car l'observance à 20h00 est régulièrement plus élevée" ou "Les week-ends nécessitent des rappels supplémentaires".

Exemple de résultat d'analyse :
```dart
AdherenceAnalysis {
  overallAdherence: 0.85,  // 85% d'observance globale
  bestDay: 'Monday',       // Lundi a la meilleure observance
  worstDay: 'Saturday',    // Samedi a la pire observance
  bestTimeSlot: '08:00',   // 8h00 est l'horaire le plus fiable
  worstTimeSlot: '22:00',  // 22h00 est régulièrement oublié
  trend: AdherenceTrend.improving,  // L'observance s'améliore
  recommendations: [
    'Envisage de déplacer la dose de 22h00 à 20h00 (meilleure observance)',
    'Les week-ends nécessitent des rappels supplémentaires'
  ]
}
```

### predictSkipProbability() : Prédiction d'Omissions

Cette fonctionnalité utilise l'historique de doses pour prédire la probabilité qu'une dose spécifique soit omise, permettant des interventions proactives.

**Entrées Spécifiques** - La prédiction considère la personne, le médicament, le jour de la semaine exact, et l'heure spécifique de la dose. Cette granularité permet des prédictions très précises.

**Analyse de Schémas Historiques** - Examine tous les cas antérieurs similaires (même jour de semaine, même horaire) pour identifier des schémas récurrents d'omission.

**Classification de Risque** - Catégorise la probabilité en trois niveaux de risque :
- **Risque Faible** (0.0-0.3) : L'utilisateur prend cette dose de manière fiable
- **Risque Moyen** (0.3-0.6) : Certains problèmes d'observance, mérite attention
- **Risque Élevé** (0.6-1.0) : Haute probabilité d'omission, intervention nécessaire

**Facteurs Contributifs** - Identifie et explique les facteurs spécifiques contribuant à la probabilité d'omission, comme "Les samedis ont 60% plus d'omissions" ou "L'horaire 22h00 est régulièrement problématique".

Exemple de prédiction :
```dart
SkipProbability {
  probability: 0.65,         // 65% de probabilité d'omission
  riskLevel: RiskLevel.high, // Risque élevé
  factors: [
    'Les samedis ont 60% plus d\'omissions',
    'L\'horaire 22h00 est régulièrement problématique',
    'Tendance récente à la hausse d\'omissions'
  ]
}
```

Cette prédiction permet à l'application d'envoyer des rappels renforcés pour les doses à haut risque, ou de suggérer des changements d'horaire proactivement.

### suggestOptimalTimes() : Optimisation d'Horaires

Cette fonctionnalité analyse l'observance actuelle et suggère des changements d'horaire concrets pour améliorer l'adhésion.

**Identification d'Horaires Problématiques** - Détecte automatiquement les horaires de dose actuels avec observance inférieure à 70%, les marquant comme candidats à l'optimisation.

**Recherche d'Alternatives** - Pour chaque horaire problématique, recherche dans l'historique des horaires alternatifs où l'utilisateur a démontré une meilleure adhésion.

**Calcul de Potentiel d'Amélioration** - Quantifie précisément combien l'observance pourrait s'améliorer en déplaçant la dose à l'horaire suggéré, basé sur les schémas historiques.

**Priorisation par Impact** - Ordonne les suggestions par impact attendu, présentant d'abord les changements qui offrent le plus grand bénéfice potentiel.

Exemple de suggestions :
```dart
[
  TimeOptimizationSuggestion {
    currentTime: '22:00',
    suggestedTime: '20:00',
    currentAdherence: 0.45,      // 45% d'observance à 22h00
    expectedAdherence: 0.82,     // 82% attendue à 20h00
    improvementPotential: 0.37,  // +37% d'amélioration potentielle
    reason: 'L\'observance à 20h00 est régulièrement élevée dans votre historique'
  },
  TimeOptimizationSuggestion {
    currentTime: '13:00',
    suggestedTime: '12:30',
    currentAdherence: 0.62,
    expectedAdherence: 0.88,
    improvementPotential: 0.26,
    reason: 'Alignement avec votre routine de déjeuner améliore l\'observance'
  }
]
```

### Cas d'Usage et Intégration Future

Ces fonctionnalités analytiques ouvrent des possibilités pour de futures fonctionnalités :

**Écrans de Statistiques Avancées** - Visualisations graphiques de l'observance par jour, horaire, avec tendances historiques et projections futures.

**Alertes Proactives** - Notifications automatiques lorsque des schémas d'omission sont détectés, suggérant des interventions avant que l'observance ne se dégrade davantage.

**Assistant d'Optimisation d'Horaires** - Wizard interactif qui guide l'utilisateur à travers l'optimisation de ses horaires basée sur ses propres données historiques.

**Rapports Médicaux** - Génération de rapports PDF détaillés avec insights d'observance à partager avec les professionnels de santé, facilitant des conversations informées sur l'adhésion au traitement.

---

## 16. Thème Sombre Natif

### Support Complet de Thèmes Clair et Sombre

MedicApp implémente un système de thèmes sophistiqué avec support natif pour modes clair et sombre, offrant trois modes de fonctionnement configurables par l'utilisateur.

### Trois Modes de Fonctionnement

**Mode System (Par Défaut)** - L'application suit automatiquement la préférence de thème du système d'exploitation. Si l'utilisateur a configuré le mode sombre dans les paramètres de son téléphone, MedicApp adoptera le thème sombre. Si le système bascule vers le mode clair (manuellement ou automatiquement à l'aube), l'application suit instantanément.

Ce mode respecte l'intention de l'utilisateur au niveau système et s'adapte automatiquement aux changements, incluant les horaires programmés (mode sombre automatique la nuit sur Android 10+).

**Mode Light (Forcer Clair)** - Force le thème clair indépendamment de la configuration du système. Utile pour les utilisateurs qui préfèrent toujours un thème clair même si leur système est en mode sombre.

**Mode Dark (Forcer Sombre)** - Force le thème sombre indépendamment de la configuration du système. Idéal pour les utilisateurs qui préfèrent constamment le mode sombre pour réduire la fatigue oculaire et économiser la batterie (sur écrans OLED/AMOLED).

### Architecture de Thème avec Provider

Le système de thèmes utilise le pattern Provider pour gérer l'état de manière réactive et efficace.

**ThemeProvider** - Un `ChangeNotifier` qui encapsule l'état actuel du thème et notifie tous les listeners lorsque l'utilisateur change de préférence. Cela provoque une reconstruction automatique de l'arbre de widgets avec le nouveau thème.

**Persistance Automatique** - Chaque fois que l'utilisateur change le mode de thème, la préférence est immédiatement sauvegardée dans `SharedPreferences` via `PreferencesService`. Au prochain démarrage de l'application, le thème préféré est restauré automatiquement.

**Changement Sans Redémarrage** - La transition entre thèmes est instantanée et fluide, sans nécessiter de redémarrage de l'application. Tous les écrans se mettent à jour immédiatement avec les nouvelles couleurs.

### Définition de Thèmes dans AppTheme

La classe `AppTheme` définit deux `ThemeData` complets : `lightTheme` et `darkTheme`.

**ColorScheme avec Material Design 3** - Les deux thèmes utilisent Material Design 3 (Material You) avec `ColorScheme.fromSeed()`, générant automatiquement une palette harmonieuse de couleurs à partir d'une couleur de départ (seed). Cela garantit cohérence et accessibilité des contrastes.

**Brightness Approprié** - `lightTheme` utilise `Brightness.light`, tandis que `darkTheme` utilise `Brightness.dark`. Cela affecte les choix automatiques de couleurs de texte, bordures, et surfaces par le framework Flutter.

### Personnalisation de Composants

Chaque thème personnalise exhaustivement tous les composants Material pour cohérence visuelle :

**AppBarTheme** - Barres d'application avec couleurs de fond et de texte appropriées pour chaque mode. En mode sombre, utilise une surface légèrement élevée pour distinction visuelle.

**CardTheme** - Cartes avec élévation et couleurs de surface adaptées. Le mode sombre utilise des surfaces légèrement plus claires que le fond pour créer de la profondeur.

**FloatingActionButtonTheme** - Boutons d'action flottante avec couleurs vives qui se démarquent dans les deux modes, mais ajustées pour contraste optimal.

**InputDecorationTheme** - Champs de texte avec bordures, couleurs de label, et couleurs de focus cohérentes avec le thème général.

**DialogTheme** - Dialogues avec coins arrondis et couleurs de surface appropriées. En mode sombre, les dialogues utilisent une surface plus élevée que les cartes pour hiérarchie visuelle.

**SnackBarTheme** - Notifications temporaires avec contrastes forts pour visibilité immédiate dans les deux modes.

**TextTheme** - Hiérarchie typographique complète avec tailles de police et poids appropriés, adaptés pour lisibilité dans chaque mode.

### Optimisation pour Mode Sombre

Le thème sombre n'est pas simplement une inversion de couleurs, mais est optimisé spécifiquement :

**Contrastes Ajustés** - Les niveaux de contraste entre texte et fond sont soigneusement calibrés pour éviter la fatigue oculaire. Le texte blanc pur sur fond noir pur est évité, utilisant plutôt des gris légèrement atténués.

**Élévation avec Couleur** - Material Design 3 en mode sombre utilise des surfaces légèrement plus claires pour les éléments élevés (cartes sur fonds, dialogues sur cartes), créant une hiérarchie visuelle claire sans ombres lourdes.

**Économie de Batterie** - Sur écrans OLED/AMOLED (la majorité des smartphones modernes), les pixels noirs sont littéralement éteints, réduisant significativement la consommation de batterie. Le mode sombre peut économiser 20-40% de batterie selon l'usage.

**Réduction de Lumière Bleue** - Le thème sombre émet moins de lumière bleue, réduisant la perturbation du sommeil lors d'usage nocturne de l'application.

### Accessibilité et Conformité

Les deux thèmes respectent les directives WCAG 2.1 AA pour l'accessibilité :

**Ratios de Contraste** - Tous les textes ont des ratios de contraste minimum de 4.5:1 (texte normal) ou 3:1 (texte large), garantissant lisibilité pour utilisateurs malvoyants.

**Sans Dépendance de Couleur** - L'information n'est jamais communiquée uniquement par la couleur. Les états (dose prise, omise, en attente) sont également indiqués par des icônes et texte.

**Tailles de Touche Appropriées** - Les éléments interactifs maintiennent des zones de touche minimum de 48x48dp dans les deux modes pour faciliter l'interaction.

### Intégration dans main.dart

Le thème est intégré dans `MaterialApp` avec support complet :

```dart
MaterialApp(
  theme: AppTheme.lightTheme,       // Thème utilisé en mode clair
  darkTheme: AppTheme.darkTheme,    // Thème utilisé en mode sombre
  themeMode: themeProvider.themeMode, // Mode actuel (system/light/dark)
  // ...
)
```

Cette configuration permet à Flutter de basculer automatiquement entre les thèmes selon `themeMode`, et de réagir automatiquement aux changements du système lorsque `themeMode` est `ThemeMode.system`.

### Avantages pour l'Utilisateur

**Confort Visuel** - Les utilisateurs peuvent choisir le mode qui réduit leur fatigue oculaire selon l'environnement d'éclairage et leurs préférences personnelles.

**Flexibilité** - Le mode System permet un changement automatique entre jour et nuit, tandis que les modes forcés offrent cohérence constante.

**Économie d'Énergie** - Le mode sombre prolonge significativement la durée de batterie sur smartphones modernes avec écrans OLED.

**Accessibilité** - Les utilisateurs avec sensibilité à la lumière ou conditions oculaires peuvent utiliser le mode qui leur convient le mieux, améliorant l'utilisabilité de l'application.

**Modernité** - Le support de thème sombre est une attente moderne des utilisateurs, et son absence peut faire paraître une application datée.

---

## 17. Interface Accessible et Utilisable

### Material Design 3

MedicApp est construite en suivant strictement les directives de Material Design 3 (Material You) de Google, le système de design le plus moderne et accessible pour les applications Android. Cette décision architecturale garantit plusieurs avantages :

**Cohérence Visuelle** - Tous les éléments d'interface (boutons, cartes, dialogues, champs de texte) suivent des schémas visuels standard que les utilisateurs d'Android reconnaissent instinctivement. Pas besoin d'apprendre une interface complètement nouvelle.

**Thématisation Dynamique** - Material 3 permet à l'application d'adopter les couleurs du système de l'utilisateur (si sur Android 12+), créant une expérience visuelle cohésive avec le reste de l'appareil. Les couleurs d'accentuation, fonds et surfaces s'adaptent automatiquement.

**Composants Accessibles Natifs** - Tous les contrôles de Material 3 sont conçus dès le départ pour être accessibles, avec des zones tactiles généreuses (minimum 48x48dp), des contrastes adéquats, et support pour les lecteurs d'écran.

### Typographie Agrandie et Lisible

L'application utilise une hiérarchie typographique claire avec des tailles de police généreuses qui facilitent la lecture sans fatigue visuelle :

**Titres d'Écran** - Taille grande (24-28sp) pour orientation claire de où se trouve l'utilisateur.

**Noms de Médicaments** - Taille mise en évidence (18-20sp) en gras pour identification rapide.

**Information Secondaire** - Taille moyenne (14-16sp) pour détails complémentaires comme horaires et quantités.

**Texte d'Aide** - Taille standard (14sp) pour instructions et descriptions.

L'interligne est généreux (1,5x) pour éviter que les lignes se confondent, particulièrement important pour les utilisateurs ayant des problèmes de vision. Les polices utilisées sont sans empattement (sans-serif) qui ont démontré une meilleure lisibilité sur écrans numériques.

### Haut Contraste Visuel

MedicApp implémente une palette de couleurs avec des ratios de contraste qui respectent et dépassent les directives WCAG 2.1 AA pour l'accessibilité. Le contraste minimum entre texte et fond est de 4,5:1 pour le texte normal et 3:1 pour le texte grand, assurant la lisibilité même dans des conditions d'éclairage sous-optimales.

Les couleurs sont utilisées de manière fonctionnelle en plus d'esthétique : rouge pour les alertes de stock bas ou jeûne actif, vert pour les confirmations et stock suffisant, ambre pour les avertissements intermédiaires, bleu pour l'information neutre. Mais crucialement, la couleur n'est jamais le seul indicateur : elle est toujours complétée par des icônes, texte ou schémas.

### Navigation Intuitive et Prévisible

La structure de navigation de MedicApp suit des principes de simplicité et prévisibilité :

**Écran Principal Central** - La vue des médicaments du jour est le hub principal depuis lequel tout est accessible en maximum 2 touches.

**Navigation par Onglets** - La barre inférieure avec 3 onglets (Médicaments, Armoire, Historique) permet un changement instantané entre les vues principales sans animations confuses.

**Boutons d'Action Flottants** - Les actions primaires (ajouter médicament, filtrer historique) se réalisent via des boutons flottants (FAB) en position cohérente, faciles à atteindre avec le pouce.

**Breadcrumbs et Bouton Retour** - Il est toujours clair dans quel écran se trouve l'utilisateur et comment revenir en arrière. Le bouton de retour est toujours dans la position supérieure gauche standard.

### Retour Visuel et Tactile

Chaque interaction produit un retour immédiat : les boutons affichent un effet "ripple" lorsqu'ils sont pressés, les actions réussies sont confirmées avec des snackbars verts qui apparaissent brièvement, les erreurs sont indiquées avec des dialogues rouges explicatifs, et les processus longs (comme exporter la base de données) affichent des indicateurs de progression animés.

Ce retour constant assure que l'utilisateur sache toujours que son action a été enregistrée et que le système répond, réduisant l'anxiété typique des applications médicales où une erreur pourrait avoir des conséquences importantes.

### Design pour Usage à Une Main

Reconnaissant que les utilisateurs manient fréquemment des médicaments d'une main (tout en tenant le flacon avec l'autre), MedicApp optimise l'ergonomie pour usage à une main :

- Éléments interactifs principaux dans la moitié inférieure de l'écran
- Boutons d'action flottante dans le coin inférieur droit, atteignable avec le pouce
- Évitement de menus dans les coins supérieurs qui nécessitent de réajuster la prise
- Gestes de glissement horizontal (plus confortables que verticaux) pour navigation temporelle

Cette considération ergonomique réduit la fatigue physique et rend l'application plus confortable à utiliser dans des situations réelles de médication, qui se produisent souvent debout ou en mouvement.

---

## 18. Widget d'Écran d'Accueil (Android)

### Vue Rapide des Doses Quotidiennes

MedicApp inclut un widget natif Android pour l'écran d'accueil qui permet de visualiser les doses programmées du jour actuel sans ouvrir l'application. Ce widget fournit des informations essentielles d'un coup d'œil, idéal pour les utilisateurs qui ont besoin d'un rappel visuel constant de leur médication.

### Caractéristiques du Widget

**Taille 2x2** : Le widget occupe un espace de 2x2 cellules sur l'écran d'accueil (environ 146x146dp), assez compact pour ne pas prendre trop de place mais avec des informations clairement lisibles.

**Liste des Doses du Jour** : Affiche toutes les doses programmées pour le jour actuel, incluant :
- Nom du médicament
- Heure programmée de chaque dose
- État visuel (en attente, prise ou sautée)

**Filtrage Intelligent** : Le widget affiche uniquement les médicaments dont le type de durée correspond au jour actuel (`durationType`), excluant automatiquement les médicaments "selon besoin" (`asNeeded`). Cela assure que seules les doses réellement programmées pour aujourd'hui sont affichées.

**Indicateurs d'État Visuels** :
- **Cercle vert rempli avec coche (✓)** : Dose prise - le texte s'affiche à 70% d'opacité
- **Cercle vert vide (○)** : Dose en attente - le texte s'affiche à 100% d'opacité
- **Cercle gris pointillé (◌)** : Dose sautée - le texte s'affiche à 50% d'opacité

**Compteur de Progression** : L'en-tête du widget affiche un compteur "X/Y" indiquant combien de doses ont été prises sur le total programmé pour la journée.

**Interactivité Complète** : Le widget est entièrement interactif - toucher n'importe quelle partie (en-tête, élément de liste ou espace vide) ouvre l'application principale MedicApp, permettant une gestion complète des doses.

### Intégration avec l'Application

**Mise à Jour Automatique** : Le widget se met à jour automatiquement chaque fois que :
- Une dose est enregistrée (prise, sautée ou extra)
- Un médicament est ajouté ou modifié
- Le jour change (à minuit)

**Communication Flutter-Android** : L'intégration utilise un MethodChannel (`com.medicapp.medicapp/widget`) qui permet à l'application Flutter de notifier le widget natif lorsque les données changent.

**Lecture Directe de Base de Données** : Le widget accède directement à la base de données SQLite de l'application pour obtenir les données de médicaments, assurant des informations actualisées même lorsque l'app n'est pas en cours d'exécution.

### Thème Visuel DeepEmerald

Le widget utilise la palette de couleurs DeepEmerald, le thème par défaut de MedicApp :

- **Fond** : Vert foncé profond (#1E2623) avec 90% d'opacité
- **Icônes et accents** : Vert clair (#81C784)
- **Texte** : Blanc avec différents niveaux d'opacité selon l'état
- **Diviseurs** : Vert clair avec transparence

### Limitations Techniques

**Android uniquement** : Le widget est une fonctionnalité native Android et n'est pas disponible sur iOS, web ou autres plateformes.

**Personne par défaut** : Le widget affiche les doses de la personne configurée comme par défaut dans l'application.

### Fichiers Associés

- `android/app/src/main/kotlin/.../MedicationWidgetProvider.kt` - Fournisseur principal du widget
- `android/app/src/main/kotlin/.../MedicationWidgetService.kt` - Service pour la ListView du widget
- `android/app/src/main/res/layout/medication_widget_layout.xml` - Layout principal
- `lib/services/widget_service.dart` - Service Flutter pour communication avec le widget

---

## 19. Optimisation pour Tablettes

### Design Responsive Adaptatif

MedicApp est optimisée pour fonctionner parfaitement sur les tablettes et les grands écrans, adaptant automatiquement son interface selon la taille de l'appareil.

### Système de Points de Rupture

L'application utilise un système de breakpoints basé sur les directives Material Design:

- **Téléphone**: < 600dp - Layout à une colonne, navigation inférieure
- **Tablette**: 600-840dp - Layout adaptatif, NavigationRail latérale
- **Bureau**: > 840dp - Layout optimisé avec contenu centré

### Fonctionnalités Responsives

**Navigation Adaptative**: Sur les tablettes et en mode paysage, l'application affiche une NavigationRail latérale au lieu de la barre de navigation inférieure.

**Contenu Centré**: Sur les grands écrans, les listes de médicaments, l'historique et les paramètres sont centrés avec une largeur maximale de 700-900px pour améliorer la lisibilité.

**Grilles Adaptatives**: L'armoire à pharmacie et l'historique des doses utilisent des layouts de grille qui affichent 2-3 colonnes sur les tablettes.

**Dialogues Optimisés**: Les dialogues et formulaires ont une largeur maximale de 400-500px sur les tablettes.

### Fichiers Associés

- `lib/utils/responsive_helper.dart` - Utilitaires de design responsive
- `lib/widgets/responsive/adaptive_grid.dart` - Widgets adaptatifs

---

## Intégration des Fonctionnalités

Toutes ces caractéristiques ne fonctionnent pas de manière isolée, mais sont profondément intégrées pour créer une expérience cohésive. Par exemple :

- Un médicament ajouté dans le flux de 8 étapes est automatiquement assigné aux personnes, génère des notifications selon son type de fréquence, apparaît dans l'armoire à pharmacie ordonnée alphabétiquement, enregistre ses doses dans l'historique, et met à jour les statistiques d'adhérence.

- Les notifications respectent la configuration de jeûne, mettant à jour automatiquement le compte à rebours visuel lorsqu'une dose avec jeûne postérieur est enregistrée.

- Le contrôle de stock multi-personnes calcule correctement les jours restants en considérant les doses de toutes les personnes assignées, et alerte lorsque le seuil est atteint indépendamment de qui prend le médicament.

- Le changement de langue met à jour instantanément toutes les notifications en attente, les écrans visibles, et les messages du système, maintenant une cohérence totale.

Cette intégration profonde est ce qui transforme MedicApp d'une simple liste de médicaments en un système complet de gestion thérapeutique familiale.

---

## Références à Documentation Additionnelle

Pour des informations plus détaillées sur des aspects spécifiques :

- **Architecture Multi-Personnes** : Voir documentation de base de données (tables `persons`, `medications`, `person_medications`)
- **Système de Notifications** : Voir code source dans `lib/services/notification_service.dart`
- **Modèle de Données** : Voir modèles dans `lib/models/` (spécialement `medication.dart`, `person.dart`, `person_medication.dart`)
- **Localisation** : Voir fichiers `.arb` dans `lib/l10n/` pour chaque langue
- **Tests** : Voir suite de tests dans `test/` avec 432+ tests qui valident toutes ces fonctionnalités

---

Cette documentation reflète l'état actuel de MedicApp dans sa version 1.0.0, une application mature et complète pour gestion de médicaments familiaux avec plus de 75% de couverture de tests et support complet pour 8 langues.
