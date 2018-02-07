module V1
  class TopController < ApiController
    def index
      # TODO
      response = { "data": {
              "Most Starred": [
              { "name": "primero.primero", "stars": 10, "url": "#" },
              { "name": "segundo.segundo", "stars": 9,  "url": "#" },
              { "name": "tercero.tercero", "stars": 8,  "url": "#" },
              { "name": "cuarto.cuarto",   "stars": 7,  "url": "#" },
              { "name": "quinto.quinto",   "stars": 6,  "url": "#" },
              { "name": "sexto.sexto",     "stars": 5,  "url": "#" },
              { "name": "séptimo.séptimo", "stars": 4,  "url": "#" },
              { "name": "octavo.octavo",   "stars": 3,  "url": "#" },
              { "name": "noveno.noveno",   "stars": 2,  "url": "#" },
              { "name": "décimo.décimo",   "stars": 1,  "url": "#" }
      ],

          "Most Watched": [
          { "name": "primero.primero", "watchers": 10, "url": "#" },
          { "name": "segundo.segundo", "watchers": 9,  "url": "#" },
          { "name": "tercero.tercero", "watchers": 8,  "url": "#" },
          { "name": "cuarto.cuarto",   "watchers": 7,  "url": "#" },
          { "name": "quinto.quinto",   "watchers": 6,  "url": "#" },
          { "name": "sexto.sexto",     "watchers": 5,  "url": "#" },
          { "name": "séptimo.séptimo", "watchers": 4,  "url": "#" },
          { "name": "octavo.octavo",   "watchers": 3,  "url": "#" },
          { "name": "noveno.noveno",   "watchers": 2,  "url": "#" },
          { "name": "décimo.décimo",   "watchers": 1,  "url": "#" }
      ],
          "Most Downloaded": [
          { "name": "primero.primero", "down": 10, "url": "#" },
          { "name": "segundo.segundo", "stars": 9,  "url": "#" },
          { "name": "tercero.tercero", "stars": 8,  "url": "#" },
          { "name": "cuarto.cuarto",   "stars": 7,  "url": "#" },
          { "name": "quinto.quinto",   "stars": 6,  "url": "#" },
          { "name": "sexto.sexto",     "stars": 5,  "url": "#" },
          { "name": "séptimo.séptimo", "stars": 4,  "url": "#" },
          { "name": "octavo.octavo",   "stars": 3,  "url": "#" },
          { "name": "noveno.noveno",   "stars": 2,  "url": "#" },
          { "name": "décimo.décimo",   "stars": 1,  "url": "#" }
      ],
       "Top Tags": [
          { "name": "primero.primero", "# Spins": 10, "url": "#" },
          { "name": "segundo.segundo", "# Spins": 9,  "url": "#" },
          { "name": "tercero.tercero", "# Spins": 8,  "url": "#" },
          { "name": "cuarto.cuarto",   "# Spins": 7,  "url": "#" },
          { "name": "quinto.quinto",   "# Spins": 6,  "url": "#" },
          { "name": "sexto.sexto",     "# Spins": 5,  "url": "#" },
          { "name": "séptimo.séptimo", "# Spins": 4,  "url": "#" },
          { "name": "octavo.octavo",   "# Spins": 3,  "url": "#" },
          { "name": "noveno.noveno",   "# Spins": 2,  "url": "#" },
          { "name": "décimo.décimo",   "# Spins": 1,  "url": "#" }
      ],
      "Top Contributors": [
          { "name": "primero.primero", "# Spins": 10, "url": "#" },
          { "name": "segundo.segundo", "# Spins": 9,  "url": "#" },
          { "name": "tercero.tercero", "# Spins": 8,  "url": "#" },
          { "name": "cuarto.cuarto",   "# Spins": 7,  "url": "#" },
          { "name": "quinto.quinto",   "# Spins": 6,  "url": "#" },
          { "name": "sexto.sexto",     "# Spins": 5,  "url": "#" },
          { "name": "séptimo.séptimo", "# Spins": 4,  "url": "#" },
          { "name": "octavo.octavo",   "# Spins": 3,  "url": "#" },
          { "name": "noveno.noveno",   "# Spins": 2,  "url": "#" },
          { "name": "décimo.décimo",   "# Spins": 1,  "url": "#" }
      ],
      "Newest": [
          { "name": "primero.primero", "Added on": Date.current, "url": "#" },
          { "name": "segundo.segundo", "Added on": Date.current, "url": "#" },
          { "name": "tercero.tercero", "Added on": Date.current, "url": "#" },
          { "name": "cuarto.cuarto",   "Added on": Date.current, "url": "#" },
          { "name": "quinto.quinto",   "Added on": Date.current, "url": "#" },
          { "name": "sexto.sexto",     "Added on": Date.current, "url": "#" },
          { "name": "séptimo.séptimo", "Added on": Date.current, "url": "#" },
          { "name": "octavo.octavo",   "Added on": Date.current, "url": "#" },
          { "name": "noveno.noveno",   "Added on": Date.current, "url": "#" },
          { "name": "décimo.décimo",   "Added on": Date.current, "url": "#" }
      ] } }
      return_response response, :ok, {}
    end
  end
end