# Dictionnaire de données (UCI Bank Marketing, bank-full.csv)

Source : Moro, Cortez & Rita (2014). Table brute : `bank_raw` ; vue nettoyée : `bank_clean` ;
vue segmentée : `bank_segments`.

## Variables

| Variable | Description | Rôle dans le projet |
|---|---|---|
| row_id | Rang de la ligne dans le fichier (ordre chronologique) | Découpage temporel train/test |
| age | Âge du client | Segmentation, modèle |
| job, marital, education | Profil socio-démographique | Segmentation, modèle |
| credit_default | Défaut de crédit | Modèle |
| balance | Solde annuel moyen (€) | **Montant** du RFM, modèle |
| housing, loan | Crédit immobilier / crédit conso | Équipement, modèle |
| contact | Canal (cellular / telephone / inconnu) | Analyse de performance ; la modalité « inconnu » marque la période mai-juin 2008 : testée en sensibilité dans le modèle |
| contact_day, contact_month | Date du dernier contact | Analyse temporelle (confondue avec la période) ; exclues du modèle v1 |
| duration | Durée de l'appel (s) | **Exclue du modèle** : connue après l'appel |
| campaign | Nb de contacts pendant cette campagne | Analyse de pression commerciale ; **exclue du modèle** |
| days_since_last_contact | Jours depuis la campagne précédente (NULL = jamais) | **Récence** du RFM, modèle |
| previously_contacted | 1 si contacté lors d'une campagne précédente | Cycle de vie, modèle |
| previous | Nb de contacts avant cette campagne | **Fréquence**, modèle |
| poutcome | Résultat de la campagne précédente | Cycle de vie, modèle |
| converted | 1 si souscription du dépôt à terme | **Cible** |

## Segments (vue `bank_segments`)

| Segment | Définition |
|---|---|
| 1 Ancien souscripteur | poutcome = success |
| 2 Recontacté récent (sans succès) | contacté avant, récence ≤ médiane |
| 3 Recontacté ancien (sans succès) | contacté avant, récence > médiane |
| 4 Nouveau, solde élevé | jamais contacté, balance ≥ Q3 |
| 5 Nouveau, solde moyen | jamais contacté, Q1 ≤ balance < Q3 |
| 6 Nouveau, solde faible | jamais contacté, balance < Q1 |

`sous_equipe` : proxy (ni crédit immobilier ni conso), non lié à l'équipement réel.

## Qualité des données

- **Volumétrie** : 45 211 lignes, 5 289 souscriptions (11,7 %).
- **Doublons** : aucun. **Cohérence pdays / previous** : aucune incohérence.
- **poutcome** : 81,7 % `unknown` (36 959 lignes), essentiellement des clients jamais contactés
  lors d'une campagne précédente : absence d'information, pas anomalie. Traité comme catégorie
  à part. Répartition : failure 10,8 %, other 4,1 %, success 3,3 %.
- **contact** : 28,8 % `unknown`, dont 96 % (12 507 sur 13 020) en mai-juin, au début de la
  collecte. Conservé comme catégorie ; sert de marqueur de période, pas de canal.
- **education** : 4,1 % `unknown` ; **job** : 0,6 % `unknown` (NULL dans `bank_clean`).
- **balance** : min −8 019, Q1 72, médiane 448, Q3 1 428, max 102 127. Distribution très
  asymétrique : segmentation par quartiles, valeurs extrêmes limitées pour le modèle.
  3 766 soldes négatifs (8,3 %) = découverts, conservés.
- **Dérive temporelle** : données ordonnées chronologiquement (mai 2008 → nov. 2010). Le taux
  de conversion passe d'environ 3 % (début) à 47 % (dernier décile) : 5,8 % sur les 70 %
  premières lignes, 25,4 % sur les 30 % dernières. Les volumes mensuels sont très inégaux
  (mai = 30,4 % des contacts ; décembre, mars, septembre, octobre < 800 lignes chacun, presque
  tous en fin de fichier). Toute comparaison entre mois, canaux ou segments est donc
  partiellement confondue avec la période.
  - **Composition** : les clients déjà contactés représentent 6,5 % de la période d'entraînement
  contre 45,7 % de la période de test ; 95 % des anciens souscripteurs sont dans la période de test.