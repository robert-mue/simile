// A Simile model, for a page with widgets embedded in it (see src/page.js).
// Predator-prey, as re-cast in Stage 3 of the Predator-prey tutorial.
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
        "initial": "5000",
        "units": ""
      }
    },
    "node2": {
      "type": "stock",
      "parent": null,
      "label": "foxes",
      "props": {
        "initial": "45",
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
        "rate": "0.5*rabbits",
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
        "rate": "0.2*foxes",
        "units": ""
      }
    },
    "node11": {
      "type": "variable",
      "parent": null,
      "label": "eaten_per_fox",
      "props": {
        "value": "0.01*rabbits",
        "units": ""
      }
    },
    "node12": {
      "type": "variable",
      "parent": null,
      "label": "rfox",
      "props": {
        "value": "0.01*eaten_per_fox",
        "units": ""
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
    }
  }
}, {"runLength": 50, "timeStep": "0.1", "logEach": 1});
