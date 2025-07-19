from app.controllers import mushroom_controller
from app.models.mushroom_model import MushroomCreate
from app.models.mushroom_model import Mushroom
from app.database import get_db

def load_mushroom_fixtures():
    db = next(get_db())
    try:
        if db.query(Mushroom).count() > 0:
            print("Fixtures already loaded, skipping.")
            return

        fixtures = [
            MushroomCreate(
                name="Chanterelle",
                description="The chanterelle is a highly prized edible mushroom known for its fruity flavor and firm texture.",
                edible=True,
                country="France",
                imageurl="http://localhost:8000/images/chanterelle.jpg"
            ),
            MushroomCreate(
                name="Death Cap",
                description="The death cap is a deadly poisonous mushroom often mistaken for edible species.",
                edible=False,
                country="Europe",
                imageurl="http://localhost:8000/images/death-cap.jpg"
            ),
            MushroomCreate(
                name="Porcini",
                description="The porcini is one of the most sought-after mushrooms, with a delicate taste and firm flesh.",
                edible=True,
                country="France",
                imageurl="http://localhost:8000/images/porcini.jpg"
            ),
            MushroomCreate(
                name="Shaggy Ink Cap",
                description="Edible when young, the shaggy ink cap becomes inedible as it liquefies with age.",
                edible=True,
                country="Europe",
                imageurl="http://localhost:8000/images/shaggy-ink-cap.jpg"
            ),
            MushroomCreate(
                name="Fly Agaric",
                description="A toxic mushroom recognizable by its red cap with white spots. Very dangerous.",
                edible=False,
                country="Europe",
                imageurl="http://localhost:8000/images/fly-agaric.jpg"
            ),
            MushroomCreate(
                name="Destroying Angel",
                description="A deadly poisonous white mushroom often confused with edible varieties.",
                edible=False,
                country="North America",
                imageurl="http://localhost:8000/images/destroying-angel.jpg"
            ),
            MushroomCreate(
                name="False Morel",
                description="Toxic mushroom that resembles the edible morel but contains harmful compounds.",
                edible=False,
                country="Europe",
                imageurl="http://localhost:8000/images/false-morel.jpg"
            ),
        ]

        for mushroom in fixtures:
            new_mushroom = Mushroom(**mushroom.model_dump())
            db.add(new_mushroom)

        db.commit()
        print("Fixtures loaded successfully.")

    finally:
        db.close()
