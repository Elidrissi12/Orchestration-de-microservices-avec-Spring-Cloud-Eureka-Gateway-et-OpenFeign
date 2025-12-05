# 🚀 Guide de Démarrage Rapide

## Méthode 1 : Script Automatique (Recommandé)

### Windows PowerShell
```powershell
# Exécuter le script de démarrage
.\start-services.ps1
```

Le script va :
- ✅ Vérifier Java et Maven
- ✅ Démarrer Eureka Server
- ✅ Démarrer Service Client
- ✅ Démarrer Service Voiture  
- ✅ Démarrer Gateway
- ✅ Ouvrir 4 fenêtres de terminal

**Note** : Fermez les fenêtres pour arrêter les services.

## Méthode 2 : Démarrage Manuel

### Étape 1 : Eureka Server
```bash
cd EurekaServer
mvn spring-boot:run
```
**Attendre** : `Started EurekaServerApplication`
**Vérifier** : http://localhost:8761

### Étape 2 : Service Client
```bash
cd Client
mvn spring-boot:run
```
**Attendre** : `Started ClientApplication`

### Étape 3 : Service Voiture
```bash
cd Voiture
mvn spring-boot:run
```
**Attendre** : `Started VoitureApplication`

### Étape 4 : Gateway
```bash
cd GateWay
mvn spring-boot:run
```
**Attendre** : `Started GateWayApplication`

## 🧪 Tests Rapides

### Test 1 : Vérifier Eureka
Ouvrez : http://localhost:8761
Vous devriez voir 3 services enregistrés.

### Test 2 : Via Gateway
```bash
# Liste des clients
curl http://localhost:8888/clients

# Liste des voitures
curl http://localhost:8888/voitures
```

### Test 3 : Script de Test Automatique
```powershell
.\test-endpoints.ps1
```

## 📋 Checklist de Vérification

- [ ] Eureka Server démarré (port 8761)
- [ ] Service Client démarré (port 8088)
- [ ] Service Voiture démarré (port 8089)
- [ ] Gateway démarré (port 8888)
- [ ] Services visibles dans Eureka Dashboard
- [ ] Test GET /clients fonctionne
- [ ] Test GET /voitures fonctionne

## ⚠️ Problèmes Fréquents

**Port déjà utilisé** :
```bash
# Windows : Trouver le processus utilisant le port
netstat -ano | findstr :8088
# Tuer le processus (remplacer PID)
taskkill /PID <PID> /F
```

**Service ne démarre pas** :
- Vérifiez que Eureka Server est démarré en premier
- Vérifiez les logs pour les erreurs
- Vérifiez que Java 17 est installé

**Service non visible dans Eureka** :
- Attendez 30 secondes après le démarrage
- Vérifiez la configuration dans application.properties
- Vérifiez que `@EnableDiscoveryClient` est présent

---

Pour plus de détails, consultez le [README.md](README.md)

