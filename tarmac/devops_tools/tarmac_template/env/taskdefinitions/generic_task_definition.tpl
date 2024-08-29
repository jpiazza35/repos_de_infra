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
    "linuxParameters": null,
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
  /* This is a template for a sidecar container if needed */
  /* , */
  /* { */
  /*   "dnsSearchDomains": [], */
  /*   "environmentFiles": [], */
  /*   "logConfiguration": { */
  /*     "logDriver": "awslogs", */
  /*     "secretOptions": [], */
  /*     "options": { */
  /*       "awslogs-group": "${awslogs-group}", */
  /*       "awslogs-region": "${awslogs-region}", */
  /*       "awslogs-stream-prefix": "ecs" */
  /*     } */
  /*   }, */
  /*   "entryPoint": [], */
  /*   "portMappings": ${sidecar_portMappings}, */
  /*   "linuxParameters": null, */
  /*   "resourceRequirements": null, */
  /*   "ulimits": [], */
  /*   "dnsServers": [], */
  /*   "mountPoints": [], */
  /*   "secrets": ${sidecar_secrets}, */
  /*   "dockerSecurityOptions": [], */
  /*   "volumesFrom": [], */
  /*   "stopTimeout": null, */
  /*   "image": "${sidecar_image}", */
  /*   "startTimeout": null, */
  /*   "firelensConfiguration": null, */
  /*   "dependsOn": null, */
  /*   "disableNetworking": false, */
  /*   "interactive": null, */
  /*   "essential": true, */
  /*   "links": [], */
  /*   "hostname": null, */
  /*   "extraHosts": [], */
  /*   "pseudoTerminal": null, */
  /*   "user": null, */
  /*   "readonlyRootFilesystem": null, */
  /*   "dockerLabels": {}, */
  /*   "systemControls": [], */
  /*   "privileged": null, */
  /*   "name": "${sidecar_container_name}" */
  /* } */
]
