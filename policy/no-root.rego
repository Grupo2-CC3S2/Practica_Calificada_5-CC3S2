package policy.noroot

# Denegar Deployment sin runAsNonRoot en securityContext
deny[msg] if {
  doc := input[_]
  doc.kind == "Deployment"
  not has_deployment_runasnonroot(doc)
  msg := sprintf("Deployment %s permite correr como root", [doc.metadata.name])
}

# Denegar containers sin runAsNonRoot
deny[msg] if {
  doc := input[_]
  doc.kind == "Deployment"
  container := doc.spec.template.spec.containers[_]
  not has_container_runasnonroot(container)
  msg := sprintf(
    "Container %s en Deployment %s permite correr como root",
    [container.name, doc.metadata.name]
  )
}

has_deployment_runasnonroot(d) if {
  d.spec.template.spec.securityContext.runAsNonRoot == true
}

has_container_runasnonroot(c) if {
  c.securityContext.runAsNonRoot == true
}
