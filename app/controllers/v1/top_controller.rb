module V1
  class TopController < ApiController
    def index
      # TODO
      response = { "data": {
              "Most Starred": [
              { "name": "primero.primero", "Stars": 10, "id": 123456 },
              { "name": "segundo.segundo", "Stars": 9,  "id": 123456 },
              { "name": "tercero.tercero", "Stars": 8,  "id": 123456 },
              { "name": "cuarto.cuarto",   "Stars": 7,  "id": 123456 },
              { "name": "quinto.quinto",   "Stars": 6,  "id": 123456 },
              { "name": "sexto.sexto",     "Stars": 5,  "id": 123456 },
              { "name": "séptimo.séptimo", "Stars": 4,  "id": 123456 },
              { "name": "octavo.octavo",   "Stars": 3,  "id": 123456 },
              { "name": "noveno.noveno",   "Stars": 2,  "id": 123456 },
              { "name": "décimo.décimo",   "Stars": 1,  "id": 123456 }
      ],

          "Most Watched": [
          { "name": "primero.primero", "Watchers": 10, "id": 123456 },
          { "name": "segundo.segundo", "Watchers": 9,  "id": 123456 },
          { "name": "tercero.tercero", "Watchers": 8,  "id": 123456 },
          { "name": "cuarto.cuarto",   "Watchers": 7,  "id": 123456 },
          { "name": "quinto.quinto",   "Watchers": 6,  "id": 123456 },
          { "name": "sexto.sexto",     "Watchers": 5,  "id": 123456 },
          { "name": "séptimo.séptimo", "Watchers": 4,  "id": 123456 },
          { "name": "octavo.octavo",   "Watchers": 3,  "id": 123456 },
          { "name": "noveno.noveno",   "Watchers": 2,  "id": 123456 },
          { "name": "décimo.décimo",   "Watchers": 1,  "id": 123456 }
      ],
          "Most Downloaded": [
          { "name": "primero.primero", "Downloads": 10, "id": 123456 },
          { "name": "segundo.segundo", "Downloads": 9,  "id": 123456 },
          { "name": "tercero.tercero", "Downloads": 8,  "id": 123456 },
          { "name": "cuarto.cuarto",   "Downloads": 7,  "id": 123456 },
          { "name": "quinto.quinto",   "Downloads": 6,  "id": 123456 },
          { "name": "sexto.sexto",     "Downloads": 5,  "id": 123456 },
          { "name": "séptimo.séptimo", "Downloads": 4,  "id": 123456 },
          { "name": "octavo.octavo",   "Downloads": 3,  "id": 123456 },
          { "name": "noveno.noveno",   "Downloads": 2,  "id": 123456 },
          { "name": "décimo.décimo",   "Downloads": 1,  "id": 123456 }
      ],
       "Top Tags": [
          { "name": "primero.primero", "# Spins": 10, "id": 123456 },
          { "name": "segundo.segundo", "# Spins": 9,  "id": 123456 },
          { "name": "tercero.tercero", "# Spins": 8,  "id": 123456 },
          { "name": "cuarto.cuarto",   "# Spins": 7,  "id": 123456 },
          { "name": "quinto.quinto",   "# Spins": 6,  "id": 123456 },
          { "name": "sexto.sexto",     "# Spins": 5,  "id": 123456 },
          { "name": "séptimo.séptimo", "# Spins": 4,  "id": 123456 },
          { "name": "octavo.octavo",   "# Spins": 3,  "id": 123456 },
          { "name": "noveno.noveno",   "# Spins": 2,  "id": 123456 },
          { "name": "décimo.décimo",   "# Spins": 1,  "id": 123456 }
      ],
      "Top Contributors": [
          { "name": "primero.primero", "# Spins": 10, "id": 123456 },
          { "name": "segundo.segundo", "# Spins": 9,  "id": 123456 },
          { "name": "tercero.tercero", "# Spins": 8,  "id": 123456 },
          { "name": "cuarto.cuarto",   "# Spins": 7,  "id": 123456 },
          { "name": "quinto.quinto",   "# Spins": 6,  "id": 123456 },
          { "name": "sexto.sexto",     "# Spins": 5,  "id": 123456 },
          { "name": "séptimo.séptimo", "# Spins": 4,  "id": 123456 },
          { "name": "octavo.octavo",   "# Spins": 3,  "id": 123456 },
          { "name": "noveno.noveno",   "# Spins": 2,  "id": 123456 },
          { "name": "décimo.décimo",   "# Spins": 1,  "id": 123456 }
      ],
      "Newest": [
          { "name": "primero.primero", "Added on": Date.current, "id": 123456 },
          { "name": "segundo.segundo", "Added on": Date.current, "id": 123456 },
          { "name": "tercero.tercero", "Added on": Date.current, "id": 123456 },
          { "name": "cuarto.cuarto",   "Added on": Date.current, "id": 123456 },
          { "name": "quinto.quinto",   "Added on": Date.current, "id": 123456 },
          { "name": "sexto.sexto",     "Added on": Date.current, "id": 123456 },
          { "name": "séptimo.séptimo", "Added on": Date.current, "id": 123456 },
          { "name": "octavo.octavo",   "Added on": Date.current, "id": 123456 },
          { "name": "noveno.noveno",   "Added on": Date.current, "id": 123456 },
          { "name": "décimo.décimo",   "Added on": Date.current, "id": 123456 }
      ] } }
      return_response response, :ok, {}
    end
  end
end