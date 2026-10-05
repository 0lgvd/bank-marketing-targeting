# Dictionnaire de données (UCI Bank Marketing, bank-full.csv)

Source : Moro, Cortez & Rita (2014). Table brute : `bank_raw` ; vue nettoyée : `bank_clean`.

| Variable | Description | Rôle dans le projet |
|---|---|---|
| row_id | Rang de la ligne dans le fichier (ordre chronologique) | Découpage temporel train/test |
| age | Âge du client | Segmentation, modèle |
| job, marital, education | Profil socio-démographique | Segmentation, modèle |
| credit_default | Défaut de crédit | Modèle |
| balance | Solde annuel moyen (€) | **Montant** du RFM, modèle |
| housing, loan | Crédit immobilier / crédit conso | Équipement, modèle |
| contact | Canal (cellular / telephone) | Analyse de performance, modèle |
| contact_day, contact_month | Date du dernier contact | Analyse saisonnière |
| duration | Durée de l'appel (s) | **Exclue du modèle** : connue après l'appel |
| campaign | Nb de contacts pendant cette campagne | Analyse de pression commerciale ; **exclue du modèle** |
| days_since_last_contact | Jours depuis la campagne précédente (NULL = jamais) | **Récence** du RFM, modèle |
| previously_contacted | 1 si contacté lors d'une campagne précédente | Cycle de vie, modèle |
| previous | Nb de contacts avant cette campagne | **Fréquence** du RFM, modèle |
| poutcome | Résultat de la campagne précédente | Cycle de vie, modèle |
| converted | 1 si souscription du dépôt à terme | **Cible** |

## Qualité des données
- **Volumétrie** : 45 211 lignes, 5 289 souscriptions (11,7 %)
- **Doublons** : aucun. **Cohérence pdays / previous** : aucune incohérence
- **contact** : 28,8 % `unknown`. Conservé comme catégorie « canal inconnu »
- **poutcome** : 81,7 % `unknown` (36 959 lignes), essentiellement des clients jamais contactés lors d'une campagne précédente : absence d'information, pas anomalie. Traité comme catégorie à part. Répartition : failure 10,8 %, other 4,1 %, success 3,3 %
- **education** : 4,1 % `unknown` ; **job** : 0,6 % `unknown` (NULL dans `bank_clean`)
- **balance** : min −8 019, Q1 72, médiane 448, Q3 1 428, max 102 127
  Distribution très asymétrique : segmentation par quartiles, valeurs extrêmes limitées pour le modèle. 3 766 soldes négatifs (8,3 %) = découverts, conservés
- **Saisonnalité** : mai = 30,4 % des contacts ; décembre, mars, septembre et octobre ont moins de 800 lignes chacun : taux de conversion à lire avec leur intervalle de confiance
- **Dérive temporelle** : les données sont ordonnées chronologiquement (mai 2008 → nov. 2010).
  Le taux de conversion passe d'environ 3 % (début) à 47 % (dernier décile). Les 70 %
  premières lignes ≈ 5,8 %, les 30 % dernières ≈ 25,4 %. Toute comparaison entre mois,
  canaux ou segments est donc partiellement confondue avec la période.
- **contact** : 96 % des `unknown` (12 507 / 13 020) datent de mai-juin, au début de la collecte.
  La modalité sert de marqueur de période, pas de canal.