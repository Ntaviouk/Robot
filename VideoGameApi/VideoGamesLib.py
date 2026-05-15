import random
from typing import Dict, Any
from jsonschema import validate, ValidationError

from robot.api.deco import keyword
from robot.api import logger


class VideoGamesLib:
    @keyword("Generate Random Game Payload")
    def generate_random_game_payload(self) -> Dict[str, Any]:
        game_id = random.randint(1000, 9999)
        payload = {
            "id": game_id,
            "name": f"AutoTest Game {game_id}",
            "releaseDate": "2024-05-14",
            "reviewScore": random.randint(10, 100),
            "category": "Action",
            "rating": "Mature"
        }

        logger.info(f"Generated new data of game: {payload}")

        return payload

    @keyword("Validate Game Schema")
    def validate_game_schema(self, response_json: Dict[str, Any]) -> None:
        schema = {
            "type": "object",
            "properties": {
                "id": {"type": "integer"},
                "name": {"type": "string"},
                "releaseDate": {"type": "string"},
                "reviewScore": {"type": "integer"},
                "category": {"type": "string"},
                "rating": {"type": "string"}
            },
            "required": ["id", "name", "category"]
        }

        try:
            validate(instance=response_json, schema=schema)
            logger.info("JSON Schema successfully validated")

        except ValidationError as e:
            logger.error(f"Error of Validations: {e.message}")
            raise AssertionError(f"Помилка валідації JSON Schema: {e.message}")