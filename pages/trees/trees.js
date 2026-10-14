// Trees — a Simile model, exported 2026-10-14.
// For a page with widgets embedded in it: load this file with
//   <script src="trees.js"></script>
// and refer to the model as data-model="trees" (see src/page.js).
Simile.model("trees", {
  "id": "trees",
  "name": "Trees",
  "format": 3,
  "schema": "simile-v1",
  "enums": {},
  "submodels": {
    "submodel1": {
      "kind": "population",
      "parent": null,
      "label": "tree",
      "props": {
        "dimensions": ""
      }
    }
  },
  "nodes": {
    "node1": {
      "type": "stock",
      "parent": "submodel1",
      "label": "size",
      "props": {
        "initial": "3",
        "units": ""
      }
    },
    "node2": {
      "type": "cloud",
      "parent": "submodel1",
      "label": "",
      "props": {}
    },
    "node3": {
      "type": "valve",
      "parent": "submodel1",
      "label": "growth",
      "props": {
        "rate": "gr*(1-size/max_size)",
        "units": ""
      }
    },
    "node4": {
      "type": "variable",
      "parent": "submodel1",
      "label": "gr",
      "props": {
        "value": "rand_const(0.1,0.3)",
        "units": "",
        "min": "",
        "max": ""
      }
    },
    "node5": {
      "type": "initialiser",
      "parent": "submodel1",
      "label": "initial",
      "props": {
        "expr": "initial_trees"
      }
    },
    "node6": {
      "type": "migrator",
      "parent": "submodel1",
      "label": "recruitment",
      "props": {
        "expr": "recruitment_rate"
      }
    },
    "node7": {
      "type": "exterminator",
      "parent": "submodel1",
      "label": "death",
      "props": {
        "expr": "size>death_size"
      }
    },
    "node8": {
      "type": "variable",
      "parent": null,
      "label": "total",
      "props": {
        "value": "sum({size})",
        "units": "",
        "min": "",
        "max": ""
      }
    },
    "node9": {
      "type": "variable",
      "parent": "submodel1",
      "label": "x",
      "props": {
        "value": "rand_const(0,50)",
        "units": "",
        "min": "",
        "max": ""
      }
    },
    "node10": {
      "type": "variable",
      "parent": "submodel1",
      "label": "y",
      "props": {
        "value": "rand_const(0,100)",
        "units": "",
        "min": "",
        "max": ""
      }
    },
    "node11": {
      "type": "variable",
      "parent": null,
      "label": "initial_trees",
      "props": {
        "value": "5",
        "units": "",
        "min": "2.5",
        "max": "10"
      }
    },
    "node12": {
      "type": "variable",
      "parent": null,
      "label": "recruitment_rate",
      "props": {
        "value": "2",
        "units": "",
        "min": "1",
        "max": "4"
      }
    },
    "node13": {
      "type": "variable",
      "parent": null,
      "label": "death_size",
      "props": {
        "value": "7",
        "units": "",
        "min": "3.5",
        "max": "14"
      }
    },
    "node14": {
      "type": "variable",
      "parent": null,
      "label": "max_size",
      "props": {
        "value": "25",
        "units": "",
        "min": "12.5",
        "max": "50"
      }
    }
  },
  "arcs": {
    "arc1": {
      "type": "flow",
      "from": "node2",
      "to": "node1",
      "valve": "node3",
      "props": {}
    },
    "arc2": {
      "type": "influence",
      "from": "node1",
      "to": "node3",
      "props": {},
      "alias": "size"
    },
    "arc3": {
      "type": "influence",
      "from": "node4",
      "to": "node3",
      "props": {},
      "alias": "gr"
    },
    "arc4": {
      "type": "influence",
      "from": "node1",
      "to": "node7",
      "props": {},
      "alias": "size"
    },
    "arc5": {
      "type": "influence",
      "from": "node1",
      "to": "node8",
      "props": {},
      "alias": "size"
    },
    "arc6": {
      "type": "influence",
      "from": "node11",
      "to": "node5",
      "props": {},
      "alias": "initial_trees"
    },
    "arc7": {
      "type": "influence",
      "from": "node12",
      "to": "node6",
      "props": {},
      "alias": "recruitment_rate"
    },
    "arc8": {
      "type": "influence",
      "from": "node13",
      "to": "node7",
      "props": {},
      "alias": "death_size"
    },
    "arc9": {
      "type": "influence",
      "from": "node14",
      "to": "node3",
      "props": {},
      "alias": "max_size"
    }
  },
  "layout": {
    "node1": {
      "x": 280.55555555555554,
      "y": 143.88888888888889
    },
    "node2": {
      "x": 169.4444105360243,
      "y": 143.88888888888889
    },
    "node4": {
      "x": 202.7777608235677,
      "y": 93.88888888888889
    },
    "submodel1": {
      "x": 225.43672561645508,
      "y": 102.63887405395508,
      "w": 160.23761749267578,
      "h": 142.5
    },
    "node5": {
      "x": 188.8179168701172,
      "y": 58.38887405395508
    },
    "node6": {
      "x": 237.77774810791016,
      "y": 58.38887405395508
    },
    "node7": {
      "x": 280.55553436279297,
      "y": 58.38887405395508
    },
    "node8": {
      "x": 339.55553436279297,
      "y": 108.88887405395508
    },
    "ports": {
      "submodel1": {
        "node1": {
          "x": 305.55553436279297,
          "y": 129.05838137319796
        },
        "arc6": {
          "x": 175.44760420595304,
          "y": 31.388874053955078
        },
        "arc7": {
          "x": 240.26535624669023,
          "y": 31.388874053955078
        },
        "arc8": {
          "x": 301.0303860758035,
          "y": 31.388874053955078
        },
        "arc9": {
          "x": 224.99999019834377,
          "y": 173.88887405395508
        }
      }
    },
    "node9": {
      "x": 161.3179168701172,
      "y": 76.38887405395508
    },
    "node10": {
      "x": 161.3179168701172,
      "y": 106.38887405395508
    },
    "node11": {
      "x": 150,
      "y": -20
    },
    "node12": {
      "x": 245,
      "y": -20
    },
    "node13": {
      "x": 340,
      "y": -20
    },
    "node14": {
      "x": 225,
      "y": 215
    }
  }
}, {"runLength":60,"logEach":1,"timeStep":"0.1"});
