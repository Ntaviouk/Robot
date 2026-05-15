import random
from jsonschema import validate, ValidationError


class VideoGamesLib:

    def generate_random_game_payload(self):
        game_id = random.randint(1000, 9999)
        return {
            "id": game_id,
            "name": f"AutoTest Game {game_id}",
            "releaseDate": "2024-05-14",
            "reviewScore": random.randint(10, 100),
            "category": "Action",
            "rating": "Mature"
        }

    def validate_game_schema(self, response_json):
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
        except ValidationError as e:
            raise AssertionError(f"Помилка валідації JSON Schema: {e.message}")