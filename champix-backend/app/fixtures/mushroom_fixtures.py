from app.controllers import mushroom_controller
from app.models.mushroom_model import MushroomCreate
from app.database import get_db

def load_mushroom_fixtures():
    db = next(get_db())
    fixtures = [
        MushroomCreate(
            name="Girolle",
            description="La girolle est un champignon comestible très apprécié pour sa saveur fruitée et sa texture ferme.",
            edible=True,
            country="France",
            imageurl="https://www.jardiner-malin.fr/wp-content/uploads/2022/04/Girolle.jpg"
        ),
        MushroomCreate(
            name="Amanite phalloïde",
            description="L'amanite phalloïde est un champignon mortel très toxique, souvent confondu avec des espèces comestibles.",
            edible=False,
            country="Europe",
            imageurl="https://upload.wikimedia.org/wikipedia/commons/5/54/Amanita_phalloides_1.JPG"
        ),
        MushroomCreate(
            name="Cèpe de Bordeaux",
            description="Le cèpe de Bordeaux est un des champignons les plus recherchés, au goût délicat et à la chair ferme.",
            edible=True,
            country="France",
            imageurl="https://www.monjardinmamaison.fr/wp-content/uploads/2022/10/cepe.jpg"
        ),
        MushroomCreate(
            name="Coprin chevelu",
            description="Comestible jeune, le coprin chevelu devient impropre à la consommation en vieillissant car il se liquéfie.",
            edible=True,
            country="Europe",
            imageurl="https://upload.wikimedia.org/wikipedia/commons/e/e7/Coprinus_comatus_1.jpg"
        ),
        MushroomCreate(
            name="Amanite tue-mouches",
            description="Champignon toxique reconnaissable à son chapeau rouge à points blancs. Très dangereux.",
            edible=False,
            country="Europe",
            imageurl="https://upload.wikimedia.org/wikipedia/commons/5/5a/Amanita_muscaria_3_vliegenzwammen_op_rij.jpg"
        ),
    ]

    for mushroom in fixtures:
        mushroom_controller.create_mushroom(mushroom, db)
