---
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: istio-gateway
  namespace: ${istio_namespace}
spec:
  selector:
    istio: ingressgateway
  servers:
## http
  - hosts:
    - '*'
    port:
      name: http2
      number: 80
      protocol: HTTP
    tls:
      httpsRedirect: true
      
# https
  - hosts:
    - '*'
    port:
      name: https
      number: 443
      protocol: HTTPS
    tls:
      mode: SIMPLE
      credentialName: istio-alb #root-certs

---
## Create Self Signed cert. We will use a key/pair to encrypt traffic from ALB to Istio Gateway.
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: istio-alb
  namespace: ${istio_namespace}
spec:
  duration: 2160h # 90d
  renewBefore: 360h # 15d
  commonName: '*.devops.cliniciannexus.com'
  dnsNames:
  - istio.devops.cliniciannexus.com
  - monitoring.devops.cliniciannexus.com
  secretName: istio-alb
  privateKey:
    algorithm: RSA
    encoding: PKCS1
    size: 4096
  issuerRef:
    name: vault-cert-issuer
    kind: ClusterIssuer
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: istio-alb
  namespace: ${istio_namespace}
  annotations:
    ## https://github.com/kubernetes-sigs/aws-load-balancer-controller/blob/main/docs/guide/ingress/annotations.md#group.name
    ## create AWS Application LoadBalancer
    alb.ingress.kubernetes.io/load-balancer-name: istio-ingress
    ## Specify Ingress Group to merge ingress rules. 
    alb.ingress.kubernetes.io/group.name: ${env}
    ## external type (requires public subnet)
    alb.ingress.kubernetes.io/scheme: internet-facing
    # alb.ingress.kubernetes.io/scheme: internal
    ## health check Config
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/backend-protocol: HTTP
    alb.ingress.kubernetes.io/healthcheck-path: /healthz/ready
    alb.ingress.kubernetes.io/healthcheck-port: status-port
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
    ## AWS Certificate Manager certificate's ARN
    alb.ingress.kubernetes.io/certificate-arn: ${acm_arn}
    ## open ports 80 and 443 
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}, {"HTTPS":443}]'
    ## redirect all HTTP to HTTPS
    alb.ingress.kubernetes.io/ssl-redirect: '443'
    alb.ingress.kubernetes.io/actions.ssl-redirect: |
      {
        "Type": "redirect", 
        "RedirectConfig": { 
          "Protocol": "HTTPS", 
          "Port": "443",
          "StatusCode": "HTTP_301"
        }
      }
    ## ALB Tags
    alb.ingress.kubernetes.io/tags: Environment=${env},Team=devops
    ## ExternalDNS settings: https://rtfm.co.ua/en/kubernetes-update-aws-route53-dns-from-an-ingress/
    external-dns.alpha.kubernetes.io/hostname: "${istio_hostname}"

spec:
  defaultBackend:
    service:
      name: istio-ingressgateway
      port:
        number: 443
  ingressClassName: alb
  tls:
  - hosts:
    - "${istio_hostname}"
    secretName: istio-alb
  rules:
  - host: "${istio_hostname}"
    http:
      paths:
        - path: /
          pathType: Prefix
          backend:
            service:
              name: ssl-redirect
              port:
                name: use-annotation
        - path: /
          pathType: Prefix
          backend:
            service:
              name: istio-ingressgateway
              port: 
                number: 443
        - path: /healthz/ready
          pathType: Prefix 
          backend:
            service:
              name: istio-ingressgateway
              port: 
                name: status-port
---
apiVersion: networking.istio.io/v1alpha3
kind: EnvoyFilter
metadata:
  name: proxy-protocol
  namespace: ${istio_namespace}
spec:
  configPatches:
  - applyTo: LISTENER
    patch:
      operation: MERGE
      value:
        listener_filters:
        - name: envoy.listener.proxy_protocol
        - name: envoy.listener.tls_inspector
  workloadSelector:
    labels:
      istio: ingressgateway
---
apiVersion: networking.istio.io/v1alpha3
kind: DestinationRule
metadata:
  name: istio
  namespace: ${istio_namespace}
spec:
  host: istio-ingressgateway
  trafficPolicy:
    tls:
      mode: SIMPLE
      credentialName: istio-alb
---
## Configure PeerAuthentication within an application Namespace to enforce Strict Mutual TLS using the Istio Proxy Sidecar
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: ${istio_namespace}
spec:
  mtls:
    mode: STRICT
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: istio
  namespace: ${istio_namespace}
spec:
  gateways:
  - istio-gateway
  hosts:
  - '*'
  tls:
  - match:
    - port: 443
      sniHosts:
      - '*'
    route:
    - destination:
        host: istio-ingressgateway
        port:
          number: 443
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: authorize-allow-all
  namespace: ${istio_namespace}
spec:
  selector:
      matchLabels:
        istio: ingressgateway
  action: ALLOW
