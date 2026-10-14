// A Simile model, for a page with widgets embedded in it (see src/page.js).
// Predator-prey, as re-cast in Stage 3 of the Predator-prey tutorial, with
// each constant in its equations — the starting populations included — drawn
// out as a parameter: a variable that nothing influences, given a range
// (min, max) for a slider.
Simile.model('predator-prey', {
  "id": "predator-prey",
  "name": "Predator-prey",
  "format": 3,
  "schema": "simile-v1",
  "enums": {},
  "submodels": {},
  "nodes": {
    "node1": {
      "type": "stock",
      "parent": null,
      "label": "rabbits",
      "props": {
        "initial": "initial_rabbits",
        "units": ""
      }
    },
    "node2": {
      "type": "stock",
      "parent": null,
      "label": "foxes",
      "props": {
        "initial": "initial_foxes",
        "units": ""
      }
    },
    "node3": {
      "type": "cloud",
      "parent": null,
      "label": "",
      "props": {}
    },
    "node4": {
      "type": "valve",
      "parent": null,
      "label": "rabbit_repro",
      "props": {
        "rate": "rabbit_birth_rate*rabbits",
        "units": ""
      }
    },
    "node5": {
      "type": "cloud",
      "parent": null,
      "label": "",
      "props": {}
    },
    "node6": {
      "type": "valve",
      "parent": null,
      "label": "predation",
      "props": {
        "rate": "eaten_per_fox*foxes",
        "units": ""
      }
    },
    "node7": {
      "type": "cloud",
      "parent": null,
      "label": "",
      "props": {}
    },
    "node8": {
      "type": "valve",
      "parent": null,
      "label": "fox_repro",
      "props": {
        "rate": "rfox*foxes",
        "units": ""
      }
    },
    "node9": {
      "type": "cloud",
      "parent": null,
      "label": "",
      "props": {}
    },
    "node10": {
      "type": "valve",
      "parent": null,
      "label": "fox_mortality",
      "props": {
        "rate": "fox_death_rate*foxes",
        "units": ""
      }
    },
    "node11": {
      "type": "variable",
      "parent": null,
      "label": "eaten_per_fox",
      "props": {
        "value": "attack_rate*rabbits",
        "units": ""
      }
    },
    "node12": {
      "type": "variable",
      "parent": null,
      "label": "rfox",
      "props": {
        "value": "conversion_rate*eaten_per_fox",
        "units": ""
      }
    },
    "node13": {
      "type": "variable",
      "parent": null,
      "label": "rabbit_birth_rate",
      "props": {
        "value": "0.5",
        "min": "0.25",
        "max": "1"
      }
    },
    "node14": {
      "type": "variable",
      "parent": null,
      "label": "attack_rate",
      "props": {
        "value": "0.01",
        "min": "0.005",
        "max": "0.02"
      }
    },
    "node15": {
      "type": "variable",
      "parent": null,
      "label": "conversion_rate",
      "props": {
        "value": "0.01",
        "min": "0.005",
        "max": "0.02"
      }
    },
    "node16": {
      "type": "variable",
      "parent": null,
      "label": "fox_death_rate",
      "props": {
        "value": "0.2",
        "min": "0.1",
        "max": "0.4"
      }
    },
    "node17": {
      "type": "variable",
      "parent": null,
      "label": "initial_rabbits",
      "props": {
        "value": "5000",
        "min": "2500",
        "max": "10000"
      }
    },
    "node18": {
      "type": "variable",
      "parent": null,
      "label": "initial_foxes",
      "props": {
        "value": "45",
        "min": "22.5",
        "max": "90"
      }
    }
  },
  "arcs": {
    "arc1": {
      "type": "flow",
      "from": "node3",
      "to": "node1",
      "valve": "node4",
      "props": {}
    },
    "arc2": {
      "type": "flow",
      "from": "node1",
      "to": "node5",
      "valve": "node6",
      "props": {}
    },
    "arc3": {
      "type": "influence",
      "from": "node1",
      "to": "node4",
      "props": {},
      "alias": "rabbits"
    },
    "arc5": {
      "type": "influence",
      "from": "node2",
      "to": "node6",
      "props": {},
      "alias": "foxes"
    },
    "arc6": {
      "type": "flow",
      "from": "node7",
      "to": "node2",
      "valve": "node8",
      "props": {}
    },
    "arc7": {
      "type": "flow",
      "from": "node2",
      "to": "node9",
      "valve": "node10",
      "props": {}
    },
    "arc9": {
      "type": "influence",
      "from": "node2",
      "to": "node10",
      "props": {},
      "alias": "foxes"
    },
    "arc10": {
      "type": "influence",
      "from": "node1",
      "to": "node11",
      "props": {},
      "alias": "rabbits"
    },
    "arc11": {
      "type": "influence",
      "from": "node11",
      "to": "node12",
      "props": {},
      "alias": "eaten_per_fox"
    },
    "arc12": {
      "type": "influence",
      "from": "node11",
      "to": "node6",
      "props": {},
      "alias": "eaten_per_fox"
    },
    "arc13": {
      "type": "influence",
      "from": "node12",
      "to": "node8",
      "props": {},
      "alias": "rfox"
    },
    "arc14": {
      "type": "influence",
      "from": "node2",
      "to": "node8",
      "props": {},
      "alias": "foxes"
    },
    "arc15": {
      "type": "influence",
      "from": "node13",
      "to": "node4",
      "props": {},
      "alias": "rabbit_birth_rate"
    },
    "arc16": {
      "type": "influence",
      "from": "node14",
      "to": "node11",
      "props": {},
      "alias": "attack_rate"
    },
    "arc17": {
      "type": "influence",
      "from": "node15",
      "to": "node12",
      "props": {},
      "alias": "conversion_rate"
    },
    "arc18": {
      "type": "influence",
      "from": "node16",
      "to": "node10",
      "props": {},
      "alias": "fox_death_rate"
    },
    "arc19": {
      "type": "influence",
      "from": "node17",
      "to": "node1",
      "props": {},
      "alias": "initial_rabbits"
    },
    "arc20": {
      "type": "influence",
      "from": "node18",
      "to": "node2",
      "props": {},
      "alias": "initial_foxes"
    }
  },
  "layout": {
    "node1": {
      "x": 175,
      "y": 60.55555555555556
    },
    "node2": {
      "x": 175,
      "y": 177.22222222222223
    },
    "node3": {
      "x": 80.55555555555556,
      "y": 60.55555555555556
    },
    "node5": {
      "x": 269.44444444444446,
      "y": 60.55555555555556
    },
    "node7": {
      "x": 80.55555555555556,
      "y": 177.22222222222223
    },
    "node9": {
      "x": 269.44444444444446,
      "y": 177.22222222222223
    },
    "node11": {
      "x": 252.77777777777777,
      "y": 116.11111111111111
    },
    "node12": {
      "x": 91.66666666666667,
      "y": 116.11111111111111
    },
    "node13": {
      "x": 128,
      "y": 22
    },
    "node14": {
      "x": 312,
      "y": 116
    },
    "node15": {
      "x": 32,
      "y": 116
    },
    "node16": {
      "x": 222,
      "y": 238
    },
    "node17": {
      "x": 240,
      "y": 22
    },
    "node18": {
      "x": 110,
      "y": 238
    }
  }
}, {"runLength": 50, "timeStep": "0.1", "logEach": 1});
