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

## 5. Contrôle de Stock (Pilulier)

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

## 6. Armoire à Pharmacie

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

## 7. Navigation Temporelle

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

## 8. Notifications Intelligentes

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

---

## 9. Alertes de Stock Faible

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

## 10. Configuration du Jeûne

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

## 11. Historique des Doses

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

## 12. Localisation et Internationalisation

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

## 13. Interface Accessible et Utilisable

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
