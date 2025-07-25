# kronform

This is the public repository containing most of the configuration for my **kronform** Kubernetes cluster hosted with Hetzner.

The process for setting up the cluster was/is being documented in a blog series at https://datavirke.dk:

*Series Index*
* [Part I: Talos on Hetzner](https://datavirke.dk/posts/bare-metal-kubernetes-part-1-talos-on-hetzner)
* [Part II: Cilium CNI & Firewalls](https://datavirke.dk/posts/bare-metal-kubernetes-part-2-cilium-and-firewalls)
* [Part III: Encrypted GitOps with FluxCD](https://datavirke.dk/posts/bare-metal-kubernetes-part-3-encrypted-gitops-with-fluxcd)
* [Part IV: Ingress, DNS and Certificates](https://datavirke.dk/posts/bare-metal-kubernetes-part-4-ingress-dns-certificates)
* [Part V: Scaling Out](https://datavirke.dk/posts/bare-metal-kubernetes-part-5-scaling-out)
* [Part VI: Persistent Storage with Rook Ceph](https://datavirke.dk/posts/bare-metal-kubernetes-part-6-persistent-storage-with-rook-ceph/)
* [Part VII: Private Registry with Harbor](https://datavirke.dk/posts/bare-metal-kubernetes-part-7-private-registry-with-harbor/)
* [Part VIII: Containerizing our Work Environment](https://datavirke.dk/posts/bare-metal-kubernetes-part-8-containerizing-our-work-environment/)
* [Part IX: Renovating old Deployments](https://datavirke.dk/posts/bare-metal-kubernetes-part-9-renovating-old-deployments/)
* [Part X: Metrics and Monitoring with OpenObserve](https://datavirke.dk/posts/bare-metal-kubernetes-part-10-metrics-and-monitoring-with-openobserve/)


# Upgrading Flux

Run `just upgrade-flux`