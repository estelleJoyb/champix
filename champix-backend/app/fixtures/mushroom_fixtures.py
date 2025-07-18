from app.controllers import mushroom_controller
from app.models.mushroom_model import MushroomCreate
from app.models.mushroom_model import Mushroom
from app.database import get_db

def load_mushroom_fixtures():
    db = next(get_db())
    try:
        if db.query(Mushroom).count() > 0:
            print("Fixtures déjà chargées, skip.")
            return

        fixtures = [
            MushroomCreate(
                name="Girolle",
                description="La girolle est un champignon comestible très apprécié pour sa saveur fruitée et sa texture ferme.",
                edible=True,
                country="France",
                imageurl="http://localhost:8000/images/girolle.jpg"
            ),
            MushroomCreate(
                name="Amanite phalloïde",
                description="L'amanite phalloïde est un champignon mortel très toxique, souvent confondu avec des espèces comestibles.",
                edible=False,
                country="Europe",
                imageurl="http://localhost:8000/images/amanite-phalloide.jpg"
            ),
            MushroomCreate(
                name="Cèpe de Bordeaux",
                description="Le cèpe de Bordeaux est un des champignons les plus recherchés, au goût délicat et à la chair ferme.",
                edible=True,
                country="France",
                imageurl="http://localhost:8000/images/cepe.jpg"
            ),
            MushroomCreate(
                name="Coprin chevelu",
                description="Comestible jeune, le coprin chevelu devient impropre à la consommation en vieillissant car il se liquéfie.",
                edible=True,
                country="Europe",
                imageurl="http://localhost:8000/images/coprin.jpg"
            ),
            MushroomCreate(
                name="Amanite tue-mouches",
                description="Champignon toxique reconnaissable à son chapeau rouge à points blancs. Très dangereux.",
                edible=False,
                country="Europe",
                imageurl="http://localhost:8000/images/amanite-muscaria.jpg"
            ),
        ]

        for mushroom in fixtures:
            new_mushroom = Mushroom(**mushroom.model_dump())
            db.add(new_mushroom)

        db.commit()
        print("Fixtures chargées avec succès.")

    finally:
        db.close()