# Notes d'analyse (résultats intermédiaires)

Lecture : corrélations observées sur données historiques ; pas d'effet causal.

## Lift par segment : brut et ajusté à la période

| Segment | Lift brut | Lift ajusté |
|---|---|---|
| 1 Ancien souscripteur | 5,53 | 1,69 |
| 2 Recontacté récent | 1,51 | 0,77 |
| 3 Recontacté ancien | 0,92 | 0,59 |
| 4 Nouveau, solde élevé | 1,07 | 1,22 |
| 5 Nouveau, solde moyen | 0,79 | 1,01 |
| 6 Nouveau, solde faible | 0,51 | 0,78 |

Référence de l'ajustement : taux moyen du décile chronologique du contact.

- Le gradient du solde chez les nouveaux clients est stable dans les deux périodes : résultat robuste.
- Anciens souscripteurs : meilleur segment, mais le lift brut mélange segment et période.
  Le 1,69 ajusté est probablement sous-estimé (ces clients pèsent dans le taux de référence) ;
  2,65 sur la seule période de test. À présenter comme une fourchette.
- Recontactés sans succès : pas de sur-performance une fois la période prise en compte.

## Backtest de la règle de ciblage

Règle : 10 000 contacts, segment 1, puis 4 par solde décroissant, puis 5.
2 048 souscriptions observées contre 1 447 attendues pour un tirage à répartition temporelle
identique : lift ajusté ≈ 1,4. Mesure faite dans l'échantillon (règle choisie sur les mêmes
données) : borne optimiste. L'évaluation hors échantillon est celle du modèle (notebook 02).

## Analyse post-campagne (à lire avec la dérive temporelle)

- Pression commerciale : conversion de 14,6 % (1 contact) à 5,8 % (6 et plus) ; en partie
  mécanique (un client qui accepte n'est plus rappelé). Piste : tester un plafond de contacts.
- Mois et canal : écarts largement dus à la période ; aucune recommandation « cibler tel mois ».