[
  {
    "dnsSearchDomains": [],
    "environmentFiles": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "secretOptions": [],
      "options": {
        "awslogs-group": "${awslogs-group}",
        "awslogs-region": "${awslogs-region}",
        "awslogs-stream-prefix": "ecs"
      }
    },
    "entryPoint": [],
    "portMappings": ${portMappings},
    "linuxParameters": {
      "initProcessEnabled": true
    },
    "resourceRequirements": null,
    "ulimits": [],
    "dnsServers": [],
    "mountPoints": [],
    "secrets": ${secrets},
    "dockerSecurityOptions": [],
    "volumesFrom": [],
    "stopTimeout": null,
    "image": "${image}",
    "startTimeout": null,
    "firelensConfiguration": null,
    "dependsOn": null,
    "disableNetworking": false,
    "interactive": null,
    "essential": true,
    "links": [],
    "hostname": null,
    "extraHosts": [],
    "pseudoTerminal": null,
    "user": null,
    "readonlyRootFilesystem": null,
    "dockerLabels": {},
    "systemControls": [],
    "privileged": null,
    "name": "${container_name}"
  }
]
