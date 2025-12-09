package policy.networkpolicy

deny[msg] if {
  not exists_networkpolicy
  msg := "No existe ninguna NetworkPolicy en los manifests"
}

exists_networkpolicy if {
  doc := input[_]
  doc.kind == "NetworkPolicy"
}