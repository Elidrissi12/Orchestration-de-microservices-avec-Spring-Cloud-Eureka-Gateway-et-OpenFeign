# TP-19 : Orchestration de Microservices avec Spring Cloud

## 📋 Prérequis

- ✅ Java 17 (installé)
- ✅ Maven 3.9+ (installé)
- ✅ IDE (IntelliJ IDEA, Eclipse, VS Code) ou terminal

## 🏗️ Architecture du Projet

Le projet contient 4 microservices :

1. **EurekaServer** (Port 8761) - Serveur de découverte de services
2. **Service Client** (Port 8088) - Gestion des clients
3. **Service Voiture** (Port 8089) - Gestion des voitures
4. **Gateway** (Port 8888) - API Gateway

## 🚀 Ordre de Démarrage

**IMPORTANT** : Démarrez les services dans cet ordre :

1. **EurekaServer** (doit démarrer en premier)
2. **Service Client**
3. **Service Voiture**
4. **Gateway** (doit démarrer en dernier)

## 📝 Instructions de Démarrage

### Option 1 : Via IDE (IntelliJ IDEA / Eclipse)

1. Ouvrez chaque module dans votre IDE
2. Trouvez la classe principale de chaque service :
   - `EurekaServerApplication.java`
   - `ClientApplication.java`
   - `VoitureApplication.java`
   - `GateWayApplication.java`
3. Exécutez chaque classe dans l'ordre indiqué ci-dessus
4. Attendez que chaque service affiche "Started" dans les logs

### Option 2 : Via Terminal (Maven)

Ouvrez **4 terminaux différents** et exécutez :

#### Terminal 1 - EurekaServer
```bash
cd EurekaServer
mvn spring-boot:run
```
Attendez : `Started EurekaServerApplication`

#### Terminal 2 - Service Client
```bash
cd Client
mvn spring-boot:run
```
Attendez : `Started ClientApplication`

#### Terminal 3 - Service Voiture
```bash
cd Voiture
mvn spring-boot:run
```
Attendez : `Started VoitureApplication`

#### Terminal 4 - Gateway
```bash
cd GateWay
mvn spring-boot:run
```
Attendez : `Started GateWayApplication`

## ✅ Vérification du Démarrage

### 1. Vérifier Eureka Server
Ouvrez votre navigateur et allez sur :
```
http://localhost:8761
```
Vous devriez voir le dashboard Eureka avec les services enregistrés :
- SERVICE-CLIENT
- SERVICE-VOITURE
- Gateway

### 2. Vérifier les Services Individuels

#### Service Client
```bash
# Liste des clients
curl http://localhost:8088/clients

# Client par ID
curl http://localhost:8088/client/1
```

#### Service Voiture
```bash
# Liste des voitures
curl http://localhost:8089/voitures

# Voiture par ID (avec infos client)
curl http://localhost:8089/voitures/1
```

## 🧪 Tests via Gateway

Une fois tous les services démarrés, testez via le Gateway :

### 1. Lister tous les clients
```bash
curl http://localhost:8888/clients
```

**Résultat attendu** :
```json
[
  {"id":1,"nom":"Rabab SELIMANI","age":23.0},
  {"id":2,"nom":"Amal RAMI","age":22.0},
  {"id":3,"nom":"Samir SAFI","age":22.0}
]
```

### 2. Obtenir un client par ID
```bash
curl http://localhost:8888/client/1
```

### 3. Lister toutes les voitures
```bash
curl http://localhost:8888/voitures
```

### 4. Obtenir une voiture par ID (avec infos client)
```bash
curl http://localhost:8888/voitures/1
```

**Résultat attendu** :
```json
{
  "id": 1,
  "marque": "Toyota",
  "matricule": "A 25 333",
  "model": "Corolla",
  "clientId": 1,
  "client": {
    "id": 1,
    "nom": "Rabab SELIMANI",
    "age": 23.0
  }
}
```

### 5. Obtenir les voitures d'un client
```bash
curl http://localhost:8888/voitures/client/1
```

### 6. Créer une nouvelle voiture
```bash
curl -X POST http://localhost:8888/voitures/1 \
  -H "Content-Type: application/json" \
  -d "{\"marque\":\"BMW\",\"matricule\":\"C 12 3456\",\"model\":\"X5\"}"
```

### 7. Mettre à jour une voiture
```bash
curl -X PUT http://localhost:8888/voitures/1 \
  -H "Content-Type: application/json" \
  -d "{\"marque\":\"Mercedes\",\"matricule\":\"D 99 9999\",\"model\":\"C200\"}"
```

## 🧪 Tests avec Postman ou un Navigateur

### Via Postman
1. Créez une nouvelle collection
2. Ajoutez les requêtes ci-dessus
3. Testez chaque endpoint

### Via Navigateur
Pour les requêtes GET uniquement :
- `http://localhost:8888/clients`
- `http://localhost:8888/client/1`
- `http://localhost:8888/voitures`
- `http://localhost:8888/voitures/1`

## 📊 Endpoints Disponibles

### Service Client (Port 8088)
- `GET /clients` - Liste tous les clients
- `GET /client/{id}` - Client par ID

### Service Voiture (Port 8089)
- `GET /voitures` - Liste toutes les voitures
- `GET /voitures/{id}` - Voiture par ID (avec client)
- `GET /voitures/client/{id}` - Voitures d'un client
- `POST /voitures/{clientId}` - Créer une voiture
- `PUT /voitures/{id}` - Mettre à jour une voiture

### Gateway (Port 8888)
Tous les endpoints ci-dessus sont accessibles via le Gateway avec les mêmes chemins.

## 🔍 Vérification de la Communication Inter-Services

Le service Voiture utilise **OpenFeign** pour communiquer avec le service Client.

Pour vérifier :
1. Appelez `GET /voitures/1` via le Gateway
2. La réponse doit contenir les informations complètes du client
3. Vérifiez les logs du service Voiture pour voir l'appel Feign

## ⚠️ Problèmes Courants

### Service ne démarre pas
- Vérifiez que le port n'est pas déjà utilisé
- Vérifiez que Eureka Server est démarré (pour Client et Voiture)
- Vérifiez les logs pour les erreurs

### Erreur "Connection refused"
- Vérifiez que tous les services sont démarrés
- Vérifiez les ports dans les `application.properties`

### Service non visible dans Eureka
- Vérifiez que `@EnableDiscoveryClient` est présent
- Vérifiez la configuration Eureka dans `application.properties`
- Attendez quelques secondes pour l'enregistrement

## 📝 Notes Importantes

- Les bases de données H2 sont en mémoire (données perdues au redémarrage)
- Les données initiales sont chargées au démarrage via `CommandLineRunner`
- Le Gateway utilise des routes statiques dans `application.yml`

## 🎯 Scénario de Test Complet

1. ✅ Démarrer Eureka Server
2. ✅ Vérifier le dashboard Eureka
3. ✅ Démarrer Service Client
4. ✅ Vérifier l'enregistrement dans Eureka
5. ✅ Tester `GET /clients`
6. ✅ Démarrer Service Voiture
7. ✅ Vérifier l'enregistrement dans Eureka
8. ✅ Tester `GET /voitures` (doit appeler Feign pour récupérer les clients)
9. ✅ Démarrer Gateway
10. ✅ Tester tous les endpoints via Gateway
11. ✅ Vérifier la communication inter-services

---

**Bon TP ! 🚀**

