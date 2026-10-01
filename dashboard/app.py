"""Tableau de bord de suivi des ventes Adventure Works (Streamlit)."""

import os

import altair as alt
import pandas as pd
import streamlit as st
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

import queries

COULEUR = "#2a78d6"

st.set_page_config(page_title="Adventure Works - Ventes", page_icon="📊", layout="wide")


@st.cache_resource
def connexion():
    url = URL.create(
        "mssql+pymssql",
        username=os.getenv("DB_USER", "sa"),
        password=os.environ["DB_PASSWORD"],
        host=os.getenv("DB_HOST", "localhost"),
        port=int(os.getenv("DB_PORT", "1433")),
        database=os.getenv("DB_NAME", "AdventureWorks2019"),
    )
    return create_engine(url)


@st.cache_data(ttl=600)
def lire(_requete, nom: str, **params) -> pd.DataFrame:
    # `nom` sert de clé de cache, la requête SQLAlchemy elle-même n'étant pas hachable
    with connexion().connect() as conn:
        return pd.read_sql(_requete, conn, params=params)


def euros(valeur: float) -> str:
    if valeur >= 1_000_000:
        return f"{valeur / 1_000_000:,.1f} M$".replace(",", " ").replace(".", ",")
    return f"{valeur:,.0f} $".replace(",", " ")


def barres(df: pd.DataFrame, categorie: str, titre_categorie: str, infos: list) -> alt.Chart:
    return (
        alt.Chart(df)
        .mark_bar(color=COULEUR, cornerRadiusEnd=4, size=18)
        .encode(
            x=alt.X("ca:Q", title="CA ($)", axis=alt.Axis(format="~s", grid=True)),
            y=alt.Y(f"{categorie}:N", title=None, sort="-x"),
            tooltip=[alt.Tooltip(f"{categorie}:N", title=titre_categorie),
                     alt.Tooltip("ca:Q", title="CA ($)", format=",.0f")] + infos,
        )
        .properties(height=max(160, 30 * len(df)))
    )


# --- Filtres -----------------------------------------------------------------
st.title("📊 Adventure Works - Suivi des ventes")

try:
    annees_dispo = lire(queries.ANNEES, "annees")["annee"].tolist()
    groupes_dispo = lire(queries.GROUPES, "groupes")["groupe"].tolist()
except Exception as erreur:
    st.error(f"Connexion impossible à la base de données : {erreur}")
    st.stop()

col_annees, col_groupe = st.columns([3, 1])
annees = col_annees.multiselect("Années", annees_dispo, default=annees_dispo)
groupe = col_groupe.selectbox("Zone géographique", ["Tous"] + groupes_dispo)

if not annees:
    st.warning("Sélectionnez au moins une année.")
    st.stop()

filtres = {"annees": annees, "groupe": groupe}
st.caption(
    "CA = sous-total des commandes, hors taxes et frais de port. "
    "Les années 2011 (à partir de juin) et 2014 (jusqu'à juin) sont incomplètes."
)

# --- Indicateurs clés ----------------------------------------------------------
ind = lire(queries.INDICATEURS, "indicateurs", **filtres).iloc[0]
ca = float(ind["ca"] or 0)
commandes = int(ind["commandes"] or 0)

k1, k2, k3, k4, k5 = st.columns(5)
k1.metric("Chiffre d'affaires", euros(ca))
k2.metric("Commandes", f"{commandes:,}".replace(",", " "))
k3.metric("Panier moyen", euros(ca / commandes) if commandes else "-")
k4.metric("Clients actifs", f"{int(ind['clients'] or 0):,}".replace(",", " "))
k5.metric("Part des ventes en ligne", f"{float(ind['ca_en_ligne'] or 0) / ca:.0%}" if ca else "-")

# --- Évolution mensuelle -------------------------------------------------------
st.subheader("Évolution mensuelle du chiffre d'affaires")
mensuel = lire(queries.CA_MENSUEL, "mensuel", **filtres)
mensuel["mois"] = pd.to_datetime(mensuel["mois"])
survol = alt.selection_point(fields=["mois"], nearest=True, on="pointerover", empty=False)
base = alt.Chart(mensuel).encode(x=alt.X("mois:T", title=None, axis=alt.Axis(format="%m/%Y")))
ligne = base.mark_line(color=COULEUR, strokeWidth=2).encode(
    y=alt.Y("ca:Q", title="CA ($)", axis=alt.Axis(format="~s"))
)
points = base.mark_point(color=COULEUR, size=80, filled=True).encode(
    y="ca:Q",
    opacity=alt.condition(survol, alt.value(1), alt.value(0)),
    tooltip=[alt.Tooltip("mois:T", title="Mois", format="%m/%Y"),
             alt.Tooltip("ca:Q", title="CA ($)", format=",.0f"),
             alt.Tooltip("commandes:Q", title="Commandes", format=",")],
).add_params(survol)
repere = base.mark_rule(color="#8a8a86", strokeDash=[3, 3]).encode(
    opacity=alt.condition(survol, alt.value(0.6), alt.value(0))
)
st.altair_chart((ligne + repere + points).properties(height=300), width="stretch")

# --- Répartition ---------------------------------------------------------------
gauche, droite = st.columns(2)
with gauche:
    st.subheader("CA par catégorie de produits")
    categories = lire(queries.CA_PAR_CATEGORIE, "categories", **filtres)
    st.altair_chart(
        barres(categories, "categorie", "Catégorie",
               [alt.Tooltip("quantite:Q", title="Quantité vendue", format=",")]),
        width="stretch",
    )
with droite:
    st.subheader("CA par territoire")
    territoires = lire(queries.CA_PAR_TERRITOIRE, "territoires", **filtres)
    st.altair_chart(
        barres(territoires, "territoire", "Territoire",
               [alt.Tooltip("groupe:N", title="Zone"),
                alt.Tooltip("commandes:Q", title="Commandes", format=",")]),
        width="stretch",
    )

gauche, droite = st.columns(2)
with gauche:
    st.subheader("Top 10 des produits")
    produits = lire(queries.TOP_PRODUITS, "produits", **filtres)
    st.altair_chart(
        barres(produits, "produit", "Produit",
               [alt.Tooltip("quantite:Q", title="Quantité vendue", format=",")]),
        width="stretch",
    )
with droite:
    st.subheader("Top 10 des vendeurs")
    vendeurs = lire(queries.TOP_VENDEURS, "vendeurs", **filtres)
    st.altair_chart(
        barres(vendeurs, "vendeur", "Vendeur",
               [alt.Tooltip("commandes:Q", title="Commandes", format=",")]),
        width="stretch",
    )

# --- Données brutes ------------------------------------------------------------
with st.expander("Voir les données sous forme de tableaux"):
    for titre, df in [("Mensuel", mensuel), ("Catégories", categories), ("Territoires", territoires),
                      ("Produits", produits), ("Vendeurs", vendeurs)]:
        st.markdown(f"**{titre}**")
        st.dataframe(df, width="stretch", hide_index=True)
